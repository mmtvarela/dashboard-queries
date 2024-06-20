SELECT 
    sad.name AS building,
    SUM(ep.active_power / 4) / sad.total_area AS energy
FROM 
    metadata.sample_assets_data sad
JOIN 
    eredes_process ep ON sad.cpe = ep.cpe
WHERE 
    sad.user_id = 51 and ep.timestamp =  DATE_TRUNC('year', CURRENT_DATE) 
GROUP BY 
    sad.name,
	sad.total_area;
