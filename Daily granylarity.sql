SELECT
    va.cpe,
    DATE_TRUNC('day', v.timestamp) AS consumption_date,
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
    AND v.timestamp >= DATE_TRUNC('year', CURRENT_DATE)  -- Start of the current year
GROUP BY
    va.cpe,
    consumption_date
ORDER BY
    va.cpe,
    consumption_date;
