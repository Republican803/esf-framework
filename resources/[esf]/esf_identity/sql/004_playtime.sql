-- 004_playtime.sql: shift/session tracking
CREATE TABLE IF NOT EXISTS playtime (
    char_id INT PRIMARY KEY,
    total_time INT DEFAULT 0,
    FOREIGN KEY (char_id) REFERENCES characters(id) ON DELETE CASCADE
);