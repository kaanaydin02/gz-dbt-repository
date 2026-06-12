WITH sales AS (
    SELECT * FROM {{ ref('stg_raw__sales') }}
),

product AS (
    SELECT * FROM {{ ref('stg_raw__product') }}
),

margin_calculation AS (
    SELECT
        s.products_id,
        s.date_date,
        s.orders_id,
        s.revenue,
        s.quantity,
        p.purchase_price,
        -- satın_alma_maliyeti = miktar * satın_alma_fiyati
        ROUND(s.quantity * p.purchase_price, 2) AS purchase_cost,
        -- marj = gelir - satın_alma_maliyeti
        ROUND(s.revenue - (s.quantity * p.purchase_price), 2) AS margin
    FROM sales s
    LEFT JOIN product p
        USING (products_id)
)

SELECT * FROM margin_calculation