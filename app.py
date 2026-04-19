from flask import request, redirect, url_for, session, jsonify
from flask import Flask, render_template
import mysql.connector
from datetime import datetime
from reportlab.platypus import (
    SimpleDocTemplate,
    Paragraph,
    Spacer,
    Image as RLImage,
    Table,
    TableStyle,
)
from reportlab.lib.styles import ParagraphStyle
from reportlab.lib import colors
from reportlab.lib.pagesizes import A4
from reportlab.lib.styles import getSampleStyleSheet
from reportlab.pdfbase.ttfonts import TTFont
from reportlab.pdfbase import pdfmetrics
from reportlab.lib.utils import ImageReader
from io import BytesIO
from flask import send_file
import os
import json
import secrets
from werkzeug.utils import secure_filename
import bcrypt
from werkzeug.security import check_password_hash
import re
import html as html_lib
from xml.sax.saxutils import escape as xml_escape
from urllib.parse import urlencode
from urllib.request import Request, urlopen


def load_env_file(env_path=".env"):
    if not os.path.exists(env_path):
        return

    try:
        with open(env_path, "r", encoding="utf-8") as env_file:
            for raw_line in env_file:
                line = raw_line.strip()
                if not line or line.startswith("#") or "=" not in line:
                    continue

                key, value = line.split("=", 1)
                key = key.strip()
                value = value.strip().strip('"').strip("'")
                if key and key not in os.environ:
                    os.environ[key] = value
    except OSError:
        pass


load_env_file(os.path.join(os.path.dirname(__file__), ".env"))

app = Flask(__name__)
app.secret_key = "vedant"

_lawyer_profile_image_column_ok = False
_ratings_table_ok = False
_chat_message_attachments_ok = False

MAX_CHAT_UPLOAD_BYTES = 15 * 1024 * 1024
ALLOWED_CHAT_UPLOAD_EXTENSIONS = frozenset(
    {".pdf", ".png", ".jpg", ".jpeg", ".webp", ".gif", ".txt", ".doc", ".docx"}
)


def ensure_ratings_table(conn, cursor):
    """Create ratings table if missing (matches migrations/add_lawyer_ratings.sql)."""
    global _ratings_table_ok
    if _ratings_table_ok:
        return
    cursor.execute(
        """
        CREATE TABLE IF NOT EXISTS ratings (
          id INT NOT NULL AUTO_INCREMENT,
          user_id INT NOT NULL,
          lawyer_id INT NOT NULL,
          rating TINYINT NOT NULL,
          created_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP,
          updated_at TIMESTAMP NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
          PRIMARY KEY (id),
          UNIQUE KEY uq_ratings_user_lawyer (user_id, lawyer_id),
          KEY idx_ratings_lawyer (lawyer_id),
          CONSTRAINT fk_ratings_user FOREIGN KEY (user_id) REFERENCES users (user_id) ON DELETE CASCADE,
          CONSTRAINT fk_ratings_lawyer FOREIGN KEY (lawyer_id) REFERENCES lawyers (lawyer_id) ON DELETE CASCADE
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci
        """
    )
    conn.commit()
    _ratings_table_ok = True


def ensure_chat_message_attachment_columns(conn, cursor):
    """Ensure chat_messages has attachment_path and attachment_original_name."""
    global _chat_message_attachments_ok
    if _chat_message_attachments_ok:
        return
    for stmt in (
        "ALTER TABLE chat_messages ADD COLUMN attachment_path VARCHAR(512) NULL DEFAULT NULL",
        "ALTER TABLE chat_messages ADD COLUMN attachment_original_name VARCHAR(255) NULL DEFAULT NULL",
    ):
        try:
            cursor.execute(stmt)
            conn.commit()
        except mysql.connector.Error as e:
            if getattr(e, "errno", None) != 1060:
                raise
    _chat_message_attachments_ok = True


def ensure_lawyer_profile_image_column(conn, cursor):
    """Ensure lawyers.profile_image exists (MySQL ER_DUP_FIELDNAME = 1060 if already there)."""
    global _lawyer_profile_image_column_ok
    if _lawyer_profile_image_column_ok:
        return
    try:
        cursor.execute(
            "ALTER TABLE lawyers ADD COLUMN profile_image VARCHAR(255) NULL DEFAULT NULL"
        )
        conn.commit()
    except mysql.connector.Error as e:
        if getattr(e, "errno", None) == 1060:
            pass
        else:
            raise
    _lawyer_profile_image_column_ok = True


def get_db_connection():
    return mysql.connector.connect(
        host="localhost",
        user="root",
        password="root123",
        database="legal_advisor_db"
    )


def get_time_ago(dt):
    if not dt:
        return "Recently"
    now = datetime.now()
    diff = now - dt
    
    seconds = diff.total_seconds()
    if seconds < 0 or seconds < 60:
        return "Just now"
    if seconds < 3600:
        return f"{int(seconds // 60)} minutes ago"
    if seconds < 86400:
        return f"{int(seconds // 3600)} hours ago"
    if diff.days < 7:
        return f"{int(diff.days)} days ago"
    return dt.strftime("%b %d, %Y")


def build_sidebar_activity():
    user_id = session.get("user_id")
    if not user_id:
        return None

    role = session.get("role", "user")
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT user_id, name, email, phone, role FROM users WHERE user_id = %s",
        (user_id,),
    )
    user = cursor.fetchone()
    if not user:
        conn.close()
        return None

    activity = {
        "user": user,
        "role": role,
        "stats": [],
        "recent_items": [],
    }

    if role == "user":
        cursor.execute(
            "SELECT COUNT(*) AS total_cases FROM cases WHERE user_id = %s",
            (user_id,),
        )
        total_cases = cursor.fetchone()["total_cases"]

        cursor.execute(
            """
            SELECT COUNT(*) AS total_docs
            FROM case_documents cd
            INNER JOIN cases c ON cd.case_id = c.case_id
            WHERE c.user_id = %s
            """,
            (user_id,),
        )
        total_docs = cursor.fetchone()["total_docs"]

        cursor.execute(
            """
            SELECT
                COUNT(*) AS total_consultations,
                SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_consultations
            FROM consultations
            WHERE user_id = %s
            """,
            (user_id,),
        )
        consultation_counts = cursor.fetchone() or {}

        cursor.execute(
            """
            SELECT next_hearing, title
            FROM cases
            WHERE user_id = %s AND next_hearing IS NOT NULL
            ORDER BY next_hearing ASC
            LIMIT 1
            """,
            (user_id,),
        )
        next_case = cursor.fetchone()

        cursor.execute(
            """
            SELECT c.consultation_id, l.name AS lawyer_name, c.status, c.consultation_date, c.consultation_type
            FROM consultations c
            JOIN lawyers l ON c.lawyer_id = l.lawyer_id
            WHERE c.user_id = %s
            ORDER BY c.consultation_date DESC, c.consultation_id DESC
            LIMIT 3
            """,
            (user_id,),
        )
        recent_consultations = cursor.fetchall()

        cursor.execute(
            """
            SELECT case_id, title, status, next_hearing
            FROM cases
            WHERE user_id = %s
            ORDER BY COALESCE(next_hearing, '9999-12-31') ASC, case_id DESC
            LIMIT 3
            """,
            (user_id,),
        )
        recent_cases = cursor.fetchall()

        activity["stats"] = [
            {"label": "Cases", "value": total_cases, "tone": "slate"},
            {"label": "Consultations", "value": consultation_counts.get("total_consultations") or 0, "tone": "amber"},
            {"label": "Pending", "value": consultation_counts.get("pending_consultations") or 0, "tone": "orange"},
            {"label": "Documents", "value": total_docs, "tone": "blue"},
        ]
        activity["next_case"] = next_case
        activity["recent_items"] = {
            "consultations": recent_consultations,
            "cases": recent_cases,
        }

    elif role == "lawyer":
        lawyer_id = session.get("lawyer_id")
        if lawyer_id:
            cursor.execute(
                """
                SELECT
                    COUNT(*) AS total_consultations,
                    SUM(CASE WHEN status = 'Pending' THEN 1 ELSE 0 END) AS pending_consultations,
                    SUM(CASE WHEN status = 'Approved' THEN 1 ELSE 0 END) AS approved_consultations
                FROM consultations
                WHERE lawyer_id = %s
                """,
                (lawyer_id,),
            )
            counts = cursor.fetchone() or {}
            cursor.execute(
                """
                SELECT consultations.consultation_id, users.name AS client_name, consultations.status, consultations.consultation_date
                FROM consultations
                JOIN users ON consultations.user_id = users.user_id
                WHERE consultations.lawyer_id = %s
                ORDER BY consultations.consultation_date DESC, consultations.consultation_id DESC
                LIMIT 3
                """,
                (lawyer_id,),
            )
            activity["stats"] = [
                {"label": "Requests", "value": counts.get("total_consultations") or 0, "tone": "slate"},
                {"label": "Pending", "value": counts.get("pending_consultations") or 0, "tone": "orange"},
                {"label": "Approved", "value": counts.get("approved_consultations") or 0, "tone": "green"},
            ]
            activity["recent_items"] = {"consultations": cursor.fetchall()}

    conn.close()
    return activity


@app.context_processor
def inject_base_activity():
    return {"base_user_activity": build_sidebar_activity()}


def get_google_oauth_config():
    client_id = os.getenv("GOOGLE_CLIENT_ID", "").strip()
    client_secret = os.getenv("GOOGLE_CLIENT_SECRET", "").strip()
    redirect_uri = os.getenv("GOOGLE_REDIRECT_URI", "").strip()

    return {
        "client_id": client_id,
        "client_secret": client_secret,
        "redirect_uri": redirect_uri,
        "enabled": bool(client_id and client_secret),
    }


def get_google_redirect_uri():
    config = get_google_oauth_config()
    if config["redirect_uri"]:
        return config["redirect_uri"]
    return url_for("google_auth_callback", _external=True)


def _redirect_to_login_with_google_error(message):
    return redirect(url_for("login", google_error=message))


def _complete_user_session(user):
    session["user_id"] = user["user_id"]
    session["user_name"] = user.get("name", "")
    session["user_email"] = user.get("email", "")
    session["role"] = user.get("role", "user")

    if session["role"] == "lawyer":
        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)
        cursor.execute(
            "SELECT lawyer_id FROM lawyers WHERE email=%s",
            (user["email"],),
        )
        lawyer = cursor.fetchone()
        conn.close()
        if lawyer:
            session["lawyer_id"] = lawyer["lawyer_id"]
        else:
            session.pop("lawyer_id", None)
    else:
        session.pop("lawyer_id", None)


