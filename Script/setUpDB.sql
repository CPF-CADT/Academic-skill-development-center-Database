-- Active: 1743781416616@@127.0.0.1@3306
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

-- USE school_db;

DELIMITER &&

-- Drop existing procedures if they exist
CREATE PROCEDURE insert_student(
    IN p_student_id VARCHAR(10),
    IN p_first_name VARCHAR(30),
    IN p_last_name VARCHAR(30),
    IN p_dob DATE,
    IN p_gender ENUM('male', 'female'),
    IN p_email VARCHAR(50),
    IN p_phone_number VARCHAR(15),
    IN p_password VARCHAR(255),
    IN p_national_id VARCHAR(15),
    IN p_province VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    INSERT INTO Students(student_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, province, address, status)
    VALUES (p_student_id, p_first_name, p_last_name, p_dob, p_gender, p_email, p_phone_number, p_password, p_national_id, p_province, p_address, true);
END&&

CREATE PROCEDURE insert_teacher(
    IN p_teacher_id VARCHAR(10),
    IN p_first_name VARCHAR(30),
    IN p_last_name VARCHAR(30),
    IN p_dob DATE,
    IN p_gender ENUM('male', 'female'),
    IN p_email VARCHAR(50),
    IN p_phone_number VARCHAR(15),
    IN p_password VARCHAR(255),
    IN p_national_id VARCHAR(15),
    IN p_province VARCHAR(100),
    IN p_address VARCHAR(255),
    IN p_major VARCHAR(50)
)
BEGIN
    INSERT INTO Teachers(teacher_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, province, address, status, major)
    VALUES (p_teacher_id, p_first_name, p_last_name, p_dob, p_gender, p_email, p_phone_number, p_password, p_national_id, p_province, p_address, true, p_major);
END&&

CREATE PROCEDURE insert_guardian(
    IN p_student_id VARCHAR(10),
    IN p_first_name VARCHAR(30),
    IN p_last_name VARCHAR(30),
    IN p_dob DATE,
    IN p_phone_number VARCHAR(15),
    IN p_province VARCHAR(100),
    IN p_address VARCHAR(255)
)
BEGIN
    INSERT INTO Guardians(student_id, first_name, last_name, dob, phone_number, province, address)
    VALUES (p_student_id, p_first_name, p_last_name, p_dob, p_phone_number, p_province, p_address);
END&&

CREATE PROCEDURE register_student(
    IN s_student_id VARCHAR(10),
    IN s_first_name VARCHAR(30),
    IN s_last_name VARCHAR(30),
    IN s_dob DATE,
    IN s_gender ENUM('male', 'female'),
    IN s_email VARCHAR(50),
    IN s_phone_number VARCHAR(15),
    IN s_password VARCHAR(255),
    IN s_national_id VARCHAR(15),
    IN s_province VARCHAR(100),
    IN s_address VARCHAR(255),

    IN g_guardian_first_name VARCHAR(30),
    IN g_guardian_last_name VARCHAR(30),
    IN g_guardian_dob DATE,
    IN g_guardian_phone_number VARCHAR(15),
    IN g_guardian_province VARCHAR(100),
    IN g_guardian_address VARCHAR(255)
)
BEGIN
    INSERT INTO Students(student_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, province, address, status)
    VALUES (s_student_id, s_first_name, s_last_name, s_dob, s_gender, s_email, s_phone_number, s_password, s_national_id, s_province, s_address, true);

    INSERT INTO Guardians(student_id, first_name, last_name, dob, phone_number, province, address)
    VALUES (s_student_id, g_guardian_first_name, g_guardian_last_name, g_guardian_dob, g_guardian_phone_number, g_guardian_province, g_guardian_address);
END&&

-- Attendance Tracking
CREATE PROCEDURE StudentAttendanceTrack(
    IN c_stu_id VARCHAR(10),
    IN c_instance_id VARCHAR(20),
    IN c_session_no INT,
    IN c_status ENUM('present', 'late', 'absent', 'permission')
)
BEGIN
    IF IsStudentInClass(c_stu_id, c_instance_id) THEN
        INSERT INTO StudentAttendance(student_id, instance_id, session_no, status)
        VALUES (c_stu_id, c_instance_id, c_session_no, c_status);
    END IF;
END&&

-- Student Grading
CREATE PROCEDURE StudentGrading(
    IN stuID VARCHAR(10),
    IN c_instance_id VARCHAR(20),
    IN sessionNo INT,
    IN assessmentType VARCHAR(200),
    IN stuScore FLOAT
)
BEGIN
    IF IsStudentInClass(stuID, c_instance_id) THEN
        INSERT INTO Grade(student_id, instance_id, session_no, assessment_type, score)
        VALUES (stuID, c_instance_id, sessionNo, assessmentType, stuScore);
    END IF;
END&&

-- Course Management
CREATE PROCEDURE InsertCourse(
    IN courseShortName VARCHAR(5),
    IN courseName VARCHAR(50),
    IN courseLevel VARCHAR(20),
    IN courseFee INT,
    IN courseDescription VARCHAR(255)
)
BEGIN
    INSERT INTO Course (shortName, name, level, fee, description)
    VALUES (courseShortName, courseName, courseLevel, courseFee, courseDescription);
END&&

CREATE PROCEDURE InsertCourseInstance(
    IN courseYear INT,
    IN courseTerm INT,
    IN courseGroupS VARCHAR(10),
    IN courseShortName VARCHAR(5),
    IN courseTeacherId VARCHAR(10)
)
BEGIN
    INSERT INTO Course_instance (year, term, groupS, shortName, teacherId)
    VALUES (courseYear, courseTerm, courseGroupS, courseShortName, courseTeacherId);
END&&

CREATE PROCEDURE InsertEnrollment(
    IN studentId VARCHAR(10),
    IN paymentStatus BOOLEAN,
    IN courseInstanceId VARCHAR(20)
)

BEGIN
    INSERT INTO Enrollment (student_id, payment_status, course_instance_id)
    VALUES (studentId, paymentStatus, courseInstanceId);
END&&

CREATE PROCEDURE InsertQuizz(
    IN quizzTitle VARCHAR(25),
    IN quizzDescription VARCHAR(70),
    IN instanceId VARCHAR(20),
    IN quizzDue DATE
)
BEGIN
    INSERT INTO Quizz (title, description, instanceId, due)
    VALUES (quizzTitle, quizzDescription, instanceId, quizzDue);
END&&

CREATE PROCEDURE InsertQuestion(
    IN quizzId INT,
    IN questionText VARCHAR(255),
    IN questionMark INT,
    IN correctAnswer VARCHAR(1),
    IN optionA VARCHAR(255),
    IN optionB VARCHAR(255),
    IN optionC VARCHAR(255),
    IN optionD VARCHAR(255)
)
BEGIN
    INSERT INTO Question (quizzId, question, mark, correctAns, optionA, optionB, optionC, optionD)
    VALUES (quizzId, questionText, questionMark, correctAnswer, optionA, optionB, optionC, optionD);
END&&

CREATE PROCEDURE InsertGrade(
    IN instanceId VARCHAR(20),
    IN studentId VARCHAR(10),
    IN score FLOAT,
    IN assessmentType VARCHAR(200),
    IN sessionNo INT
)
BEGIN
    INSERT INTO Grade (instanceId, studentId, score, assessmentType, sessionNo)
    VALUES (instanceId, studentId, score, assessmentType, sessionNo);
END&&

CREATE PROCEDURE InsertQuizzAttempt(
    IN quizzId INT,
    IN instanceId VARCHAR(20),
    IN studentId VARCHAR(10),
    IN attemptDate DATE,
    IN score INT,
    IN timeRemain TIME
)
BEGIN
    INSERT INTO QuizzAttempt (quizzId, instanceId, studentId, attemptDate, score, timeRemain)
    VALUES (quizzId, instanceId, studentId, attemptDate, score, timeRemain);
END&&

CREATE PROCEDURE InsertClassAllocate(
    IN classId VARCHAR(20),
    IN instanceId VARCHAR(20),
    IN startTime TIME,
    IN stopTime TIME
)
BEGIN
    INSERT INTO Class_allocate (classId, instanceId, startTime, stopTime)
    VALUES (classId, instanceId, startTime, stopTime);
END&&

-- Deleting Data
CREATE PROCEDURE DeleteStudent(
    IN studentID VARCHAR(10)
)
BEGIN
    DELETE FROM Students WHERE student_id = studentID;
END&&

CREATE PROCEDURE DeleteTeacher(
    IN teacherID VARCHAR(10)
)
BEGIN
    DELETE FROM Teachers WHERE teacher_id = teacherID;
END&&

CREATE PROCEDURE DeleteGuardian(
    IN guardianID INT
)
BEGIN
    DELETE FROM Guardians WHERE guardian_id = guardianID;
END&&

CREATE PROCEDURE DeleteCourse(
    IN courseShortName VARCHAR(5)
)
BEGIN
    DELETE FROM Course WHERE short_name = courseShortName;
END&&

CREATE PROCEDURE DeleteCourseInstance(
    IN courseYear INT, 
    IN courseTerm INT, 
    IN groupS VARCHAR(10), 
    IN courseShortName VARCHAR(5)
)
BEGIN
    DELETE FROM Course_instance 
    WHERE year = courseYear 
      AND term = courseTerm 
      AND group_s = groupS 
      AND short_name = courseShortName;
END&&

CREATE PROCEDURE DeleteEnrollment(
    IN studentID VARCHAR(10),
    IN courseInstance VARCHAR(20)
)
BEGIN
    DELETE FROM Enrollment WHERE student_id = studentID AND course_instance_id;
END&&

CREATE PROCEDURE DeleteQuizz(
    IN quizzID INT
)
BEGIN
    DELETE FROM Quizz WHERE quizz_id = quizzID;
END&&

CREATE PROCEDURE DeleteQuestion(
    IN questionID INT, 
    IN quizzID INT
)
BEGIN
    DELETE FROM Question WHERE id = questionID AND quizz_id = quizzID;
END&&

CREATE PROCEDURE DeleteStudentAttendance(
    IN instanceID VARCHAR(20), 
    IN studentID VARCHAR(10), 
    IN sessionNo INT
)
BEGIN
    DELETE FROM StudentAttendance WHERE instance_id = instanceID AND student_id = studentID AND session_no = sessionNo;
END&&

CREATE PROCEDURE DeleteGrade(
    IN instanceID VARCHAR(20), 
    IN studentID VARCHAR(10)
)
BEGIN
    DELETE FROM Grade WHERE instance_id = instanceID AND student_id = studentID;
END&&

CREATE PROCEDURE DeleteQuizzAttempt(
    IN quizzAttemptID INT
)
BEGIN
    DELETE FROM QuizzAttempt WHERE quizz_attempt_id = quizzAttemptID;
END&&

CREATE PROCEDURE updatePaymentStatus(
    IN eid VARCHAR(10),
    IN pay_status BOOLEAN
)
BEGIN
    UPDATE Enrollment
    SET payment_status = pay_status
    WHERE enrollment_id = eid;
END &&

CREATE PROCEDURE updateStudentAttendance(
    IN stu_id VARCHAR(10),
    IN instance VARCHAR(20),
    IN section INT,
    IN new_status ENUM('present', 'late', 'absent', 'permission')
)
BEGIN
    UPDATE StudentAttendance
    SET status = new_status
    WHERE student_id = stu_id AND instance_id = instance AND session_no = section;
END &&

CREATE PROCEDURE updateGrade(
    IN stu_id VARCHAR(10),
    IN instance VARCHAR(20),
    IN session INT,
    IN new_score FLOAT
)
BEGIN
    UPDATE Grade
    SET score = new_score
    WHERE student_id = stu_id AND instance_id = instance AND session_no = session;
END &&

CREATE PROCEDURE updateCourseFee(
    IN course_short_name VARCHAR(5),
    IN new_fee INT
)
BEGIN
    UPDATE Course
    SET fee = new_fee
    WHERE short_name = course_short_name;
END &&

CREATE PROCEDURE updateCourseInstanceEndDate(
    IN instance_id_in VARCHAR(20),
    IN new_end_date DATE
)
BEGIN
    UPDATE Course_instance
    SET end_date = new_end_date
    WHERE course_instance_id = instance_id_in;
END &&

DELIMITER ;

DELIMITER &&

CREATE FUNCTION IsStudentInClass(
    sid VARCHAR(10),
    instance_id VARCHAR(20)
) RETURNS BOOLEAN
BEGIN
    DECLARE studentCount INT DEFAULT 0;
    
    SELECT COUNT(*) INTO studentCount 
    FROM Enrollment 
    WHERE student_id = sid 
    AND course_instance_id = instance_id;
    
    RETURN studentCount > 0;
END&&

CREATE FUNCTION getCourseInstanceID(
    syear INT,
    sterm INT,
    sgroup VARCHAR(10),
    shortNameCourse VARCHAR(5)
) RETURNS VARCHAR(20)
BEGIN
    DECLARE instnace_id VARCHAR(20) DEFAULT NULL;
    SELECT course_instance_id INTO instnace_id
    FROM Course_instance
    WHERE year = syear 
    AND term = sterm 
    AND group_s = sgroup 
    AND short_name = shortNameCourse;
    
    RETURN instnace_id;
END&&

CREATE FUNCTION getAttendanceScore(
    status ENUM('present', 'late', 'absent', 'permission')
) RETURNS FLOAT
BEGIN
    DECLARE score FLOAT DEFAULT 0.0;    
    SET score = CASE 
        WHEN status = 'present' THEN 1.0
        WHEN status = 'late' THEN 0.75
        WHEN status = 'permission' THEN 0.5
        WHEN status = 'absent' THEN 0.0
        ELSE 0.0 
    END;
    RETURN score;
END&&

CREATE FUNCTION getCharGrade(
    average FLOAT
) RETURNS CHAR(1)
BEGIN
    DECLARE grade CHAR(1) DEFAULT 'F';
    SET grade = CASE
        WHEN average >=90 AND average <=100 THEN 'A'
        WHEN average >=80 THEN 'B'
        WHEN average >=70 THEN 'C'
        WHEN average >=60 THEN 'D'
        WHEN average >=50 THEN 'E'
        ELSE 'F'
    END;
    RETURN grade;
END &&

CREATE FUNCTION GetStudentCount(instance_id VARCHAR(20)) 
RETURNS INT
BEGIN
    DECLARE student_count INT;
    SELECT COUNT(e.student_id) INTO student_count 
    FROM Enrollment e     
    WHERE e.course_instance_id = instance_id;
    RETURN student_count;
END &&


CREATE FUNCTION findMaxGradeSection(instance_id VARCHAR(20))
RETURNS INT
BEGIN
    DECLARE maxSection INT;

    SELECT MAX(session_count) INTO maxSection
    FROM (
        SELECT COUNT(g.session_no) AS session_count
        FROM Grade g
        WHERE g.instance_id = instance_id
        GROUP BY g.student_id
    ) AS subquery;
    RETURN maxSection;
END &&

CREATE FUNCTION findMaxAttendacneSection(instance_id VARCHAR(20))
RETURNS INT
BEGIN
    DECLARE maxSection INT;

    SELECT MAX(session_count) INTO maxSection
    FROM (
        SELECT COUNT(sa.session_no) AS session_count
        FROM StudentAttendance sa
        WHERE sa.instance_id = instance_id
        GROUP BY sa.student_id
    ) AS subquery;
    RETURN maxSection;
END &&

CREATE FUNCTION CheckClassAvailability(classID VARCHAR(20), requested_start_time TIME, requested_stop_time TIME)
RETURNS BOOLEAN
DETERMINISTIC
BEGIN
    DECLARE is_available BOOLEAN DEFAULT TRUE;
    DECLARE overlapping_count INT;

    SELECT COUNT(*)  INTO overlapping_count  
    FROM Class_allocate
    WHERE class_id = classID
      AND (
          (requested_start_time < stop_time AND requested_stop_time > start_time) 
      );

    RETURN overlapping_count = 0;
END &&

DELIMITER ;

LOAD DATA INFILE 'C:/Users/USER/Desktop/Code/DATABASE_PRO/Academic-skill-development-center-Database/Dataset/teachers_30.csv'
INTO TABLE Teachers
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(teacher_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, register_date, province, address, status, major);
SELECT * FROM Teachers;	

LOAD DATA INFILE 'C:/Users/USER/Desktop/Code/DATABASE_PRO/Academic-skill-development-center-Database/Dataset/updated_students_data_300.csv'
INTO TABLE Students
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(student_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, register_date, province, address, status);
SELECT * FROM Students;
DESCRIBE Students;
LOAD DATA INFILE 'C:/Users/USER/Desktop/Code/DATABASE_PRO/Academic-skill-development-center-Database/Dataset/updated_guardians_data_300.csv'
INTO TABLE Guardians
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(guardian_id, student_id, first_name, last_name, dob, phone_number, province, address);
SELECT * FROM Guardians;


-- Inserting data into Course table
INSERT INTO Course (short_name, name, level, fee, description) VALUES
('WEB', 'Web Development', 'Beginner', 300, 'Introduction to HTML, CSS, and JavaScript for building websites.'),
('DS', 'Data Science', 'Intermediate', 400, 'Learn data analysis, statistics, and machine learning algorithms.'),
('AI', 'Artificial Intelligence', 'Advanced', 500, 'In-depth study of AI models, neural networks, and deep learning.'),
('APP', 'App Development', 'Beginner', 350, 'Basics of mobile app development for iOS and Android.'),
('CPS', 'Cybersecurity', 'Intermediate', 450, 'Understanding cybersecurity principles, practices, and ethical hacking.'),
('DB', 'Database Management', 'Advanced', 400, 'Study of relational databases, SQL, and data manipulation.'),
('UX', 'User Experience', 'Beginner', 250, 'Introduction to UX design principles and user research methods.'),
('ML', 'Machine Learning', 'Intermediate', 300, 'Learn the basics of machine learning and its applications.'),
('CLOUD', 'Cloud Computing', 'Beginner', 200, 'Introduction to cloud technologies and deployment models.'),
('ECOM', 'E-commerce', 'Advanced', 500, 'Study of online business models, digital marketing, and e-commerce platforms.');

-- Inserting data into Course_instance table
INSERT INTO Course_instance (year, term, group_s, teacher_id, short_name) VALUES
(2022, 1, '1', 'T1', 'UX');
INSERT INTO Course_instance (year, term, group_s, teacher_id, short_name) VALUES
(2022, 1, '1', 'T5', 'WEB'),
(2022, 1, '2', 'T12', 'DS'),
(2022, 1, '3', 'T18', 'AI'),
(2022, 1, '1', 'T7', 'APP'),
(2022, 1, '2', 'T24', 'CPS'),
(2022, 1, '3', 'T3', 'DB'),
(2022, 1, '2', 'T15', 'UX'),
(2022, 1, '2', 'T27', 'ML'),
(2022, 1, '3', 'T9', 'CLOUD'),
(2022, 1, '1', 'T21', 'ECOM');

-- Insert into Class_room table
INSERT INTO Class_room (class_id, floor_number, capacity, status) 
VALUES
('A101', 1, 40, 1),
('B202', 2, 35, 1),
('C303', 3, 50, 1),
('D404', 4, 60, 1),
('E505', 5, 30, 1);

-- Insert into Class_allocate table
-- Insert into Class_allocate table with different time slots and classrooms
INSERT INTO Class_allocate (class_id, instance_id, start_time, stop_time) 
VALUES
('A101', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '1' AND short_name = 'UX'), '08:00:00', '10:00:00'),
('B202', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '1' AND short_name = 'WEB'), '10:30:00', '12:30:00'),
('C303', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '2' AND short_name = 'DS'), '13:00:00', '15:00:00'),
('D404', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '3' AND short_name = 'AI'), '15:30:00', '17:30:00'),
('E505', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '1' AND short_name = 'APP'), '08:00:00', '10:00:00'),
('A101', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '2' AND short_name = 'CPS'), '10:30:00', '12:30:00'),
('B202', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '3' AND short_name = 'DB'), '13:00:00', '15:00:00'),
('C303', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '2' AND short_name = 'UX'), '15:30:00', '17:30:00'),
('D404', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '2' AND short_name = 'ML'), '08:00:00', '10:00:00'),
('E505', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '3' AND short_name = 'CLOUD'), '10:30:00', '12:30:00'),
('A101', (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1 AND group_s = '1' AND short_name = 'ECOM'), '13:00:00', '15:00:00');


