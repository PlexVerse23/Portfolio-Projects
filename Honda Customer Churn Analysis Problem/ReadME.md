# Honda 2-Wheeler Sales & Churn Risk Analytics Dashboard

![Home](Dash_snaps/home.png)

## Project Overview
This project presents an **end-to-end business analytics solution** built to monitor **Honda 2-wheeler sales performance, profitability, and customer churn risk patterns** using **Power BI, DAX, MySQL, and n8n automation**.

The solution combines:
- **Automated data ingestion**
- **Database integration**
- **Data modeling**
- **Interactive dashboarding**
- **Proxy churn risk analysis**

The primary objective was to transform raw transactional sales records into a **live, decision-support dashboard** that helps evaluate:

- Sales and profitability trends
- Product and regional performance
- Customer satisfaction indicators
- Retention and churn-risk behavior
- Dealer-level service and performance issues

---

## Business Problem
Honda’s retail sales data contains valuable information related to:
- customer transactions,
- pricing behavior,
- dealer operations,
- customer satisfaction,
- and financing patterns.

However, raw sales data alone does not directly provide business insights.

This project was designed to answer key business questions such as:

- Which bike models are driving the highest sales and profit?
- Which regions and payment modes contribute most to revenue?
- Which customer segments show higher churn risk?
- How do customer ratings and delivery delays affect retention risk?
- Which dealers may require intervention based on service and risk patterns?

---

## Project Objectives
The key objectives of this project were:

- Build a **live reporting pipeline** for sales data updates
- Create a centralized analytical model for dashboard reporting
- Track **sales, cost, and profitability KPIs**
- Simulate **customer churn risk analysis** using proxy variables
- Segment customers based on **behavioral and service-related factors**
- Deliver a visually intuitive dashboard for business decision-making

---

## Tech Stack
- **Power BI** – Dashboard development and data modeling
- **DAX** – Calculated columns, KPIs, and churn logic
- **MySQL** – Online database storage
- **n8n** – Workflow automation for live data ingestion
- **CSV / Excel** – Source data files

---

## Dataset Information
The dataset consists of **Honda 2-wheeler sales transaction records** and includes fields such as:

- Order ID
- Order Date
- Year / Month / Quarter
- State / City
- Dealer Name
- Sales Channel
- Bike Model / Segment / Engine CC / Color
- Customer Age / Gender
- Payment Mode
- On-Road Price / Discount / Finance Amount
- Insurance / Accessories / Exchange Bonus
- Net Sales / Cost Price / Gross Profit
- Delivery Days
- Customer Rating

> **Note:** The dataset did not include a unique `Customer_ID`, so direct repeat purchase tracking was not possible.  
> To address this, a **proxy churn risk framework** was developed using customer satisfaction, delivery performance, discount dependency, and financing behavior.

---

# Workflow

## 1) Automated Data Pipeline
An **n8n automation workflow** was built to keep the reporting system live and reduce manual data handling.

### Workflow Steps:
- Read incoming emails
- Filter emails based on subject line
- Extract attached CSV files
- Transform date formats to match MySQL schema
- Insert cleaned records into an **online MySQL database**
- Enable Power BI dashboard refresh using the updated database

### Business Value:
- Reduced manual file handling
- Maintained consistent data formatting
- Supported near-live reporting workflow

---

## 2) Data Modeling in Power BI
After loading the data into Power BI, the dataset was modeled to support time-based and business-level analysis.

### Key modeling steps:
- Built a **Calendar Dimension Table**
- Linked transactional data with date hierarchy
- Prepared fields for trend analysis and filtering
- Created custom sorting columns for:
  - Month order
  - Age group order
  - Category display order

---

## 3) Feature Engineering using DAX
To support customer segmentation and churn-risk analysis, several **derived columns and business logic fields** were created.

### Calculated / Categorized Fields:
- **Age Group**
- **Delivery Delay Band**
- **Customer Rating Band**
- **Discount Band**
- **Finance Band**
- **Churn Risk Score**
- **Churn Risk Category**
  - High Risk
  - Medium Risk
  - Low Risk
- **Retention Category**
  - Highly Retained
  - Moderately Retained
  - Retention Risk

### Churn Risk Logic
Since actual customer repetition data was unavailable, churn behavior was approximated using a **proxy risk framework** based on:

- Lower customer ratings
- Longer delivery delays
- Higher discount dependency
- Financing behavior
- Customer engagement indicators

This made it possible to build a **customer retention intelligence layer** despite the absence of direct customer lifecycle data.

---

# Dashboard Pages

## Page 1 – Sales Overview Dashboard
This page provides an executive summary of Honda 2-wheeler sales performance.

### KPIs Included:
- **Gross Profit**
- **Net Sales**
- **Total Cost Price**
- **Total Orders**
- **Average Customer Rating**
- **Bike Segment**
- **Insurance Amount**

