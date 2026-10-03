/*
===============================================================================
PROJECT: Healthcare Admissions and Billing Analysis
PLATFORM: Google BigQuery
LANGUAGE: SQL

OBJECTIVE:
Analyze hospital admission records to identify patterns in patient demographics,
medical conditions, billing amounts, admission types, test outcomes, hospitals,
insurance providers, length of stay, and medication use.
===============================================================================
*/


-- 1. Preview the dataset
SELECT *
FROM `intro-to-bq-484420.healthcare.health`
LIMIT 10;


-- 2. Basic dataset summary
SELECT
  COUNT(*) AS total_records,
  ROUND(AVG(Age), 1) AS average_age,
  MIN(Age) AS youngest_age,
  MAX(Age) AS oldest_age,
  ROUND(AVG(`Billing Amount`), 2) AS average_billing
FROM `intro-to-bq-484420.healthcare.health`;

-- INTERPRETATION:
-- The dataset contains 55,500 hospital admission records.
-- The average patient age was 51.5 years, with ages ranging from 13 to 89.
-- The average billing amount per admission was approximately $25,539.


-- 3. Medical condition admission and billing analysis
SELECT
  `Medical Condition`,
  COUNT(*) AS total_admissions,
  ROUND(AVG(`Billing Amount`), 2) AS average_billing,
  ROUND(SUM(`Billing Amount`), 2) AS total_billing
FROM `intro-to-bq-484420.healthcare.health`
GROUP BY `Medical Condition`
ORDER BY total_admissions DESC;

-- INTERPRETATION:
-- Admissions were distributed fairly evenly across the six medical conditions.
-- Arthritis had the highest number of admissions with 9,308 records.
-- Obesity had the highest average billing amount at approximately $25,806.

-- 4. Gender admission and billing comparison
SELECT
  Gender,
  COUNT(*) AS total_admissions,
  ROUND(AVG(`Billing Amount`), 2) AS average_billing,
  ROUND(MIN(`Billing Amount`), 2) AS lowest_billing,
  ROUND(MAX(`Billing Amount`), 2) AS highest_billing
FROM `intro-to-bq-484420.healthcare.health`
GROUP BY Gender
ORDER BY total_admissions DESC;
-- INTERPRETATION:
-- Admissions were almost evenly distributed between male and female patients.
-- Male patients had a slightly higher average billing amount ($25,607.86)
-- compared with female patients ($25,470.65).
-- Negative minimum billing values may indicate adjustments, refunds, or data-quality issues.

-- 5. Test results distribution
SELECT
  `Test Results`,
  COUNT(*) AS total_results,
  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
    2
  ) AS result_percentage
FROM `intro-to-bq-484420.healthcare.health`
GROUP BY `Test Results`
ORDER BY total_results DESC;
-- INTERPRETATION:
-- Test results were almost evenly distributed across the three categories.
-- Abnormal results were slightly the most common at 33.56%,
-- followed by Normal at 33.36% and Inconclusive at 33.07%.

-- 6. Admission type and billing analysis
SELECT
  `Admission Type`,
  COUNT(*) AS total_admissions,
  ROUND(AVG(`Billing Amount`), 2) AS average_billing,
  ROUND(SUM(`Billing Amount`), 2) AS total_billing
FROM `intro-to-bq-484420.healthcare.health`
GROUP BY `Admission Type`
ORDER BY total_admissions DESC;
-- INTERPRETATION:
-- Admission volume was relatively balanced across elective, urgent, and emergency admissions.
-- Elective admissions were the most frequent with 18,655 admissions
-- and had the highest average billing amount at approximately $25,602.

-- 7. Age-group admission analysis
SELECT
  CASE
    WHEN Age < 18 THEN 'Under 18'
    WHEN Age BETWEEN 18 AND 35 THEN '18-35'
    WHEN Age BETWEEN 36 AND 50 THEN '36-50'
    WHEN Age BETWEEN 51 AND 65 THEN '51-65'
    ELSE '66+'
  END AS age_group,

  COUNT(*) AS total_admissions,

  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
    2
  ) AS admission_percentage,

  ROUND(AVG(`Billing Amount`), 2) AS average_billing

