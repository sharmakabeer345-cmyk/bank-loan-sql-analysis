# Bank Loan Analysis (PostgreSQL)

SQL analysis of **38,576 bank loan applications from 2021**. The queries measure loan volume, funding, repayments, interest rate and DTI, separate good loans from bad loans, track monthly growth, and break results down by state, term, employment length, purpose and home ownership.

## Business questions answered

* How many loans were applied for, funded and repaid, and how did December compare with November?
* What share of loans are good (Fully Paid or Current) and what share are bad (Charged Off)?
* How much money was lost on bad loans?
* How did applications, funding and repayments change month by month?
* Which states, terms, employment lengths, purposes and home ownership types drive the most lending?

## Tools

* PostgreSQL
* pgAdmin 4
* Dataset in CSV format: 38,576 rows and 24 columns (loan details, borrower details, loan status, dates and amounts)

## Key metrics

|KPI|Total|MTD (Dec 2021)|PMTD (Nov 2021)|MoM change|
|-|-|-|-|-|
|Loan applications|38,576|4,314|4,035|+6.9%|
|Funded amount|$435,757,075|$53,981,425|$47,754,825|+13.0%|
|Amount received|$473,070,933|$58,074,380|$50,132,030|+15.8%|
|Avg interest rate|12.05%|12.36%|11.94%|+0.42 pts|
|Avg DTI|13.33%|13.67%|13.30%|+0.37 pts|

## Good loans vs bad loans

|Category|Share of loans|Applications|Funded amount|Amount received|
|-|-|-|-|-|
|Good (Fully Paid + Current)|86.18%|33,243|$370,224,850|$435,786,170|
|Bad (Charged Off)|13.82%|5,333|$65,532,225|$37,284,763|



## Key insights

* **Strong growth.** Monthly applications rose from 2,332 in January to 4,314 in December (+85%), with only a small dip in February.
* **Repayments exceed funding overall.** $473.1M was received against $435.8M funded, a net $37.3M more than was lent out.
* **Bad loans are costly.** Charged Off loans were funded with $65.5M but only $37.3M came back (about 57%), a shortfall of roughly $28.2M.
* **Risk shows in pricing.** Charged Off loans average a 13.88% interest rate against 11.64% for Fully Paid loans.
* **Debt consolidation dominates.** It accounts for 18,214 applications (47.2%) and $232.5M, or 53.4% of the total funded amount.
* **Term.** 36-month loans make up 73.2% of applications, but 60-month loans are larger on average (about $15.7K vs $9.7K) and hold 37.3% of the funded amount.
* **Geography.** California leads with 6,894 applications and $78.5M funded, followed by New York (3,701) and Florida (2,773).
* **Borrowers.** Renters (18,439) and mortgage holders (17,198) account for over 92% of applications. Borrowers with 10+ years of employment apply most (8,870).

## Author

**KABEER SHARMA**
MBA (Finance \& Business Analatics)
LinkedIn: www.linkedin.com/in/kabeer-sharma-7b3813340

