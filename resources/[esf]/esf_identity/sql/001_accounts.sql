-- 001_accounts.sql: accounts(id, license, steam, discord,...)
CREATE TABLE IF NOT EXISTS accounts (
    id INT AUTO_INCREMENT PRIMARY KEY,
    license VARCHAR(50) UNIQUE,
    steam VARCHAR(50),
    discord VARCHAR(50),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);