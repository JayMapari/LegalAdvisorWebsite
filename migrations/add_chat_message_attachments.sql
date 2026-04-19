-- Optional file attachments for consultation chat messages (run if columns missing).
ALTER TABLE chat_messages
  ADD COLUMN attachment_path VARCHAR(512) NULL DEFAULT NULL,
  ADD COLUMN attachment_original_name VARCHAR(255) NULL DEFAULT NULL;
