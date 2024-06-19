WITH daily_consumption AS (
    SELECT
        va.cpe,
        DATE_TRUNC('day', v.timestamp) AS consumption_date,
        MAX(v.active_energy) AS max_active_energy,
        MAX(v.reactive_inductive_energy) AS max_reactive_inductive_energy,
        MAX(v.reactive_capacitive_energy) AS max_reactive_capacitive_energy,
    FROM
         mv_curated_data v
    JOIN
	    metadata.sample_assets_data va ON v.cpe = va.cpe -- replace the table name to form_assets
    WHERE
        va.user_id = 51
        AND v.timestamp >= DATE_TRUNC('year', CURRENT_DATE)  -- Start of the current year
    GROUP BY
        va.cpe,
        DATE_TRUNC('day', v.timestamp)
)
SELECT
    cpe,
    consumption_date,
    max_active_energy,
    min_active_energy,
    max_reactive_inductive_energy,
    min_reactive_inductive_energy,
    max_reactive_capacitive_energy,
    min_reactive_capacitive_energy
FROM
    daily_consumption
ORDER BY
    cpe,
    consumption_date;
