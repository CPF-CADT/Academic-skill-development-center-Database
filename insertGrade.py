import mysql.connector
import random

def random_score():
    """Generate a random score between 10 and 100, with priority between 70 and 90"""
    # Prioritize the range between 70 and 90
    if random.random() < 0.7:  # 80% chance for score to be in the range of 70-90
        return round(random.uniform(30, 90), 2)
    else:  # 20% chance for score to be in the range of 10-100 but not in 70-90
        return round(random.uniform(10, 100), 2)

def random_assessment_type():
    """Randomly select an assessment type"""
    return random.choice(['LAB', 'QA','Quizz'])

def insert_student_grading(connection, stuID, year, term, group_s, short_name_course, session_no, assessment_type, stuScore):
    """Call the StudentGrading stored procedure to insert a student's grade"""
    try:
        cursor = connection.cursor()
        cursor.callproc("StudentGrading", [stuID, year, term, group_s, short_name_course, session_no, assessment_type, stuScore])
        connection.commit()
        print(f"✅ Grading for student {stuID} inserted successfully!")
    except mysql.connector.Error as e:
        print(f"❌ Error inserting grading for student {stuID}: {e}")
    finally:
        cursor.close()

def get_course_instances():
    """Fetch all course instances"""
    query = "SELECT year, term, group_s, short_name FROM Course_instance"
    return MySQLConnection.execute_query(query)

def get_students_for_course_instance(year, term, group_s, short_name):
    """Fetch students for a given course instance"""
    query = """
    SELECT e.student_id 
    FROM Enrollment e
    JOIN Course_instance ci 
        ON ci.course_instance_id = e.course_instance_id
    WHERE ci.year = %s AND ci.term = %s AND ci.group_s = %s AND ci.short_name = %s;
    """
    return MySQLConnection.execute_query(query, (year, term, group_s, short_name))

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
    def execute_update(cls, query, params=None):
        """Execute an INSERT, UPDATE, or DELETE query."""
        try:
            conn = cls.get_connection()
            cursor = conn.cursor()
            cursor.execute(query, params)
            conn.commit()
        except mysql.connector.Error as e:
            print(f"Update execution failed: {e}")

# Main script to iterate over course instances and insert grading data
if __name__ == "__main__":
    # Get all course instances (year, term, group, short_name)
    course_instances = get_course_instances()

    # Iterate over each course instance
    for course_instance in course_instances:
        year = course_instance['year']
        term = course_instance['term']
        group_s = course_instance['group_s']
        short_name = course_instance['short_name']

        # Fetch students for the current course instance
        students = get_students_for_course_instance(year, term, group_s, short_name)

        # Loop through each session (from 1 to 10)
        for session_no in range(1, 11):
            for student in students:
                stuID = student['student_id']
                # Generate random score and assessment type
                stuScore = random_score()
                assessment_type = random_assessment_type()
                
                # Insert the grading record into the database using the stored procedure
                insert_student_grading(MySQLConnection.get_connection(), stuID, year, term, group_s, short_name, session_no, assessment_type, stuScore)