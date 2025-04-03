import mysql.connector 
import random

def random_attendance_status():
    """Generate a random attendance status with preference for 'present' and 'late'."""
    # Weighted choices to favor 'present' and 'late'
    statuses = ['present', 'late', 'absent', 'permission']
    weights = [0.7, 0.2, 0.05, 0.05]  # 70% chance for 'present', 20% for 'late', and 5% each for 'absent' and 'permission'
    return random.choices(statuses, weights)[0]

def insert_student_attendance(connection, stu_id, year, term, group, short_name_course, session_no, status):
    """Insert student attendance record by calling the stored procedure StudentAttendanceTrack."""
    try:
        cursor = connection.cursor()
        cursor.callproc("StudentAttendanceTrack", [
            stu_id, year, term, group, short_name_course, session_no, status
        ])
        connection.commit()
        print(f"✅ Attendance for student {stu_id} inserted successfully!")
    except mysql.connector.Error as e:
        print(f"❌ Error inserting attendance for student {stu_id}: {e}")
    finally:
        cursor.close()

class MySQLConnection:
    _connection = None
    _host = "localhost"
    _database = "school_db"
    _user = "root"
    _password = ""

    @classmethod
    def get_connection(cls):
        """Establish and return a database connection."""
        if cls._connection is None:
            try:
                cls._connection = mysql.connector.connect(
                    host=cls._host,
                    user=cls._user,
                    password=cls._password,
                    database=cls._database
                )
                print("Database connection established successfully!")
            except mysql.connector.Error as e:
                print(f"Connection failed: {e}")
                cls._connection = None
        return cls._connection

    @classmethod
    def execute_query(cls, query, params=None):
        """Execute a SELECT query and return the results."""
        try:
            conn = cls.get_connection()
            cursor = conn.cursor(dictionary=True)
            cursor.execute(query, params)
            results = cursor.fetchall()
            return results
        except mysql.connector.Error as e:
            print(f"Query execution failed: {e}")
            return None

    @classmethod
    def execute_update(cls, query):
        """Execute an INSERT, UPDATE, or DELETE query."""
        try:
            conn = cls.get_connection()
            cursor = conn.cursor()
            affected_rows = cursor.execute(query)
            conn.commit()
            return affected_rows
        except mysql.connector.Error as e:
            print(f"Update execution failed: {e}")
            return 0

    @classmethod
    def close_connection(cls):
        """Close the database connection."""
        if cls._connection is not None:
            try:
                cls._connection.close()
                cls._connection = None
                print("Database connection closed.")
            except mysql.connector.Error as e:
                print(f"Failed to close connection: {e}")

    @classmethod
    def test_connection(cls):
        """Check if the database connection is successful."""
        return cls.get_connection() is not None


if __name__ == "__main__":

    # Fetch all course instances dynamically
    course_instances = MySQLConnection.execute_query("""
        SELECT ci.year, ci.term, ci.group_s, ci.short_name 
        FROM Course_instance ci;
    """)

    # Iterate over each course instance and insert attendance dynamically
    for course_instance in course_instances:
        year = course_instance['year']
        term = course_instance['term']
        group_s = course_instance['group_s']
        short_name = course_instance['short_name']

        # Fetch students for the current course instance
        students = MySQLConnection.execute_query("""
            SELECT e.student_id 
            FROM Enrollment e
            JOIN Course_instance ci 
                ON ci.course_instance_id = e.course_instance_id
            WHERE ci.year = %s AND ci.term = %s AND ci.group_s = %s AND ci.short_name = %s;
        """, (year, term, group_s, short_name))

        # Loop through each week (from 1 to 10)
        for i in range(1, 11):
            for student in students:
                # Get random attendance status (mostly 'present' and 'late')
                status = random_attendance_status()
                # Insert the attendance record
                insert_student_attendance(MySQLConnection.get_connection(), student['student_id'], year, term, group_s, short_name, i, status)
