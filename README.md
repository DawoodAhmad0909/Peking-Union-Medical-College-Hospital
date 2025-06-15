# Peking Union Medical College Hospital(Patients Data Analysis)
## Overview
#### Project : Patients Data Analysis
#### Database : PUMCH_db
## Objectives
To manage the Peking Union hospital patient data systematically for accurate, scalable analysis and decision-making.
The analysis is based on following factors 
Demographic,Financial Performance,PatientActivity & Retention,Geographic Insights,Patient Segmentation,Quality of data,Advanced Analytics,Comparative Analysis.
## Database Creation
```sql 
CREATE DATABASE PUMCH_db;
USE PUMCH_db;
```
## Table Creation
``` sql 
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
```
## Objective Queries 
### 1. How many patients do we have by gender?  
```sql
SELECT gender, COUNT(*) AS Total_Patients FROM patients
GROUP BY gender;
```
### 2. What is the age distribution of our patients?  
```sql 
SELECT TIMESTAMPDIFF(YEAR,date_of_birth,NOW()) AS Age, COUNT(*) AS Total_Patients FROM patients
GROUP BY Age
ORDER BY Age;
```
### 3. Which cities do most of our patients come from?
```sql
SELECT city, COUNT(*) AS Total_Patients FROM patients
GROUP BY city
ORDER BY Total_Patients DESC
LIMIT 3;
``` 
### 4. Who are our top 5 highest-spending patients? 
```sql
SELECT patient_id, CONCAT( first_name, ' ',last_name) AS Patient_name, total_spend FROM patients
ORDER BY  total_spend DESC
LIMIT 5;
```
### 5. What is the average spending per insurance provider?  
```sql
SELECT insurance_provider,ROUND( AVG(total_spend),2) AS Average_Spending FROM patients
GROUP BY insurance_provider;
```
### 6. Which insurance providers have patients spending above $3,000 on average?  
```sql
SELECT insurance_provider,ROUND( AVG(total_spend),2) AS Patients_Average_Spending FROM patients
GROUP BY insurance_provider
HAVING ROUND( AVG(total_spend),2) >3000.00;
```
### 7. Which patients haven't visited in the last 6 months?  
```sql
SELECT patient_id, CONCAT( first_name,' ',last_name) AS Patient_name, last_visit_date,TIMESTAMPDIFF(MONTH,last_visit_date,NOW()) AS months_till_last_visit  FROM patients
WHERE  TIMESTAMPDIFF(MONTH,last_visit_date,NOW()) >6;
```
### 8. How many patients registered each year?  
```sql
SELECT YEAR(registration_date) AS Year, COUNT(*) AS Total_patients FROM patients
GROUP BY Year
ORDER BY Year ASC;
```
### 9. What is the trend in new patient registrations by month?  
```sql
SELECT MONTH(registration_date) AS Month, COUNT(*) AS Total_patients FROM patients
GROUP BY MontH
ORDER BY Month ASC;
```
### 10. Which cities contribute the most to our revenue?  
```sql
SELECT city, SUM(total_spend) AS Revenue FROM patients
GROUP BY city
ORDER BY Revenue DESC
LIMIT 3;
```
### 11. Do we have any cities with fewer than 3 patients?  
```sql
SELECT city, COUNT(*) AS Total_patients FROM patients
WHERE patient_id<3
GROUP BY city;
```
### 12. Can we classify patients into spending tiers (Premium/Standard/Basic)?  
```sql
SELECT patient_id, CONCAT( first_name,' ',last_name) AS Patient_name, 
        CASE WHEN total_spend BETWEEN 100.00 AND 3000.00 THEN 'Basic'
                 WHEN total_spend BETWEEN 3000.01 AND 6000.00 THEN 'Standard'
          WHEN total_spend >6000.00 THEN 'Premium'
        END AS Tiers FROM patients;
```
### 13. What percentage of patients are on government vs. private insurance?  
```sql
SELECT 
        CASE  WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
                 ELSE 'Private' END AS insurance_type,
        COUNT(*) AS patient_count,
    ROUND(COUNT(*)*100/(SELECT COUNT(*) FROM patients),2) AS percentage
    FROM patients
    GROUP BY 
                CASE WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
                 ELSE 'Private' END;
```
### 14. Are there any patients with invalid birth dates (e.g., future dates)?  
```sql
SELECT CONCAT( first_name,' ',last_name) AS Patient_name, date_of_birth FROM patients
WHERE date_of_birth is NULL
        OR date_of_birth > CURDATE();
```
### 15. Do we have duplicate patient records with identical names?  
```sql
SELECT CONCAT( first_name,' ',last_name) AS Patient_name, COUNT(*) AS count FROM patients
GROUP BY  Patient_name
HAVING count >1;
```
### 16. How does patient spending accumulate over time?  
```sql
SELECT YEAR(registration_date) AS Year, SUM(total_spend) FROM patients
GROUP BY Year
ORDER BY Year;
```
### 17. Who are the 3 most recently registered patients in each city?  
```sql
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
```
### 18. How does 2024 patient registration compare to 2025 in terms of revenue?  

```sql
SELECT YEAR(registration_date) AS Year, SUM(total_spend) AS Revenue FROM patients
WHERE YEAR(registration_date) IN (2024,2025)
GROUP BY Year
ORDER BY Year;
```
### 19. Which insurance type has higher average spending?
```sql
SELECT 
        CASE WHEN insurance_provider IN ('Medicaid','Medicare') THEN 'Government'
                 ELSE 'Private' END AS insurance_type,
        ROUND(AVG(total_spend),2) AS Average_Spending
    FROM patients
GROUP BY insurance_type
ORDER BY Average_Spending DESC;
```