-- Insert Quizz
INSERT INTO Quizz (time_limit, title, description, instance_id, due)
SELECT 
    '00:30:00', 
    CONCAT(short_name, ' Quiz'), 
    CONCAT('Quiz for ', short_name, ' course'), 
    course_instance_id, 
    DATE_ADD('2022-02-01', INTERVAL FLOOR(RAND() * 30) DAY) -- Random due date within 30 days
FROM 
    Course_instance
WHERE year = 2022 AND term = 1
ORDER BY RAND()
LIMIT 30;
DESC Question;
LOAD DATA INFILE 'C:/Users/USER/Desktop/Code/DATABASE_PRO/Academic-skill-development-center-Database/Dataset/questions_300.csv'
INTO TABLE Question
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(quizz_id, question, mark, correct_ans, option_a,option_b,option_c,option_d);
SELECT * FROM Question WHERE quizz_id = 1;
-- CALL StudentAttendanceTrack('S1', 2022, 1, '1', 'UX', 1, 'present');

-- Insert Enrollment Data for 300 students enrolling in random courses

INSERT INTO Enrollment (student_id, course_instance_id, payment_status)
SELECT 
    student_ids.student_id,
    course_instances.course_instance_id,
    FLOOR(RAND() * 2) AS payment_status  -- Randomly assigns 0 or 1
