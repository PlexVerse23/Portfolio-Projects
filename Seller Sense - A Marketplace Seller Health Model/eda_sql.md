## 📊 Exploratory Data Analysis (EDA)

```sql
-- =====================================================
-- 1. Date Range
-- =====================================================
SELECT
    MIN(order_purchase_timestamp) AS min_date,
    MAX(order_purchase_timestamp) AS max_date
FROM orders;


-- =====================================================
-- 2. Order Status Distribution
-- =====================================================
SELECT
    order_status,
    COUNT(*) AS total_orders
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;


-- =====================================================
-- 3. Total Sellers
-- =====================================================
SELECT COUNT(*) AS total_sellers
FROM sellers;


-- =====================================================
-- 4. Orders per Seller
-- =====================================================
SELECT
    MIN(total_orders_per_seller) AS min_orders,
    MAX(total_orders_per_seller) AS max_orders,
    ROUND(AVG(total_orders_per_seller), 1) AS avg_orders
FROM (
    SELECT
        seller_id,
        COUNT(DISTINCT order_id) AS total_orders_per_seller
    FROM order_items
    GROUP BY seller_id
) seller_orders;


-- =====================================================
-- 5. Orders with NULL Delivery Date
-- =====================================================
SELECT
    COUNT(*) AS null_delivery_dates
FROM orders
WHERE order_delivered_customer_date IS NULL;


-- =====================================================
-- 6. Orders Without Reviews
-- =====================================================
SELECT
    COUNT(*) AS orders_without_review
FROM orders o
LEFT JOIN order_reviews r
    ON o.order_id = r.order_id
WHERE r.review_score IS NULL;
```

---

## 🏗️ Seller Feature Engineering

```sql
WITH base AS (

    -- =================================================
    -- 1. Base Table
    -- =================================================
    SELECT
        oi.order_id,
        oi.product_id,
        s.seller_id,
        s.seller_state,
        oi.price,
        oi.freight_value,
        o.order_status,
        o.order_purchase_timestamp,

        CAST(strftime('%Y', o.order_purchase_timestamp) AS INTEGER) AS sale_year,
        CAST(strftime('%m', o.order_purchase_timestamp) AS INTEGER) AS sale_month,

        o.order_approved_at,
        o.order_delivered_customer_date,
        o.order_estimated_delivery_date,

        r.review_score,
        pt.product_category_name_english AS product_category

    FROM order_items oi
    JOIN orders o
        ON o.order_id = oi.order_id
    JOIN sellers s
        ON s.seller_id = oi.seller_id
    JOIN products p
        ON p.product_id = oi.product_id
    JOIN product_category_name_translation pt
        ON pt.product_category_name = p.product_category_name
    LEFT JOIN order_reviews r
        ON r.order_id = oi.order_id
),

-- =====================================================
-- 2. Monthly Seller Metrics
-- =====================================================
seller_monthly AS (

    SELECT
        seller_id,
        sale_year,
        sale_month,
        MAX(seller_state) AS seller_state,

        COUNT(DISTINCT order_id) AS total_orders,
        SUM(price + freight_value) AS total_revenue,

        ROUND(
            SUM(
                CASE
                    WHEN order_status = 'delivered'
                     AND order_delivered_customer_date IS NOT NULL
                     AND order_delivered_customer_date <= order_estimated_delivery_date
                    THEN 1.0
                    ELSE 0
                END
            )
            /
            NULLIF(
                SUM(
                    CASE
                        WHEN order_status = 'delivered'
                         AND order_delivered_customer_date IS NOT NULL
                        THEN 1.0
                        ELSE 0
                    END
                ),
                0
            ) * 100,
            2
        ) AS on_time_delivery_pct,

        ROUND(
            SUM(
                CASE
                    WHEN order_status IN ('canceled', 'unavailable')
                    THEN 1.0
                    ELSE 0
                END
            ) * 100 / COUNT(DISTINCT order_id),
            2
        ) AS cancellation_pct,

        ROUND(AVG(review_score), 2) AS avg_review_score,

        ROUND(
            SUM(
                CASE
                    WHEN review_score <= 2
                    THEN 1.0
                    ELSE 0
                END
            )
            /
            NULLIF(COUNT(DISTINCT order_id), 0) * 100,
            2
        ) AS pct_low_reviews,

        COUNT(DISTINCT product_category) AS category_count

    FROM base
    GROUP BY seller_id, sale_year, sale_month
),

-- =====================================================
-- 3. Seller Lifetime Orders
-- =====================================================
seller_lifetime AS (

    SELECT
        seller_id,
        SUM(total_orders) AS lifetime_orders
    FROM seller_monthly
    GROUP BY seller_id
),

-- =====================================================
-- 4. Filter Active Sellers
-- =====================================================
seller_monthly_filtered AS (

    SELECT sm.*
    FROM seller_monthly sm
    JOIN seller_lifetime st
        ON sm.seller_id = st.seller_id
    WHERE st.lifetime_orders >= 10
      AND sm.sale_year >= 2017
),

-- =====================================================
-- 5. Month-over-Month Comparative Metrics
-- =====================================================
seller_comparative AS (

    SELECT
        *,

        ROUND(
            COALESCE(
                avg_review_score -
                LAG(avg_review_score)
                    OVER (
                        PARTITION BY seller_id
                        ORDER BY sale_year, sale_month
                    ),
                0
            ),
            2
        ) AS review_score_change,

        COALESCE(
            total_orders -
            LAG(total_orders)
                OVER (
                    PARTITION BY seller_id
                    ORDER BY sale_year, sale_month
                ),
            0
        ) AS order_volume_change,

        ROUND(
            COALESCE(
                on_time_delivery_pct -
                LAG(on_time_delivery_pct)
                    OVER (
                        PARTITION BY seller_id
                        ORDER BY sale_year, sale_month
                    ),
                0
            ),
            2
        ) AS delivery_rate_change

    FROM seller_monthly_filtered
),

-- =====================================================
-- 6. Seller Profile
-- =====================================================
seller_profile AS (

    SELECT
        seller_id,

        MIN(
            sale_year || '-' || printf('%02d', sale_month)
        ) AS first_active_month,

        MAX(
            sale_year || '-' || printf('%02d', sale_month)
        ) AS last_active_month,

        COUNT(DISTINCT sale_year || '-' || sale_month)
            AS seller_vintage

    FROM seller_comparative
    GROUP BY seller_id
),

-- =====================================================
-- 7. Primary Product Category
-- =====================================================
seller_category_profile AS (

    SELECT
        seller_id,
        product_category AS primary_category

    FROM (

        SELECT *,
               ROW_NUMBER() OVER (
                   PARTITION BY seller_id
                   ORDER BY total_sold DESC
               ) AS rn

        FROM (

            SELECT
                seller_id,
                product_category,
                COUNT(*) AS total_sold
            FROM base
            GROUP BY seller_id, product_category

        ) category_sales

    ) ranked_categories

    WHERE rn = 1
),

-- =====================================================
-- 8. Final Seller Profile
-- =====================================================
final_seller_profile AS (

    SELECT
        sp.*,
        scp.primary_category
    FROM seller_profile sp
    JOIN seller_category_profile scp
        ON sp.seller_id = scp.seller_id
)
```