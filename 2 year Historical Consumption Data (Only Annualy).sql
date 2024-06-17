SELECT
    va.cpe,
    DATE_TRUNC('year', v.timestamp) AS year_start,
    SUM(v.active_energy) AS total_active_energy,
    SUM(v.reactive_inductive_energy) AS total_reactive_inductive_energy,
    SUM(v.reactive_capacitive_energy) AS total_reactive_capacitive_energy
FROM
    "view-curate-eredes-process-wcfp-app-with-reactive" v
JOIN
    metadata.form_assets va ON v.cpe = va.cpe
JOIN
    metadata.users u ON va.company_vat = u.vat
WHERE
    u.id = 51  -- Replace with the user's ID
    AND v.timestamp >= CURRENT_DATE - INTERVAL '2 years'  -- Two years historical data
GROUP BY
    va.cpe,
    year_start
ORDER BY
    va.cpe,
    year_start;