FROM 
    (SELECT CONCAT('S', LPAD(n, 3, '0')) AS student_id FROM (SELECT (a.a + (10 * b.a) + (100 * c.a)) AS n 
    FROM 
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2) c) numbers 
    WHERE n BETWEEN 1 AND 300) AS student_ids
JOIN 
    (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1) AS course_instances
ON RAND() < 0.5  -- Ensures each student gets 1-3 enrollments randomly
ORDER BY student_ids.student_id, RAND()
LIMIT 300; -- Adjust to ensure each student gets multiple enrollments
-- Insert Enrollment Data for 300 students enrolling in random courses

INSERT INTO Enrollment (student_id, course_instance_id, payment_status)
SELECT 
    student_ids.student_id,
    course_instances.course_instance_id,
    FLOOR(RAND() * 2) AS payment_status  -- Randomly assigns 0 or 1
FROM 
    (SELECT CONCAT('S', LPAD(n, 3, '0')) AS student_id FROM 
    (SELECT (a.a + (10 * b.a) + (100 * c.a)) AS n 
    FROM 
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) a,
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2 UNION ALL SELECT 3 UNION ALL SELECT 4 
    UNION ALL SELECT 5 UNION ALL SELECT 6 UNION ALL SELECT 7 UNION ALL SELECT 8 UNION ALL SELECT 9) b,
    (SELECT 0 AS a UNION ALL SELECT 1 UNION ALL SELECT 2) c) numbers 
    WHERE n BETWEEN 1 AND 300) AS student_ids
