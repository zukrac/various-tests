CREATE DATABASE IF NOT EXISTS vacancies_db CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

USE vacancies_db;

CREATE TABLE vacancies (
    id INT AUTO_INCREMENT PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    salary_from INT NULL,
    salary_to INT NULL,
    country_id INT NOT NULL,
    region_id INT NOT NULL,
    city_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
);

SET NAMES utf8mb4;
SET CHARACTER SET utf8mb4;

INSERT INTO vacancies (title, salary_from, salary_to, country_id, region_id, city_id, created_at) VALUES
('PHP разработчик', 80000, 120000, 1, 1, 1, '2024-10-01 10:00:00'),
('Senior Python Developer', 150000, 200000, 1, 1, 1, '2024-10-02 11:00:00'),
('Frontend разработчик React', 90000, 140000, 1, 2, 2, '2024-10-03 12:00:00'),
('DevOps инженер', 120000, 180000, 1, 1, 1, '2024-10-04 13:00:00'),
('Full Stack разработчик', 100000, 160000, 1, 3, 3, '2024-10-05 14:00:00'),
('QA автоматизатор', 70000, 110000, 1, 1, 1, '2024-10-06 15:00:00'),
('Data Scientist', 130000, 190000, 1, 2, 2, '2024-10-07 16:00:00');