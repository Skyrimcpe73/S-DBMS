create table Department (
	department_id 		serial primary key,
	department_name 	varchar(100) unique not null,
	building 			varchar(100)
);

create table Person (
	person_id 			serial primary key,
	firstname 			varchar(20) not null,
	lastname			varchar(30) not null,
	email				varchar(100) unique not null,
	date_of_birth		date
);

create table Student (
	student_id			integer primary key
						references Person(person_id)
						on delete cascade,
	enrollment_date		date default current_date,
	department_id		integer
						references Department(department_id)
						on delete set null
);

create table Professor (
	professor_id		integer primary key
						references Person(person_id)
						on delete cascade,
	department_id		integer
						references Department(department_id)
						on delete set null
);

create table Course (
	course_id			serial primary key,
	course_name			varchar(100) not null,
	credit				integer not null check (credits > 0),
	instructor_id		integer
						references Professor(professor_id)
						on delete set null,
	department_id		integer 
						references Department(department_id)
						on delete set null
);

create table Enrollment (
	enrollment_id		serial primary key,
	student_id			integer not null
						references Student(student_id)
						on delete cascade,
	course_id			integer not null
						references Course(course_id)
						on delete cascade,
	enrollment_date		date default current_date,
	grade 				numeric(2,1)
						check (grade >= 1.0 and grade <= 5.0),
	unique(student_id,course_id)
);

create table student_log (
	log_id				serial primary key,
	student_id			integer
						references Student(student_id)
						on delete set null,
	activity 			varchar(50) not null,
	created_at			timestamp default current_timestamp
);



insert into Department (department_name, building) 
values
('Computer Science', 'Building A'), ('Mathematics', 'Building B'),
('Engineering', 'Building C'), ('Economy', 'Building D');

insert into Person (firstname, lastname, email, date_of_birth)
values
('Max', 'Mustermann', 'max@example.com', '2002-05-12'),
('Anna', 'Schmidt', 'anna@example.com', '2003-08-21'),
('John', 'Müller', 'john@example.com', '2001-11-03'),
('Sarah', 'Weber', 'sarah@example.com', '2002-02-15'),
('David', 'Fischer', 'david@example.com', '2003-6-18'),
('Thomas', 'Meyer', 'meyer@university.de', '1975-04-10'),
('Laura', 'Schulz', 'schulz@university.de', '1980-07-22'),
('Michael', 'Fischer', 'fischer@university.de', '1978-09-15')
('Alexander', 'Olaf', 'olaf@university.de', '1968-5-22');

insert into Student (student_id, department_id)
values
(1, 1), (2,1), (3,2), (4,3), (5, 3);

insert into Professor (professor_id, department_id)
values
(6, 1), (7, 2), (8, 3), (9, 4);

insert into Course (course_name, credit, instructor_id, department_id)
values
('Database Management Systems', 6, 6, 1),
('Software Engineering', 6, 7, 1),
('Statistics', 3, 8, 2),
('Computer Networks', 5, 9, 3);

insert into Enrollment (student_id, course_id, grade)
values
(1, 1, 1.7), (1, 2, 2.0), (2, 1, 1.3), (2, 2, 2.3),
(3, 3, 1.7), (4, 4, 2.0), (5, 1, 5.0), (5, 2, 5.0);



create or replace function log_new_student()
returns trigger as $$
begin
	insert into student_log (student_id, activity)
	values
	(new.student_id, 'insert');
	return new;
end;
$$ language plpgsql;

create trigger student_insert_trigger
after insert on Student
for each row
execute function log_new_student();



create view student_course_overview as
select p.person_id, p.firstname, p.lastname, p.email,
	   d.department_name,
	   c.course_name, c.credit,
	   e.grade
from		Person p
left join 	Student s
	on(p.person_id = s.student_id)
left join 	Department d
	on(s.department_id = d.department_id)
left join 	Enrollment e
	on(s.student_id = e.student_id)
left join 	Course c
	on(e.course_id = c.course_id);