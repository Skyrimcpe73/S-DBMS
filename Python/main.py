from students import *



def main():
    while True:

        print("\n========== STUDENT MANAGEMENT SYSTEM ==========")
        print("1. Create student")
        print("2. Read all students")
        print("3. Update student")
        print("4. Delete student")
        print("5. Exit")

        choice = input("\nChoose an option: ")

        # CREATE
        if choice == "1":

            firstname = input("Firstname: ")
            lastname = input("Lastname: ")
            email = input("Email: ")
            department_id = int(input("Department ID: "))

            student_id = create_student(firstname, lastname, email, department_id)

            print(f"Student created! ID: {student_id}")

        # READ
        elif choice == "2":

            students = read_all_students()
        
            for student in students:
                print(student)

        # UPDATE
        elif choice == "3":

            student_id = int(input("Student ID: "))
            firstname = input("New firstname: ")
            lastname = input("New lastname: ")
            email = input("New email: ")

            update_student(student_id, firstname, lastname, email)

        # DELETE
        elif choice == "4":

            student_id = int(input("Student ID: "))

            delete_student(student_id)

        elif choice == "5":
            print("Goodbye!")
            break
        else:
            print("Invalid option!")


if __name__ == "__main__":
    main()