JOIN 
    (SELECT course_instance_id FROM Course_instance WHERE year = 2022 AND term = 1) AS course_instances
ON RAND() < 0.4  -- Adjusted probability to ensure around 300 total enrollments
ORDER BY RAND()
LIMIT 300; -- Ensures exactly 300 enrollments

DELIMITER &&

CREATE TABLE IF NOT EXISTS Student_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    student_id VARCHAR(10) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

CREATE TRIGGER studentDelete
	AFTER DELETE ON Students
	FOR EACH ROW 
	BEGIN
		INSERT INTO Student_Deletion (student_id)
		VALUES (OLD.student_id);
	END&&
-- Log table for deleted teachers
CREATE TABLE IF NOT EXISTS Teacher_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    teacher_id VARCHAR(10) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted teachers
CREATE TRIGGER teacherDelete
AFTER DELETE ON Teachers 
FOR EACH ROW 
BEGIN 
    INSERT INTO Teacher_Deletion(teacher_id)
    VALUES (OLD.teacher_id);
END&&

-- Log table for deleted courses
CREATE TABLE IF NOT EXISTS Course_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    short_name VARCHAR(5) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted courses
CREATE TRIGGER courseDelete
AFTER DELETE ON Course 
FOR EACH ROW 
BEGIN 
    INSERT INTO Course_Deletion(short_name)
    VALUES (OLD.short_name);
