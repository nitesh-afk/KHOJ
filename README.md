# KHOJ 🏠
### A Property Rental Platform for Nepal

> **CS5054NT — Advanced Programming and Technologies**
> London Metropolitan University × Itahari International College | Spring 2026

KHOJ *(Nepali: खोज — "to search")* is a full-stack web application that connects tenants with verified landlords across Nepal. Built using Java EE, JSP, and MySQL following the MVC architecture pattern.

---

## 📸 Screenshots

<img width="1763" height="4603" alt="Screenshot_31-5-2026_20514_localhost" src="https://github.com/user-attachments/assets/1651b059-74b9-46ff-8c93-616f04cb9c12" />

<img width="1763" height="2172" alt="Screenshot_31-5-2026_205155_localhost" src="https://github.com/user-attachments/assets/e4540e6a-b33f-4fb6-b499-bddd5b2d5f19" />

<img width="1763" height="1946" alt="Screenshot_31-5-2026_205235_localhost" src="https://github.com/user-attachments/assets/4ee79893-6dbb-4760-ace0-19851f4fa6a4" />

<img width="1763" height="899" alt="Screenshot_31-5-2026_205314_localhost" src="https://github.com/user-attachments/assets/3d7a09d9-24c3-4fbc-b88c-6b06b385bf38" />

---

## ✨ Features

### 👤 Authentication & Authorization
- Secure registration and login with **BCrypt password hashing**
- **Role-based access control** — Admin, Landlord, Tenant
- Session management with redirect filters
- Landlord account requires Admin approval before activation

### 🏡 Tenant Portal
- Browse and search verified properties by location, type, price, and furnishing
- Save properties to a **Wishlist**
- Submit rental applications and track their status
- Leave **star ratings and reviews** on properties
- View and update personal **profile** (name, email, phone, password)

### 🏢 Landlord Portal
- List, edit, and delete property listings
- Upload property images and set amenities
- Receive and respond to tenant applications
- View dashboard stats — total listings, verified vs. pending

### 🔧 Admin Dashboard
- Approve or reject landlord registrations
- Verify or reject property listings
- Manage all users (activate/deactivate/delete)
- View **analytics** — top properties, application trends, monthly registrations
- Read and manage contact inquiries

### 📄 Additional Pages
- **About** — mission, team, and how KHOJ works
- **Contact** — inquiry form stored in the database
- Custom **404 and 500** error pages

---

## 🛠️ Tech Stack

| Layer | Technology |
|---|---|
| Language | Java 21 |
| Web Framework | Jakarta EE 6 (Servlets + JSP) |
| Template Engine | JSP + JSTL 3.0 |
| Database | MySQL 8 |
| Connection Pool | HikariCP |
| Security | jBCrypt 0.4 |
| Build Tool | Apache Maven |
| Server | Apache Tomcat 10+ |
| Frontend | HTML5, CSS3 (Flexbox, CSS Grid), vanilla JS |
| Fonts | Google Fonts (Playfair Display, Inter) |
| Icons | Font Awesome 6 |

---

## 🗂️ Project Structure

```
src/
└── main/
    ├── java/com/khoj/
    │   ├── controller/       # Servlets (MVC Controllers)
    │   ├── dao/              # Data Access Objects
    │   ├── filter/           # Auth & session filters
    │   ├── model/            # POJOs / entities
    │   ├── service/          # Business logic layer
    │   └── util/             # DBConnection, SecurityUtil
    ├── resources/
    │   └── schema.sql        # Database schema
    └── webapp/
        ├── views/
        │   ├── admin/        # Admin dashboard JSPs
        │   ├── landlord/     # Landlord portal JSPs
        │   ├── tenant/       # Tenant portal JSPs
        │   └── auth/         # Login & register JSPs
        ├── resources/
        │   └── css/          # Stylesheets
        └── WEB-INF/
            └── web.xml       # Servlet mappings & error pages
```

---

## ⚙️ Getting Started

### Prerequisites

- Java 21+
- Apache Maven 3.8+
- Apache Tomcat 10.1+
- MySQL 8.0+
- XAMPP (or any MySQL server)

### 1. Clone the repository

