-- Run once on existing databases (MySQL):
ALTER TABLE lawyers ADD COLUMN profile_image VARCHAR(255) NULL DEFAULT NULL AFTER consultation_fee;
