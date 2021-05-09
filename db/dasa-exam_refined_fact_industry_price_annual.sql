WITH 
q_price01 AS (
SELECT tube_assembly_id
      ,supplier
      ,quote_date
      ,annual_usage
      ,min_order_quantity
      ,bracket_pricing
      ,quantity
      ,cost
      --,ROW_NUMBER() OVER(PARTITION BY tube_assembly_id, quantity ORDER BY quote_date DESC) AS price_rank
FROM dasa-exam.trusted.industry_price_quote
),

q_price02 AS (
SELECT tube_assembly_id
      ,EXTRACT(YEAR FROM quote_date) AS quote_year
      ,MAX(annual_usage) AS annual_usage       
      ,SUM(quantity) AS quantity_order
      ,SUM(cost) AS cost
      ,SUM(quantity) * SUM(cost) AS total_cost
FROM q_price01
GROUP BY tube_assembly_id
        ,EXTRACT(YEAR FROM quote_date)
)

SELECT *
FROM q_price02