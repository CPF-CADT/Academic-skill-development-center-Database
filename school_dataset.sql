use school_db;

LOAD DATA INFILE '/home/vathanak/Downloads/teachers_30.csv'
INTO TABLE Teachers
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(teacher_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, register_date, province, address, status, major);
SELECT * FROM Teachers;	

LOAD DATA INFILE '/home/vathanak/Downloads/updated_students_data_300.csv'
INTO TABLE Students
FIELDS TERMINATED BY ','  
ENCLOSED BY '"'  
LINES TERMINATED BY '\n'  
IGNORE 1 ROWS
(student_id, first_name, last_name, dob, gender, email, phone_number, password, national_id, register_date, province, address, status);
SELECT * FROM Students;
DESCRIBE Students;
LOAD DATA INFILE '/home/vathanak/Downloads/updated_guardians_data_300.csv'
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
LOAD DATA INFILE '/home/vathanak/Downloads/questions_300.csv'
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