def _redirect_after_login(role):
    if role == "admin":
        return redirect("/admin-dashboard")
    if role == "lawyer":
        return redirect("/lawyer-dashboard")
    return redirect("/")


@app.route("/login/google")
def google_login():
    config = get_google_oauth_config()
    if not config["enabled"]:
        return _redirect_to_login_with_google_error(
            "Google sign-in is not configured yet. Add GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET."
        )

    state = secrets.token_urlsafe(32)
    session["google_oauth_state"] = state

    auth_params = {
        "client_id": config["client_id"],
        "redirect_uri": get_google_redirect_uri(),
        "response_type": "code",
        "scope": "openid email profile",
        "state": state,
        "access_type": "online",
        "prompt": "select_account",
    }

    return redirect(
        "https://accounts.google.com/o/oauth2/v2/auth?" + urlencode(auth_params)
    )


@app.route("/auth/google/callback")
def google_auth_callback():
    config = get_google_oauth_config()
    if not config["enabled"]:
        return _redirect_to_login_with_google_error(
            "Google sign-in is not configured yet. Add GOOGLE_CLIENT_ID and GOOGLE_CLIENT_SECRET."
        )

    if request.args.get("error"):
        return _redirect_to_login_with_google_error("Google sign-in was cancelled.")

    state = request.args.get("state", "")
    code = request.args.get("code", "")
    if not code or not state or state != session.get("google_oauth_state"):
        session.pop("google_oauth_state", None)
        return _redirect_to_login_with_google_error("Google sign-in failed. Please try again.")

    session.pop("google_oauth_state", None)

    try:
        token_payload = urlencode(
            {
                "code": code,
                "client_id": config["client_id"],
                "client_secret": config["client_secret"],
                "redirect_uri": get_google_redirect_uri(),
                "grant_type": "authorization_code",
            }
        ).encode("utf-8")

        token_request = Request(
            "https://oauth2.googleapis.com/token",
            data=token_payload,
            headers={"Content-Type": "application/x-www-form-urlencoded"},
        )
        with urlopen(token_request, timeout=15) as response:
            token_data = json.loads(response.read().decode("utf-8"))

        access_token = token_data.get("access_token")
        if not access_token:
            return _redirect_to_login_with_google_error(
                "Could not verify your Google account."
            )

        userinfo_request = Request(
            "https://openidconnect.googleapis.com/v1/userinfo",
            headers={"Authorization": f"Bearer {access_token}"},
        )
        with urlopen(userinfo_request, timeout=15) as response:
            google_user = json.loads(response.read().decode("utf-8"))
    except Exception:
        return _redirect_to_login_with_google_error(
            "Google sign-in is temporarily unavailable. Please try again."
        )

    email = (google_user.get("email") or "").strip().lower()
    name = (google_user.get("name") or google_user.get("given_name") or "Google User").strip()

    if not email:
        return _redirect_to_login_with_google_error(
            "Google account did not provide an email address."
        )

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
    user = cursor.fetchone()

    if not user:
        generated_password = secrets.token_urlsafe(24)
        hashed_password = bcrypt.hashpw(
            generated_password.encode("utf-8"),
            bcrypt.gensalt(),
        ).decode("utf-8")

        cursor.execute(
            """
            INSERT INTO users (name, email, phone, password, role)
            VALUES (%s, %s, %s, %s, %s)
            """,
            (
                name,
                email,
                "0000000000",
                hashed_password,
                "user",
            ),
        )
        conn.commit()

        cursor.execute("SELECT * FROM users WHERE user_id=%s", (cursor.lastrowid,))
        user = cursor.fetchone()

    conn.close()

    _complete_user_session(user)
    return _redirect_after_login(user.get("role", "user"))

@app.route("/")
def home():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    ensure_ratings_table(conn, cursor)
    cursor.execute(
        """
        SELECT l.*,
               COALESCE(AVG(r.rating), 0) AS avg_rating,
               COUNT(r.id) AS total_reviews
        FROM lawyers l
        LEFT JOIN ratings r ON r.lawyer_id = l.lawyer_id
        GROUP BY l.lawyer_id
        ORDER BY avg_rating DESC, total_reviews DESC, l.lawyer_id ASC
        LIMIT 3
        """
    )
    featured_lawyers = cursor.fetchall()
    conn.close()
    return render_template("index.html", featured_lawyers=featured_lawyers)

@app.route("/law-library")
def law_library():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    cursor.execute("SELECT * FROM law_categories")
    categories = cursor.fetchall()
    conn.close()
    return render_template("law_library.html", categories=categories)


@app.route("/about-us")
def about_us():
    return render_template("about_us.html")


@app.route("/contact-us")
def contact_us():
    return render_template("contact_us.html")

@app.route("/laws/<int:category_id>")
def show_laws(category_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM laws WHERE category_id = %s",
        (category_id,)
    )
    laws = cursor.fetchall()

    # Fetch steps & helplines for each law
    for law in laws:
        cursor.execute(
            "SELECT step_number, step_description FROM steps_to_follow WHERE law_id = %s ORDER BY step_number",
            (law["law_id"],)
        )
        law["steps"] = cursor.fetchall()

        cursor.execute(
            "SELECT helpline_name, phone_number, description FROM helplines WHERE category_id = %s",
            (law["category_id"],)
        )
        law["helplines"] = cursor.fetchall()

    conn.close()
    return render_template("laws.html", laws=laws)

@app.route("/scenario-checker", methods=["GET", "POST"])
def scenario_checker():
    case_type = None
    laws = None

    if request.method == "POST":
        scenario = request.form["scenario"]
        case_type, laws = legal_engine(scenario)

    return render_template(
        "scenario_checker.html",
        case_type=case_type,
        laws=laws
    )

@app.route("/admin-dashboard")
def admin_dashboard():

    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT COUNT(*) as count FROM users")
    total_users = cursor.fetchone()['count']

    cursor.execute("SELECT COUNT(*) as count FROM lawyers")
    total_lawyers = cursor.fetchone()['count']

    cursor.execute("SELECT COUNT(*) as count FROM consultations")
    total_consultations = cursor.fetchone()['count']

    cursor.execute("SELECT COUNT(*) as count FROM laws")
    total_laws = cursor.fetchone()['count']

    # Fetch Recent Activity
    # 1. Recent Users
    cursor.execute("SELECT name, created_at FROM users WHERE role='user' ORDER BY created_at DESC LIMIT 5")
    recent_users = cursor.fetchall()
    
    # 2. Recent Lawyers
    cursor.execute("SELECT name, created_at FROM users WHERE role='lawyer' ORDER BY created_at DESC LIMIT 5")
    recent_lawyers = cursor.fetchall()
    
    # 3. Recent Consultations
    cursor.execute("""
        SELECT u.name, c.created_at 
        FROM consultations c 
        JOIN users u ON c.user_id = u.user_id 
        ORDER BY c.created_at DESC LIMIT 5
    """)
    recent_consultations = cursor.fetchall()
    
    # 4. Recent Laws
    cursor.execute("SELECT law_title FROM laws ORDER BY law_id DESC LIMIT 5")
    recent_laws = cursor.fetchall()

    activities = []
    for u in recent_users:
        activities.append({
            'icon': 'user-plus', 
            'text': f"New user registered: {u['name']}", 
            'time': get_time_ago(u['created_at']), 
            'color': 'green', 
            'ts': u['created_at']
        })
    for l in recent_lawyers:
        activities.append({
            'icon': 'user', 
            'text': f"New lawyer joined: {l['name']}", 
            'time': get_time_ago(l['created_at']), 
            'color': 'purple', 
            'ts': l['created_at']
        })
    for c in recent_consultations:
        activities.append({
            'icon': 'calendar', 
            'text': f"Consultation booked: {c['name']}", 
            'time': get_time_ago(c['created_at']), 
            'color': 'blue', 
            'ts': c['created_at']
        })
    for lw in recent_laws:
        activities.append({
            'icon': 'book', 
            'text': f"New law added: {lw['law_title']}", 
            'time': 'Recently', 
            'color': 'amber', 
            'ts': datetime.min # Fallback since no timestamp
        })

    # Sort by timestamp (ts) descending
    activities.sort(key=lambda x: x['ts'] if x['ts'] else datetime.min, reverse=True)
    recent_activities = activities[:10]

    conn.close()

    return render_template(
        "admin_dashboard.html",
        total_users=total_users,
        total_lawyers=total_lawyers,
        total_consultations=total_consultations,
        total_laws=total_laws,
        recent_activities=recent_activities
    )

@app.route("/admin/logout")
def admin_logout():
    session.pop("admin_logged_in", None)
    return redirect("/admin")

@app.route("/admin/add-category", methods=["GET","POST"])
def add_category():

    if session.get("role") != "admin":
        return redirect("/login")

    message = None

    if request.method == "POST":
        name = request.form["category_name"]
        desc = request.form["description"]

        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute(
            "INSERT INTO law_categories (category_name, description) VALUES (%s,%s)",
            (name, desc)
        )

        conn.commit()
        conn.close()

        message = "Category added successfully!"

    return render_template("admin_add_category.html", message=message)

@app.route("/admin/add-law", methods=["GET","POST"])
def add_law():

    if session.get("role") != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM law_categories")
    categories = cursor.fetchall()

    message = None

    if request.method == "POST":

        cursor.execute("""
        INSERT INTO laws
        (category_id, act_name, section_number, law_title,
        simple_explanation, example, legal_consequence)

        VALUES (%s,%s,%s,%s,%s,%s,%s)
        """,(
            request.form["category_id"],
            request.form["act_name"],
            request.form["section_number"],
            request.form["law_title"],
            request.form["simple_explanation"],
            request.form["example"],
            request.form["legal_consequence"]
        ))

        conn.commit()
        message = "Law added successfully!"

    conn.close()

    return render_template(
        "admin_add_law.html",
        categories=categories,
        message=message
    )

@app.route("/admin/add-helpline", methods=["GET","POST"])
def add_helpline():

    if session.get("role") != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM law_categories")
    categories = cursor.fetchall()

    message = None

    if request.method == "POST":

        cursor.execute("""
        INSERT INTO helplines
        (category_id, helpline_name, phone_number, description)

        VALUES (%s,%s,%s,%s)
        """,(
            request.form["category_id"],
            request.form["helpline_name"],
            request.form["phone_number"],
            request.form["description"]
        ))

        conn.commit()

        message = "Helpline added successfully!"

    conn.close()

    return render_template(
        "admin_add_helpline.html",
        categories=categories,
        message=message
    )

@app.route("/qa")
def qa_module():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM qa_module")
    qas = cursor.fetchall()

    conn.close()
    return render_template("qa_module.html", qas=qas)


