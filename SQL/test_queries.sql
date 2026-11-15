-- Display all persons
select * from Person;

-- Display all professors
select * from Professor;

-- Display all departments
select * from Department;

-- Display students sorted by lastname
select * from Person p
join Student s
	on(p.person_id = s.student_id)
order by p.lastname asc;



-- Students with their departments
select p.firstname, p.lastname, d.department_name
from Person p
join Student s
	on(p.person_id = s.student_id)
join Department d
	on(s.department_id = d.department_id);

-- Courses with their professors
select c.course_name, p.firstname as prof_firstname, p.lastname as prof_lastname
from Course c
join Professor pr
	on(c.instructor_id = pr.professor_id)
join Person p
	on(pr.professor_id = p.person_id);



-- Count all students
select count(*) as total_students
from Student;

-- Count students per department
select d.department_name, count(s.student_id) as total_students
from Department d
left join Student s
	on(d.department_id = s.department_id)
group by d.department_id, d.department_name;

-- Average grade per student
select p.firstname, p.lastname, avg(e.grade)::Numeric(2,1) as average_grade
from Student s
join Person p
	on(s.student_id = p.person_id)
join Enrollment e 
	on(s.student_id = e.student_id)
group by p.person_id, p.firstname, p.lastname;

-- Best and worst grade
select min(grade) as best_grade, max(grade) as worst_grade
from Enrollment;



-- Students with a grade better than 2.0
select * from Enrollment 
where grade < 2.0;

-- Departments with more than one student
select d.department_name, count(s.student_id) as student_count
from Department d
join Student s 
	on(d.department_id = s.department_id)
group by d.department_id, d.department_name
having count(s.student_id) > 1;



-- Students who are enrolled in a course with at least 6 credits
select firstname, lastname
from Person
where person_id in (select student_id
					from Enrollment
					where course_id in(
						select course_id
						from Course
						where credit >= 6)
						);


begin;

-- Test view
select * from student_course_overview;

-- Display all student logs
select * from student_log;

-- Insert a new Person
insert into Person (firstname, lastname, email)
values ('Rob', 'Schneider', 'rob@example.com');

-- Register as a student
insert into Student (student_id, department_id)
values (10, 1);

-- Check whether the trigger created a log entry
select * from student_log
where student_id = 10;

rollback;


begin;

-- CRUD -- 

-- CREATE
insert into Department (department_name, building)
values ('Physics', 'Building E');

-- READ
select * from Department;

-- UPDATE
update Department
set building = 'Building F'
where department_name = 'Physics';

-- DELETE
delete from Department
where department_name = 'Physics';

commit;