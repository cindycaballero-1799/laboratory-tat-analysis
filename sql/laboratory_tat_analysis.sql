-- =====================================================
-- CLINICAL LABORATORY TURNAROUND TIME (TAT) ANALYSIS
-- January to July 2026
-- =====================================================

-- Project Objective:
-- Analyze monthly laboratory turnaround time performance 
-- and identify operational factors associated with 
-- delayed test results.

-- Problem Statement:
-- Laboratory test results experienced delayed turnaround 
-- time from January to July 2026, with an average monthly 
-- delay rate of 19.06%, consistently exceeding the 
-- laboratory target of <10% per month.

-- Data Sources:
-- 1. lab_data
-- 2. staff_survey
-- 3. shift_standard

-- Key Metrics:
-- Monthly TAT delay rate
-- Repeat testing rate
-- Equipment issue rate
-- STAT testing rate
-- Staff workload
-- Staffing adequacy
-- Equipment reliability
-- Workflow efficiency
-- Staff overtime


-- =====================================================
-- MONTHLY TAT PERFORMANCE
-- Purpose: Measure monthly test volume and TAT delays
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    COUNT(*) AS total_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean)

ORDER BY month;

-- Finding:
-- Monthly TAT delay rates ranged from 16.43% to 21.91%.
-- All seven months exceeded the laboratory target of <10%.
-- January had the highest delay rate at 21.91%, while
-- June had the lowest at 16.43%.


-- =====================================================
-- AVERAGE MONTHLY TAT DELAY RATE
-- Purpose: Calculate the average of the monthly TAT
-- =====================================================

WITH monthly_tat AS (
    SELECT
        strftime('%Y-%m', test_date_clean) AS month,

        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*) AS monthly_delay_rate

    FROM lab_data

    GROUP BY
        strftime('%Y-%m', test_date_clean)
)

SELECT
    ROUND(AVG(monthly_delay_rate), 2)
        AS average_monthly_delay_rate_percent

FROM monthly_tat;

-- Finding:
-- The average monthly TAT delay rate was 19.06%, 
-- which exceeded the laboratory target of <10%.


-- =====================================================
-- MONTHLY REPEAT TESTING VS TAT DELAY
-- Purpose: Evaluate the monthly TAT delay rate among 
-- tests that required repeat testing.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    COUNT(*) AS repeat_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_repeat_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_test_delay_rate_percent

FROM lab_data

WHERE "Repeat Testing" = 'Yes'

GROUP BY
    strftime('%Y-%m', test_date_clean)

ORDER BY month;

-- Finding:
-- Tests requiring repeat testing had consistently high 
-- monthly TAT delay rates, ranging from 45.65% to 61.19%.
-- April had the highest repeat-test delay rate at 61.19%,
-- while July had the lowest at 45.65%.
-- This indicates a strong association between repeat 
-- testing and delayed TAT.


-- =====================================================
-- MONTHLY EQUIPMENT STATUS VS TAT DELAY
-- Purpose: Compare monthly TAT delay rates according 
-- to equipment operational status.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    "Equipment Status",

    COUNT(*) AS total_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean),
    "Equipment Status"

ORDER BY
    month,
    delay_rate_percent DESC;

-- Finding:
-- Tests processed while equipment was under maintenance 
-- or not operational consistently showed higher monthly
-- TAT delay rates than tests processed with operational 
-- equipment. This indicates a strong association 
-- between equipment issues and delayed TAT.


-- =====================================================
-- MONTHLY PRIORITY VS TAT DELAY
-- Purpose: Compare monthly TAT delay rates between 
-- STAT and Routine laboratory tests.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    "Priority",

    COUNT(*) AS total_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean),
    "Priority"

ORDER BY
    month,
    delay_rate_percent DESC;

-- Finding:
-- STAT tests consistently showed higher monthly TAT 
-- delay rates than Routine tests throughout the study 
-- period. This indicates that STAT testing was associated 
-- with a greater proportion of TAT delays despite its 
-- priority status and shorter target turnaround time.


