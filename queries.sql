-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, and DEPARTMENT from the employee record table, and make a list of employees and details of their department.
select 
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT
from emp_record_table;

-- Write a query to fetch EMP_ID, FIRST_NAME, LAST_NAME, GENDER, DEPARTMENT, and EMP_RATING if the EMP_RATING is:
-- less than two
-- greater than four
-- between two and four
select 
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    GENDER,
    DEPT,
    EMP_RATING
from emp_record_table
where EMP_RATING < 2 
	or EMP_RATING > 4
    or EMP_RATING between 2 and 4; 
    
-- Write a query to concatenate the FIRST_NAME and the LAST_NAME of employees in the Finance department from the employee table and then give the resultant column alias as NAME.
select concat(FIRST_NAME,' ', LAST_NAME) as NAME
from emp_record_table
where DEPT = 'Finance';

-- Write a query to list only those employees who have someone reporting to them. Also, show the number of reporters (including the President).
select 
	d.EMP_ID,
    d.FIRST_NAME,
    d.LAST_NAME,
    count(e.MANAGER_ID) as Number_of_Reporters
from
	data_science_team d
join
	emp_record_table e on d.EMP_ID = e.MANAGER_ID
group by 
	d.EMP_ID, d.FIRST_NAME, d.LAST_NAME
having
	count(e.MANAGER_ID) > 0;

-- Write a query to list down all the employees from the healthcare and finance departments using union. Take data from the employee record table.
select *
from emp_record_table
where
	DEPT = 'Healthcare'
union
select *
from emp_record_table
where
	DEPT = 'Finance';

-- Write a query to list down employee details such as EMP_ID, FIRST_NAME, LAST_NAME, ROLE, DEPARTMENT, and EMP_RATING grouped by dept. Also include the respective employee rating along with the max emp rating for the department.
select
	e.EMP_ID,
    e.FIRST_NAME,
    e.LAST_NAME,
    e.ROLE,
    e.DEPT as DEPARTMENT,
    e.EMP_RATING,
    Max_Rating
from emp_record_table e
join
	(select
		DEPT,
        max(EMP_RATING) as Max_Rating
	from
		emp_record_table
	group by
		DEPT) d on e.DEPT = d.DEPT;

-- Write a query to calculate the minimum and the maximum salary of the employees in each role. Take data from the employee record table.
select
	ROLE,
    min(SALARY) as Min_Salary,
    max(SALARY) as Max_Salary
from
	emp_record_table
group by
	ROLE;

-- Write a query to assign ranks to each employee based on their experience. Take data from the employee record table.
select
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    EXP,
    rank() over (order by EXP desc) as Experience_Rank
from emp_record_table;
    
-- Write a query to create a view that displays employees in various countries whose salary is more than six thousand. Take data from the employee record table.
create view Employees_High_Salary as
select
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    COUNTRY,
    SALARY
from emp_record_table
where salary > 6000;

-- Write a nested query to find employees with experience of more than ten years. Take data from the employee record table.
select
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    ROLE,
    DEPT,
    EXP
from
	emp_record_table
where
	EMP_ID in (select EMP_ID from emp_record_table where EXP > 10);

-- Write a query to create a stored procedure to retrieve the details of the employees whose experience is more than three years. Take data from the employee record table.
delimiter //

create procedure GetExperiencedEmployees()
begin
	select
		EMP_ID,
        FIRST_NAME,
        LAST_NAME,
        ROLE,
        DEPT,
        EXP
	from
		emp_record_table
	where
		EXP > 3;
END //
delimiter;  

-- Write a query using stored functions in the project table to check whether the job profile assigned to each employee in the data science team matches the organization’s set standard.
delimiter // 

create function GetExpectedJobProfile(EXP int)
returns varchar(50)
deterministic
begin
	return case
		when EXP <= 2 then 'JUNIOR DATA SCIENTIST'
        when EXP > 2 and EXP <= 5 then 'ASSOCIATE DATA SCIENTIST'
        when EXP > 5 and EXP <= 10 then 'SENIOR DATA SCIENTIST'
        when EXP > 10 and EXP <= 12 then 'LEAD DATA SCIENTIST'
        when EXP > 12 and EXP <= 16 then 'MANAGER'
        else 'Undefined Role'
	end;
end //

delimiter ;

-- Create an index to improve the cost and performance of the query to find the employee whose FIRST_NAME is ‘Eric’ in the employee table after checking the execution plan.
create index idx_firstname on emp_record_table (FIRST_NAME(255));

-- Write a query to calculate the bonus for all the employees, based on their ratings and salaries (Use the formula: 5% of salary * employee rating).
select
	EMP_ID,
    FIRST_NAME,
    LAST_NAME,
    SALARY,
    EMP_RATING,
    (SALARY * EMP_RATING * 0.05) as Bonus
from
	emp_record_table;

-- Write a query to calculate the average salary distribution based on the continent and country. Take data from the employee record table.
select
	CONTINENT,
    COUNTRY,
    avg(SALARY) as Average_Salary
from
	emp_record_table
group by 
	CONTINENT, COUNTRY;