END&&

-- Log table for deleted course instances
CREATE TABLE IF NOT EXISTS CourseInstance_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    course_instance_id VARCHAR(20) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted course instances
CREATE TRIGGER courseInstanceDelete
AFTER DELETE ON Course_instance 
FOR EACH ROW 
BEGIN 
    INSERT INTO CourseInstance_Deletion(course_instance_id)
    VALUES (OLD.course_instance_id);
END&&

-- Log table for deleted enrollments
CREATE TABLE IF NOT EXISTS Enrollment_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    enrollment_id INT NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted enrollments
CREATE TRIGGER enrollmentDelete
AFTER DELETE ON Enrollment 
FOR EACH ROW 
BEGIN 
    INSERT INTO Enrollment_Deletion(enrollment_id)
    VALUES (OLD.enrollment_id);
END&&

-- Log table for deleted quizzes
CREATE TABLE IF NOT EXISTS Quizz_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    quizz_id INT NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted quizzes
CREATE TRIGGER quizzDelete
AFTER DELETE ON Quizz 
FOR EACH ROW 
BEGIN 
    INSERT INTO Quizz_Deletion(quizz_id)
    VALUES (OLD.quizz_id);
END&&

-- Log table for deleted quiz attempts
CREATE TABLE IF NOT EXISTS QuizzAttempt_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    quizz_id INT NOT NULL,
    student_id VARCHAR(10) NOT NULL,
    instance_id VARCHAR(20) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted quiz attempts
