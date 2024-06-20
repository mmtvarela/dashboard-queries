SELECT 
    name,
    lat,
    lon,
    COUNT(cpe) AS cpe_count,
    MAX(total_area) AS total_area_sum -- this is max instead of sum, because the data aren't accurate and sum returns an exagerated value
FROM metadata.sample_assets_data
WHERE user_id = 51
GROUP BY name, lat, lon
