SELECT
    va.cpe,
    DATE_TRUNC('minute', v.timestamp) AS time_start,  -- Truncate to minute
    SUM(v.active_energy) AS total_active_energy,
    SUM(v.reactive_inductive_energy) AS total_reactive_inductive_energy,
    SUM(v.reactive_capacitive_energy) AS total_reactive_capacitive_energy,
FROM
    mv_curated_data v
JOIN
    metadata.sample_assets_data va ON v.cpe = va.cpe -- replace the table name to form_assets
WHERE
    va.user_id = 51
    AND v.timestamp >= (CURRENT_DATE - INTERVAL '2 years')  -- Two years historical data
GROUP BY
    va.cpe,
    va.client,
    time_start
ORDER BY
    va.cpe,
    va.client,
    time_start;