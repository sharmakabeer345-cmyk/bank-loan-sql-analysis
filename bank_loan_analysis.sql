/* =====================================================
   Project : Bank Loan Analysis
   Database: PostgreSQL
   Table   : Bank_Loan_File (loaded from CSV)
   Purpose : KPIs, good vs bad loans, monthly trend and
             grouped summaries
   Note    : MTD = December 2021, PMTD = November 2021
   ===================================================== */

-- ========== 0. SETUP ==========
CREATE TABLE Bank_Loan_File (
    id                    INT PRIMARY KEY,
    address_state         VARCHAR(2),
    application_type      VARCHAR(20),
    emp_length            VARCHAR(20),
    emp_title             VARCHAR(100),
    grade                 VARCHAR(2),
    home_ownership        VARCHAR(20),
    issue_date            DATE,
    last_credit_pull_date DATE,
    last_payment_date     DATE,
    loan_status           VARCHAR(20),
    next_payment_date     DATE,
    member_id             INT,
    purpose               VARCHAR(50),
    sub_grade             VARCHAR(5),
    term                  VARCHAR(20),
    verification_status   VARCHAR(20),
    annual_income         NUMERIC(12,2),
    dti                   NUMERIC(8,4),
    installment           NUMERIC(10,2),
    int_rate              NUMERIC(8,4),
    loan_amount           INT,
    total_acc             INT,
    total_payment         INT
);

-- Dates in the CSV are dd-mm-yyyy
SET datestyle = 'DMY';

-- Change the path to where your CSV is saved (or use \copy in psql)
COPY Bank_Loan_File
FROM 'D:/financial_loan.csv'
DELIMITER ','
CSV HEADER;

SELECT COUNT(*) FROM Bank_Loan_File;  -- expected: 38576


-- ========== 1. KPIs ==========

-- Total loan applications
SELECT COUNT(id) AS Total_Applications
FROM Bank_Loan_File;

-- MTD loan applications (December 2021)
SELECT COUNT(id) AS MTD_Total_Applications
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01';

-- PMTD loan applications (November 2021)
SELECT COUNT(id) AS PMTD_Total_Applications
FROM Bank_Loan_File
WHERE issue_date >= '2021-11-01'
  AND issue_date <  '2021-12-01';

-- Total funded amount
SELECT SUM(loan_amount) AS Total_Funded_Amount
FROM Bank_Loan_File;

-- MTD funded amount
SELECT SUM(loan_amount) AS MTD_Funded_Amount
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01';

-- PMTD funded amount
SELECT SUM(loan_amount) AS PMTD_Funded_Amount
FROM Bank_Loan_File
WHERE issue_date >= '2021-11-01'
  AND issue_date <  '2021-12-01';

-- Total amount received
SELECT SUM(total_payment) AS Total_Amount_Received
FROM Bank_Loan_File;

-- MTD amount received
SELECT SUM(total_payment) AS MTD_Amount_Received
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01';

-- PMTD amount received
SELECT SUM(total_payment) AS PMTD_Amount_Received
FROM Bank_Loan_File
WHERE issue_date >= '2021-11-01'
  AND issue_date <  '2021-12-01';

-- Average interest rate (stored as a fraction, so x 100)
SELECT ROUND(AVG(int_rate) * 100, 2) AS Avg_Int_Rate
FROM Bank_Loan_File;

-- MTD average interest rate
SELECT ROUND(AVG(int_rate) * 100, 2) AS MTD_Avg_Int_Rate
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01';

-- PMTD average interest rate
SELECT ROUND(AVG(int_rate) * 100, 2) AS PMTD_Avg_Int_Rate
FROM Bank_Loan_File
WHERE issue_date >= '2021-11-01'
  AND issue_date <  '2021-12-01';

-- Average DTI
SELECT ROUND(AVG(dti) * 100, 2) AS Avg_DTI
FROM Bank_Loan_File;

-- MTD average DTI
SELECT ROUND(AVG(dti) * 100, 2) AS MTD_Avg_DTI
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01';

-- PMTD average DTI
SELECT ROUND(AVG(dti) * 100, 2) AS PMTD_Avg_DTI
FROM Bank_Loan_File
WHERE issue_date >= '2021-11-01'
  AND issue_date <  '2021-12-01';


-- ========== 2. GOOD LOAN vs BAD LOAN ==========
-- Good loan = Fully Paid or Current | Bad loan = Charged Off

