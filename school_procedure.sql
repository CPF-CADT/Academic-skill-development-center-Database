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
