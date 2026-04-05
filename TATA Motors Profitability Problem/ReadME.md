# Tata Motors Portfolio Profitability Analysis

<p align="center">
  <img src="assets/homepage.png" alt="Tata Motors Dashboard" width="100%" />
</p>

---

## Project Overview

This project presents a **Business Analytics case study for Tata Motors**, focused on identifying **vehicle models that contribute significantly to revenue but underperform in profitability**.  

Rather than limiting the analysis to descriptive sales reporting, this project approaches the automobile industry from a **business decision-making lens** — helping answer which models should be **scaled, optimized, repositioned, or reviewed** based on their financial and commercial performance.

The project combines **Excel, SQL, and Power BI** to move from raw data to a structured, insight-driven dashboard that supports **portfolio evaluation and strategic decision-making**.

> Power BI File: [`Tata_Motors_Analysis.pbix`](#)  
> SQL Script: [`tata_motors_analysis.sql`](#)

---

## Business Problem

Tata Motors offers a diverse vehicle portfolio across multiple markets and customer segments. However, **strong sales volume or revenue does not always translate into strong profitability**.  

Some vehicle models may appear commercially successful on the surface while actually underperforming due to factors such as:

- weak profit realization
- inefficient pricing
- high cost burden
- discount dependency
- poor product positioning

This project was built to answer a core business question:

> **Which Tata Motors vehicle models are underperforming in profitability despite contributing to revenue?**

---

## Key Business Questions

This analysis was designed to answer the following business questions:

- Which Tata Motors models generate the highest **units sold**, **revenue**, and **profit**?
- Which models are **high-revenue but low-profit**, and can therefore be considered underperformers?
- How does model performance vary across **years** and **countries**?
- Which models contribute significantly to revenue but fail to deliver strong returns?
- What product or customer behavior patterns are associated with underperforming models?
- Which models should Tata Motors **scale, optimize, reposition, or review**?

---

## Dataset Overview

The project was built using three structured datasets:

### 1) `car_finance`
Primary financial and business performance dataset used for:
- units sold
- revenue
- profit
- margins
- pricing ranges
- cost components

### 2) `car_sales`
Commercial and customer behavior dataset used for:
- discounts
- average sale price
- customer ratings
- feedback
- first-time buyer indicators
- loyalty behavior

### 3) `car_specs`
Product and specification dataset used for:
- car type
- fuel type
- horsepower
- torque
- safety rating
- price positioning
- feature analysis

These datasets were used together to create a **multi-layered business view** of Tata Motors’ vehicle portfolio.

---

## Project Workflow

This project was executed in three main stages:

---

### 1) Data Cleaning & Inspection (Excel)

The raw datasets were first inspected and lightly cleaned in Excel to ensure consistency before analysis.

#### Tasks performed:
- Checked for missing values and duplicate records
- Validated key identifiers such as `model_id`
- Reviewed column consistency and formatting
- Removed unnecessary fields for focused analysis
- Prepared clean sheets for SQL import

Excel was used primarily for **inspection and pre-processing**, while all major transformations were performed in SQL.

---

### 2) Data Transformation & Analysis (SQL)

SQL was used as the **core analytical engine** of the project.

#### Key work completed in SQL:
- Filtered and structured the data into **analysis-ready views**
- Created transformed and calculated columns such as:
  - estimated model price
  - profit per unit
  - profitability ratios
  - model performance categories
- Built **clean analytical views** for:
  - overall financial performance
  - customer behavior analysis
  - underperforming vehicle identification
- Performed exploratory and business-focused analysis to identify:
  - top-performing models
  - underperforming models
  - yearly and country-level trends
  - financial inefficiencies

A **quartile-based model classification approach** was used to segment models into meaningful performance groups.

---

### 3) Dashboarding & Visualization (Power BI)

Power BI was used to convert the SQL outputs into an interactive dashboard for **business storytelling and decision support**.

The dashboard was designed to help stakeholders quickly answer:

- Which Tata Motors models are underperforming?
- Where is underperformance most concentrated?
- What product and customer factors may explain it?

---

## Dashboard Walkthrough

This dashboard is structured into **three business-focused pages**, each designed to support a different layer of analysis.

---

### 📊 1. Executive Overview
![Executive Overview](assets/overview.png)

Provides a high-level view of Tata Motors’ vehicle portfolio performance.

#### Includes:
- Total Revenue
- Total Profit
- Total Units Sold
- Average Profit Margin
- Number of Underperforming Models

#### Visuals:
- Revenue by Model
- Profit by Model
- Units Sold by Model
- Revenue vs Profit comparison
- Model category breakdown

---

### 🚨 2. Underperformer Analysis
![Underperformer Analysis](assets/underperformer.png)

Focused specifically on identifying models that generate strong revenue but weak financial returns.

#### Includes:
- Top underperforming vehicle models
- Revenue and profit contribution of underperformers
- Underperformers by Year
- Underperformers by Country

#### Visuals:
- Revenue vs Profit comparison for flagged models
- Underperformer trend analysis
- Country-wise underperformer concentration
- Flagged model summary table

---

### 👥 3. Customer & Product Diagnosis
![Customer & Product Analysis](assets/specs_customer.png)

Explores the potential drivers behind underperformance by combining customer behavior and product characteristics.

#### Includes:
- Discount patterns
- Customer ratings and feedback
- Loyalty and first-time buyer trends
- Product positioning insights

#### Visuals:
- Underperformers by Fuel Type
- Underperformers by Car Type
- Safety Rating vs Performance
- Price Band vs Profitability
- Discount vs Profitability

---

## Key Insights

Some of the most important insights from the project include:

- Certain Tata Motors models contributed significantly to **revenue** but failed to generate proportionate **profit**, indicating portfolio inefficiency.
- Underperforming models were not necessarily low-selling products — some had strong commercial presence but weak profitability.
- Year-wise and country-wise patterns helped identify where underperformance was more concentrated.
- Product-level characteristics such as **car type, fuel type, pricing, and positioning** helped explain differences in financial performance.
- Customer-side indicators such as **discount levels, ratings, and feedback** provided additional clues into why some models underperformed.

---

## Business Recommendations

Based on the analysis, the following actions are recommended for Tata Motors:

### 1) Scale High-Performing Models
Increase strategic focus on models that demonstrate strong performance across:
- revenue
- profit
- profitability efficiency

### 2) Optimize Underperforming Revenue Drivers
For high-revenue but low-profit models:
- review pricing strategy
- reduce unnecessary discounting
- improve cost efficiency
- optimize variant mix

### 3) Reposition Weakly Performing Products
For models with reasonable product strength but weaker business performance:
- improve market targeting
- refine customer positioning
- strengthen promotional strategy

### 4) Review Low-Impact Models
For models that are weak across both scale and return:
- reassess their role in the portfolio
- evaluate redesign or rationalization

---

## Tools Used

- **Excel** → Initial inspection and cleaning  
- **MySQL** → Data cleaning, transformation, business analysis, analytical views  
- **Power BI** → Dashboarding, storytelling, and business reporting  

---

## Final Thoughts

This project demonstrates how business analytics can go beyond simple dashboarding to support **real portfolio-level decisions** in the automobile industry.

By combining **financial performance, customer behavior, and product characteristics**, the project delivers a more complete answer to an important business question:

> **Which Tata Motors models look successful on the surface but underperform where it matters most — profitability?**

This project reflects an end-to-end analytics workflow covering:

- **Business Problem Framing**
- **Data Cleaning & Structuring**
- **SQL-Based Analysis**
- **Interactive Dashboarding**
- **Insight Generation & Recommendation Building**

---

## Author

**[Your Name]**  
Business Analytics | SQL | Power BI | Excel | Data Storytelling
