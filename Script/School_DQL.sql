-- Active: 1743781416616@@127.0.0.1@3306@school_db
USE school_db;

-- Get the name, phone number, and address from the Guardian table.
SELECT first_name, last_name, phone_number, address FROM Guardians;

-- Get the ID, name, date of birth (DOB), phone number, and address from the student table.
SELECT student_id, first_name, last_name, dob, phone_number, address FROM Students;

-- Get the ID, name, date of birth (DOB), phone number, address, and major from the Teacher table.
SELECT teacher_id, first_name, last_name, dob, phone_number, address, major FROM Teachers;

-- Retrieve the courses that students have enrolled in.
SELECT E.student_id, C.name, C.level FROM Enrollment E
    JOIN Course_instance CI ON E.course_instance_id = CI.course_instance_id
    JOIN Course C ON CI.short_name = C.short_name;

-- Retrieve the courses that teachers have taught.
SELECT T.teacher_id, T.first_name, T.last_name, C.name AS course
FROM Teachers T
JOIN Course_instance CI ON T.teacher_id = CI.teacher_id
JOIN Course C ON CI.short_name = C.short_name;

-- Get all students who have studied in a class (join Enrollment and Course Instance tables).
SELECT S.student_id, S.first_name, S.last_name, E.course_instance_id
	FROM Students S
	JOIN Enrollment E ON S.student_id = E.student_id;

-- Retrieve all courses offered in a specific term and year.
SELECT * FROM Course_instance WHERE year = 2022 AND term = 1;

-- Get the student’s name, ID, guardian’s name, and phone number.
SELECT S.student_id, S.first_name, S.last_name, G.first_name as guardian_first_name, 
       G.last_name as guardian_last_name, G.phone_number
	FROM Students S
	JOIN Guardians G ON S.student_id = G.student_id;

-- Get the number of students in each class.
SELECT e.course_instance_id, COUNT(student_id) as student_count FROM Enrollment AS e GROUP BY e.course_instance_id;

-- Retrieve students with unpaid enrollment fees.
SELECT S.student_id, S.first_name, S.last_name FROM Students S
	JOIN Enrollment E ON S.student_id = E.student_id
	WHERE E.payment_status = FALSE;

-- Get questions from quizzes in a specific course instance.
SELECT Q.title, Q.description, Qz.question, Qz.option_a, Qz.option_b, Qz.option_c, Qz.option_d
	FROM Quizz Q
	JOIN Question Qz ON Q.quizz_id = Qz.quizz_id
	WHERE Q.instance_id = '2025-1-A-CS101';

-- Retrieve scores when students attempt quizzes.
SELECT student_id, quizz_id, score FROM QuizzAttempt;

-- Get attendance records for a specific student in a class.
SELECT * FROM StudentAttendance WHERE student_id = 'S';

-- Get the classes (course instances) associated with a course.
SELECT * FROM Course_instance WHERE short_name = 'UX';

-- Retrieve class ID, course instance ID, start time, and end time from class allocation.
SELECT * FROM Class_allocate;

-- Get the number of students enrolled in a specific term and year.
SELECT year, term, COUNT(student_id) as student_count
	FROM Course_instance CI
	JOIN Enrollment E ON CI.course_instance_id = E.course_instance_id
	WHERE year = 2022 AND term = 1
	GROUP BY CI.`year`, term;

-- Get the number of students enrolled in a specific course.
SELECT C.name, COUNT(E.student_id) as student_count
	FROM Course C
	JOIN Course_instance CI ON C.short_name = CI.short_name
	JOIN Enrollment E ON CI.course_instance_id = E.course_instance_id
	WHERE C.short_name = 'DS'
	GROUP BY C.name;

-- Retrieve all quizzes in a course instance.
SELECT * FROM Quizz WHERE instance_id = '2022-1-1-UX';

-- Retrieve the total amount of money earned from students.
SELECT SUM(C.fee) as total_earned FROM Enrollment E
	JOIN Course_instance CI ON E.course_instance_id = CI.course_instance_id
	JOIN Course C ON CI.short_name = C.short_name
	WHERE E.payment_status = 1;

-- Retrieve the total amount of money earned in each year and term.
SELECT CI.year, CI.term, SUM(C.fee) as total_earned
	FROM Enrollment E
	JOIN Course_instance CI ON E.course_instance_id = CI.course_instance_id
	JOIN Course C ON CI.short_name = C.short_name
	WHERE E.payment_status = 1
	GROUP BY CI.year, CI.term;

-- Retrieve the total amount of money earned from each course for a specific term and year.
SELECT C.name, SUM(C.fee) as total_earned
	FROM Enrollment E
	JOIN Course_instance CI ON E.course_instance_id = CI.course_instance_id
	JOIN Course C ON CI.short_name = C.short_name
	WHERE CI.year = 2022 AND CI.term = 1 AND E.payment_status = TRUE
	GROUP BY C.name;

-- Get a list of students based on gender (male or female).
SELECT gender, COUNT(*) as student_count FROM Students GROUP BY gender;

-- Retrieve the number of students per province.
SELECT province, COUNT(*) as student_count FROM Students GROUP BY province;

-- Get the top 5 youngest students.
SELECT student_id, first_name, last_name, dob FROM Students ORDER BY dob DESC LIMIT 5;

-- Get the most common province among students.
SELECT province, COUNT(*) as student_count FROM Students GROUP BY province ORDER BY student_count DESC LIMIT 1;

-- Find students who have not enrolled in any course.
DESC Enrollment;
SELECT DISTINCT S.student_id, S.first_name, S.last_name 
	FROM Students S
	LEFT JOIN Enrollment E ON S.student_id = E.student_id
	WHERE E.student_id IS NULL;

-- Retrieve students who have enrolled in more than 3 courses.
SELECT student_id, COUNT(course_instance_id) as total_courses FROM Enrollment
GROUP BY student_id HAVING total_courses > 3;

-- Retrieve students with at least 90% attendance.
SELECT * FROM StudentPerformance AS sp WHERE sp.attendancePercent >90;

-- Retrieve the top 10 students based on their average grade.
SELECT * FROM StudentReport AS sr ORDER BY sr.final_score DESC LIMIT 10 ;
 
-- Find students who have failed.
SELECT * FROM StudentReport AS sr WHERE sr.grade ='F';


