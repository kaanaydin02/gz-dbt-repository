WITH source AS (
    SELECT * FROM {{ source('raw', 'ship') }}
),

renamed AS (
    SELECT
        orders_id,
        shipping_fee, -- shipping_fee_1 sütunu gereksiz olduğu için kaldırıldı
        logcost AS log_cost, -- logcost ismi log_cost olarak standartlaştırıldı
        CAST(ship_cost AS INT64) AS ship_cost -- Uygun veri türüne dönüştürüldü
    FROM source
)

SELECT * FROM renamed