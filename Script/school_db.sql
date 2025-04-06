-- Active: 1743781416616@@127.0.0.1@3306@school_db
DROP DATABASE IF EXISTS school_db;
CREATE DATABASE school_db;
USE school_db;

CREATE TABLE IF NOT EXISTS Students (
    student_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    dob DATE,
    gender ENUM('male', 'female'),
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    national_id VARCHAR(15),
    register_date DATE DEFAULT CURRENT_DATE,
    province VARCHAR(100),
    address VARCHAR(255),
    status BOOLEAN
);

CREATE TABLE IF NOT EXISTS Teachers (
    teacher_id VARCHAR(10) PRIMARY KEY,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    dob DATE,
    gender ENUM('male', 'female'),
    email VARCHAR(50) NOT NULL UNIQUE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    national_id VARCHAR(15),
    register_date DATE DEFAULT CURRENT_DATE,
    province VARCHAR(100),
    address VARCHAR(255),
    status BOOLEAN,
    major VARCHAR(50)
);
CREATE TABLE IF NOT EXISTS Guardians (
    guardian_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL UNIQUE,
    first_name VARCHAR(30) NOT NULL,
    last_name VARCHAR(30) NOT NULL,
    dob DATE,
    phone_number VARCHAR(15) NOT NULL UNIQUE,
    province VARCHAR(100),
    address TEXT,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Course (
    short_name VARCHAR(5) PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    level VARCHAR(20) NOT NULL,
    fee INT NOT NULL,
    description VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS Course_instance (
    year INT NOT NULL,
    term INT NOT NULL,
    group_s VARCHAR(10) NOT NULL,
    short_name VARCHAR(5) NOT NULL,
    course_instance_id VARCHAR(20) GENERATED ALWAYS AS (CONCAT(year, '-', term, '-', group_s, '-', short_name)) STORED,
    teacher_id VARCHAR(10),
    start_date DATE DEFAULT CURRENT_DATE,
    end_date DATE,
    PRIMARY KEY (year, term, group_s, short_name),
    UNIQUE (course_instance_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (short_name) REFERENCES Course(short_name) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Enrollment (
    enrollment_id INT AUTO_INCREMENT PRIMARY KEY,
    enroll_date DATE DEFAULT CURRENT_DATE,
    student_id VARCHAR(10) NOT NULL,
    payment_status BOOLEAN,
    course_instance_id VARCHAR(20) NOT NULL,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (course_instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Quizz (
    quizz_id INT AUTO_INCREMENT PRIMARY KEY,
    time_limit TIME,
    title VARCHAR(25) NOT NULL,
    description VARCHAR(70) NOT NULL,
    instance_id VARCHAR(20) NOT NULL,
    due DATE,
    FOREIGN KEY (instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Question (
    id INT AUTO_INCREMENT,
    quizz_id INT,
    question VARCHAR(255),
    mark INT,
    correct_ans VARCHAR(1),  
    option_a VARCHAR(255),    
    option_b VARCHAR(255),  
    option_c VARCHAR(255),    
    option_d VARCHAR(255),    
    PRIMARY KEY (id, quizz_id),
    FOREIGN KEY (quizz_id) REFERENCES Quizz(quizz_id) ON UPDATE CASCADE ON DELETE CASCADE
);	

CREATE TABLE IF NOT EXISTS StudentAttendance (
    instance_id VARCHAR(20) NOT NULL,
    student_id VARCHAR(10),
    session_no INT,
    status ENUM('present', 'late', 'absent', 'permission'),
    PRIMARY KEY (instance_id, student_id, session_no),
    FOREIGN KEY (instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Grade (
    instance_id VARCHAR(20) NOT NULL,
    student_id VARCHAR(10),
    score FLOAT,
    assessment_type VARCHAR(200),
    session_no INT,
    PRIMARY KEY (instance_id, student_id, session_no),
    FOREIGN KEY (instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS QuizzAttempt (
    quizz_id INT,
    instance_id VARCHAR(20) NOT NULL,
    student_id VARCHAR(10),
    attempt_date DATE DEFAULT CURRENT_DATE,
    score INT,
    time_remain TIME,
    PRIMARY KEY (quizz_id, instance_id, student_id),
    FOREIGN KEY (quizz_id) REFERENCES Quizz(quizz_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (student_id) REFERENCES Students(student_id) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS Class_room (
    class_id VARCHAR(20) PRIMARY KEY,
    floor_number INT,
    capacity INT,
    status BOOLEAN
);

CREATE TABLE IF NOT EXISTS Class_allocate (
    class_id VARCHAR(20),
    instance_id VARCHAR(20),
    start_time TIME,
    stop_time TIME,
    PRIMARY KEY (class_id, instance_id),
    FOREIGN KEY (class_id) REFERENCES Class_room(class_id) ON UPDATE CASCADE ON DELETE CASCADE,
    FOREIGN KEY (instance_id) REFERENCES Course_instance(course_instance_id) ON UPDATE CASCADE ON DELETE CASCADE
);

SHOW TABLES;