-- =====================================================
-- MONTHLY LABORATORY SECTION VS TAT DELAY
-- Purpose: Compare monthly TAT delay rates across 
-- different laboratory sections.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    "Laboratory Section",

    COUNT(*) AS total_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean),
    "Laboratory Section"

ORDER BY
    month,
    delay_rate_percent DESC;

-- Finding:
-- TAT delay rates varied across laboratory sections.
-- Blood Bank generally showed higher delay rates, while 
-- Clinical Microscopy generally showed lower delay rates.
-- The variation across sections suggests that TAT 
-- performance may be influenced by section-specific 
-- workload and operational requirements.


-- =====================================================
-- MONTHLY STAFF SURVEY OVERVIEW
-- Purpose: Summarize monthly staff survey ratings for 
-- workload, staffing, equipment, repeat testing, 
-- workflow efficiency, and overall satisfaction.
-- =====================================================

SELECT
    strftime('%Y-%m', survey_date_clean) AS month,

    COUNT(*) AS survey_responses,

    ROUND(AVG("Workload Rating (1-5)"), 2)
        AS avg_workload_rating,

    ROUND(AVG("Staffing Adequacy (1-5)"), 2)
        AS avg_staffing_adequacy,

    ROUND(AVG("Equipment Reliability (1-5)"), 2)
        AS avg_equipment_reliability,

    ROUND(AVG("Repeat Testing Manageability (1-5)"), 2)
        AS avg_repeat_testing_manageability,

    ROUND(AVG("Workflow Efficiency (1-5)"), 2)
        AS avg_workflow_efficiency,

    ROUND(AVG("Overall Satisfaction (1-5)"), 2)
        AS avg_overall_satisfaction

FROM staff_survey

GROUP BY
    strftime('%Y-%m', survey_date_clean)

ORDER BY month;

-- Finding:
-- Staff survey ratings varied across the study period.
-- January had the highest average workload rating at 4.05 
-- and the lowest staffing adequacy rating at 2.77.
-- These findings coincide with January having the 
-- highest monthly TAT delay rate at 21.91%.


-- =====================================================
-- MONTHLY STAFF OVERTIME RATE
-- Purpose: Measure the percentage of staff survey 
-- respondents who reported working overtime each month.
-- =====================================================

SELECT
    strftime('%Y-%m', survey_date_clean) AS month,

    COUNT(*) AS survey_responses,

    SUM(
        CASE
            WHEN "Worked Overtime" = 'Yes' THEN 1
            ELSE 0
        END
    ) AS worked_overtime,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Worked Overtime" = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS overtime_rate_percent

FROM staff_survey

GROUP BY
    strftime('%Y-%m', survey_date_clean)

ORDER BY month;

-- Finding:
-- Monthly overtime rates ranged from 40.00% to 61.90%.
-- July had the highest overtime rate at 61.90%, while 
-- March had the lowest at 40.00%. Overtime rates did 
-- not consistently follow the pattern of monthly TAT 
-- delays, suggesting that overtime alone does not 
-- explain the variation in TAT performance.


-- =====================================================
-- MONTHLY TAT VS STAFF SURVEY FACTORS
-- Purpose: Combine monthly TAT performance with staff 
-- survey indicators to examine possible associations 
-- between TAT delays and operational factors.
-- =====================================================

WITH monthly_tat AS (

    SELECT
        strftime('%Y-%m', test_date_clean) AS month,

        COUNT(*) AS total_tests,

        SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) AS delayed_tests,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN "TAT Status" = 'Delayed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS delay_rate_percent

    FROM lab_data

    GROUP BY
        strftime('%Y-%m', test_date_clean)
),

monthly_staff AS (

    SELECT
        strftime('%Y-%m', survey_date_clean) AS month,

        ROUND(
            AVG("Workload Rating (1-5)"),
            2
        ) AS avg_workload,

        ROUND(
            AVG("Staffing Adequacy (1-5)"),
            2
        ) AS avg_staffing_adequacy,

        ROUND(
            AVG("Equipment Reliability (1-5)"),
            2
        ) AS avg_equipment_reliability,

        ROUND(
            AVG("Workflow Efficiency (1-5)"),
            2
        ) AS avg_workflow_efficiency,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN "Worked Overtime" = 'Yes' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS overtime_rate_percent

    FROM staff_survey

    GROUP BY
        strftime('%Y-%m', survey_date_clean)
)