### Visualizations Included:
- **Donut Charts**
  - Net Sales by Payment Mode
  - State-wise Share of Sales
- **Line Charts**
  - Month-wise Gross Profit Trend
  - Month-wise Net Sales Trend
  - Month-wise Cost Price Trend
- **Model Display**
  - Dynamic bike image based on selected model
- **Interactive Navigation**
  - Page navigator for dashboard flow

### Filters / Slicers:
- Bike Model

---

## Page 2 – Customer Churn Risk Analysis
This page focuses on identifying **high-risk customer segments** and analyzing factors contributing to churn propensity.

### KPIs Included:
- **Total Customers**
- **Average Churn Risk Score**
- **High Risk Customers**
- **Churn Risk Percentage**
- **Average Customer Rating**

### Visualizations Included:
- **Bar Chart**
  - High Risk Customers by Bike Model
- **Donut Chart**
  - Customer Distribution by Risk Category
- **Stacked Column Chart**
  - High Risk Customers by Age Group and Gender
- **Line and Clustered Column Chart**
  - High Risk Customers by Dealer
  - Average Delivery Days by Dealer
- **Scatter Plot**
  - Average Delivery Days vs Average Customer Rating
  - Bubble Size = High Risk Customer Count

### Filters / Slicers:
- Year
- Quarter
- State

---

# Key Metrics / KPIs Used

## Sales Metrics
- Net Sales
- Gross Profit
- Total Cost Price
- Total Orders

## Customer Metrics
- Average Customer Rating
- High Risk Customer Count
- Churn Risk %
- Average Churn Risk Score

## Operational Metrics
- Delivery Delay
- Insurance Amount
- Finance Amount
- Discount Behavior

---

# Key DAX / Analytical Logic

## Examples of business logic implemented:
- Time intelligence using Calendar table
- Customer segmentation by age and satisfaction
- Delay and discount categorization
- Churn risk scoring using weighted conditional logic
- Retention classification based on churn score

> You may optionally include sample DAX formulas in a separate section or `/docs` folder if sharing implementation details publicly.

---

# Challenges Faced

## 1) Lack of Customer ID
The biggest challenge in this project was the absence of a **unique customer identifier**, which made it impossible to directly measure:
- repeat purchases,
- exact customer churn,
- customer lifetime behavior.

### Solution:
A **proxy churn risk framework** was developed using:
- delivery performance,
- customer ratings,
- discount dependence,
- financing patterns,
- and customer segmentation behavior.

This allowed meaningful **retention risk analysis** despite incomplete customer lifecycle data.

---

## 2) Raw Date Formatting for Database Ingestion
Incoming CSV files contained date formats that were not directly compatible with the MySQL schema.

### Solution:
A transformation step was added in the **n8n workflow** to standardize dates before insertion into the database.

---

## 3) Maintaining Dashboard Readiness
The data needed to remain reporting-ready without repeated manual cleaning.

### Solution:
An automated ETL-style process was created using:
- email filtering,
- CSV extraction,
- transformation,
- and direct database loading.

---

# Key Insights
> Replace the placeholders below with your actual findings from the dashboard.

## Sales & Profitability Insights
- **[Insight Placeholder 1]**
- **[Insight Placeholder 2]**
- **[Insight Placeholder 3]**

## Customer & Churn Risk Insights
- **[Insight Placeholder 4]**
- **[Insight Placeholder 5]**
- **[Insight Placeholder 6]**

## Dealer / Operational Insights
- **[Insight Placeholder 7]**
- **[Insight Placeholder 8]**
- **[Insight Placeholder 9]**

---

# Business Recommendations
> Replace or edit these based on your actual analysis.

- **[Recommendation Placeholder 1]**
- **[Recommendation Placeholder 2]**
- **[Recommendation Placeholder 3]**
- **[Recommendation Placeholder 4]**

---

# Outcome
This project demonstrates how **business intelligence, automation, and proxy analytical modeling** can be combined to create a **real-world portfolio project** with strong business relevance.

It showcases the ability to:
- automate reporting workflows,
- model business-ready datasets,
- engineer analytical features,
- and build decision-support dashboards for business use cases.

---

# Dashboard Preview
> Add screenshots here

## Sales Overview
![Sales Overview](path/to/overview-image.png)

## Churn Risk Analysis
![Churn Analysis](path/to/churn-image.png)

---

# Folder Structure
```bash
Honda-2Wheeler-Sales-Churn-Analytics/
│
├── README.md
├── Dashboard/
│   └── Honda_Sales_Churn_Dashboard.pbix
│
├── SQL/
│   └── schema.sql
│
├── Data/
│   └── sample_data.csv
│
├── Images/
│   ├── overview-dashboard.png
│   └── churn-dashboard.png
│
└── Automation/
    └── n8n_workflow.json
```

---

# Author
**Your Name**  
[LinkedIn](your-linkedin-url) | [GitHub](your-github-url)
