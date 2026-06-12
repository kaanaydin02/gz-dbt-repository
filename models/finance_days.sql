WITH product_cleaned AS (
    SELECT 
        products_id,
        -- DÜZELTME: Tablodaki orijinal 'purchse_price' (A harfi yok) alanı kullanıldı
        CAST(purchse_price AS FLOAT64) AS purchase_price_clean
    FROM {{ source('raw', 'product') }}
),

sales_margin AS (
    SELECT
        s.date_date,
        s.orders_id,
        s.revenue,
        s.quantity,
        -- Marj Hesaplama
        ROUND(s.revenue - (s.quantity * p.purchase_price_clean), 2) AS margin
    FROM {{ source('raw', 'sales') }} s
    LEFT JOIN product_cleaned p 
        ON s.pdt_id = p.products_id
),

daily_operations AS (
    SELECT
        sm.date_date,
        COUNT(DISTINCT sm.orders_id) AS nb_transactions,
        ROUND(SUM(sm.revenue), 2) AS revenue,
        ROUND(SUM(sm.margin), 2) AS margin,
        ROUND(SUM(sh.shipping_fee), 2) AS shipping_fee,
        ROUND(SUM(sh.logcost), 2) AS logcost,
        ROUND(SUM(CAST(sh.ship_cost AS FLOAT64)), 2) AS ship_cost
    FROM sales_margin sm
    LEFT JOIN {{ source('raw', 'ship') }} sh 
        ON sm.orders_id = sh.orders_id
    GROUP BY sm.date_date
)

SELECT
    date_date,
    nb_transactions,
    revenue,
    ROUND(revenue / nb_transactions, 2) AS average_basket,
    margin,
    ROUND(margin + shipping_fee - logcost - ship_cost, 2) AS operational_margin
FROM daily_operations
ORDER BY date_date DESC