CREATE TRIGGER quizzAttemptDelete
AFTER DELETE ON QuizzAttempt 
FOR EACH ROW 
BEGIN 
    INSERT INTO QuizzAttempt_Deletion(quizz_id, student_id, instance_id)
    VALUES (OLD.quizz_id, OLD.student_id, OLD.instance_id);
END&&

-- Log table for deleted student attendance records
CREATE TABLE IF NOT EXISTS StudentAttendance_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    instance_id VARCHAR(20) NOT NULL,
    student_id VARCHAR(10) NOT NULL,
    session_no INT NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted student attendance records
CREATE TRIGGER studentAttendanceDelete
AFTER DELETE ON StudentAttendance 
FOR EACH ROW 
BEGIN 
    INSERT INTO StudentAttendance_Deletion(instance_id, student_id, session_no)
    VALUES (OLD.instance_id, OLD.student_id, OLD.session_no);
END&&

-- Log table for deleted grades
CREATE TABLE IF NOT EXISTS Grade_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    instance_id VARCHAR(20) NOT NULL,
    student_id VARCHAR(10) NOT NULL,
    session_no INT NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted grades
CREATE TRIGGER gradeDelete
AFTER DELETE ON Grade 
FOR EACH ROW 
BEGIN 
    INSERT INTO Grade_Deletion(instance_id, student_id, session_no)
    VALUES (OLD.instance_id, OLD.student_id, OLD.session_no);
END&&

