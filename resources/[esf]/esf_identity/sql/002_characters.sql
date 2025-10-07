-- 002_characters.sql: characters(slot, dept, rank, last_pos)
CREATE TABLE IF NOT EXISTS characters (
    id INT AUTO_INCREMENT PRIMARY KEY,
    account_id INT NOT NULL,
    slot TINYINT NOT NULL,
    char_name VARCHAR(100) NOT NULL,
    age TINYINT NOT NULL,
    bio TEXT,
    dept VARCHAR(50) NOT NULL,
    rank VARCHAR(50) DEFAULT 'recruit',
    last_pos JSON,
    deleted_at TIMESTAMP NULL,
    UNIQUE KEY (account_id, slot),
    FOREIGN KEY (account_id) REFERENCES accounts(id) ON DELETE CASCADE
);