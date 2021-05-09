SELECT DISTINCT b.tube_assembly_id
      ,b.quantity AS quantity_component
	  ,a.*
      ,'yes'AS data_quality 
FROM dasa-exam.trusted.industry_component AS a
LEFT JOIN dasa-exam.trusted.industry_material_bill AS b ON b.component_id = a.component_id
UNION ALL 
SELECT DISTINCT a.tube_assembly_id
      ,a.quantity AS quantity_component
      ,a.component_id
	  ,CAST(NULL AS STRING)  AS component_type_id
	  ,CAST(NULL AS STRING)  AS type
	  ,CAST(NULL AS STRING)  AS connection_type_id
	  ,CAST(NULL AS STRING)  AS outside_shape
	  ,CAST(NULL AS STRING)  AS base_type
	  ,CAST(NULL AS FLOAT64) AS height_over_tube
	  ,CAST(NULL AS FLOAT64) AS bolt_pattern_long
	  ,CAST(NULL AS FLOAT64) AS bolt_pattern_wide
	  ,CAST(NULL AS BOOLEAN) AS groove
	  ,CAST(NULL AS FLOAT64) AS base_diameter
	  ,CAST(NULL AS FLOAT64) AS shoulder_diameter
	  ,CAST(NULL AS BOOLEAN) AS unique_feature
	  ,CAST(NULL AS BOOLEAN) AS orientation
	  ,CAST(NULL AS FLOAT64) AS weight
      ,'no'AS data_quality
FROM dasa-exam.trusted.industry_material_bill AS a
WHERE NOT EXISTS(SELECT 1 FROM dasa-exam.trusted.industry_component AS b WHERE b.component_id = a.component_id)
ORDER BY data_quality
        ,tube_assembly_id
		,component_id