-- Good loan percentage
SELECT ROUND(
         COUNT(CASE WHEN loan_status IN ('Fully Paid', 'Current') THEN id END) * 100.0
         / COUNT(id), 4
       ) AS Good_Loan_Percentage
FROM Bank_Loan_File;

-- Good loan applications
SELECT COUNT(id) AS Good_Loan_Applications
FROM Bank_Loan_File
WHERE loan_status IN ('Fully Paid', 'Current');

-- Good loan funded amount
SELECT SUM(loan_amount) AS Good_Loan_Funded_Amount
FROM Bank_Loan_File
WHERE loan_status IN ('Fully Paid', 'Current');

-- Good loan amount received
SELECT SUM(total_payment) AS Good_Loan_Amount_Received
FROM Bank_Loan_File
WHERE loan_status IN ('Fully Paid', 'Current');

-- Bad loan percentage
SELECT ROUND(
         COUNT(CASE WHEN loan_status = 'Charged Off' THEN id END) * 100.0
         / COUNT(id), 4
       ) AS Bad_Loan_Percentage
FROM Bank_Loan_File;

-- Bad loan applications
SELECT COUNT(id) AS Bad_Loan_Applications
FROM Bank_Loan_File
WHERE loan_status = 'Charged Off';

-- Bad loan funded amount
SELECT SUM(loan_amount) AS Bad_Loan_Funded_Amount
FROM Bank_Loan_File
WHERE loan_status = 'Charged Off';

-- Bad loan amount received
SELECT SUM(total_payment) AS Bad_Loan_Amount_Received
FROM Bank_Loan_File
WHERE loan_status = 'Charged Off';


-- ========== 3. LOAN STATUS SUMMARY ==========

SELECT loan_status,
       COUNT(id)                     AS Loan_Count,
       SUM(total_payment)            AS Total_Amount_Received,
       SUM(loan_amount)              AS Total_Funded_Amount,
       ROUND(AVG(int_rate * 100), 4) AS Interest_Rate,
       ROUND(AVG(dti * 100), 4)      AS DTI
FROM Bank_Loan_File
GROUP BY loan_status;

-- Loan status for December 2021 (MTD)
SELECT loan_status,
       SUM(total_payment) AS MTD_Total_Amount_Received,
       SUM(loan_amount)   AS MTD_Total_Funded_Amount
FROM Bank_Loan_File
WHERE issue_date >= '2021-12-01'
  AND issue_date <  '2022-01-01'
GROUP BY loan_status;


-- ========== 4. MONTHLY TREND ==========

SELECT EXTRACT(MONTH FROM issue_date) AS Month_Number,
       TO_CHAR(issue_date, 'FMMonth') AS Month_Name,
       COUNT(id)                      AS Total_Loan_Applications,
       SUM(loan_amount)               AS Total_Funded_Amount,
       SUM(total_payment)             AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY EXTRACT(MONTH FROM issue_date),
         TO_CHAR(issue_date, 'FMMonth')
ORDER BY Month_Number;


-- ========== 5. SEGMENT ANALYSIS ==========

-- By state
SELECT address_state,
       COUNT(id)          AS Total_Loan_Applications,
       SUM(loan_amount)   AS Total_Funded_Amount,
       SUM(total_payment) AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY address_state
ORDER BY Total_Funded_Amount DESC;

-- By term
SELECT term,
       COUNT(id)          AS Total_Loan_Applications,
       SUM(loan_amount)   AS Total_Funded_Amount,
       SUM(total_payment) AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY term
ORDER BY term;

-- By employee length (sorted from < 1 year to 10+ years)
SELECT emp_length,
       COUNT(id)          AS Total_Loan_Applications,
       SUM(loan_amount)   AS Total_Funded_Amount,
       SUM(total_payment) AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY emp_length
ORDER BY CASE
           WHEN emp_length LIKE '<%' THEN 0
           ELSE REGEXP_REPLACE(emp_length, '[^0-9]', '', 'g')::INT
         END;

-- By purpose
SELECT purpose,
       COUNT(id)          AS Total_Loan_Applications,
       SUM(loan_amount)   AS Total_Funded_Amount,
       SUM(total_payment) AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY purpose
ORDER BY Total_Funded_Amount DESC;

-- By home ownership
SELECT home_ownership,
       COUNT(id)          AS Total_Loan_Applications,
       SUM(loan_amount)   AS Total_Funded_Amount,
       SUM(total_payment) AS Total_Received_Amount
FROM Bank_Loan_File
GROUP BY home_ownership
ORDER BY Total_Funded_Amount DESC;
