# Portfolio Project: A/B Testing Analysis

This project focuses on analyzing A/B test results to evaluate the performance of different variants using statistical significance tests (Z-test). It includes data preparation, conversion rate calculation, and visualization of results.

## Project Overview
**Objective**: Analyze A/B test data to determine which test group has a statistically significant difference in conversion rates.

**Key Metrics**: 
- add_payment_info
- add_shipping_info
- begin_checkout
- new_accounts

## Tools Used:
- **Python** (Pandas, NumPy, Statsmodels)
- **SQL** (BigQuery)
- **Tableau** (for visualization)

## Files in the Repository:
- `ab_test_analysis.ipynb`: Google Colab notebook containing the complete analysis, including Z-tests and statistical significance evaluation.
- **SQL Scripts**: SQL queries used to aggregate data from the BigQuery database.
- **Tableau Dashboard**: Interactive visualizations for the analysis results. [Click here to view the dashboard on Tableau Public](https://public.tableau.com/app/profile/alex.vorotilin/viz/PortfolioProject2ABTesting/Signaficance).

## Data Source:
The A/B test data was sourced from an internal database (BigQuery) and includes user events, conversions, and test group data.
