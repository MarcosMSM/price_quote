WITH 
q_price00 AS (
SELECT a.tube_assembly_id
      ,SUM(a.quantity) AS quantity_component
FROM dasa-exam.trusted.industry_material_bill AS a
GROUP BY a.tube_assembly_id
),
q_price01 AS (
SELECT a.tube_assembly_id
      ,a.supplier
      ,a.quote_date
      ,a.annual_usage
      ,a.min_order_quantity
      ,a.bracket_pricing
      ,a.quantity
      ,a.cost
      ,COALESCE(b.quantity_component, 0) AS quantity_component
      --,ROW_NUMBER() OVER(PARTITION BY tube_assembly_id, quantity ORDER BY quote_date DESC) AS price_rank
FROM dasa-exam.trusted.industry_price_quote AS a
LEFT JOIN q_price00 AS b ON b.tube_assembly_id = a.tube_assembly_id
),

q_price02 AS (
SELECT tube_assembly_id
      ,supplier
      ,quote_date
      ,EXTRACT(YEAR FROM quote_date) AS quote_year
      ,EXTRACT(MONTH FROM quote_date) AS quote_month
      ,EXTRACT(DAY FROM quote_date) AS quote_day
      ,annual_usage
      ,min_order_quantity
      ,bracket_pricing
      ,CASE 
        WHEN bracket_pricing = TRUE THEN 'na'
        WHEN bracket_pricing = FALSE AND (CASE WHEN bracket_pricing = FALSE THEN quantity - min_order_quantity ELSE 0 END) < 0 THEN 'no' 
        ELSE 'yes' 
       END AS quantity_reached         
      ,quantity AS quantity_order
      ,cost
      ,quantity * cost AS total_cost
      ,quantity_component
FROM q_price01
)

SELECT *
FROM q_price02 AS a