@app.route("/rights")
def rights_categories():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT DISTINCT category FROM rights_awareness")
    categories = cursor.fetchall()

    conn.close()
    return render_template("rights_categories.html", categories=categories)

@app.route("/rights/<category>")
def rights_by_category(category):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM rights_awareness WHERE category = %s",
        (category,)
    )
    rights = cursor.fetchall()

    conn.close()
    return render_template("rights_list.html", rights=rights, category=category)


@app.route("/ai-assistant", methods=["GET", "POST"])
def ai_assistant():
    response = None
    laws = None

    if request.method == "POST":
        query = request.form["query"]

        # Call legal engine
        case_type, laws = legal_engine(query)

        if laws:
            response = "I found relevant legal information based on your query. You can view detailed legal sections below."
        else:
            response = "Please provide more specific details about your legal issue."

    return render_template(
    "ai_assistant.html",
    response=response,
    laws=laws,
    case_type=case_type
)
def legal_engine(user_text):
    user_text = user_text.lower()

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    category_id = None
    case_type = None

    # Cyber Law
    if any(word in user_text for word in ["fraud", "online", "otp", "hacking", "cyber", "instagram", "facebook"]):
        category_id = 7
        case_type = "Cyber Law"

    # Consumer Law
    elif any(word in user_text for word in ["refund", "consumer", "product", "service", "defective"]):
        category_id = 10
        case_type = "Consumer Law"

    # Criminal Law
    elif any(word in user_text for word in ["theft", "assault", "threat", "violence", "fight", "cheating"]):
        category_id = 8
        case_type = "Criminal Law"

    # Family Law
    elif any(word in user_text for word in ["divorce", "maintenance", "custody", "marriage"]):
        category_id = 9
        case_type = "Family Law"

    # Property Law
    elif any(word in user_text for word in ["property", "land", "tenant", "builder"]):
        category_id = 11
        case_type = "Property Law"

    # Women Protection
    elif any(word in user_text for word in ["dowry", "harassment", "molestation", "abuse"]):
        category_id = 12
        case_type = "Women Protection Law"

    # Labour Law
    elif any(word in user_text for word in ["salary", "pf", "esi", "job", "employee"]):
        category_id = 13
        case_type = "Labour Law"

    # Banking Law
    elif any(word in user_text for word in ["cheque", "bank", "loan", "credit card"]):
        category_id = 14
        case_type = "Banking Law"

    # Traffic Law
    elif any(word in user_text for word in ["helmet", "license", "drunk driving", "traffic"]):
        category_id = 15
        case_type = "Traffic Law"

    laws = []

    if category_id:
        cursor.execute("SELECT * FROM laws WHERE category_id = %s", (category_id,))
        laws = cursor.fetchall()

        for law in laws:
            # Get steps
            cursor.execute(
                "SELECT step_number, step_description FROM steps_to_follow WHERE law_id = %s ORDER BY step_number",
                (law["law_id"],)
            )
            law["steps"] = cursor.fetchall()

            # Get helplines
            cursor.execute(
                "SELECT helpline_name, phone_number, description FROM helplines WHERE category_id = %s",
                (category_id,)
            )
            law["helplines"] = cursor.fetchall()

    conn.close()
    return case_type, laws


def _lawyer_select_with_ratings_sql(where_clause: str) -> str:
    return f"""
        SELECT l.*,
          (SELECT COALESCE(AVG(r.rating), 0) FROM ratings r WHERE r.lawyer_id = l.lawyer_id) AS avg_rating,
          (SELECT COUNT(*) FROM ratings r WHERE r.lawyer_id = l.lawyer_id) AS total_reviews
        FROM lawyers l
        {where_clause}
    """


def _safe_redirect_path(next_path: str) -> str:
    if not next_path or not isinstance(next_path, str):
        return url_for("lawyers_list")
    next_path = next_path.strip()
    if not next_path.startswith("/") or next_path.startswith("//"):
        return url_for("lawyers_list")
    return next_path


@app.route("/lawyers")
def lawyers_list():
    city = request.args.get("city")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    ensure_ratings_table(conn, cursor)

    if city:
        cursor.execute(
            _lawyer_select_with_ratings_sql("WHERE l.city LIKE %s"),
            (f"%{city}%",),
        )
    else:
        cursor.execute(_lawyer_select_with_ratings_sql(""))

    lawyers = cursor.fetchall()

    user_ratings = {}
    uid = session.get("user_id")
    if uid and lawyers:
        lids = [row["lawyer_id"] for row in lawyers]
        ph = ",".join(["%s"] * len(lids))
        cursor.execute(
            f"SELECT lawyer_id, rating FROM ratings WHERE user_id = %s AND lawyer_id IN ({ph})",
            (uid, *lids),
        )
        for row in cursor.fetchall():
            user_ratings[row["lawyer_id"]] = row["rating"]

    conn.close()

    return render_template("lawyers.html", lawyers=lawyers, user_ratings=user_ratings)


@app.route("/lawyer/<int:lawyer_id>")
def lawyer_profile(lawyer_id):
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    ensure_ratings_table(conn, cursor)

    cursor.execute(
        """
        SELECT l.*,
          (SELECT COALESCE(AVG(r.rating), 0) FROM ratings r WHERE r.lawyer_id = l.lawyer_id) AS avg_rating,
          (SELECT COUNT(*) FROM ratings r WHERE r.lawyer_id = l.lawyer_id) AS total_reviews
        FROM lawyers l
        WHERE l.lawyer_id = %s
        """,
        (lawyer_id,),
    )
    lawyer = cursor.fetchone()

    user_rating = None
    uid = session.get("user_id")
    if lawyer and uid:
        cursor.execute(
            "SELECT rating FROM ratings WHERE user_id = %s AND lawyer_id = %s",
            (uid, lawyer_id),
        )
        row = cursor.fetchone()
        if row:
            user_rating = row["rating"]

    conn.close()

    if not lawyer:
        return redirect(url_for("lawyers_list"))

    return render_template(
        "lawyer_profile.html",
        lawyer=lawyer,
        user_rating=user_rating,
    )


@app.route("/rate-lawyer/<int:lawyer_id>", methods=["POST"])
def rate_lawyer(lawyer_id):
    uid = session.get("user_id")
    if not uid:
        return redirect(url_for("login"))

    rating_raw = request.form.get("rating")
    try:
        rating = int(rating_raw)
    except (TypeError, ValueError):
        rating = 0
    if rating < 1 or rating > 5:
        return redirect(_safe_redirect_path(request.form.get("next")))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)
    ensure_ratings_table(conn, cursor)

    cursor.execute("SELECT lawyer_id FROM lawyers WHERE lawyer_id = %s", (lawyer_id,))
    if not cursor.fetchone():
        conn.close()
        return redirect(url_for("lawyers_list"))

    cursor.execute(
        "SELECT id FROM ratings WHERE user_id = %s AND lawyer_id = %s",
        (uid, lawyer_id),
    )
    if cursor.fetchone():
        conn.close()
        return redirect(_safe_redirect_path(request.form.get("next")))

    cursor.execute(
        "INSERT INTO ratings (user_id, lawyer_id, rating) VALUES (%s, %s, %s)",
        (uid, lawyer_id, rating),
    )
    conn.commit()
    conn.close()

    return redirect(_safe_redirect_path(request.form.get("next")))

@app.route("/document-generator", methods=["GET", "POST"])
def document_generator():
    current_date = datetime.now().strftime("%d-%m-%Y")
    document = None

    if request.method == "POST":
        doc_type = request.form.get("doc_type")
        name = request.form.get("name")
        address = request.form.get("address")
        details = request.form.get("details")

        # âœ… OPTIONAL IMAGE UPLOAD (signature)
        image = request.files.get("image")
        image_path = None

        if image and image.filename != "":
            upload_folder = "static/uploads"
            os.makedirs(upload_folder, exist_ok=True)

            image_path = os.path.join(upload_folder, image.filename)
            image.save(image_path)

        # signature image (optional)
        sign_img = f'<img src="/{image_path}" width="120">' if image_path else ""

        # âœ… FUNCTION TO BUILD DOCUMENT
        def build_document(body):
            return f"""
            <div style="padding:30px; font-family:'Times New Roman'; line-height:1.8;">

                <!-- âœ… STAMP IMAGE ON TOP -->
                <div style="text-align:center; margin-bottom:20px;">
                    <img src="/static/images/stamp.jpg"
                         style="width:100%; max-height:200px; object-fit:cover;">
                </div>

                <!-- âœ… MAIN CONTENT -->
                <div>
                    {body}
                </div>

                <br><br>

                <!-- âœ… SIGNATURE -->
                {sign_img}
                <p>Signature: _______________________</p>
                <p><strong>{name}</strong></p>

            </div>
            """

        # âœ… DOCUMENT TYPES

        if doc_type == "consumer":
            body = f"""
            <p><strong>Date:</strong> {current_date}</p>

            <p>
            To,<br>
            The President,<br>
            District Consumer Disputes Redressal Commission
            </p>

            <p><strong>Subject:</strong> Complaint Regarding Defective Product / Service</p>

            <p>Respected Sir/Madam,</p>

            <p>
            I, {name}, residing at {address}, respectfully submit this complaint:
            </p>

            <p>{details}</p>
            """

            document = build_document(body)

        elif doc_type == "fir":
            body = f"""
            <p><strong>Date:</strong> {current_date}</p>

            <p>
            To,<br>
            The Station House Officer,<br>
            [Police Station Name]
            </p>

            <p><strong>Subject:</strong> Request for Registration of FIR</p>

            <p>Respected Sir/Madam,</p>

            <p>
            I, {name}, residing at {address}, wish to report the following incident:
            </p>

            <p>{details}</p>
            """

            document = build_document(body)

        elif doc_type == "notice":
            body = f"""
            <p><strong>Date:</strong> {current_date}</p>

            <p><strong>LEGAL NOTICE</strong></p>

            <p>
            From:<br>
            {name}<br>
            {address}
            </p>

            <p>
            To:<br>
            [Opposite Party Name & Address]
            </p>

            <p><strong>Subject:</strong> Legal Notice</p>

            <p>{details}</p>

            <p>
            You are hereby requested to resolve the issue within 15 days,
            failing which legal action will be taken.
            </p>
            """

            document = build_document(body)

        else:
            document = "<p>Error: Invalid document type</p>"

    # âœ… IMPORTANT: send as object (your template expects this)
    return render_template(
        "document_generator.html",
        document={
            "doc_type": doc_type if request.method == "POST" else "",
            "content": document,
            "created_at": datetime.now()
        } if document else None
    )