SELECT
    t.month,
    t.total_tests,
    t.delayed_tests,
    t.delay_rate_percent,

    s.avg_workload,
    s.avg_staffing_adequacy,
    s.avg_equipment_reliability,
    s.avg_workflow_efficiency,
    s.overtime_rate_percent

FROM monthly_tat t

LEFT JOIN monthly_staff s
    ON t.month = s.month

ORDER BY t.month;

-- Finding:
-- January had the highest monthly TAT delay rate at 21.91%, together with the highest 
-- average workload rating at 4.05 and the lowest staffing adequacy rating at 2.77. 
-- However, patterns varied across the remaining months, indicating that no 
-- single staff survey factor alone consistently explains TAT delays.


-- =====================================================
-- MONTHLY TAT AND STAFFING BY SHIFT
-- Purpose: Compare monthly TAT delay rates and average 
-- staff on duty between AM and PM shifts.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    "Shift",

    COUNT(*) AS total_tests,

    ROUND(
        AVG("Staff on Duty"),
        2
    ) AS avg_staff_on_duty,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean),
    "Shift"

ORDER BY
    month,
    "Shift";

-- Finding:
-- The AM shift generally had more staff on duty than the PM shift. 
-- However, TAT delay rates varied between shifts across months,
-- and the shift with more staff did not consistently have a lower delay rate.
-- This suggests that staff count alone does not fully explain differences in TAT performance.


-- =====================================================
-- MONTHLY TAT AND STAFF FACTORS BY SHIFT
-- Purpose: Combine monthly TAT performance and staffing 
-- data with staff survey factors for each shift.
-- =====================================================

WITH tat_staffing AS (

    SELECT
        strftime('%Y-%m', test_date_clean) AS month,
        "Shift" AS shift,

        COUNT(*) AS total_tests,

        ROUND(
            AVG("Staff on Duty"),
            2
        ) AS avg_staff_on_duty,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN "TAT Status" = 'Delayed' THEN 1
                    ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS delay_rate_percent

    FROM lab_data

    GROUP BY
        strftime('%Y-%m', test_date_clean),
        "Shift"
),

survey_shift AS (

    SELECT
        strftime('%Y-%m', survey_date_clean) AS month,
        "Shift" AS shift,

        ROUND(
            AVG("Workload Rating (1-5)"),
            2
        ) AS avg_workload,

        ROUND(
            AVG("Staffing Adequacy (1-5)"),
            2
        ) AS avg_staffing_adequacy,

        ROUND(
            AVG("Workflow Efficiency (1-5)"),
            2
        ) AS avg_workflow_efficiency

    FROM staff_survey

    GROUP BY
        strftime('%Y-%m', survey_date_clean),
        "Shift"
)

SELECT
    t.month,
    t.shift,
    t.total_tests,
    t.avg_staff_on_duty,
    t.delay_rate_percent,
    s.avg_workload,
    s.avg_staffing_adequacy,
    s.avg_workflow_efficiency

FROM tat_staffing t

LEFT JOIN survey_shift s
    ON t.month = s.month
    AND t.shift = s.shift

ORDER BY
    t.month,
    t.shift;

-- Finding:
-- TAT delay rates and staff survey indicators varied 
-- between AM and PM shifts across the study period.
-- Higher staffing levels did not consistently correspond 
-- to lower TAT delay rates. This suggests that TAT performance 
-- may be associated with multiple operational factors rather 
-- than staffing levels alone.

-- =====================================================
-- FINAL MONTHLY SUMMARY - LAB DATA
-- Purpose: Summarize the main monthly laboratory KPIs, 
-- including TAT delays, repeat testing, equipment issues, 
-- and STAT testing rates.
-- =====================================================

