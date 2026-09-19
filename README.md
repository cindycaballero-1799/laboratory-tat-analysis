# Clinical Laboratory Turnaround Time (TAT) Analysis

## Problem Statement

Laboratory test results experienced delayed turnaround time from January to July 2026, with an average monthly delay rate of **19.06%**, consistently exceeding the laboratory target of <10% per month.

## Data

This project uses a synthetic clinical laboratory dataset created for data analytics portfolio purposes, covering January to July 2026

- **4,416 laboratory test records** containing test date, laboratory section, test name, priority, turnaround time, repeat testing, staff on duty, equipment status, and TAT status.
- **272 staff survey responses** containing workload, staffing adequacy, equipment reliability, repeat testing manageability, workflow efficiency, overall satisfaction, and overtime information.
- **Shift reference data** defining AM and PM laboratory shifts and their standard staffing levels.

## Methodology

- **Excel** – Cleaned and prepared the raw laboratory, staff survey, and shift reference data for analysis.
- **SQL** – Analyzed monthly TAT performance and examined associations with repeat testing, equipment status, priority, laboratory section, and staffing indicators.
- **Power BI** – Built the data model, created DAX measures, and developed an interactive dashboard to visualize TAT performance and operational factors.

![Clinical Laboratory TAT Dashboard](laboratory_tat_dashboard.png)

## Insights

## Insights

- The laboratory recorded an **overall TAT delay rate of 19.34%**, with **854 delayed tests out of 4,416 total tests**. Every month exceeded the laboratory target of **<10%**.
- **January had the highest monthly delay rate at 21.91%**, while **June had the lowest at 16.43%**.

<p align="center">
  <img src="monthly_tat_delay_rate.png" width="700">
</p>

- Tests with **repeat testing** had a much higher delay rate (**55.11%**) than tests without repeat testing (**15.08%**).

<p align="center">
  <img src="tat_delay_rate_by_repeat_testing.png" width="500">
</p>

- Tests performed while equipment was **under maintenance (39.23%)** or **not operational (36.23%)** had higher delay rates than tests performed with **operational equipment (13.12%)**.

<p align="center">
  <img src="tat_delay_rate_by_equipment_status.png" width="500">
</p>

- Staffing levels were **below the standard for both AM and PM shifts** throughout the study period. The staffing gap was greater during the AM shift.

<p align="center">
  <img src="average_staff_on_duty.png" width="650">
</p>

- Staff survey indicators varied across the seven-month period, but their relationship with TAT delays was not consistent, suggesting that **other factors may also contribute to delays**.

<p align="center">
  <img src="monthly_staff_survey_factors.png" width="600">
</p>

## Recommendations

- **Review staffing levels against the established shift standards**

- **Investigate and reduce avoidable repeat testing**

- **Strengthen preventive maintenance and equipment downtime management**
