# Design System: The Editorial Advocate

## 1. Overview & Creative North Star
The Creative North Star for this design system is **"The Stoic Editorial."** 

This is not a typical "corporate" legal site. It is a high-end digital publication that happens to provide world-class legal counsel. We move away from the "template" look—characterized by rigid boxes and centered text—and instead embrace the asymmetrical elegance of a premium broadsheet or a luxury fashion house. 

To achieve this, we utilize extreme typographic scale, intentional white space (negative space as a luxury), and a layered depth that feels like physical paper and glass rather than digital pixels. We reject the "standard" UI of 1px borders and shadows; instead, we define authority through composition and tonal shifts.

---

## 2. Colors & Surface Philosophy
The palette is rooted in `primary` (#0e1c2b), a deep, commanding navy that establishes immediate gravitas. This is balanced by the `secondary` (#775a19) "Subtle Gold," used sparingly for high-value accents.

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning or card definition. Structural boundaries must be defined solely through background color shifts. For example, a `surface-container-low` (#f3f3f8) section should sit directly against a `surface` (#f9f9fe) background. The contrast is felt, not seen as a line.

### Surface Hierarchy & Nesting
Treat the UI as a series of stacked, premium materials.
*   **Base:** `surface` (#f9f9fe) for the widest areas.
*   **Nesting:** Place a `surface-container-lowest` (#ffffff) card inside a `surface-container-low` (#f3f3f8) section. This "lifts" the content through brightness rather than artificial shadow.
*   **Depth:** Use `surface-container-highest` (#e2e2e7) for small, functional UI elements like search bars or inactive tabs to ground them.

### The "Glass & Gradient" Rule
To avoid a "flat" feel, use Glassmorphism for floating navigation bars or sticky headers. Use `surface` at 80% opacity with a `backdrop-filter: blur(20px)`. 
*   **Signature Textures:** For Hero backgrounds or primary CTAs, apply a subtle linear gradient from `primary` (#0e1c2b) to `primary-container` (#233141). This adds a "soul" to the color that prevents it from looking like a dead hex code.

---

## 3. Typography
We use a high-contrast pairing of **Newsreader** (Serif) for authority and **Manrope** (Sans-Serif) for modern clarity.

*   **Display (Newsreader):** Use `display-lg` (3.5rem) for hero statements. Tighten letter-spacing (-0.02em) to give it a "printed" feel.
*   **Headlines (Newsreader):** `headline-lg` (2rem) and `headline-md` (1.75rem) serve as the editorial voice of the page.
*   **Body (Manrope):** `body-lg` (1rem) is the workhorse. It provides a contemporary, clean counterpoint to the traditional serif headlines.
*   **Labels (Manrope):** `label-md` (0.75rem) should always be in Uppercase with +0.05em letter-spacing when used for eyebrows or categories to maintain the premium feel.

---

## 4. Elevation & Depth
In this system, depth is a byproduct of light and layering, never "structural" lines.

*   **The Layering Principle:** Depth is achieved by stacking the `surface-container` tiers. A `surface-container-lowest` card on a `surface-container-low` background creates a soft, natural lift.
*   **Ambient Shadows:** If a floating element (like a modal) requires a shadow, use a "Whisper Shadow": `box-shadow: 0 24px 48px -12px rgba(15, 28, 44, 0.08)`. Note the use of the `on-primary-fixed` color for the shadow tint rather than pure black.
*   **The "Ghost Border" Fallback:** If a border is required for accessibility, use the `outline-variant` (#c6c5d4) at **15% opacity**. A 100% opaque border is a failure of the system.

---

## 5. Components

### Buttons
*   **Primary:** A solid `primary` (#0e1c2b) block with `on-primary` (#ffffff) text. Use `DEFAULT` (0.25rem) rounding—keep it sharp and architectural, never pill-shaped.
*   **Secondary:** A "Ghost" style. No background, no border. Use `primary` text with a `secondary` (#775a19) underline that is 2px thick, offset by 4px.
*   **States:** On hover, Primary buttons should shift to `primary-container` (#233141).

### Cards & Lists
*   **Zero-Border Policy:** Cards must never have borders. Use the `surface-container-lowest` color and the `xl` (0.75rem) rounding scale.
*   **Spacing:** Use `spacing-8` (2.75rem) or `spacing-10` (3.5rem) for internal padding. Luxury is defined by the space you "waste."
*   **Dividers:** Forbidden. Use a `spacing-4` (1.4rem) gap between list items or a subtle background shift to `surface-container-low`.

### Input Fields
*   **Styling:** Inputs should be "Underlined" style only, using the `outline` (#767683) token at 30% opacity for the bottom line. This mimics the look of a signed legal document.
*   **Focus:** The line transitions to `secondary` (#775a19) at 100% opacity.

### Signature Component: The "Case Study Ledger"
A specialized list component for legal wins. Use `display-sm` for the "Result" and `body-sm` for the "Context," separated by a `spacing-20` (7rem) horizontal gap, creating a wide, cinematic layout.

---

## 6. Do's and Don'ts

### Do
*   **Do** use asymmetrical layouts (e.g., a 2-column grid where the left column is 33% and the right is 66%).
*   **Do** allow headlines to overlap image containers slightly to create a sense of physical collage.
*   **Do** use `secondary_fixed_dim` (#e9c176) for small, meaningful iconography to draw the eye to "Trust" markers.

### Don't
*   **Don't** use "Blue" for links. Use `primary` with an underline or `secondary` for high-emphasis calls to action.
*   **Don't** use standard 4px or 8px padding for sections. Start at `spacing-16` (5.5rem) and go up to `spacing-24` (8.5rem).
*   **Don't** use drop shadows on buttons or small cards. It cheapens the "Editorial" aesthetic.