```bash
git clone https://github.com/<your-username>/KHOJ.git
cd KHOJ
```

### 2. Set up the database

Open **MySQL Workbench** or **phpMyAdmin** and run the SQL dump in order:

```sql
-- Step 1: Run the main dump (creates all tables and seed data)
SOURCE Dump20260502.sql;

-- Step 2: Run the additions script (adds wishlists, notifications, contact_inquiries tables)
SOURCE khoj_additions_v2.sql;
```

Both SQL files are in the repository root.

### 3. Configure the database connection

Open `src/main/java/com/khoj/util/DBConnection.java` and update:

```java
private static final String URL  = "jdbc:mysql://localhost:3307/khoj_db";
private static final String USER = "root";
private static final String PASSWORD = "your_password";
```

> ⚠️ Default port in this project is **3307** (XAMPP default). Change to `3306` if your MySQL uses the standard port.

### 4. Build the project

```bash
mvn clean package
```

This generates `target/Khoj-1.0-SNAPSHOT.war`.

### 5. Deploy to Tomcat

Copy the WAR file to Tomcat's webapps folder:

```bash
cp target/Khoj-1.0-SNAPSHOT.war /path/to/tomcat/webapps/KHOJ.war
```

Then start Tomcat and visit:

```
http://localhost:8080/KHOJ/home
```

---

## 🔐 Default Test Credentials

| Role | Email | Password |
|---|---|---|
| Admin | admin@khoj.com | admin123 |
| Landlord | landlord@khoj.com | test1234 |
| Tenant | tenant@khoj.com | test1234 |

> Create these accounts manually or use the seed data from the SQL dump.

---

## 🗄️ Database Schema (Key Tables)

```
users               — user accounts with role and approval status
roles               — ADMIN, LANDLORD, TENANT
properties          — property listings linked to landlords
property_types      — Flat, Room, House, Villa, etc.
neighborhoods       — location data
property_images     — image URLs per property
amenities           — WiFi, Parking, AC, etc.
property_amenities  — many-to-many join
applications        — tenant rental applications
reviews             — tenant reviews with star ratings
wishlists           — saved properties per tenant
messages            — contact form inquiries (admin inbox)
contact_inquiries   — public contact page submissions
notifications       — in-app notification records
```

---

## 🧭 URL Routes

| URL | Role | Description |
|---|---|---|
| `/home` | Public | Property listings homepage |
| `/search` | Public | Search & filter properties |
| `/property-detail?id=X` | Public | Property detail with reviews |
| `/about` | Public | About KHOJ page |
| `/contact` | Public | Contact form |
| `/views/auth/login.jsp` | Public | Login |
| `/views/auth/register.jsp` | Public | Register |
| `/tenant/dashboard` | Tenant | Tenant home |
| `/wishlist` | Tenant | Saved properties |
| `/my-bookings` | Tenant | Application history |
| `/profile` | Any | View/edit profile |
| `/landlord/dashboard` | Landlord | Landlord home |
| `/my-rooms` | Landlord | Manage listings |
| `/add-room` | Landlord | Add new listing |
| `/edit-room?id=X` | Landlord | Edit existing listing |
| `/admin/dashboard` | Admin | Admin command center |
| `/admin/property-verification` | Admin | Verify listings |
| `/admin/user-approval` | Admin | Approve landlords |
| `/admin/analytics` | Admin | Charts and stats |
| `/admin/messages` | Admin | Contact inbox |

---

## 🏗️ Architecture

This project follows the **MVC (Model-View-Controller)** pattern:

- **Model** — Plain Java objects in `com.khoj.model` representing DB entities
- **View** — JSP pages in `webapp/views/` with JSTL for dynamic rendering
- **Controller** — Servlets in `com.khoj.controller` handling HTTP requests
- **Service** — Business logic in `com.khoj.service` between controllers and DAOs
- **DAO** — Data access in `com.khoj.dao` using `PreparedStatement` and HikariCP

---



## 📝 License

This project was developed as coursework for **CS5054NT — Advanced Programming and Technologies** at London Metropolitan University (delivered via Itahari International College). Not licensed for commercial use.

---

*KHOJ — खोज — Search. Find. Home.*
