# 🧳 Booking Funnel Drop-off Analysis — Travel & Hospitality

## Project Overview

This project presents an **end-to-end business analytics solution** built to identify and reduce customer drop-off across the online booking funnel of a travel and hospitality platform.

The solution combines:
- **Exploratory data analysis and funnel mapping**
- **Root cause diagnosis by acquisition channel and device**
- **Statistical validation of findings**
- **Interactive dashboard for stakeholder reporting**
- **Pre vs Post intervention performance tracking**

---

## Business Problem

A travel and hospitality company was experiencing significant drop-off across their online booking platform. While the platform was attracting a healthy volume of users through multiple acquisition channels, a large proportion of users were abandoning the journey before completing their booking.

The business had no structured visibility into:
- **Where** in the booking journey users were dropping off
- **Which acquisition channels** were bringing low-intent traffic
- **Whether device experience** was contributing to abandonment
- **Whether interventions were actually working** or just producing noise

This project was designed to answer these questions systematically.

---

## Key Business Questions

- At which stage of the booking funnel are we losing the most users?
- Which acquisition channels are driving high volume but low conversion?
- Is the drop-off a traffic quality problem, a UX problem, or both?
- Did the product changes we made actually improve conversion — and can we prove it statistically?

---

## Project Objectives

- Map the complete booking funnel and establish baseline conversion metrics
- Identify the primary drop-off stage and quantify the business impact
- Diagnose root cause by breaking down drop-off across acquisition channels and device types
- Recommend targeted interventions based on findings
- Track and validate post-intervention performance using statistical testing

---

## Tech Stack

| Tool | Purpose |
|------|---------|
| **Python** | Data transformation, feature engineering, statistical testing |
| **MySQL** | Data storage, funnel queries, segmentation analysis |
| **Power BI** | Interactive dashboard, KPI reporting, before vs after visualization |
| **DAX** | Calculated measures, CVR metrics, lift calculations |

---

## The Booking Funnel

```
Stage 1          Stage 2       Stage 3          Stage 4           Stage 5        Converted
(Awareness)  →  (Browse)  →  (Property/Trip  →  (Booking      →  (Payment)  →  (Booked ✓)
                               Selection)         Details)
```

Users enter through various acquisition channels — Organic Search, Paid Ads, Referral, Social Media, and Email Campaigns — and are tracked across each stage until conversion or drop-off.

---

## Dataset Information

The dataset consists of **12,000 booking journey records** spanning 6 months (January 2024 – June 2024) and includes fields such as:

- User ID
- Entry Date & Month
- Acquisition Segment (Organic, Paid Search, Referral, Social, Email)
- Device Type (Mobile, Desktop, Tablet)
- Region
- Age Group
- Stage Progression Flags (Stage 1 through Stage 5)
- Conversion Status
- Exit Stage
- Period (Pre-Intervention: Jan–Mar / Post-Intervention: Apr–Jun)

> **Note:** An intervention was launched on April 1, 2024 based on findings from the pre-intervention analysis. Post-intervention data was used to validate whether the changes produced measurable improvement.

---

## Workflow

### 1) Data Transformation — Python

Raw data required feature engineering before analysis. The following columns were derived in Python:

- `exit_stage` — the last stage a user reached before dropping off
- `converted` — binary flag (1 = completed booking, 0 = dropped)
- `reached_stage2` through `reached_stage5` — binary progression flags per stage

This transformation was done manually to ensure full ownership of the logic before importing into MySQL for analysis.

---

### 2) Funnel Analysis — MySQL

Eight core SQL queries were written to systematically break down the funnel:

- Overall funnel volume and stage-to-stage conversion rates
- Drop-off count and percentage at each stage transition
- Conversion rate breakdown by acquisition segment
- Conversion rate breakdown by device type
- Segment × Device cross analysis
- Monthly conversion trend (pre-intervention period)
- Regional performance analysis
- Exit stage distribution (Pareto view of where users are lost)

---

### 3) Root Cause Analysis — MySQL

A dedicated set of queries focused specifically on the identified bottleneck stage (Stage 3 → Stage 4) to diagnose:

- Which acquisition segments bleed most at this transition
- Whether device type compounds the drop-off
- Which segment × device combinations are the worst performers

---

### 4) Statistical Validation — Python

To ensure findings were not the result of random variation in the data, two statistical tests were conducted:

#### Z-Test for Proportions
**Question:** Did the post-intervention conversion rate genuinely improve, or could the difference be explained by chance?

```python
from scipy.stats import norm
import numpy as np

pool = (pre_converted + post_converted) / (pre_total + post_total)
z = (post_cvr - pre_cvr) / np.sqrt(pool * (1 - pool) * (1/pre_total + 1/post_total))
p_value = 2 * (1 - norm.cdf(abs(z)))
```

**Result:** Z = 6.538 | P-value ≈ 0.000000
**Interpretation:** The improvement in conversion rate post-intervention was statistically significant — not random noise.

#### Chi-Square Test
**Question:** Is the drop-off at Stage 3→4 dependent on which acquisition channel the user came from?

```python
from scipy.stats import chi2_contingency

stage3_users = df[df['stage3_reached'] == 1]
contingency = pd.crosstab(stage3_users['segment'], stage3_users['stage4_reached'])
chi2, p_value, dof, expected = chi2_contingency(contingency)
```

