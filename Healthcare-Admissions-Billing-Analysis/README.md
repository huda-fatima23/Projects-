# Healthcare Admissions & Billing Analysis

## Project Overview
This project analyzes 55,000+ healthcare admission records using SQL in Google BigQuery. The analysis explores patient demographics, medical conditions, billing patterns, insurance providers, medications, hospital utilization, and length of stay.

## Tools
- Google BigQuery
- SQL

## SQL Techniques
- CTEs
- CASE statements
- Subqueries
- Aggregate functions
- Window functions
- DENSE_RANK
- Date functions

## Key Findings
- The dataset contains 55,500 hospital admission records with an average patient age of 51.5 years.
- The average billing amount was approximately $25,539 per admission.
- Arthritis had the highest number of admissions, while Obesity had the highest average billing amount.
- Patients aged 66+ represented the largest age group, accounting for 29.28% of admissions.
- Insurance payer mix was highly balanced, with each provider representing approximately 20% of admissions.
- Average length of stay was similar across medical conditions, ranging from 15.4 to 15.7 days.

## Analysis
The SQL analysis includes:
1. Dataset summary
2. Medical condition and billing analysis
3. Gender and billing comparison
4. Test result distribution
5. Admission type analysis
6. Age-group analysis
7. Top hospitals by admissions
8. Medication frequency by medical condition
9. Insurance payer mix
10. Length-of-stay analysis
11. High-cost admission analysis

## Data Quality Note
Negative billing values were identified in the dataset and may represent billing adjustments, refunds, or data-quality issues.
