WITH orders_margin AS (
    SELECT * FROM {{ ref('int_orders_margin') }}
),

ship AS (
    SELECT * FROM {{ ref('stg_raw__ship') }}
),

operational_calculation AS (
    SELECT
        o.orders_id,
        o.date_date,
        -- Operasyonel Marj Formülü: marj + shipping_fee - log_cost - ship_cost
        ROUND(o.margin + s.shipping_fee - (s.log_cost + s.ship_cost), 2) AS operational_margin,
        o.quantity,
        o.revenue,
        o.purchase_cost,
        o.margin,
        s.shipping_fee,
        s.log_cost,
        s.ship_cost
    FROM orders_margin o
    LEFT JOIN ship s
        USING (orders_id)
)

SELECT * FROM operational_calculation
ORDER BY orders_id DESC