use school_db;
	
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
	    FORMAT(AVG(g.score), 2) AS avg_score, 
	    FORMAT(100 * (SUM(getAttendanceScore(sa.status)) / COUNT(sa.session_no)), 2) AS attendancePercent
	FROM 
	    Grade g
	JOIN 
	    StudentAttendance sa 
	    ON g.instance_id = sa.instance_id 
	    AND sa.student_id = g.student_id 
	    AND g.session_no = sa.session_no
	GROUP BY 
	    g.instance_id, g.student_id;
	
	SELECT sp.instance_id,sp.student_id,CONCAT(s.first_name ,' ', s.last_name) AS name,s.dob,(avg_score * 0.9) + (attendancePercent * 0.1) AS final_score, getCharGrade((avg_score * 0.9) + (attendancePercent * 0.1)) AS grade
	FROM StudentPerformance AS sp JOIN Students s ON s.student_id = sp.student_id;

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
	
	
	
	
	
	