def _strip_ai_disclaimer_html(html: str) -> str:
    """Remove AI output notice text if it appears in posted HTML."""
    return re.sub(
        r'AI-Generated Document\s*This document is AI-generated\.\s*Please review carefully before use\.\s*Consult a legal professional for important matters\.?',
        "",
        html,
        flags=re.I | re.S,
    )


def _inner_html_to_paragraph_markup(inner: str) -> str:
    """Turn inner HTML of a <p> into ReportLab-safe markup (bold + line breaks)."""
    _BR = "@@RL_BR@@"
    _BO = "@@RL_BO@@"
    _BC = "@@RL_BC@@"
    inner = re.sub(r"(?i)<strong>", "<b>", inner)
    inner = re.sub(r"(?i)</strong>", "</b>", inner)
    inner = re.sub(r"(?i)<br\s*/?>", _BR, inner)
    inner = re.sub(r"(?i)</?div[^>]*>", "", inner)
    inner = re.sub(r"(?i)</?span[^>]*>", "", inner)
    inner = re.sub(r"<(?![/]?b\b)[^>]+>", "", inner)
    inner = inner.strip()
    inner = inner.replace("<b>", _BO).replace("</b>", _BC)
    inner = xml_escape(inner)
    inner = inner.replace(_BO, "<b>").replace(_BC, "</b>").replace(_BR, "<br/>")
    return inner


def _paragraphs_from_export_html(html: str):
    """Extract paragraph inner HTML; images are omitted (stamp drawn once in PDF)."""
    html = _strip_ai_disclaimer_html(html)
    html = re.sub(r"(?is)<img[^>]*>", "", html)
    blocks = re.findall(r"(?is)<p[^>]*>(.*?)</p>", html)
    if not blocks:
        plain = re.sub(r"<[^>]+>", " ", html)
        plain = html_lib.unescape(re.sub(r"\s+", " ", plain)).strip()
        if plain:
            return [xml_escape(plain).replace("\n", "<br/>")]
        return []
    return [_inner_html_to_paragraph_markup(b) for b in blocks if b.strip()]


@app.route("/download-pdf", methods=["POST"])
def download_pdf():
    content = request.form.get("content", "")

    buffer = BytesIO()
    doc = SimpleDocTemplate(
        buffer,
        pagesize=A4,
        leftMargin=54,
        rightMargin=54,
        topMargin=54,
        bottomMargin=54,
    )

    styles = getSampleStyleSheet()
    body_style = ParagraphStyle(
        name="DocumentBody",
        parent=styles["Normal"],
        fontName="Times-Roman",
        fontSize=11,
        leading=16,
        spaceAfter=10,
    )

    elements = []
    stamp_path = os.path.join(app.root_path, "static", "images", "stamp.jpg")
    if os.path.exists(stamp_path):
        ir = ImageReader(stamp_path)
        iw, ih = ir.getSize()
        max_w = doc.width
        scale = max_w / float(iw)
        img = RLImage(stamp_path, width=max_w, height=ih * scale)
        stamp_table = Table([[img]], colWidths=[max_w])
        stamp_table.setStyle(
            TableStyle([("ALIGN", (0, 0), (-1, -1), "CENTER"), ("VALIGN", (0, 0), (-1, -1), "MIDDLE")])
        )
        elements.append(stamp_table)
        elements.append(Spacer(1, 14))

    for markup in _paragraphs_from_export_html(content):
        if markup:
            elements.append(Paragraph(markup, body_style))

    doc.build(elements)

    buffer.seek(0)
    return send_file(
        buffer,
        as_attachment=True,
        download_name="legal_document.pdf",
        mimetype="application/pdf",
    )

@app.route("/add-case", methods=["GET", "POST"])
def add_case():
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # âœ… FETCH LAWYERS
    cursor.execute("SELECT lawyer_id, name, specialization FROM lawyers")
    lawyers = cursor.fetchall()

    print("LAWYERS:", lawyers)   # DEBUG

    if request.method == "POST":

        cursor.execute("""
            INSERT INTO cases 
            (title, case_type, court_name, next_hearing, status, description, user_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            request.form["title"],
            request.form["case_type"],
            request.form["court_name"],
            request.form["next_hearing"],
            request.form["status"],
            request.form["description"],
            session["user_id"]
        ))

        case_id = cursor.lastrowid

        # âœ… INSIDE BLOCK (IMPORTANT)
        lawyer_id = request.form.get("lawyer_id")

        if lawyer_id and lawyer_id.strip() != "":
            cursor.execute("""
                INSERT INTO case_lawyer (case_id, lawyer_id)
                VALUES (%s, %s)
            """, (case_id, int(lawyer_id)))

        conn.commit()
        conn.close()

        return redirect("/cases")

    conn.close()
    return render_template("add_case.html", lawyers=lawyers)

from datetime import date, timedelta

@app.route("/cases", methods=["GET", "POST"])
def cases_list():

    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # ðŸ”¥ HANDLE FORM SUBMIT (ADD CASE)
    if request.method == "POST":

        cursor.execute("""
            INSERT INTO cases 
            (title, case_type, court_name, next_hearing, status, description, user_id)
            VALUES (%s, %s, %s, %s, %s, %s, %s)
        """, (
            request.form["title"],
            request.form["case_type"],
            request.form["court_name"],
            request.form["next_hearing"],
            request.form["status"],
            request.form["description"],
            session["user_id"]
        ))

        case_id = cursor.lastrowid

        lawyer_id = request.form.get("lawyer_id")

        if lawyer_id and lawyer_id.strip() != "":
            cursor.execute("""
                INSERT INTO case_lawyer (case_id, lawyer_id)
                VALUES (%s, %s)
            """, (case_id, int(lawyer_id)))

        conn.commit()

        return redirect("/cases")

    # ðŸ”¥ FETCH CASES
    cursor.execute("""
        SELECT * FROM cases
        WHERE user_id = %s
        ORDER BY next_hearing ASC
    """, (session["user_id"],))

    cases = cursor.fetchall()

    # ðŸ”¥ FETCH LAWYERS (IMPORTANT FOR DROPDOWN)
    cursor.execute("SELECT lawyer_id, name, specialization FROM lawyers")
    lawyers = cursor.fetchall()

    conn.close()

    return render_template("cases.html", cases=cases, lawyers=lawyers)

@app.route("/case/<int:case_id>")
def case_detail(case_id):
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get case + lawyer
    cursor.execute("""
        SELECT cases.*, lawyers.name AS lawyer_name, case_lawyer.lawyer_id
        FROM cases
        LEFT JOIN case_lawyer ON cases.case_id = case_lawyer.case_id
        LEFT JOIN lawyers ON case_lawyer.lawyer_id = lawyers.lawyer_id
        WHERE cases.case_id = %s
    """, (case_id,))

    case = cursor.fetchone()

    if not case:
        conn.close()
        return "Case not found"

    # ðŸ” ACCESS CONTROL
    allowed = False

    # Case owner
    if case["user_id"] == session.get("user_id"):
        allowed = True

    # Admin
    if session.get("role") == "admin":
        allowed = True

    # Assigned lawyer
    if session.get("role") == "lawyer" and session.get("lawyer_id") == case["lawyer_id"]:
        allowed = True

    if not allowed:
        conn.close()
        return "Unauthorized access"

    # Timeline
    cursor.execute("""
        SELECT * FROM case_timeline
        WHERE case_id = %s
        ORDER BY event_date DESC
    """, (case_id,))
    timeline = cursor.fetchall()

    # Documents
    cursor.execute("""
        SELECT * FROM case_documents
        WHERE case_id = %s
        ORDER BY uploaded_at DESC
    """, (case_id,))
    documents = cursor.fetchall()

    conn.close()

    return render_template(
        "case_detail.html",
        case=case,
        timeline=timeline,
        documents=documents
    )

@app.route("/add-timeline/<int:case_id>", methods=["GET", "POST"])
def add_timeline(case_id):
    if request.method == "POST":
        conn = get_db_connection()
        cursor = conn.cursor()

        cursor.execute("""
            INSERT INTO case_timeline
            (case_id, event_date, event_title, event_description)
            VALUES (%s, %s, %s, %s)
        """, (
            case_id,
            request.form["event_date"],
            request.form["event_title"],
            request.form["event_description"]
        ))

        conn.commit()
        conn.close()

        return redirect(f"/case/{case_id}")

    return render_template("add_timeline.html", case_id=case_id)

UPLOAD_FOLDER = "static/uploads"
CASE_DOCUMENT_FOLDER = "static/case_documents"
LAWYER_PROFILE_FOLDER = "static/lawyer_profiles"

app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["CASE_DOCUMENT_FOLDER"] = CASE_DOCUMENT_FOLDER
app.config["LAWYER_PROFILE_FOLDER"] = LAWYER_PROFILE_FOLDER

@app.route("/upload-document/<int:case_id>", methods=["POST"])
def upload_document(case_id):
    if "file" not in request.files:
        return redirect(f"/case/{case_id}")

    file = request.files["file"]

    if file.filename == "":
        return redirect(f"/case/{case_id}")

    filename = secure_filename(file.filename)
    file_path = os.path.join(app.config["UPLOAD_FOLDER"], filename)
    file.save(file_path)

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO case_documents (case_id, file_name, file_path)
        VALUES (%s, %s, %s)
    """, (case_id, filename, file_path))

    conn.commit()
    conn.close()

    return redirect(f"/case/{case_id}")


@app.route("/profile")
def profile():
    if "user_id" not in session:
        return redirect(url_for("login"))
    if session.get("role") != "user":
        if session.get("role") == "lawyer":
            return redirect("/lawyer-dashboard")
        if session.get("role") == "admin":
            return redirect("/admin-dashboard")
        return redirect("/")

    activity = build_sidebar_activity()
    if not activity:
        return redirect("/")

    return render_template("user_profile.html", activity=activity)


@app.route("/register", methods=["GET", "POST"])
def register():
    if request.method == "POST":
        name = request.form["name"]
        email = request.form["email"]
        password = request.form["password"]
        phone = request.form["phone"]   # âœ… NEW FIELD

        hashed_password = bcrypt.hashpw(
            password.encode("utf-8"),
            bcrypt.gensalt()
        ).decode("utf-8")

        conn = get_db_connection()
        cursor = conn.cursor()

        try:
            # âœ… UPDATED INSERT QUERY
            cursor.execute("""
                INSERT INTO users (name, email, password, phone)
                VALUES (%s, %s, %s, %s)
            """, (name, email, hashed_password, phone))

            conn.commit()
            conn.close()

            # âœ… SEND EMAIL AFTER REGISTER
            send_welcome_email(email, name)

            return redirect("/login")

        except Exception as e:
            conn.close()
            print("Register Error:", e)   # ðŸ‘ˆ logs error in terminal
            return "Registration failed. Please try again."
    
    return render_template("register.html")