**Result:** χ² = 14.511 | P-value = 0.0058 | Degrees of Freedom = 4
**Interpretation:** Acquisition channel significantly influences whether a user drops off at Stage 3→4 — confirming that the segment-level differences observed were real and actionable.

---

### 5) Dashboard — Power BI

A three-page interactive dashboard was built to communicate findings to stakeholders.

#### Page 1 — Funnel Overview
Executive summary of the booking funnel performance with full slicer control for period, segment, device, and region.

#### Page 2 — Root Cause Analysis
Segment and device level breakdown of drop-off at the critical stage, with heatmap and monthly trend visuals.

#### Page 3 — Before vs After
Pre vs Post intervention comparison across all KPIs, with monthly trend line marking the intervention date and incremental conversion calculation.

---

## Key Findings

### Primary Bottleneck
**Stage 3 → Stage 4** (Property Selection → Booking Details) was identified as the critical drop-off point — over **50% of users who reached Stage 3 did not proceed to Stage 4**. Every other stage transition was significantly healthier.

### Acquisition Channel Analysis
Normalizing by base users at Stage 3 revealed the true picture:

| Segment | Stage 3→4 Drop-off % |
|---------|----------------------|
| Paid Search | 63.36% |
| Social | 62.78% |
| Organic | 55.85% |
| Referral | 54.95% |
| Email | 53.88% |

> Raw counts were misleading — Organic appeared worst in absolute numbers but Paid Search and Social were significantly worse once normalized by segment size.

### Device Analysis
Tablet users showed disproportionately high drop-off **across all channels**, pointing to a UI/UX issue specific to tablet at Stage 3→4 — independent of user intent.

### Worst Performing Combination
**Paid Search + Tablet** — 69.77% drop-off rate at Stage 3→4.

### Best Performing Combination
**Referral + Desktop** — 50.67% drop-off rate at Stage 3→4, consistently the strongest segment throughout.

### Monthly Trend (Pre-Intervention)
Overall CVR declined from **7.81% in January to 6.98% in March**, with Paid Search dropping sharply from 6.02% to 3.96% — adding urgency to the need for intervention.

---

## Business Recommendations

**1. Reduce friction at Stage 3→4 (Booking Details step)**
This is the highest-priority fix. The jump from selecting a trip to filling booking details is where users hesitate. Recommended actions:
- Reduce the number of required fields at this step
- Enable progress saving so users can return without restarting
- Add trust signals — security badges, reviews, "X people booked this today"

**2. Fix the tablet UI at Stage 3→4**
Tablet drop-off is a device-specific problem, not a user intent problem. The booking details form likely has rendering or usability issues on tablet screens. This is a quick technical fix with measurable impact.

**3. Revisit Paid Search and Social targeting strategy**
These channels drive volume but attract low-intent users who exit when commitment is required. Recommended actions:
- Tighten audience targeting on paid campaigns to attract higher-intent travelers
- Add a soft commitment step before Stage 3→4 for Social traffic (e.g., wishlist or save trip)
- Set realistic CVR benchmarks per channel rather than applying a single platform-wide target

**4. Double down on Referral channel**
Referral users consistently convert at the highest rate across all stages and all devices. Investing in a referral incentive program would bring in more of the highest-quality traffic.

---

## Post-Intervention Results

The intervention launched on April 1, 2024 included: simplified booking details form, tablet UI fix, and trust signal additions at Stage 3.

| Metric | Pre-Intervention | Post-Intervention | Change |
|--------|-----------------|-------------------|--------|
| Overall CVR | 7.53% | 10.99% | **+3.46 ppt** |
| Stage 3→4 Drop-off | ~58% | ~45% | **−13 ppt** |
| Incremental Bookings | — | +204 | **+46% relative lift** |
| Statistical Significance | — | p < 0.001 | **✓ Confirmed** |

Every acquisition segment showed improvement post-intervention, confirming that the fixes addressed a structural funnel problem rather than a channel-specific one.

---

## Key DAX Measures

```DAX
Overall CVR % = DIVIDE([Total Conversions], [Total Users]) * 100

S3 to S4 Drop % = 100 - DIVIDE([Users at Stage 4], [Users at Stage 3]) * 100

Pre CVR % = 
CALCULATE([Overall CVR %], user_journey[period] = "Pre-Intervention")

Post CVR % = 
CALCULATE([Overall CVR %], user_journey[period] = "Post-Intervention")

CVR Lift ppt = [Post CVR %] - [Pre CVR %]

Incremental Conversions = 
VAR PostUsers = CALCULATE([Total Users], user_journey[period] = "Post-Intervention")
VAR PostConv  = CALCULATE([Total Conversions], user_journey[period] = "Post-Intervention")
VAR PreRate   = DIVIDE(
    CALCULATE([Total Conversions], user_journey[period] = "Pre-Intervention"),
    CALCULATE([Total Users], user_journey[period] = "Pre-Intervention"))
RETURN PostConv - ROUND(PostUsers * PreRate, 0)
```

---

## Project Outcome

This project demonstrates how a structured analytical approach — funnel mapping, segmentation, statistical validation, and stakeholder reporting — can convert raw transactional data into clear business decisions.

It showcases the ability to:
- Diagnose where and why a business is losing customers
- Separate signal from noise using statistical testing
- Translate data findings into prioritized, actionable recommendations
- Measure and validate the impact of business interventions

