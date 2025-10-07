-- shared/schema.lua: Minimal schema constants for validation
return {
    Users = {
        id = 'INT PRIMARY KEY AUTO_INCREMENT',
        license = 'VARCHAR(50) UNIQUE',
        -- Expand
    },
    -- Expand for other tables
}