import bcrypt

@app.route("/login", methods=["GET", "POST"])
def login():

    error = None

    if request.method == "POST":

        email = request.form["email"]
        password = request.form["password"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        # Get user
        cursor.execute("SELECT * FROM users WHERE email=%s", (email,))
        user = cursor.fetchone()

        password_ok = False
        if user and user.get("password"):
            stored_password = user["password"]
            try:
                password_ok = bcrypt.checkpw(
                    password.encode("utf-8"),
                    stored_password.encode("utf-8"),
                )
            except ValueError:
                # Support older admin-created accounts saved with Werkzeug hashing.
                password_ok = check_password_hash(stored_password, password)

        if user and password_ok:

            session["user_id"] = user["user_id"]
            session["user_name"] = user["name"]
            session["user_email"] = user["email"]
            session["role"] = user["role"]

            # â­ Get lawyer_id if role = lawyer
            if user["role"] == "lawyer":
                cursor.execute("SELECT lawyer_id FROM lawyers WHERE email = %s", (email,))
                lawyer = cursor.fetchone()

                if lawyer:
                    session["lawyer_id"] = lawyer["lawyer_id"]
                    print("Lawyer ID stored in session:", session["lawyer_id"])
                else:
                    print("Lawyer record not found!")

            conn.close()
            return redirect("/")

        else:
            conn.close()
            error = "Invalid email or password"

    return render_template("login.html", error=error)

@app.route("/logout")
def logout():
    session.clear()
    return redirect("/")


@app.route("/profile/update", methods=["POST"])
def update_profile():
    if "user_id" not in session:
        return redirect(url_for("login"))

    name = request.form.get("name", "").strip()
    phone = request.form.get("phone", "").strip()

    if not name or not phone:
        return redirect(request.referrer or "/")

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "UPDATE users SET name = %s, phone = %s WHERE user_id = %s",
        (name, phone, session["user_id"]),
    )
    conn.commit()
    conn.close()

    session["user_name"] = name
    return redirect(request.referrer or "/")


@app.route("/delete-my-account", methods=["POST"])
def delete_my_account():
    if "user_id" not in session:
        return redirect(url_for("login"))
    role = session.get("role")
    if role == "admin":
        return redirect("/")

    user_id = session["user_id"]
    email = session.get("user_email")
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    try:
        if role == "lawyer":
            cursor.execute("SELECT lawyer_id FROM lawyers WHERE email = %s", (email,))
            law_row = cursor.fetchone()
            if not law_row:
                session.clear()
                return redirect("/")
            lid = int(law_row["lawyer_id"])
            sid = session.get("lawyer_id")
            if sid is not None and int(sid) != lid:
                return redirect("/")

            try:
                cursor.execute(
                    """
                    DELETE cm FROM chat_messages cm
                    INNER JOIN consultations c ON cm.consultation_id = c.consultation_id
                    WHERE c.lawyer_id = %s
                    """,
                    (lid,),
                )
            except mysql.connector.Error as e:
                if getattr(e, "errno", None) != 1146:
                    raise

            cursor.execute("DELETE FROM forwarded_documents WHERE lawyer_id = %s", (lid,))
            cursor.execute("DELETE FROM case_lawyer WHERE lawyer_id = %s", (lid,))
            cursor.execute("UPDATE cases SET lawyer_id = NULL WHERE lawyer_id = %s", (lid,))
            cursor.execute("DELETE FROM consultations WHERE lawyer_id = %s", (lid,))
            cursor.execute("DELETE FROM lawyers WHERE lawyer_id = %s", (lid,))
            cursor.execute("DELETE FROM users WHERE user_id = %s", (user_id,))

            folder = os.path.join(
                app.root_path, app.config.get("LAWYER_PROFILE_FOLDER", "static/lawyer_profiles")
            )
            if os.path.isdir(folder):
                prefix = f"lawyer_{lid}_"
                legacy = f"lawyer_{lid}.jpg"
                for name in os.listdir(folder):
                    if name.startswith(prefix) or name == legacy:
                        try:
                            os.remove(os.path.join(folder, name))
                        except OSError:
                            pass

        elif role == "user":
            try:
                cursor.execute(
                    """
                    DELETE cm FROM chat_messages cm
                    INNER JOIN consultations c ON cm.consultation_id = c.consultation_id
                    WHERE c.user_id = %s
                    """,
                    (user_id,),
                )
            except mysql.connector.Error as e:
                if getattr(e, "errno", None) != 1146:
                    raise
            cursor.execute(
                "DELETE FROM users WHERE user_id = %s AND role = %s",
                (user_id, "user"),
            )
        else:
            return redirect("/")

        conn.commit()
    except mysql.connector.Error:
        conn.rollback()
        raise
    finally:
        conn.close()

    session.clear()
    return redirect("/")


@app.route("/forgot-password", methods=["GET", "POST"])
def forgot_password():
    error = None

    if request.method == "POST":
        email = request.form["email"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM users WHERE email = %s", (email,))
        user = cursor.fetchone()
        conn.close()

        if user:
            return render_template("reset_password.html", email=email)
        else:
            error = "Email not registered."

    return render_template("forgot_password.html", error=error)

@app.route("/reset-password", methods=["POST"])
def reset_password():
    email = request.form["email"]
    new_password = request.form["new_password"]

    hashed_password = bcrypt.hashpw(
        new_password.encode("utf-8"),
        bcrypt.gensalt()
    ).decode("utf-8")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE users SET password = %s
        WHERE email = %s
    """, (hashed_password, email))

    conn.commit()
    conn.close()

    return redirect("/login")

@app.route("/consultations/<int:lawyer_id>", methods=["GET", "POST"])
def consultations(lawyer_id):

    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get selected lawyer
    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id = %s", (lawyer_id,))
    lawyer = cursor.fetchone()

    # If form submitted â†’ Insert booking
    if request.method == "POST":

        consultation_type = request.form["consultation_type"]
        consultation_date = request.form["consultation_date"]
        issue = request.form["issue"]

        # âœ… STEP 2: VIDEO LINK GENERATION
        video_link = None
        if consultation_type == "Video Call":
            video_link = f"https://meet.jit.si/legaladvisor-{session['user_id']}-{lawyer_id}"

        # âœ… UPDATED INSERT QUERY
        cursor.execute("""
            INSERT INTO consultations
            (user_id, lawyer_id, consultation_type, consultation_date, issue, video_link)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (
            session["user_id"],
            lawyer_id,
            consultation_type,
            consultation_date,
            issue,
            video_link
        ))

        conn.commit()

    # Fetch user consultations
    cursor.execute("""
        SELECT consultations.*, lawyers.name
        FROM consultations
        JOIN lawyers ON consultations.lawyer_id = lawyers.lawyer_id
        WHERE consultations.user_id = %s
        ORDER BY consultation_date DESC
    """, (session["user_id"],))

    user_consultations = cursor.fetchall()

    from datetime import date
    
    return render_template(
        "consultations.html",
        lawyer=lawyer,
        consultations=user_consultations,
        today=date.today().isoformat()
    )

import os
from werkzeug.utils import secure_filename

@app.route("/book-consultation/<int:lawyer_id>", methods=["GET", "POST"])
def book_consultation(lawyer_id):

    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id = %s", (lawyer_id,))
    lawyer = cursor.fetchone()

    if request.method == "POST":

        consultation_type = request.form["consultation_type"]
        consultation_date = request.form["consultation_date"]
        issue = request.form["issue"]
        payment_method = request.form["payment_method"]

        # â­ DOCUMENT UPLOAD
        file = request.files["document"]
        filename = None

        if file and file.filename != "":
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))

        # ðŸ’µ CASH PAYMENT
        if payment_method == "cash":

            cursor.execute("""
                INSERT INTO consultations
                (user_id, lawyer_id, consultation_type, consultation_date, issue, status, payment_method, payment_status, document)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
            """, (
                session["user_id"],
                lawyer_id,
                consultation_type,
                consultation_date,
                issue,
                "Pending",
                "Cash",
                "Pending",
                filename
            ))

            conn.commit()
            conn.close()

            return redirect(f"/book-consultation/{lawyer_id}")

        # ðŸ’³ ONLINE PAYMENT
        else:
            conn.close()
            return redirect(f"/create-checkout-session/{lawyer_id}")

    conn.close()
    return render_template("book_consultation.html", lawyer=lawyer)
@app.route("/my-consultations/<int:lawyer_id>")
def my_consultations(lawyer_id):

    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get lawyer details
    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id = %s", (lawyer_id,))
    lawyer = cursor.fetchone()

    # Get user's bookings for that lawyer
    cursor.execute("""
        SELECT * FROM consultations
        WHERE user_id = %s AND lawyer_id = %s
        ORDER BY consultation_date DESC
    """, (session["user_id"], lawyer_id))

    consultations = cursor.fetchall()

    conn.close()

    return render_template(
        "my_consultations.html",
        lawyer=lawyer,
        consultations=consultations
    )

@app.route("/update-consultation-status/<int:consultation_id>/<status>")
def update_consultation_status(consultation_id, status):

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        UPDATE consultations
        SET status = %s
        WHERE consultation_id = %s
    """, (status, consultation_id))

    conn.commit()
    conn.close()

    return redirect(request.referrer)

@app.route("/admin-consultations")
def admin_consultations():

    if session.get("role") != "admin":
        return "Access Denied"

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("""
        SELECT consultations.*, lawyers.name AS lawyer_name
        FROM consultations
        JOIN lawyers ON consultations.lawyer_id = lawyers.lawyer_id
    """)

    consultations = cursor.fetchall()

    conn.close()

    return render_template("admin_consultations.html", consultations=consultations)

@app.route("/search")
def search():

    query = request.args.get("query")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Search Laws
    cursor.execute("""
