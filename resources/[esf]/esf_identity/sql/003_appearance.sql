-- 003_appearance.sql: per-character appearance JSON
CREATE TABLE IF NOT EXISTS appearance (
    char_id INT PRIMARY KEY,
    appearance JSON,
    FOREIGN KEY (char_id) REFERENCES characters(id) ON DELETE CASCADE
);