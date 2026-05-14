-- =============================================================================
-- KHOJ — Complete normalized MySQL schema (Java EE / Servlets / JSP)
-- Run against a clean database. Adjust ENGINE/CHARSET if your server differs.
-- =============================================================================

SET NAMES utf8mb4;
SET FOREIGN_KEY_CHECKS = 0;

DROP TABLE IF EXISTS wishlists;
DROP TABLE IF EXISTS reviews;
DROP TABLE IF EXISTS property_amenities;
DROP TABLE IF EXISTS property_images;
DROP TABLE IF EXISTS applications;
DROP TABLE IF EXISTS messages;
DROP TABLE IF EXISTS notifications;
DROP TABLE IF EXISTS properties;
DROP TABLE IF EXISTS contact_messages;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS neighborhoods;
DROP TABLE IF EXISTS amenities;
DROP TABLE IF EXISTS property_types;
DROP TABLE IF EXISTS cities;
DROP TABLE IF EXISTS destination_themes;
DROP TABLE IF EXISTS roles;

SET FOREIGN_KEY_CHECKS = 1;

-- -----------------------------------------------------------------------------
-- Reference / lookup
-- -----------------------------------------------------------------------------

CREATE TABLE roles (
    role_id       INT AUTO_INCREMENT PRIMARY KEY,
    role_name     VARCHAR(32) NOT NULL UNIQUE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE destination_themes (
    theme_id      INT AUTO_INCREMENT PRIMARY KEY,
    theme_name    VARCHAR(120) NOT NULL,
    description   VARCHAR(512) DEFAULT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_theme_name (theme_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE cities (
    city_id       INT AUTO_INCREMENT PRIMARY KEY,
    city_name     VARCHAR(120) NOT NULL,
    theme_id      INT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cities_theme FOREIGN KEY (theme_id) REFERENCES destination_themes (theme_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_cities_theme (theme_id),
    INDEX idx_cities_name (city_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE neighborhoods (
    neighborhood_id   INT AUTO_INCREMENT PRIMARY KEY,
    neighborhood_name   VARCHAR(160) NOT NULL,
    city_id             INT NOT NULL,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_neighborhoods_city FOREIGN KEY (city_id) REFERENCES cities (city_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_neighborhoods_city (city_id),
    INDEX idx_neighborhoods_name (neighborhood_name)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE property_types (
    type_id       INT AUTO_INCREMENT PRIMARY KEY,
    type_name     VARCHAR(120) NOT NULL UNIQUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE amenities (
    amenity_id    INT AUTO_INCREMENT PRIMARY KEY,
    amenity_name  VARCHAR(120) NOT NULL UNIQUE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Users (RBAC via roles; landlord onboarding via approved_status)
-- -----------------------------------------------------------------------------

CREATE TABLE users (
    user_id           INT AUTO_INCREMENT PRIMARY KEY,
    full_name         VARCHAR(100) NOT NULL,
    email             VARCHAR(120) NOT NULL,
    password          VARCHAR(255) NOT NULL,
    phone_number      VARCHAR(32) DEFAULT NULL,
    role_id           INT NOT NULL,
    status            VARCHAR(32) NOT NULL DEFAULT 'ACTIVE',
    approved_status   VARCHAR(32) NOT NULL DEFAULT 'APPROVED',
    profile_img       VARCHAR(255) DEFAULT NULL,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_users_role FOREIGN KEY (role_id) REFERENCES roles (role_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    UNIQUE KEY uk_users_email (email),
    UNIQUE KEY uk_users_phone (phone_number),
    INDEX idx_users_role (role_id),
    INDEX idx_users_status (status),
    INDEX idx_users_approved (approved_status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Properties & media
-- -----------------------------------------------------------------------------

CREATE TABLE properties (
    property_id        INT AUTO_INCREMENT PRIMARY KEY,
    landlord_id        INT NOT NULL,
    neighborhood_id    INT NOT NULL,
    type_id             INT NOT NULL,
    title               VARCHAR(255) NOT NULL,
    description         TEXT,
    price               DECIMAL(12,2) NOT NULL,
    price_model         VARCHAR(32) NOT NULL DEFAULT 'Monthly',
    furnishing_status   VARCHAR(32) NOT NULL DEFAULT 'Unfurnished',
    is_verified         BOOLEAN NOT NULL DEFAULT FALSE,
    bedrooms            INT NOT NULL DEFAULT 1,
    created_at          TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_properties_landlord FOREIGN KEY (landlord_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_properties_neighborhood FOREIGN KEY (neighborhood_id) REFERENCES neighborhoods (neighborhood_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    CONSTRAINT fk_properties_type FOREIGN KEY (type_id) REFERENCES property_types (type_id)
        ON UPDATE CASCADE ON DELETE RESTRICT,
    INDEX idx_properties_landlord (landlord_id),
    INDEX idx_properties_neighborhood (neighborhood_id),
    INDEX idx_properties_type (type_id),
    INDEX idx_properties_verified (is_verified)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE property_images (
    image_id      INT AUTO_INCREMENT PRIMARY KEY,
    property_id   INT NOT NULL,
    image_url     VARCHAR(512) NOT NULL,
    is_primary    BOOLEAN NOT NULL DEFAULT FALSE,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_property_images_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_property_images_property (property_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE property_amenities (
    property_id   INT NOT NULL,
    amenity_id    INT NOT NULL,
    PRIMARY KEY (property_id, amenity_id),
    CONSTRAINT fk_pa_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_pa_amenity FOREIGN KEY (amenity_id) REFERENCES amenities (amenity_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_pa_amenity (amenity_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Applications, reviews, wishlists
-- -----------------------------------------------------------------------------

CREATE TABLE applications (
    app_id        INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id     INT NOT NULL,
    property_id   INT NOT NULL,
    status        VARCHAR(32) NOT NULL DEFAULT 'PENDING',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_app_tenant FOREIGN KEY (tenant_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_app_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY uk_app_tenant_property (tenant_id, property_id),
    INDEX idx_applications_tenant (tenant_id),
    INDEX idx_applications_property (property_id),
    INDEX idx_applications_status (status)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE reviews (
    review_id     INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id     INT NOT NULL,
    property_id   INT NOT NULL,
    rating        INT NOT NULL,
    comment       TEXT,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_reviews_tenant FOREIGN KEY (tenant_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_reviews_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY uk_reviews_tenant_property (tenant_id, property_id),
    INDEX idx_reviews_property (property_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE wishlists (
    wishlist_id   INT AUTO_INCREMENT PRIMARY KEY,
    tenant_id     INT NOT NULL,
    property_id   INT NOT NULL,
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_wish_tenant FOREIGN KEY (tenant_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_wish_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    UNIQUE KEY uk_wish_tenant_property (tenant_id, property_id),
    INDEX idx_wishlists_tenant (tenant_id),
    INDEX idx_wishlists_property (property_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Messaging & notifications
-- -----------------------------------------------------------------------------

CREATE TABLE messages (
    message_id    INT AUTO_INCREMENT PRIMARY KEY,
    sender_id     INT NOT NULL,
    receiver_id   INT NOT NULL,
    property_id   INT NOT NULL,
    content       TEXT NOT NULL,
    is_read       BOOLEAN NOT NULL DEFAULT FALSE,
    sent_at       TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_msg_sender FOREIGN KEY (sender_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_msg_receiver FOREIGN KEY (receiver_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    CONSTRAINT fk_msg_property FOREIGN KEY (property_id) REFERENCES properties (property_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_messages_sender (sender_id),
    INDEX idx_messages_receiver (receiver_id),
    INDEX idx_messages_property (property_id),
    INDEX idx_messages_unread (receiver_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

CREATE TABLE notifications (
    notification_id   INT AUTO_INCREMENT PRIMARY KEY,
    user_id           INT NOT NULL,
    message           VARCHAR(512) NOT NULL,
    notification_type VARCHAR(64) NOT NULL,
    is_read           BOOLEAN NOT NULL DEFAULT FALSE,
    created_at        TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_notif_user FOREIGN KEY (user_id) REFERENCES users (user_id)
        ON UPDATE CASCADE ON DELETE CASCADE,
    INDEX idx_notifications_user (user_id),
    INDEX idx_notifications_unread (user_id, is_read)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- -----------------------------------------------------------------------------
-- Public contact form
-- -----------------------------------------------------------------------------

CREATE TABLE contact_messages (
    message_id    INT AUTO_INCREMENT PRIMARY KEY,
    full_name     VARCHAR(150) NOT NULL,
    email         VARCHAR(150) NOT NULL,
    subject       VARCHAR(255) NOT NULL,
    message       TEXT NOT NULL,
    status        VARCHAR(32) NOT NULL DEFAULT 'NEW',
    created_at    TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    INDEX idx_contact_status (status),
    INDEX idx_contact_created (created_at)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

-- =============================================================================
-- Seed data (transactional)
-- Password for seeded admin: "password" (bcrypt below — change in production)
-- =============================================================================

BEGIN;

INSERT INTO roles (role_name) VALUES ('ADMIN'), ('LANDLORD'), ('TENANT');

INSERT INTO destination_themes (theme_name, description) VALUES
    ('Heritage & Culture', 'Cities rich in history and local character'),
    ('Student Hubs', 'Areas popular with students and young professionals');

INSERT INTO cities (city_name, theme_id) VALUES
    ('Kathmandu', 1),
    ('Pokhara', 2);

INSERT INTO neighborhoods (neighborhood_name, city_id) VALUES
    ('Thamel', 1),
    ('Lakeside', 2);

INSERT INTO property_types (type_name) VALUES
    ('Studio'), ('Shared Room'), ('Private Room'), ('Apartment');

INSERT INTO amenities (amenity_name) VALUES
    ('WiFi'), ('Hot Water'), ('Parking'), ('Laundry'), ('Kitchen');

-- bcrypt hash for plain text "password" (jBCrypt-compatible $2a$ prefix)
INSERT INTO users (full_name, email, password, phone_number, role_id, status, approved_status) VALUES
    ('System Admin', 'admin@khoj.com',
     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
     '+9779800000001', 1, 'ACTIVE', 'APPROVED');

INSERT INTO users (full_name, email, password, phone_number, role_id, status, approved_status) VALUES
    ('Demo Landlord', 'landlord@khoj.com',
     '$2a$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi',
     '+9779800000002', 2, 'ACTIVE', 'APPROVED');

INSERT INTO properties (landlord_id, neighborhood_id, type_id, title, description, price, price_model, furnishing_status, is_verified, bedrooms)
VALUES (2, 1, 4, 'Sample verified listing', 'Starter property for local development.', 15000.00, 'Monthly', 'Furnished', TRUE, 2);

INSERT INTO property_images (property_id, image_url, is_primary) VALUES
    (1, '/resources/images/placeholder-room.jpg', TRUE);

INSERT INTO property_amenities (property_id, amenity_id) VALUES (1, 1), (1, 2);

COMMIT;
