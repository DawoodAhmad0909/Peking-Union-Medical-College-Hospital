CREATE DATABASE PUMCH_db;
USE PUMCH_db;

CREATE TABLE patients (
	patient_id INT PRIMARY KEY,
	first_name VARCHAR(20),
	last_name VARCHAR(20),
	date_of_birth DATE,
	gender VARCHAR(5),
	city VARCHAR(30),
	insurance_provider VARCHAR(50),
	registration_date DATE,
	last_visit_date DATE,
    total_spend DECIMAL(10,2)
);

INSERT INTO patients VALUES
	(1, 'John', 'Smith', '1985-03-15', 'M', 'Boston', 'BlueCross', '2025-01-10', '2025-06-22', 1850.00),
	(2, 'Mary', 'Johnson', '1972-07-22', 'F', 'Cambridge', 'Aetna', '2024-05-15', '2025-07-18', 6200.00),
	(3, 'Robert', 'Williams', '1990-11-30', 'M', 'Somerville', 'Medicare', '2025-02-20', '2025-08-05', 3200.00),
	(4, 'Jennifer', 'Brown', '1982-09-05', 'F', 'Quincy', 'UnitedHealth', '2023-11-03', '2025-09-12', 4150.00),
	(5, 'Michael', 'Davis', '1975-12-18', 'M', 'Boston', 'BlueCross', '2025-07-22', '2025-10-01', 2800.00),
	(6, 'Sarah', 'Miller', '1988-04-25', 'F', 'Brookline', 'Tufts Health', '2025-03-18', '2025-08-30', 1350.00),
	(7, 'David', 'Wilson', '1965-08-12', 'M', 'Boston', 'Medicare', '2022-09-09', '2025-09-25', 5870.00),
	(8, 'Lisa', 'Moore', '1993-01-07', 'F', 'Newton', 'Aetna', '2025-01-05', '2025-07-11', 920.00),
	(9, 'James', 'Taylor', '1978-06-19', 'M', 'Boston', 'UnitedHealth', '2024-08-14', '2025-10-18', 3100.00),
	(10, 'Emily', 'Anderson', '1980-10-31', 'F', 'Cambridge', 'BlueCross', '2025-04-30', '2025-11-02', 2450.00),
	(11, 'Daniel', 'Thomas', '1995-02-14', 'M', 'Somerville', 'Medicaid', '2025-11-22', '2025-11-22', 750.00),
	(12, 'Jessica', 'Jackson', '1970-05-27', 'F', 'Boston', 'Medicare', '2023-06-17', '2025-10-15', 6820.00),
	(13, 'Matthew', 'White', '1987-07-08', 'M', 'Quincy', 'Aetna', '2025-09-25', '2025-11-10', 1850.00),
	(14, 'Amanda', 'Harris', '1991-12-03', 'F', 'Boston', 'Tufts Health', '2025-07-11', '2025-09-28', 1670.00),
	(15, 'Christopher', 'Martin', '1968-09-21', 'M', 'Brookline', 'Medicare', '2024-04-05', '2025-08-14', 5300.00),
	(16, 'Elizabeth', 'Wang', '1973-04-19', 'F', 'Boston', 'BlueCross', '2024-02-28', '2025-10-30', 12450.00),
	(17, 'Brian', 'Rodriguez', '1984-11-08', 'M', 'Cambridge', 'Aetna', '2025-05-12', '2025-09-05', 2150.00),
	(18, 'Nancy', 'Martinez', '1977-08-31', 'F', 'Quincy', 'UnitedHealth', '2025-01-22', '2025-11-12', 3800.00),
	(19, 'Kevin', 'Lee', '1992-06-14', 'M', 'Boston', 'BlueCross', '2025-03-03', '2025-07-29', 2950.00),
	(20, 'Patricia', 'Clark', '1960-12-05', 'F', 'Cambridge', 'Medicare', '2023-10-17', '2025-10-22', 7100.00);

