# Academic Skill Developemnt Center Database

This repository contains SQL scripts used for creating, managing, and querying the school database. The scripts include Database Definition Language (DDL), Data Query Language (DQL), triggers, stored procedures, functions, and views.
## SQL Scripts

### 1. `school_db.sql`
This script is used to **create the database**, **tables**, and **relationships** (DDL). It sets up the foundational structure of the database.

- Creates the school database.
- Defines tables for storing information about students, teachers, courses, classes, grades, and attendance.
- Establishes relationships between the tables (foreign keys) to ensure data integrity.

### 2. `SchoolView.sql`
This script defines **views** that make data access easier for common queries. A view is a virtual table that can simplify complex queries.

- Creates views for simplified access to frequently queried data, such as student performance, class lists, and attendance summaries.

### 3. `SchoolDQL.sql`
This script contains **queries** to **retrieve data** from the database (DQL). It focuses on selecting, filtering, and aggregating data.

- Defines common queries used to fetch student grades, teacher schedules, course enrollments, and attendance reports.

### 4. `SchoolTrigger.sql`
This script sets up **triggers** to automatically perform actions when certain changes are made to the database. Triggers can help maintain consistency and automate workflows.

- Creates triggers to automatically update student records, calculate total grades, or flag attendance violations when data is inserted, updated, or deleted.

### 5. `SchoolFunction.sql`
This script defines **reusable functions** that are helpful for repetitive tasks, such as calculations or checks. Functions provide modularity and help keep the code DRY (Don’t Repeat Yourself).

- Includes functions for grade calculations, attendance validation, and other recurring logic.

### 6. `SchoolProcedure.sql`
This script contains **stored procedures** for executing more complex database operations that require multiple steps.

- Defines procedures for tasks like enrolling students in courses, generating reports, and updating student records based on specific business logic.
