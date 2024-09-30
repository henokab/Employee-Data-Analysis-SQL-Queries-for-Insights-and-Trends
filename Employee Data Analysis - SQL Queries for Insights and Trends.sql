-- ----------------------------
-- Average Salary Queries
-- ----------------------------

-- 1. Get the average salary by occupation for those earning over $75,000
-- Demonstrates aggregation and filtering using HAVING.
SELECT occupation, AVG(salary) AS avg_salary
FROM employee_salary
GROUP BY occupation
HAVING AVG(salary) > 75000;

-- 9. Average salary by gender
-- Combines join and aggregation to analyze salary distribution.
SELECT gender, AVG(salary) AS avg_salary
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id
GROUP BY gender;

-- ----------------------------
-- Employee Demographics Queries
-- ----------------------------

-- 2. Select top 4 oldest employees from demographics
-- Showcases data retrieval and sorting capabilities.
SELECT TOP 4 *
FROM employee_demographics
ORDER BY age DESC;

-- 4. Average age by gender where age is greater than 40
-- Uses conditional aggregation to analyze age distribution.
SELECT gender, AVG(age) AS avg_age
FROM employee_demographics
GROUP BY gender
HAVING AVG(age) > 40;

-- 8. Categorize employees by age brackets
-- Demonstrates conditional logic with CASE for categorization.
SELECT first_name, last_name, age,
       CASE
           WHEN age <= 30 THEN 'Young'
           WHEN age BETWEEN 31 AND 50 THEN 'Old'
           WHEN age > 50 THEN 'Very Old'
       END AS age_bracket
FROM employee_demographics;

-- ----------------------------
-- Joining and Labeling Queries
-- ----------------------------

-- 5. Join demographics with salary table
-- Highlights the use of LEFT JOIN to combine related data.
SELECT *
FROM employee_demographics dem
LEFT JOIN employee_salary sal ON dem.employee_id = sal.employee_id;

-- 6. Generate labels based on employee age and gender
-- Demonstrates UNION and creates custom labels for analysis.
SELECT first_name, last_name, 'Old Man' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Male'

UNION

SELECT first_name, last_name, 'Old Lady' AS label
FROM employee_demographics
WHERE age > 40 AND gender = 'Female'

UNION

SELECT first_name, last_name, 'Highly Paid Employee' AS label
FROM employee_salary
WHERE salary > 70000
ORDER BY first_name, last_name;

-- ----------------------------
-- Advanced Queries
-- ----------------------------

-- 3. Retrieve SQL server version
-- Shows usage of system functions for server information.
SELECT @@VERSION;

-- 10. Row number partitioned by gender and ordered by salary
-- Utilizes window functions for advanced data analytics.
SELECT dem.first_name, dem.last_name, gender, sal.salary,
       ROW_NUMBER() OVER (PARTITION BY gender ORDER BY salary DESC) AS row_num
FROM employee_demographics dem
JOIN employee_salary sal ON dem.employee_id = sal.employee_id;

-- 11. Create CTE for salary statistics by gender
-- Demonstrates CTEs for organizing complex queries.
WITH cte_example AS (
    SELECT gender, 
           AVG(salary) AS avg_salary, 
           MAX(salary) AS max_salary, 
           COUNT(salary) AS salary_count
    FROM employee_demographics dem
    JOIN employee_salary sal ON dem.employee_id = sal.employee_id
    WHERE salary IS NOT NULL
    GROUP BY gender
)
SELECT AVG(avg_salary) AS overall_avg_salary
FROM cte_example;

-- ----------------------------
-- Triggers and Data Manipulation
-- ----------------------------

-- 12. Create trigger to insert into demographics after a salary insert
-- Defines a trigger for automatic data management.
CREATE TRIGGER employee_insert
ON employee_salary
AFTER INSERT
AS
BEGIN
    INSERT INTO employee_demographics (employee_id, first_name, last_name)
    SELECT employee_id, first_name, last_name
    FROM inserted;
END;

-- 13. Insert a new employee into salary table
-- Demonstrates data insertion with relevant employee details.
INSERT INTO employee_salary (employee_id, first_name, last_name, occupation, salary, dept_id)
VALUES (13, 'Henok', 'Sharew', 'IT', 100000, NULL);
