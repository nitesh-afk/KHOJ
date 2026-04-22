-- KHOJ Project: Resetting the Foundation
-- This script will drop the existing table and recreate it with the correct structure.

DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- BCrypt hashes need space!
    role ENUM('ADMIN', 'LANDLORD', 'TENANT') DEFAULT 'TENANT',
    status VARCHAR(20) DEFAULT 'ACTIVE',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Optional: Insert an Admin for testing (Password is 'admin123' hashed with BCrypt)
-- INSERT INTO users (full_name, email, password, role, status) 
-- VALUES ('System Admin', 'admin@khoj.com', '$2a$12$R.S2C.hR7q0X9Z8r6g8e2u.X6Yk8Z.L7r.m2W1e3N4S5T6U7V8W9X', 'ADMIN', 'ACTIVE');