SELECT laws.*
FROM laws
LEFT JOIN law_categories
ON laws.category_id = law_categories.category_id
WHERE LOWER(laws.act_name) LIKE LOWER(%s)
OR LOWER(laws.simple_explanation) LIKE LOWER(%s)
OR LOWER(law_categories.category_name) LIKE LOWER(%s)
""", (f"%{query}%", f"%{query}%", f"%{query}%"))

    laws = cursor.fetchall()

    # Search Lawyers
    cursor.execute("""
        SELECT * FROM lawyers
        WHERE name LIKE %s
        OR specialization LIKE %s
        OR city LIKE %s
    """, (f"%{query}%", f"%{query}%", f"%{query}%"))

    lawyers = cursor.fetchall()

    conn.close()

    return render_template(
        "search_results.html",
        query=query,
        laws=laws,
        lawyers=lawyers
    )

@app.route("/lawyer-dashboard")
def lawyer_dashboard():

    if session.get("role") != "lawyer":
        return "Access denied"

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT * FROM lawyers WHERE email = %s",
        (session.get("user_email"),),
    )
    lawyer_profile = cursor.fetchone()

    if not lawyer_profile:
        conn.close()
        return "Lawyer profile not found"

    lawyer_id = lawyer_profile["lawyer_id"]

    # Get consultations
    cursor.execute("""
        SELECT consultations.*, users.name AS user_name
        FROM consultations
        JOIN users ON consultations.user_id = users.user_id
        WHERE consultations.lawyer_id = %s
        ORDER BY consultation_date DESC
    """, (lawyer_id,))
    consultations = cursor.fetchall()

    # â­ NEW â€” Get forwarded case documents
    cursor.execute("""
    SELECT forwarded_documents.forward_id,
           cases.title AS case_title,
           case_documents.file_name,
           forwarded_documents.forwarded_at,
           users.name AS client_name
    FROM forwarded_documents
    JOIN cases ON forwarded_documents.case_id = cases.case_id
    JOIN case_documents ON forwarded_documents.document_id = case_documents.document_id
    LEFT JOIN users ON cases.user_id = users.user_id
    WHERE forwarded_documents.lawyer_id = %s
    ORDER BY forwarded_documents.forwarded_at DESC
""", (session.get("lawyer_id"),))

    forwarded_docs = cursor.fetchall()

    conn.close()

    return render_template(
        "lawyer_dashboard.html",
        consultations=consultations,
        forwarded_docs=forwarded_docs,
        lawyer_profile=lawyer_profile,
    )


@app.route("/lawyer/update-profile", methods=["POST"])
def lawyer_update_profile():
    if session.get("role") != "lawyer":
        return redirect("/login")

    name = request.form.get("name", "").strip()
    phone = request.form.get("phone", "").strip()
    specialization = request.form.get("specialization", "").strip()
    city = request.form.get("city", "").strip()

    if not all([name, phone, specialization, city]):
        return redirect(url_for("lawyer_dashboard", profile_error="Please fill in all profile fields."))

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT lawyer_id, email FROM lawyers WHERE email = %s",
        (session.get("user_email"),),
    )
    lawyer = cursor.fetchone()

    if not lawyer:
        conn.close()
        return redirect(url_for("lawyer_dashboard", profile_error="Lawyer profile not found."))

    cursor.execute(
        """
        UPDATE lawyers
        SET name = %s, phone = %s, specialization = %s, city = %s
        WHERE lawyer_id = %s
        """,
        (name, phone, specialization, city, lawyer["lawyer_id"]),
    )
    cursor.execute(
        "UPDATE users SET name = %s WHERE email = %s",
        (name, lawyer["email"]),
    )

    conn.commit()
    conn.close()

    session["lawyer_id"] = lawyer["lawyer_id"]
    return redirect(url_for("lawyer_dashboard", profile_updated="1"))


@app.route("/lawyer/upload-profile-image", methods=["POST"])
def lawyer_upload_profile_image():
    if session.get("role") != "lawyer" or session.get("lawyer_id") is None:
        return jsonify({"ok": False, "error": "Unauthorized"}), 403

    f = request.files.get("image")
    if not f or f.filename == "":
        return jsonify({"ok": False, "error": "No image uploaded"}), 400

    ct = (f.mimetype or "").lower()
    fn = (f.filename or "").lower()
    head = f.stream.read(16)
    f.stream.seek(0)
    is_jpeg = len(head) >= 3 and head[:3] == b"\xff\xd8\xff"
    is_png = len(head) >= 8 and head[:8] == b"\x89PNG\r\n\x1a\n"
    canvas_upload = ct == "application/octet-stream" and fn.endswith((".jpg", ".jpeg", ".png"))
    if not (is_jpeg or is_png or ct.startswith("image/") or canvas_upload):
        return jsonify({"ok": False, "error": "File must be an image"}), 400

    lawyer_id = session["lawyer_id"]
    folder = os.path.join(app.root_path, app.config["LAWYER_PROFILE_FOLDER"])
    os.makedirs(folder, exist_ok=True)

    # New filename each upload so browsers load the updated photo on /lawyers (cache bust)
    ext = ".png" if is_png else ".jpg"
    fname = f"lawyer_{lawyer_id}_{datetime.now().strftime('%Y%m%d%H%M%S%f')}{ext}"
    dest = os.path.join(folder, fname)

    conn = get_db_connection()
    cursor = conn.cursor()
    try:
        ensure_lawyer_profile_image_column(conn, cursor)
    except mysql.connector.Error as e:
        conn.close()
        return (
            jsonify(
                {
                    "ok": False,
                    "error": "Could not update database schema: "
                    + (str(e) or "check MySQL user has ALTER privilege"),
                }
            ),
            500,
        )

    for name in os.listdir(folder):
        if name.startswith(f"lawyer_{lawyer_id}_") or name == f"lawyer_{lawyer_id}.jpg":
            try:
                os.remove(os.path.join(folder, name))
            except OSError:
                pass

    f.save(dest)
    if os.path.getsize(dest) < 64:
        try:
            os.remove(dest)
        except OSError:
            pass
        conn.close()
        return jsonify({"ok": False, "error": "Image file was empty or too small"}), 400

    try:
        cursor.execute(
            "UPDATE lawyers SET profile_image = %s WHERE lawyer_id = %s",
            (fname, lawyer_id),
        )
        conn.commit()
    except mysql.connector.Error as e:
        conn.close()
        try:
            os.remove(dest)
        except OSError:
            pass
        if getattr(e, "errno", None) == 1054:
            return (
                jsonify(
                    {
                        "ok": False,
                        "error": "profile_image column still missing; run migrations/add_lawyer_profile_image.sql manually.",
                    }
                ),
                500,
            )
        raise
    conn.close()

    image_url = url_for("static", filename=f"lawyer_profiles/{fname}")
    return jsonify({"ok": True, "url": image_url})


@app.route("/delete-forwarded-document/<int:forward_id>", methods=["POST"])
def delete_forwarded_document(forward_id):
    """Remove a document from the lawyer's forwarded list (does not delete the client's case file)."""
    if session.get("role") != "lawyer" or session.get("lawyer_id") is None:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()
    cursor.execute(
        "DELETE FROM forwarded_documents WHERE forward_id = %s AND lawyer_id = %s",
        (forward_id, session["lawyer_id"]),
    )
    conn.commit()
    conn.close()

    return redirect(url_for("lawyer_dashboard"))


@app.route("/delete-document/<int:doc_id>", methods=["POST"])
def delete_document(doc_id):

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute(
        "SELECT file_name FROM case_documents WHERE document_id = %s",
        (doc_id,)
    )
    doc = cursor.fetchone()

    if doc:
        file_path = os.path.join("static/case_documents", doc["file_name"])

        if os.path.exists(file_path):
            os.remove(file_path)

        cursor.execute(
            "DELETE FROM case_documents WHERE document_id = %s",
            (doc_id,)
        )
        conn.commit()

    conn.close()

    return redirect("/lawyer-dashboard")

@app.route("/admin/delete-user/<int:user_id>")
def delete_user(user_id):

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM users WHERE user_id=%s",(user_id,))
    conn.commit()

    return redirect("/admin/users")

@app.route("/admin/delete-lawyer/<int:lawyer_id>")
def delete_lawyer(lawyer_id):

    if session.get("role") != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT email FROM lawyers WHERE lawyer_id=%s",(lawyer_id,))
    lawyer = cursor.fetchone()

    cursor.execute("DELETE FROM lawyers WHERE lawyer_id=%s",(lawyer_id,))
    cursor.execute("DELETE FROM users WHERE email=%s",(lawyer["email"],))

    conn.commit()
    conn.close()

    return redirect("/admin/lawyers")

@app.route("/admin/add-lawyer", methods=["GET", "POST"])
def admin_add_lawyer():

    if session.get("role") != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    if request.method == "POST":

        name = request.form["name"].strip()
        email = request.form["email"].strip().lower()
        password = request.form["password"]
        city = request.form["city"].strip()
        specialization = request.form["specialization"].strip()
        experience = request.form["experience"]
        phone = request.form["phone"].strip()
        consultation_fee = request.form["consultation_fee"]
        description = request.form["description"].strip()

        form_user = {
            "name": name,
            "email": email,
            "city": city,
            "specialization": specialization,
            "experience": experience,
            "phone": phone,
            "consultation_fee": consultation_fee,
            "description": description,
        }

        if len(password) < 8:
            conn.close()
            return render_template(
                "admin_add_lawyer.html",
                user=form_user,
                error="Password must be at least 8 characters long.",
            )

        cursor.execute("SELECT lawyer_id FROM lawyers WHERE email=%s", (email,))
        existing_lawyer = cursor.fetchone()
        if existing_lawyer:
            conn.close()
            return render_template(
                "admin_add_lawyer.html",
                user=form_user,
                error="A lawyer with this email already exists.",
            )

        cursor.execute("SELECT user_id FROM users WHERE email=%s", (email,))
        existing_user = cursor.fetchone()
        hashed_password = bcrypt.hashpw(
            password.encode("utf-8"),
            bcrypt.gensalt()
        ).decode("utf-8")

        if existing_user:
            cursor.execute(
                """
                UPDATE users
                SET name=%s, phone=%s, password=%s, role='lawyer'
                WHERE user_id=%s
                """,
                (name, phone, hashed_password, existing_user["user_id"]),
            )
        else:
            cursor.execute(
                """
                INSERT INTO users (name, email, password, phone, role)
                VALUES (%s, %s, %s, %s, 'lawyer')
                """,
                (name, email, hashed_password, phone),
            )

        # insert into lawyers table
        cursor.execute("""
        INSERT INTO lawyers 
        (name, email, city, specialization, experience, phone, consultation_fee, description)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        """, (name, email, city, specialization, experience, phone, consultation_fee, description))

        conn.commit()
        conn.close()

        return redirect("/admin/lawyers")

    conn.close()
    return render_template("admin_add_lawyer.html", user={})

@app.route("/payment/<int:lawyer_id>")
def payment(lawyer_id):

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id=%s",(lawyer_id,))
    lawyer = cursor.fetchone()

    conn.close()

    return render_template("payment.html", lawyer=lawyer)

@app.route("/payment-success/<int:lawyer_id>", methods=["GET","POST"])
def payment_success(lawyer_id):

    user_id = session.get("user_id")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
    INSERT INTO consultations
    (user_id, lawyer_id, consultation_type, consultation_date, status, payment_status)
    VALUES (%s,%s,'Online',CURDATE(),'Pending','Paid')
    """,(user_id,lawyer_id))

    conn.commit()
    conn.close()

    return redirect("/consultations/1")

