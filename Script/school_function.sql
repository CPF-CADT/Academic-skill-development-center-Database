USE school_db;

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
END&&

DESC Enrollment;
CREATE FUNCTION GetStudentCount(instance_id VARCHAR(20)) 
RETURNS INT
BEGIN
    DECLARE student_count INT;
    SELECT COUNT(e.student_id) INTO student_count 
    FROM Enrollment e     
    WHERE e.course_instance_id = instance_id;
    RETURN student_count;
END  &&


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

use school_db;


