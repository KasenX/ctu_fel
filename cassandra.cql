CREATE KEYSPACE test WITH replication = {'class': 'SimpleStrategy', 'replication_factor': 3};

CREATE TABLE student_courses (
    student_name TEXT,
    course_name TEXT,
    teacher_name TEXT,
    recording_date DATE,
    email_addresses SET<TEXT>,
    PRIMARY KEY ((student_name, course_name), recording_date)
);

INSERT INTO student_courses (student_name, course_name, teacher_name, recording_date) VALUES ('Jack', 'Math', 'Nielson', '2022-06-21');
INSERT INTO student_courses (student_name, course_name, teacher_name, recording_date, email_addresses) VALUES ('Tony', 'Algorithms', 'Novak', '2022-06-12', {'tony@gmail.com', 'tony@hotmail.com'});
INSERT INTO student_courses (student_name, course_name, teacher_name, recording_date) VALUES ('Robert', 'Math', 'Nielson', '2022-06-13');
INSERT INTO student_courses (student_name, course_name, teacher_name, recording_date) VALUES ('Jack', 'JavaScript', 'Novak', '2022-06-14');

-- A. Nielson’s pupils
SELECT student_name FROM student_courses WHERE teacher_name = 'Nielson' ALLOW FILTERING;

-- B. Jack’s first course
SELECT course_name FROM student_courses WHERE student_name = 'Jack' ORDER BY recording_date ASC LIMIT 1 ALLOW FILTERING;

-- C. Add a new email address to Tony
UPDATE student_courses SET email_addresses = email_addresses + {'tony@fel.cvut.cz'} WHERE student_name = 'Tony';