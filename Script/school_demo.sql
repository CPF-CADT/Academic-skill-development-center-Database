use school_db;

CALL register_student('S301','Sok','Dara','2006-03-11','male','sokdara@gmail.com','078687364','acdefg','098772632','Kratie','St8 #8712','Sok','Kaka','1980-02-11','097563721','Kratie','st33 #234');

CALL insert_teacher('T31','Chea','Mon','1980-02-13','female','cheasok@gmail.com','098762323','abcdefr','098742933','Kompong Cham','St37 #6121','Data Science');

SELECT * FROM ClassInfor;

CALL InsertEnrollment('S301',1,'2022-1-1-APP');

SELECT * FROM listStudentInClass WHERE course_instance_id ='2022-1-1-APP';

CALL StudentAttendanceTrack('S301','2022-1-1-APP',1,'present');

CALL StudentAttendanceTrack('S301','2022-1-1-APP',2,'late');

SELECT * FROM StudentAttendance sa WHERE sa.student_id ='S301';

CALL StudentGrading('S301', '2022-1-1-APP', 1, 'QA', '75');

CALL StudentGrading('S301', '2022-1-1-APP', 2, 'QA', '85');

SELECT * FROM Grade g WHERE g.student_id = 'S301';

SELECT * FROM AvgGrades;

SELECT * FROM Quizz q WHERE q.instance_id ='2022-1-1-APP';

SELECT * FROM quiz_with_questions qwq WHERE qwq.course_instance_id = '2022-1-1-APP' AND qwq.quizz_id = 4;
 
SELECT * FROM AttendanceScores a WHERE a.instance_id ='2022-1-1-APP';

SELECT * FROM AvgGrades ag WHERE ag.instance_id ='2022-1-1-APP';

SELECT * FROM StudentReport sr WHERE sr.instance_id = '2022-1-1-APP';

SELECT * FROM StudentReport sr WHERE sr.student_id = 'S301' AND sr.instance_id = '2022-1-1-APP';

UPDATE Students s 
	SET s.first_name = 'San'
	WHERE s.student_id = 'S301';

CALL updateGrade('S301', '2022-1-1-APP', 2, 97);
CALL updateStudentAttendance('S301', '2022-1-1-APP', 2, 'present');

SELECT * FROM StudentAttendance	sa WHERE sa.session_no = 2  AND sa.instance_id ='2022-1-1-APP' AND sa.student_id ='S301';

SELECT * FROM incomeEachClass as ic;

SELECT SUM(ic.total_earned) FROM incomeEachClass as ic;

CALL DeleteTeacher('T31');

CALL DeleteStudent('S301');

CALL DeleteEnrollment('S301','2022-1-1-APP');

SELECT * FROM Class_allocate ca ;
-- TRIGGER
SELECT * FROM Update_Log ul;

SELECT * FROM Teacher_Deletion td ;

SELECT * FROM Student_Deletion sd ;

SELECT * FROM Enrollment_Deletion ed ;


