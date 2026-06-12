WITH sales_margin AS (
    SELECT * FROM {{ ref('int_sales_margin') }}
),

order_aggregation AS (
    SELECT
        orders_id,
        MAX(date_date) AS date_date, -- Her sipariş için tarihi tekilleştiriyoruz
        ROUND(SUM(revenue), 2) AS revenue,
        ROUND(SUM(quantity), 2) AS quantity,
        ROUND(SUM(purchase_cost), 2) AS purchase_cost,
        ROUND(SUM(margin), 2) AS margin
    FROM sales_margin
    GROUP BY orders_id
)

SELECT * FROM order_aggregation
ORDER BY orders_id DESC