SELECT
    strftime('%Y-%m', test_date_clean) AS month,

    COUNT(*) AS total_tests,

    SUM(
        CASE
            WHEN "TAT Status" = 'Delayed' THEN 1
            ELSE 0
        END
    ) AS delayed_tests,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS delay_rate_percent,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Repeat Testing" = 'Yes' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS repeat_testing_rate_percent,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Equipment Status" IN
                    ('Not Operational', 'Under Maintenance')
                THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS equipment_issue_rate_percent,

    ROUND(
        100.0 * SUM(
            CASE
                WHEN "Priority" = 'STAT' THEN 1
                ELSE 0
            END
        ) / COUNT(*),
        2
    ) AS stat_test_rate_percent

FROM lab_data

GROUP BY
    strftime('%Y-%m', test_date_clean)

ORDER BY month;

-- Finding:
-- Monthly TAT delay rates remained above the <10% target
-- throughout the study period, ranging from 16.43% to 21.91%. 
-- Repeat testing, equipment issues, and STAT testing were 
-- present at varying rates across months, providing operational 
-- context for changes in monthly TAT performance.


-- =====================================================
-- FINAL CONSOLIDATED MONTHLY SUMMARY
-- LAB DATA + STAFF SURVEY
-- Purpose: Combine monthly laboratory TAT KPIs with 
-- staff survey indicators to create a consolidated 
-- dataset for final analysis and visualization.
-- =====================================================

WITH monthly_lab AS (

    SELECT
        strftime('%Y-%m', test_date_clean) AS month,

        COUNT(*) AS total_tests,

        SUM(
            CASE
                WHEN "TAT Status" = 'Delayed' THEN 1
                ELSE 0
            END
        ) AS delayed_tests,

        ROUND(
            100.0 * SUM(
                CASE WHEN "TAT Status" = 'Delayed'
                THEN 1 ELSE 0 END
            ) / COUNT(*),
            2
        ) AS delay_rate_percent,

        ROUND(
            100.0 * SUM(
                CASE WHEN "Repeat Testing" = 'Yes'
                THEN 1 ELSE 0 END
            ) / COUNT(*),
            2
        ) AS repeat_testing_rate_percent,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN "Equipment Status" IN
                        ('Not Operational', 'Under Maintenance')
                    THEN 1 ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS equipment_issue_rate_percent,

        ROUND(
            100.0 * SUM(
                CASE WHEN "Priority" = 'STAT'
                THEN 1 ELSE 0 END
            ) / COUNT(*),
            2
        ) AS stat_test_rate_percent

    FROM lab_data

    GROUP BY
        strftime('%Y-%m', test_date_clean)
),

monthly_staff AS (

    SELECT
        strftime('%Y-%m', survey_date_clean) AS month,

        ROUND(AVG("Workload Rating (1-5)"), 2)
            AS avg_workload,

        ROUND(AVG("Staffing Adequacy (1-5)"), 2)
            AS avg_staffing_adequacy,

        ROUND(AVG("Equipment Reliability (1-5)"), 2)
            AS avg_equipment_reliability,

        ROUND(AVG("Workflow Efficiency (1-5)"), 2)
            AS avg_workflow_efficiency,

        ROUND(
            100.0 * SUM(
                CASE
                    WHEN "Worked Overtime" = 'Yes'
                    THEN 1 ELSE 0
                END
            ) / COUNT(*),
            2
        ) AS overtime_rate_percent

    FROM staff_survey

    GROUP BY
        strftime('%Y-%m', survey_date_clean)
)

SELECT
    l.month,
    l.total_tests,
    l.delayed_tests,
    l.delay_rate_percent,
    l.repeat_testing_rate_percent,
    l.equipment_issue_rate_percent,
    l.stat_test_rate_percent,

    s.avg_workload,
    s.avg_staffing_adequacy,
    s.avg_equipment_reliability,
    s.avg_workflow_efficiency,
    s.overtime_rate_percent

FROM monthly_lab l

LEFT JOIN monthly_staff s
    ON l.month = s.month

ORDER BY l.month;

-- Finding:
-- The consolidated monthly results show that TAT delay
-- rates remained above the <10% target throughout the
-- study period. January had the highest delay rate at
-- 21.91%, while June had the lowest at 16.43%.
-- Operational and staff indicators varied across months,
-- suggesting that TAT performance is associated with
-- multiple factors rather than a single condition.

-- =====================================================
-- END OF ANALYSIS
-- =====================================================
