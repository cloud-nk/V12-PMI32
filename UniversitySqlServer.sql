USE UniversityBD;

-- 1. Дисциплины
CREATE TABLE Disciplines (
    discipline_id INT IDENTITY(1,1) PRIMARY KEY,
    discipline_name NVARCHAR(100) NOT NULL   --название дисциплины
);

-- 2. Преподаватель
CREATE TABLE Teachers (
    teacher_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL, --ФИО преподавателя
    department NVARCHAR(100) NOT NULL --Кафедра
);

-- 3. Связь преподаватель_дисциплина
CREATE TABLE Teacher_Discipline (
    teacher_id INT NOT NULL,
    discipline_id INT NOT NULL,
    PRIMARY KEY (teacher_id, discipline_id),
    FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id)
);

-- 4. Группа
CREATE TABLE StudyGroups (
    group_id INT IDENTITY(1,1) PRIMARY KEY,
    group_name NVARCHAR(20) NOT NULL, 
	specialty NVARCHAR (100) NOT NULL 
);

-- 5. Учебный план
CREATE TABLE CurriculumPlan (
    plan_id INT IDENTITY(1,1) PRIMARY KEY,
    discipline_id INT NOT NULL, 
    group_id INT NOT NULL, 
	teacher_id INT NOT NULL, 
    academic_year NVARCHAR(10) NOT NULL, 
    semester INT NOT NULL, 
    course INT NOT NULL, 
    specialty NVARCHAR(100) NOT NULL,
    hours_count INT NOT NULL,
    report_type NVARCHAR(50) NOT NULL,
    
    FOREIGN KEY (discipline_id) REFERENCES Disciplines(discipline_id),
    FOREIGN KEY (group_id) REFERENCES StudyGroups(group_id),
	FOREIGN KEY (teacher_id) REFERENCES Teachers(teacher_id),
    CONSTRAINT CK_CurriculumPlan_semester CHECK (semester BETWEEN 1 AND 11),
    CONSTRAINT CK_CurriculumPlan_hours CHECK (hours_count > 0),
    CONSTRAINT CK_CurriculumPlan_course CHECK (course BETWEEN 1 AND 6)
);

-- 6. Ведомость
CREATE TABLE Statements (
    statement_id INT IDENTITY(1,1) PRIMARY KEY,
    plan_id INT NOT NULL, 
    creation_date DATE NOT NULL DEFAULT GETDATE(),
    
    FOREIGN KEY (plan_id) REFERENCES CurriculumPlan(plan_id)
);

-- 7. Студенты
CREATE TABLE Students (
    student_id INT IDENTITY(1,1) PRIMARY KEY,
    full_name NVARCHAR(100) NOT NULL,
    group_id INT NOT NULL,
	course INT NOT NULL,
    
    FOREIGN KEY (group_id) REFERENCES StudyGroups(group_id),
	CONSTRAINT CK_Students_course CHECK (course BETWEEN 1 AND 6)
);

-- 8. Оценка
CREATE TABLE Grades (
    grade_id INT IDENTITY(1,1) PRIMARY KEY,
    student_id INT NOT NULL,
    statement_id INT NOT NULL,
    grade_value NVARCHAR(10) NOT NULL, 
    exam_date DATE NOT NULL DEFAULT GETDATE(),
    
    FOREIGN KEY (student_id) REFERENCES Students(student_id),
    FOREIGN KEY (statement_id) REFERENCES Statements(statement_id),
    CONSTRAINT CK_Grades_value
        CHECK (grade_value IN ('2', '3', '4', '5', 'Зачет', 'Незачет'))
);

