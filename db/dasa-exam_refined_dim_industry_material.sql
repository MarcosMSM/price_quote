SELECT a.tube_assembly_id
      ,SUM(a.quantity) AS quantity
      ,'yes' AS data_quality
FROM dasa-exam.trusted.industry_material_bill AS a
GROUP BY a.tube_assembly_id
UNION ALL 
SELECT DISTINCT a.tube_assembly_id
       ,0 AS quantity
       ,'no' AS data_quality
FROM dasa-exam.trusted.industry_price_quote AS a       
WHERE NOT EXISTS (SELECT 1 FROM dasa-exam.trusted.industry_material_bill AS b WHERE b.tube_assembly_id = a.tube_assembly_id)
ORDER BY data_quality
        ,tube_assembly_id
		
		
		