-- Log table for deleted classroom allocations
CREATE TABLE IF NOT EXISTS ClassAllocate_Deletion (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    class_id VARCHAR(20) NOT NULL,
    instance_id VARCHAR(20) NOT NULL,
    deleted_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&

-- Trigger for tracking deleted classroom allocations
CREATE TRIGGER classAllocateDelete
AFTER DELETE ON Class_allocate 
FOR EACH ROW 
BEGIN 
    INSERT INTO ClassAllocate_Deletion(class_id, instance_id)
    VALUES (OLD.class_id, OLD.instance_id);
END&&

-- Create log tables for each entity
CREATE TABLE IF NOT EXISTS Update_Log (
    log_id INT AUTO_INCREMENT PRIMARY KEY,
    table_name VARCHAR(50) NOT NULL,
    record_id VARCHAR(50) NOT NULL,
    field_updated VARCHAR(50) NOT NULL,
    old_value VARCHAR(255),
    new_value VARCHAR(255),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
)&&
-- Trigger for Students
CREATE TRIGGER studentUpdate AFTER UPDATE ON Students 
FOR EACH ROW 
BEGIN
    IF OLD.first_name <> NEW.first_name THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'first_name', OLD.first_name, NEW.first_name);
    END IF;
    IF OLD.last_name <> NEW.last_name THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'last_name', OLD.last_name, NEW.last_name);
    END IF;
    IF OLD.dob <> NEW.dob THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'dob', OLD.dob, NEW.dob);
    END IF;
    IF OLD.email <> NEW.email THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'email', OLD.email, NEW.email);
    END IF;
    IF OLD.phone_number <> NEW.phone_number THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'phone_number', OLD.phone_number, NEW.phone_number);
    END IF;
    IF OLD.password <> NEW.password THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'password', 'Updated', 'Updated');
    END IF;
    IF OLD.national_id <> NEW.national_id THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'national_id', OLD.national_id, NEW.national_id);
    END IF;
    IF OLD.status <> NEW.status THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Students', OLD.student_id, 'status', OLD.status, NEW.status);
    END IF;
END &&

-- Trigger for Teachers
CREATE TRIGGER teacherUpdate AFTER UPDATE ON Teachers 
FOR EACH ROW 
BEGIN
    IF OLD.first_name <> NEW.first_name THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'first_name', OLD.first_name, NEW.first_name);
    END IF;
    IF OLD.last_name <> NEW.last_name THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'last_name', OLD.last_name, NEW.last_name);
    END IF;
    IF OLD.dob <> NEW.dob THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'dob', OLD.dob, NEW.dob);
    END IF;
    IF OLD.email <> NEW.email THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'email', OLD.email, NEW.email);
    END IF;
    IF OLD.phone_number <> NEW.phone_number THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'phone_number', OLD.phone_number, NEW.phone_number);
    END IF;
    IF OLD.password <> NEW.password THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'password', 'Updated', 'Updated');
    END IF;
    IF OLD.national_id <> NEW.national_id THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'national_id', OLD.national_id, NEW.national_id);
    END IF;
    IF OLD.status <> NEW.status THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'status', OLD.status, NEW.status);
    END IF;
    IF OLD.major <> NEW.major THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Teachers', OLD.teacher_id, 'major', OLD.major, NEW.major);
    END IF;
END &&

-- Trigger for Course
CREATE TRIGGER courseUpdate AFTER UPDATE ON Course 
FOR EACH ROW 
BEGIN
    IF OLD.name <> NEW.name THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Course', OLD.short_name, 'name', OLD.name, NEW.name);
    END IF;
    IF OLD.level <> NEW.level THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Course', OLD.short_name, 'level', OLD.level, NEW.level);
    END IF;
    IF OLD.fee <> NEW.fee THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Course', OLD.short_name, 'fee', OLD.fee, NEW.fee);
    END IF;
    IF OLD.description <> NEW.description THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Course', OLD.short_name, 'description', OLD.description, NEW.description);
    END IF;
END &&

-- Trigger for Enrollment
CREATE TRIGGER enrollmentUpdate AFTER UPDATE ON Enrollment 
FOR EACH ROW 
BEGIN
    IF OLD.payment_status <> NEW.payment_status THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Enrollment', OLD.enrollment_id, 'payment_status', OLD.payment_status, NEW.payment_status);
    END IF;
END &&

-- Trigger for Grade
CREATE TRIGGER gradeUpdate AFTER UPDATE ON Grade 
FOR EACH ROW 
BEGIN
    IF OLD.score <> NEW.score THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Grade', CONCAT(OLD.instance_id, '-', OLD.student_id), 'score', OLD.score, NEW.score);
    END IF;
    IF OLD.assessment_type <> NEW.assessment_type THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Grade', CONCAT(OLD.instance_id, '-', OLD.student_id), 'assessment_type', OLD.assessment_type, NEW.assessment_type);
    END IF;
END &&

CREATE TRIGGER attendanceUpdate 
AFTER UPDATE ON StudentAttendance
FOR EACH ROW 
BEGIN
    IF OLD.status <> NEW.status THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('StudentAttendance', CONCAT(OLD.instance_id, '-', OLD.student_id), 'status', OLD.status, NEW.status);
    END IF;
END &&

-- Trigger for Quizz
CREATE TRIGGER quizzUpdate AFTER UPDATE ON Quizz 
FOR EACH ROW 
BEGIN
    IF OLD.time_limit <> NEW.time_limit THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Quizz', OLD.quizz_id, 'time_limit', OLD.time_limit, NEW.time_limit);
    END IF;
    IF OLD.title <> NEW.title THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Quizz', OLD.quizz_id, 'title', OLD.title, NEW.title);
    END IF;
    IF OLD.description <> NEW.description THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Quizz', OLD.quizz_id, 'description', OLD.description, NEW.description);
    END IF;