@app.route("/scheme-checker", methods=["GET","POST"])
def scheme_checker():

    schemes = []

    if request.method == "POST":

        category = request.form["category"]
        income = request.form["income"]
        caste = request.form["caste"]
        gender = request.form["gender"]

        conn = get_db_connection()
        cursor = conn.cursor(dictionary=True)

        cursor.execute("""
            SELECT * FROM government_schemes
            WHERE category = %s
            AND %s BETWEEN min_income AND max_income
            AND (caste = %s OR caste = 'Any')
            AND (gender = %s OR gender = 'Any')
        """, (category, income, caste, gender))

        schemes = cursor.fetchall()
        conn.close()

    return render_template("scheme_checker.html", schemes=schemes)

@app.route("/admin/lawyers")
def admin_lawyers():

    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lawyers")
    lawyers = cursor.fetchall()

    conn.close()

    return render_template("admin_lawyers.html", lawyers=lawyers)

@app.route("/admin-users")
def admin_users():

    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM users")
    users = cursor.fetchall()

    conn.close()

    return render_template("admin_users.html", users=users)


def _get_user_for_role_change(cursor, user_id):
    cursor.execute(
        "SELECT user_id, name, email, phone, role FROM users WHERE user_id=%s",
        (user_id,),
    )
    return cursor.fetchone()


def _ensure_lawyer_profile_for_user(cursor, user):
    """Create a minimal lawyer profile when admin promotes a user to lawyer."""
    cursor.execute(
        "SELECT lawyer_id FROM lawyers WHERE email=%s",
        (user["email"],),
    )
    existing_lawyer = cursor.fetchone()

    if existing_lawyer:
        cursor.execute(
            """
            UPDATE lawyers
            SET name=%s,
                phone=%s
            WHERE lawyer_id=%s
            """,
            (
                user["name"],
                user.get("phone") or "0000000000",
                existing_lawyer["lawyer_id"],
            ),
        )
        return existing_lawyer["lawyer_id"]

    cursor.execute(
        """
        INSERT INTO lawyers
        (name, email, city, specialization, experience, phone, consultation_fee, description)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """,
        (
            user["name"],
            user["email"],
            "Not Added Yet",
            "General Practice",
            0,
            user.get("phone") or "0000000000",
            0,
            "Profile created by admin promotion. Please update lawyer details from admin panel.",
        ),
    )
    return cursor.lastrowid

@app.route("/admin/make-lawyer/<int:user_id>")
def make_lawyer(user_id):
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    user = _get_user_for_role_change(cursor, user_id)
    if not user:
        conn.close()
        return redirect("/admin-users")

    _ensure_lawyer_profile_for_user(cursor, user)

    cursor.execute(
    "UPDATE users SET role='lawyer' WHERE user_id=%s",
    (user_id,)
    )

    conn.commit()
    conn.close()

    return redirect("/admin-users")

@app.route("/admin/make-admin/<int:user_id>")
def make_admin(user_id):
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    user = _get_user_for_role_change(cursor, user_id)
    if not user:
        conn.close()
        return redirect("/admin-users")

    cursor.execute(
    "UPDATE users SET role='admin' WHERE user_id=%s",
    (user_id,)
    )

    conn.commit()
    conn.close()

    return redirect("/admin-users")

@app.route("/admin/make-user/<int:user_id>")
def make_user(user_id):
    if "role" not in session or session["role"] != "admin":
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    user = _get_user_for_role_change(cursor, user_id)
    if not user:
        conn.close()
        return redirect("/admin-users")

    # update role
    cursor.execute(
        "UPDATE users SET role='user' WHERE user_id=%s",
        (user_id,)
    )

    cursor.execute(
        "DELETE FROM consultations WHERE lawyer_id IN (SELECT lawyer_id FROM lawyers WHERE email=%s)",
        (user["email"],)
)

    # remove lawyer profile
    cursor.execute(
        "DELETE FROM lawyers WHERE email=%s",
        (user["email"],)
    )

    conn.commit()
    conn.close()

    return redirect("/admin-users")

@app.route("/admin/add-lawyer/<int:user_id>", methods=["GET","POST"])
def add_lawyer_from_user(user_id):

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get user info
    cursor.execute("SELECT * FROM users WHERE user_id=%s",(user_id,))
    user = cursor.fetchone()

    if request.method == "POST":

        name = request.form["name"]
        city = request.form["city"]
        specialization = request.form["specialization"]
        experience = request.form["experience"]
        phone = request.form["phone"]
        consultation_fee = request.form["consultation_fee"]
        description = request.form["description"]

        # Insert into lawyers table
        cursor.execute("""
        INSERT INTO lawyers
        (name,email,city,specialization,experience,phone,consultation_fee,description)
        VALUES (%s,%s,%s,%s,%s,%s,%s,%s)
        """,
        (name,user["email"],city,specialization,experience,phone,consultation_fee,description)
        )

        # Update role
        cursor.execute(
        "UPDATE users SET role='lawyer' WHERE user_id=%s",
        (user_id,)
        )

        conn.commit()
        conn.close()

        return redirect("/admin/lawyers")

    conn.close()

    return render_template("admin_add_lawyer.html", user=user)

import stripe

stripe.api_key = "os.getenv("STRIPE_SECRET_KEY", "")"

@app.route("/create-checkout-session/<int:lawyer_id>")
def create_checkout_session(lawyer_id):

    conn = get_db_connection()

    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id=%s",(lawyer_id,))
    lawyer = cursor.fetchone()

    conn.close()

    try:
        session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'inr',
                    'product_data': {
                        'name': f'Consultation with {lawyer["name"]}',
                    },
                    'unit_amount': int(lawyer["consultation_fee"]) * 100,
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=f'http://127.0.0.1:5000/payment-success/{lawyer_id}',
            cancel_url='http://127.0.0.1:5000/lawyers',
        )

        return redirect(session.url, code=303)

    except Exception as e:
        print(e)
        return str(e)

@app.route("/admin/edit-fee/<int:lawyer_id>", methods=["GET","POST"])
def edit_fee(lawyer_id):

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # get lawyer
    cursor.execute("SELECT * FROM lawyers WHERE lawyer_id=%s",(lawyer_id,))
    lawyer = cursor.fetchone()

    if request.method == "POST":

        new_fee = request.form["consultation_fee"]

        cursor.execute(
        "UPDATE lawyers SET consultation_fee=%s WHERE lawyer_id=%s",
        (new_fee,lawyer_id)
        )

        conn.commit()
        conn.close()

        return redirect("/admin/lawyers")

    conn.close()

    return render_template("edit_fee.html", lawyer=lawyer)

@app.route("/book/<int:lawyer_id>", methods=["GET","POST"])
def book(lawyer_id):

    if request.method == "POST":

        consultation_type = request.form["consultation_type"]
        consultation_date = request.form["consultation_date"]
        issue = request.form["issue"]
        payment_method = request.form["payment_method"]

        # ðŸŸ¢ CASH PAYMENT
        if payment_method == "cash":

            conn = get_db_connection()
            cursor = conn.cursor()

            cursor.execute("""
            INSERT INTO consultations 
            (user_id, lawyer_id, consultation_type, consultation_date, issue, payment_status, payment_method)
            VALUES (%s,%s,%s,%s,%s,%s,%s)
            """, (
                session["user_id"],
                lawyer_id,
                consultation_type,
                consultation_date,
                issue,
                "Pending",   # payment not done yet
                "Cash"
            ))

            conn.commit()
            conn.close()

            return redirect("/consultations/" + str(session["user_id"]))

        # ðŸ”µ ONLINE PAYMENT (Stripe)
        elif payment_method == "online":
            return redirect("/create-checkout-session/" + str(lawyer_id))

    return render_template("book_consultation.html")


@app.route("/forward-document/<int:case_id>", methods=["POST"])
def forward_document(case_id):
    if "user_id" not in session:
        return redirect("/login")

    # Get selected document
    document_id = request.form.get("document_id")

    if not document_id:
        return "No document selected"

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get lawyer assigned to this case
    cursor.execute("""
        SELECT lawyer_id FROM case_lawyer
        WHERE case_id = %s
    """, (case_id,))
    lawyer = cursor.fetchone()

    if not lawyer:
        conn.close()
        return "No lawyer assigned to this case"

    lawyer_id = lawyer["lawyer_id"]

    # Insert forwarded document
    cursor.execute("""
        INSERT INTO forwarded_documents (case_id, lawyer_id, document_id)
        VALUES (%s, %s, %s)
    """, (case_id, lawyer_id, document_id))

    conn.commit()
    conn.close()

    return redirect(f"/case/{case_id}")

@app.route("/upload-case-document/<int:case_id>", methods=["POST"])
def upload_case_document(case_id):
    if "user_id" not in session:
        return redirect("/login")

    import os

    file = request.files["document"]
    filename = file.filename

    upload_folder = app.config["CASE_DOCUMENT_FOLDER"]

    # Create folder if not exists
    if not os.path.exists(upload_folder):
        os.makedirs(upload_folder)

    file_path = os.path.join(upload_folder, filename)
    file.save(file_path)

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("""
        INSERT INTO case_documents (case_id, file_name)
        VALUES (%s, %s)
    """, (case_id, filename))

    conn.commit()
    conn.close()

    print("Saved to:", file_path)

    return redirect(f"/case/{case_id}")

@app.route("/delete-case/<int:case_id>", methods=["POST"])
def delete_case(case_id):
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()

    # Delete related data first
    cursor.execute("DELETE FROM case_documents WHERE case_id=%s", (case_id,))
    cursor.execute("DELETE FROM case_timeline WHERE case_id=%s", (case_id,))
    cursor.execute("DELETE FROM forwarded_documents WHERE case_id=%s", (case_id,))
    cursor.execute("DELETE FROM cases WHERE case_id=%s", (case_id,))

    conn.commit()
    conn.close()

    return redirect("/cases")

@app.route("/delete-consultation/<int:consultation_id>", methods=["POST"])
def delete_consultation(consultation_id):
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get lawyer_id before deleting
    cursor.execute("SELECT lawyer_id FROM consultations WHERE consultation_id=%s", (consultation_id,))
    consultation = cursor.fetchone()
    lawyer_id = consultation["lawyer_id"]

    # Delete consultation
    cursor.execute("DELETE FROM consultations WHERE consultation_id=%s", (consultation_id,))

    conn.commit()
    conn.close()

    # Redirect back to same consultation page
    return redirect(f"/consultations/{lawyer_id}")

