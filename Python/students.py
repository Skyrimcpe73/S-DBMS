from database import get_connection


# CREATE: Add new students

def create_student(firstname, lastname, email, department_id):
    with get_connection() as con:
        with con.cursor() as cur:
            cur.execute("""
            insert into Person (firstname, lastname, email)
            values (%s, %s, %s)
            returning person_id;
            """, (firstname, lastname, email))
            person_id = cur.fetchone()[0]

            cur.execute("""
            insert into Student (student_id, department_id)
            values (%s, %s);
            """, (person_id, department_id))

            return person_id

# READ: Display all students

def read_all_students():
    with get_connection() as con:
        with con.cursor() as cur:
            cur.execute("""
            select p.person_id, p.firstname, p.lastname, p.email
            from Person p
            join Student s
                on(p.person_id = s.student_id)
            order by p.lastname asc;
            """)

            return cur.fetchall()

# UPDATE: Edit student

def update_student(student_id, firstname, lastname, email):
    with get_connection() as con:
        with con.cursor() as cur:
            cur.execute("""
            update Person
            set firstname = %s, lastname = %s, email = %s
            where person_id = %s
            and exists(
            select 1 
            from Student
            where student_id = Person.person_id);  
            """, (firstname, lastname, email, student_id))

            if cur.rowcount == 0:
                print("Student not found!")
            else:
                print("Student succesfully updated!")

# DELETE: Remove student

def delete_student(student_id):
    with get_connection() as con:
        with con.cursor() as cur:
            cur.execute("""
            delete from Person
            where person_id = %s;
            """, (student_id,))

            if cur.rowcount == 0:
                print("Student not found!")
            else:
                print("Student successfully deleted") 