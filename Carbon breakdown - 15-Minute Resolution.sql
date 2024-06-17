-- needs to be double checked
SELECT
    va.cpe,
    DATE_TRUNC('hour', v.timestamp) AS consumption_hour,
    ROUND(SUM((v.renewable_biomass_kwh * v.active_energy))::numeric, 4) AS renewable_biomass_gco2eq,
    ROUND(SUM((v.renewable_hydro_kwh * v.active_energy))::numeric, 4) AS renewable_hydro_gco2eq,
    ROUND(SUM((v.renewable_solar_kwh * v.active_energy))::numeric, 4) AS renewable_solar_gco2eq,
    ROUND(SUM((v.renewable_wind_kwh * v.active_energy))::numeric, 4) AS renewable_wind_gco2eq,
    ROUND(SUM((v.renewable_geothermal_kwh * v.active_energy))::numeric, 4) AS renewable_geothermal_gco2eq,
    ROUND(SUM(v.renewable_biomass_kwh * v.active_energy
              + v.renewable_hydro_kwh * v.active_energy
              + v.renewable_solar_kwh * v.active_energy
              + v.renewable_wind_kwh * v.active_energy
              + v.renewable_geothermal_kwh * v.active_energy)::numeric, 4) AS total_renewable_gco2eq,
    ROUND(SUM((v.nonrenewable_coal_kwh * v.active_energy))::numeric, 4) AS nonrenewable_coal_gco2eq,
    ROUND(SUM((v.nonrenewable_gas_kwh * v.active_energy))::numeric, 4) AS nonrenewable_gas_gco2eq,
    ROUND(SUM((v.nonrenewable_nuclear_kwh * v.active_energy))::numeric, 4) AS nonrenewable_nuclear_gco2eq,
    ROUND(SUM((v.nonrenewable_oil_kwh * v.active_energy))::numeric, 4) AS nonrenewable_oil_gco2eq,
    ROUND(SUM(v.nonrenewable_coal_kwh * v.active_energy
              + v.nonrenewable_gas_kwh * v.active_energy
              + v.nonrenewable_nuclear_kwh * v.active_energy
              + v.nonrenewable_oil_kwh * v.active_energy)::numeric, 4) AS total_nonrenewable_gco2eq,
    ROUND(SUM((v.hydropumpedstorage_kwh * v.active_energy))::numeric, 4) AS hydropumpedstorage_gco2eq,
    ROUND(SUM((v.unknown_kwh * v.active_energy))::numeric, 4) AS unknown_gco2eq
FROM
    "view-curate-eredes-process-wcfp-app-with-reactive" v
JOIN
    metadata.form_assets va ON v.cpe = va.cpe
JOIN
    metadata.users u ON va.company_vat = u.vat
WHERE
    u.id = 51  -- Replace with the user's ID
    AND v.timestamp >= NOW() - INTERVAL '15 minutes'  -- Adjust as needed for current time - 15 minutes
GROUP BY
    va.cpe,
    consumption_hour
ORDER BY
    va.cpe,
    consumption_hour;
