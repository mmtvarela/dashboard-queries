SELECT *
FROM mv_curated_data v
JOIN (
    SELECT va.cpe
    FROM metadata.users u
    JOIN metadata.form_assets va ON u.vat = va.company_vat
    WHERE u.id = 51
) assets ON v.cpe = assets.cpe;

-- the materialized view is the fasted solution. ~0.5ms compared to the 22s from the view above
SELECT *
FROM mv_curated_data v
JOIN (
    SELECT va.cpe
    FROM metadata.users u
    JOIN metadata.form_assets va ON u.vat = va.company_vat
    WHERE u.id = 51
) assets ON v.cpe = assets.cpe;


CREATE MATERIALIZED VIEW mv_curated_data AS
SELECT *
FROM "view-curate-eredes-process-wcfp-app-with-reactive";

-- should refresh the materialized view regularly:
REFRESH MATERIALIZED VIEW mv_curated_data;


