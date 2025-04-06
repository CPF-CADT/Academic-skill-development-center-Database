USE school_db;

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
