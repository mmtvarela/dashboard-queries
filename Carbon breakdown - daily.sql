SELECT
    va.cpe,
    DATE_TRUNC('day', v.timestamp) AS consumption_day,
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
    mv_curated_data v
JOIN
    metadata.sample_assets_data va ON v.cpe = va.cpe -- replace the table name to form_assets
WHERE
    va.user_id = 51 -- user id should be dynamically (obviously)
    AND v.timestamp >= (CURRENT_DATE - INTERVAL '2 years')  -- 2 years historical data
GROUP BY
    va.cpe,
    va.client,
	DATE_TRUNC('day', v.timestamp)
ORDER BY
    va.cpe,
    va.client,
	DATE_TRUNC('day', v.timestamp)