END &&

-- Trigger for Class_allocate
CREATE TRIGGER classAllocateUpdate AFTER UPDATE ON Class_allocate 
FOR EACH ROW 
BEGIN
    IF OLD.class_id <> NEW.class_id THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Class_allocate', OLD.class_id, 'class_id', OLD.class_id, NEW.class_id);
    END IF;
    IF OLD.instance_id <> NEW.instance_id THEN 
        INSERT INTO Update_Log(table_name, record_id, field_updated, old_value, new_value) 
        VALUES ('Class_allocate', OLD.class_id, 'instance_id', OLD.instance_id, NEW.instance_id);
    END IF;
END &&

DELIMITER ;
	
CREATE OR REPLACE VIEW AvgGrades AS
SELECT g.student_id, 
		FORMAT(AVG(g.score), 2) AS avg_score,
		g.instance_id,
		FORMAT(SUM(g.score),2) AS total_score
FROM Grade g
GROUP BY g.student_id, g.instance_id;

CREATE OR REPLACE VIEW AttendanceScores AS
SELECT 
	sa.student_id, 
	sa.instance_id, 
	FORMAT(SUM(getAttendanceScore(sa.status)), 2) AS attendanceScore
FROM 
	StudentAttendance sa
GROUP BY 
sa.student_id, sa.instance_id;

	
CREATE OR REPLACE VIEW StudentPerformance AS
SELECT 
    g.instance_id,
    g.student_id, 
    FORMAT(SUM(g.score) / findMaxAttendacneSection(g.instance_id), 2) AS avg_score, 
    FORMAT(100 * SUM(getAttendanceScore(sa.status)) / findMaxAttendacneSection(g.instance_id), 2) AS attendancePercent
FROM 
    Grade g
JOIN 
    StudentAttendance sa 
    ON g.instance_id = sa.instance_id 
    AND sa.student_id = g.student_id 
    AND g.session_no = sa.session_no
GROUP BY 
    g.instance_id, g.student_id;
	
CREATE OR REPLACE VIEW StudentReport AS
	SELECT sp.instance_id, 
	       sp.student_id, 
	       CONCAT(s.first_name, ' ', s.last_name) AS name, 
	       s.dob, 
	       FORMAT((avg_score * 0.9) + (attendancePercent * 0.1),2) AS final_score, 
	       getCharGrade((avg_score * 0.9) + (attendancePercent * 0.1)) AS grade, 
       		RANK() OVER (PARTITION BY sp.instance_id ORDER BY (avg_score * 0.9) + (attendancePercent * 0.1) DESC) AS rank
	FROM StudentPerformance AS sp 
	JOIN Students s ON s.student_id = sp.student_id;

CREATE OR REPLACE VIEW listStudentInClass AS 
	SELECT S.student_id, S.first_name, S.last_name, E.course_instance_id,c.name
	FROM Students S
	JOIN Enrollment E ON S.student_id = E.student_id
	JOIN Course c ON c.short_name = SUBSTRING_INDEX(E.course_instance_id, '-', -1);

CREATE VIEW student_guardians AS
SELECT 
    S.student_id, 
    S.first_name AS student_first_name, 
    S.last_name AS student_last_name,
    G.first_name AS guardian_first_name, 
    G.last_name AS guardian_last_name, 
    G.phone_number
FROM Students S
JOIN Guardians G ON S.student_id = G.student_id;
	
CREATE VIEW students_not_enrolled AS
SELECT 
    S.student_id, 
    S.first_name, 
    S.last_name 
FROM Students S
LEFT JOIN Enrollment E ON S.student_id = E.student_id
WHERE E.student_id IS NULL;

CREATE OR Replace VIEW  revenue_per_term AS
SELECT 
    CI.year, 
    CI.term, 
    SUM(C.fee) AS total_earned
FROM Enrollment E
JOIN Course_instance CI ON E.course_instance_id = CI.course_instance_id
JOIN Course C ON CI.short_name = C.short_name
WHERE E.payment_status = TRUE
GROUP BY CI.year, CI.term;

CREATE OR REPLACE VIEW quiz_with_questions AS
SELECT 
	ci.course_instance_id,
    Q.quizz_id,
    Q.title,
    Q.description,
    Qz.id,
    Qz.question,
    Qz.option_a,
    Qz.option_b,
    Qz.option_c,
    Qz.option_d
FROM Quizz Q
JOIN Question Qz ON Q.quizz_id = Qz.quizz_id
JOIN Course_instance ci on ci.course_instance_id = Q.instance_id;
	
	