FROM `intro-to-bq-484420.healthcare.health`
GROUP BY age_group
ORDER BY total_admissions DESC;
-- INTERPRETATION:
-- Patients aged 66+ represented the largest share of admissions at 29.28%.
-- Patients aged 18-35 represented 25.97% of admissions.
-- Patients under 18 accounted for only 0.21%, showing that the dataset is primarily adult-focused.

-- 8. Top five hospitals by number of admissions
SELECT
  Hospital,
  COUNT(*) AS total_admissions,
  ROUND(AVG(`Billing Amount`), 2) AS average_billing
FROM `intro-to-bq-484420.healthcare.health`
GROUP BY Hospital
ORDER BY total_admissions DESC
LIMIT 5;
-- INTERPRETATION:
-- LLC Smith had the highest number of admissions among individual hospitals with 44 admissions.
-- Admission counts were relatively low across individual hospitals,
-- suggesting that the dataset includes a large number of distinct hospital names.

-- 9. Most common medication for each medical condition
WITH medication_counts AS (
  SELECT
    `Medical Condition`,
    Medication,
    COUNT(*) AS prescription_count
  FROM `intro-to-bq-484420.healthcare.health`
  GROUP BY
    `Medical Condition`,
    Medication
),

ranked_medications AS (
  SELECT
    `Medical Condition`,
    Medication,
    prescription_count,

    DENSE_RANK() OVER (
      PARTITION BY `Medical Condition`
      ORDER BY prescription_count DESC
    ) AS medication_rank

  FROM medication_counts
)

SELECT
  `Medical Condition`,
  Medication,
  prescription_count
FROM ranked_medications
WHERE medication_rank = 1
ORDER BY `Medical Condition`;
-- INTERPRETATION:
-- The most frequently recorded medication varied across medical conditions.
-- Aspirin was most common for Arthritis, Paracetamol for Asthma,
-- Lipitor for Cancer and Diabetes, Ibuprofen for Hypertension,
-- and Penicillin for Obesity.
-- These results describe patterns in the dataset and should not be interpreted as treatment recommendations.

-- 10. Insurance provider payer mix and billing analysis
SELECT
  `Insurance Provider`,
  COUNT(*) AS total_admissions,

  ROUND(
    COUNT(*) * 100.0 / SUM(COUNT(*)) OVER (),
    2
  ) AS payer_percentage,

  ROUND(AVG(`Billing Amount`), 2) AS average_billing,
  ROUND(SUM(`Billing Amount`), 2) AS total_billing

FROM `intro-to-bq-484420.healthcare.health`
GROUP BY `Insurance Provider`
ORDER BY total_admissions DESC;
-- INTERPRETATION:
-- The payer mix was highly balanced across the five insurance providers.
-- Each provider represented approximately 20% of total admissions.
-- Cigna had the largest share at 20.27%, while Aetna had the smallest at 19.66%.

-- 11. Length of stay by medical condition
SELECT
  `Medical Condition`,
  COUNT(*) AS total_admissions,

  ROUND(
    AVG(
      DATE_DIFF(
        `Discharge Date`,
        `Date of Admission`,
        DAY
      )
    ),
    1
  ) AS average_length_of_stay,

  ROUND(AVG(`Billing Amount`), 2) AS average_billing

FROM `intro-to-bq-484420.healthcare.health`
GROUP BY `Medical Condition`
ORDER BY average_length_of_stay DESC;
-- INTERPRETATION:
-- Average length of stay was very similar across all medical conditions,
-- ranging from approximately 15.4 to 15.7 days.
-- Asthma had the longest average stay at 15.7 days,
-- while Diabetes had the shortest at 15.4 days.

-- 12. High-cost admissions above the overall average billing amount
SELECT
  Name,
  Age,
  Gender,
  `Medical Condition`,
  `Admission Type`,
  Hospital,
  `Insurance Provider`,
  `Billing Amount`

FROM `intro-to-bq-484420.healthcare.health`

WHERE `Billing Amount` > (
  SELECT AVG(`Billing Amount`)
  FROM `intro-to-bq-484420.healthcare.health`
)

ORDER BY `Billing Amount` DESC;
-- INTERPRETATION:
-- This query identified admissions with billing amounts above the overall
-- average billing amount of approximately $25,539.
-- A subquery was used to calculate the overall average and filter
-- individual admissions above that benchmark.