SELECT*FROM patients;
    
SELECT gender, COUNT(*) AS Total_Patients FROM patients
GROUP BY gender;

SELECT TIMESTAMPDIFF(YEAR,date_of_birth,NOW()) AS Age, COUNT(*) AS Total_Patients FROM patients
GROUP BY Age
ORDER BY Age;

SELECT city, COUNT(*) AS Total_Patients FROM patients
GROUP BY city
ORDER BY Total_Patients DESC
LIMIT 3;

SELECT patient_id, CONCAT( first_name, ' ',last_name) AS Patient_name, total_spend FROM patients
ORDER BY  total_spend DESC
LIMIT 5;

SELECT insurance_provider,ROUND( AVG(total_spend),2) AS Average_Spending FROM patients
GROUP BY insurance_provider;

SELECT insurance_provider,ROUND( AVG(total_spend),2) AS Patients_Average_Spending FROM patients
GROUP BY insurance_provider
HAVING ROUND( AVG(total_spend),2) >3000.00;

SELECT patient_id, CONCAT( first_name,' ',last_name) AS Patient_name, last_visit_date,TIMESTAMPDIFF(MONTH,last_visit_date,NOW()) AS months_till_last_visit  FROM patients
WHERE  TIMESTAMPDIFF(MONTH,last_visit_date,NOW()) >6;

SELECT YEAR(registration_date) AS Year, COUNT(*) AS Total_patients FROM patients
GROUP BY Year
ORDER BY Year ASC;

SELECT MONTH(registration_date) AS Month, COUNT(*) AS Total_patients FROM patients
GROUP BY MontH
ORDER BY Month ASC;

SELECT city, SUM(total_spend) AS Revenue FROM patients
GROUP BY city
ORDER BY Revenue DESC
LIMIT 3;

SELECT city, COUNT(*) AS Total_patients FROM patients
WHERE patient_id<3
GROUP BY city;

SELECT patient_id, CONCAT( first_name,' ',last_name) AS Patient_name, 
	CASE WHEN total_spend BETWEEN 100.00 AND 3000.00 THEN 'Basic'
		 WHEN total_spend BETWEEN 3000.01 AND 6000.00 THEN 'Standard'
          WHEN total_spend >6000.00 THEN 'Premium'
	END AS Tiers FROM patients;

SELECT 
	CASE  WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
		 ELSE 'Private' END AS insurance_type,
	COUNT(*) AS patient_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM patients),2) AS percentage
    FROM patients
    GROUP BY 
		CASE WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
		 ELSE 'Private' END;
         
SELECT CONCAT( first_name,' ',last_name) AS Patient_name, date_of_birth FROM patients
WHERE date_of_birth is NULL
	OR date_of_birth > CURDATE();
    
SELECT CONCAT( first_name,' ',last_name) AS Patient_name, COUNT(*) AS count FROM patients
GROUP BY  Patient_name
HAVING count >1;

SELECT YEAR(registration_date) AS Year, SUM(total_spend) FROM patients
GROUP BY Year
ORDER BY Year;
 
WITH ranked_patients AS (
    SELECT 
        patient_id,
        CONCAT( first_name,' ',last_name) AS Patient_name ,
        city,
        registration_date,
        ROW_NUMBER() OVER (
            PARTITION BY city 
            ORDER BY registration_date DESC
        ) AS rank_in_city
    FROM patients
)
SELECT *
FROM ranked_patients
WHERE rank_in_city <= 3
ORDER BY city,rank_in_city;

SELECT YEAR(registration_date) AS Year, SUM(total_spend) AS Revenue FROM patients
WHERE YEAR(registration_date) IN (2024,2025)
GROUP BY Year
ORDER BY Year;

SELECT 
	CASE WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
		 ELSE 'Private' END AS insurance_type,
	ROUND(AVG(total_spend),2) AS Average_Spending
    FROM patients
GROUP BY insurance_type
ORDER BY Average_Spending DESC;