# ADMIN DELETE CONSULTATION
@app.route("/delete-consultation-admin/<int:consultation_id>", methods=["POST"])
def delete_consultation_admin(consultation_id):
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM consultations WHERE consultation_id=%s", (consultation_id,))

    conn.commit()
    conn.close()

    return redirect("/admin-consultations")


# LAWYER DELETE CONSULTATION
@app.route("/delete-consultation-lawyer/<int:consultation_id>", methods=["POST"])
def delete_consultation_lawyer(consultation_id):
    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor()

    cursor.execute("DELETE FROM consultations WHERE consultation_id=%s", (consultation_id,))

    conn.commit()
    conn.close()

    return redirect("/lawyer-dashboard")

import smtplib
from email.mime.text import MIMEText

def send_email(to_email, subject, message):
    from_email = "advisorlegal2026@gmail.com"
    password = "jdhq qxma mijn waor"

    msg = MIMEText(message)
    msg["Subject"] = subject
    msg["From"] = from_email
    msg["To"] = to_email

    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(from_email, password)
    server.sendmail(from_email, to_email, msg.as_string())
    server.quit()

from datetime import datetime, timedelta

def check_hearing_reminders():
    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    tomorrow = (datetime.now() + timedelta(days=1)).date()

    cursor.execute("""
        SELECT cases.case_id, cases.title, cases.next_hearing, users.email
        FROM cases
        JOIN users ON cases.user_id = users.user_id
        WHERE DATE(next_hearing) = %s
    """, (tomorrow,))

    hearings = cursor.fetchall()

    for case in hearings:
        subject = "Hearing Reminder"
        message = f"""
        Reminder: Your hearing for case '{case['title']}' is scheduled tomorrow ({case['next_hearing']}).
        Please be prepared.
        """

        send_email(case["email"], subject, message)

    conn.close()

from apscheduler.schedulers.background import BackgroundScheduler

scheduler = BackgroundScheduler()
scheduler.add_job(func=check_hearing_reminders, trigger="interval", hours=24)
scheduler.start()

import smtplib
from email.mime.text import MIMEText
from datetime import datetime, timedelta
from apscheduler.schedulers.background import BackgroundScheduler


def send_email(to_email, subject, message):
    from_email = "advisorlegal2026@gmail.com"
    password = "jdhq qxma mijn waor"

    msg = MIMEText(message)
    msg["Subject"] = subject
    msg["From"] = from_email
    msg["To"] = to_email

    server = smtplib.SMTP("smtp.gmail.com", 587)
    server.starttls()
    server.login(from_email, password)
    server.sendmail(from_email, to_email, msg.as_string())
    server.quit()


from datetime import datetime, timedelta

def check_hearing_reminders():
    print("Checking hearing reminders...")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    now = datetime.now()
    next_24_hours = now + timedelta(hours=24)

    # Get hearings within next 24 hours and reminder not sent
    cursor.execute("""
        SELECT cases.case_id, cases.title, cases.next_hearing,
               users.email, users.name
        FROM cases
        JOIN users ON cases.user_id = users.user_id
        WHERE cases.next_hearing BETWEEN %s AND %s
        AND cases.reminder_sent = 0
    """, (now, next_24_hours))

    hearings = cursor.fetchall()

    for case in hearings:
        subject = "Court Hearing Reminder"
        message = f"""
Dear {case['name']},

This is a reminder that your court hearing for the case 
"{case['title']}" is scheduled on {case['next_hearing']}.

Please ensure that you are present at the court on the scheduled date 
and carry all the necessary documents related to your case.

If you have any questions, please contact your lawyer.

Thank you for using Legal Advisor System.

Best Regards,
Legal Advisor Team
"""

        send_email(case["email"], subject, message)

        # Mark reminder as sent
        cursor.execute("""
            UPDATE cases SET reminder_sent = 1
            WHERE case_id = %s
        """, (case["case_id"],))

        conn.commit()

    # Reset reminder after hearing date passed
    cursor.execute("""
        UPDATE cases
        SET reminder_sent = 0
        WHERE next_hearing < CURDATE()
    """)
    conn.commit()

    conn.close()

@app.route("/chat/<int:consultation_id>", methods=["GET", "POST"])
def chat(consultation_id):

    if "user_id" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    cursor.execute("SELECT * FROM consultations WHERE consultation_id = %s", (consultation_id,))
    consultation = cursor.fetchone()

    if not consultation:
        return "Consultation not found"

    # ACCESS CONTROL
    if session["role"] == "user" and consultation["user_id"] != session["user_id"]:
        return "Unauthorized"

    if session["role"] == "lawyer" and consultation["lawyer_id"] != session.get("lawyer_id"):
        return "Unauthorized"

    # ONLY APPROVED
    if consultation["status"] != "Approved":
        return "Chat available only after approval"

    cursor.execute("SELECT name FROM users WHERE user_id = %s", (consultation["user_id"],))
    user_row = cursor.fetchone()
    cursor.execute("SELECT name FROM lawyers WHERE lawyer_id = %s", (consultation["lawyer_id"],))
    lawyer_row = cursor.fetchone()
    user = {"name": (user_row or {}).get("name") or "Client"}
    lawyer = {"name": (lawyer_row or {}).get("name") or "Lawyer"}

    ensure_chat_message_attachment_columns(conn, cursor)

    chat_upload_dir = os.path.join(app.root_path, "static", "chat_uploads")
    os.makedirs(chat_upload_dir, exist_ok=True)

    # SEND MESSAGE (text and/or file)
    if request.method == "POST":
        message = (request.form.get("message") or "").strip()
        upload = request.files.get("document")
        attachment_path = None
        attachment_original_name = None

        if upload and upload.filename:
            raw_name = secure_filename(upload.filename)
            if not raw_name:
                conn.close()
                return redirect(url_for("chat", consultation_id=consultation_id))
            ext = os.path.splitext(raw_name)[1].lower()
            if ext not in ALLOWED_CHAT_UPLOAD_EXTENSIONS:
                conn.close()
                return redirect(url_for("chat", consultation_id=consultation_id))
            upload.seek(0, os.SEEK_END)
            size = upload.tell()
            upload.seek(0)
            if size > MAX_CHAT_UPLOAD_BYTES:
                conn.close()
                return redirect(url_for("chat", consultation_id=consultation_id))
            store_name = f"{consultation_id}_{secrets.token_hex(8)}{ext}"
            dest_fs = os.path.join(chat_upload_dir, store_name)
            upload.save(dest_fs)
            attachment_path = f"chat_uploads/{store_name}"
            attachment_original_name = raw_name[:240]

        if not message and not attachment_path:
            conn.close()
            return redirect(url_for("chat", consultation_id=consultation_id))

        if session["role"] == "lawyer":
            sender_id = session.get("lawyer_id")
        else:
            sender_id = session["user_id"]

        cursor.execute(
            """
            INSERT INTO chat_messages
            (consultation_id, sender_id, sender_role, message, attachment_path, attachment_original_name)
            VALUES (%s, %s, %s, %s, %s, %s)
            """,
            (
                consultation_id,
                sender_id,
                session["role"],
                message,
                attachment_path,
                attachment_original_name,
            ),
        )

        conn.commit()

    # GET MESSAGES
    cursor.execute("""
        SELECT * FROM chat_messages
        WHERE consultation_id = %s
        ORDER BY created_at ASC
    """, (consultation_id,))

    messages = cursor.fetchall()

    conn.close()

    return render_template(
        "chat.html",
        messages=messages,
        consultation=consultation,
        lawyer=lawyer,
        user=user,
    )

@app.route("/audio-call/<int:consultation_id>")
def audio_call(consultation_id):

    if "role" not in session:
        return redirect("/login")

    conn = get_db_connection()
    cursor = conn.cursor(dictionary=True)

    # Get consultation
    cursor.execute("SELECT * FROM consultations WHERE consultation_id = %s", (consultation_id,))
    c = cursor.fetchone()

    if not c:
        return "Consultation not found"

    # ðŸ” Access control
    if session["role"] == "user" and c["user_id"] != session.get("user_id"):
        return "Unauthorized"

    if session["role"] == "lawyer" and c["lawyer_id"] != session.get("lawyer_id"):
        return "Unauthorized"

    # ðŸš« Only approved
    if c["status"] != "Approved":
        return "Call available only after approval"

    # âœ… HANDLE ALL ROLES
    if session["role"] == "user":
        # ðŸ‘¤ USER â†’ calls LAWYER
        cursor.execute(
            "SELECT phone FROM lawyers WHERE lawyer_id = %s",
            (c["lawyer_id"],)
        )
        target = cursor.fetchone()

    elif session["role"] == "lawyer":
        # âš– LAWYER â†’ calls USER
        cursor.execute(
            "SELECT phone FROM users WHERE user_id = %s",
            (c["user_id"],)
        )
        target = cursor.fetchone()

    elif session["role"] == "admin":
        # ðŸ›  ADMIN â†’ calls LAWYER (default behavior)
        cursor.execute(
            "SELECT phone FROM lawyers WHERE lawyer_id = %s",
            (c["lawyer_id"],)
        )
        target = cursor.fetchone()

    else:
        conn.close()
        return "Invalid role"

    conn.close()

    phone = target["phone"] if target and target.get("phone") else "Not available"

    return render_template("audio_call.html", phone=phone)

import smtplib
from email.mime.text import MIMEText


def send_welcome_email(to_email, name):
    try:
        sender_email = "advisorlegal2026@gmail.com"
        sender_password = "jdhq qxma mijn waor"

        subject = "Welcome to Legal Advisor"
        message = f"""
Hello {name},

Welcome to Legal Advisor Platform!

You can now:
- Book consultations
- Chat with lawyers
- Use audio/video calls

Thank you for joining us.

Regards,
Legal Advisor Team
"""

        msg = MIMEText(message)
        msg["Subject"] = subject
        msg["From"] = sender_email
        msg["To"] = to_email

        server = smtplib.SMTP("smtp.gmail.com", 587)
        server.starttls()
        server.login(sender_email, sender_password)
        server.send_message(msg)
        server.quit()

        print("Email sent successfully")

    except Exception as e:
        print("Email failed:", e)

from apscheduler.schedulers.background import BackgroundScheduler

if __name__ == "__main__":
    scheduler = BackgroundScheduler()
    scheduler.add_job(func=check_hearing_reminders, trigger="interval", minutes=1)  #change to hour = 1 for testing i will use  minutes = 1
    scheduler.start()

    app.run(debug=True)


print(app.url_map)


# ðŸš¨ ALWAYS KEEP THIS AT THE VERY END
if __name__ == "__main__":
    app.run(debug=True)
