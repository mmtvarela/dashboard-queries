BEGIN TRANSACTION;

CREATE OR REPLACE VIEW "view-curate-eredes-process-wcfp-app-with-reactive" AS 
WITH
  -- Define the CTE for eredes 
  eredes AS (
    SELECT
      timestamp,
      cpe,
      (active_power / 4) AS active_energy,
      (reactive_inductive_power / 4) AS reactive_inductive_energy,
      (reactive_capacitive_power / 4) AS reactive_capacitive_energy,
      CASE 
        WHEN month = '1' THEN 'January' 
        WHEN month = '2' THEN 'February' 
        WHEN month = '3' THEN 'March' 
        WHEN month = '4' THEN 'April' 
        WHEN month = '5' THEN 'May' 
        WHEN month = '6' THEN 'June' 
        WHEN month = '7' THEN 'July' 
        WHEN month = '8' THEN 'August' 
        WHEN month = '9' THEN 'September' 
        WHEN month = '10' THEN 'October' 
        WHEN month = '11' THEN 'November' 
        WHEN month = '12' THEN 'December' 
        ELSE 'Unknown'
      END AS month_name,
      CASE 
        WHEN EXTRACT(DOW FROM timestamp) = 0 THEN 'Sunday'
        WHEN EXTRACT(DOW FROM timestamp) = 1 THEN 'Monday'
        WHEN EXTRACT(DOW FROM timestamp) = 2 THEN 'Tuesday'
        WHEN EXTRACT(DOW FROM timestamp) = 3 THEN 'Wednesday'
        WHEN EXTRACT(DOW FROM timestamp) = 4 THEN 'Thursday'
        WHEN EXTRACT(DOW FROM timestamp) = 5 THEN 'Friday'
        WHEN EXTRACT(DOW FROM timestamp) = 6 THEN 'Saturday'
        ELSE 'Unknown'
      END AS weekday_name,
      SUBSTRING(timestamp::text, 1, 13) AS to_join
    FROM
      eredes_process
    WHERE timestamp >= DATE '2024-01-01'
  ),
  -- Define the CTE for cfp
  cfp AS (
    SELECT
      timestamp,
      CAST(renewable_biomass AS DOUBLE PRECISION) AS renewable_biomass,
      CAST(renewable_hydro AS DOUBLE PRECISION) AS renewable_hydro,
      CAST(renewable_solar AS DOUBLE PRECISION) AS renewable_solar,
      CAST(renewable_wind AS DOUBLE PRECISION) AS renewable_wind,
      CAST(renewable_geothermal AS DOUBLE PRECISION) AS renewable_geothermal,
      CAST(renewable_otherrenewable AS DOUBLE PRECISION) AS renewable_otherrenewable,
      CAST(renewable AS DOUBLE PRECISION) AS renewable,
      CAST(nonrenewable_coal AS DOUBLE PRECISION) AS nonrenewable_coal,
      CAST(nonrenewable_gas AS DOUBLE PRECISION) AS nonrenewable_gas,
      CAST(nonrenewable_nuclear AS DOUBLE PRECISION) AS nonrenewable_nuclear,
      CAST(nonrenewable_oil AS DOUBLE PRECISION) AS nonrenewable_oil,
      CAST(nonrenewable AS DOUBLE PRECISION) AS nonrenewable,
      CAST(hydropumpedstorage AS DOUBLE PRECISION) AS hydropumpedstorage,
      CAST(unknown AS DOUBLE PRECISION) AS unknown,
      SUBSTRING(timestamp::text, 1, 13) AS to_join
    FROM
      cfp_entsoe_hourly_pt
  ),
  -- Define the CTE for cfp_intensity
  cfp_intensity AS (
    SELECT
      230 AS renewable_biomass,
      11 AS renewable_hydro,
      26 AS renewable_solar,
      13 AS renewable_wind,
      38 AS renewable_geothermal,
      -1 AS renewable_otherrenewable,
      1100 AS nonrenewable_coal,
      492 AS nonrenewable_gas,
      5 AS nonrenewable_nuclear,
      1125 AS nonrenewable_oil,
      155 AS hydropumpedstorage,
      -1 AS unknown
  )
SELECT
  e.timestamp,
  SUBSTRING(e.timestamp::text, 1, 4) AS year_str,
  e.cpe,
  e.active_energy,
  e.reactive_inductive_energy,
  e.reactive_capacitive_energy,
  e.month_name,
  e.weekday_name,
   ROUND((c.renewable_biomass * e.active_energy)::numeric, 4) AS renewable_biomass_kwh,
  ROUND((c.renewable_hydro * e.active_energy)::numeric, 4) AS renewable_hydro_kwh,
  ROUND((c.renewable_solar * e.active_energy)::numeric, 4) AS renewable_solar_kwh,
  ROUND((c.renewable_wind * e.active_energy)::numeric, 4) AS renewable_wind_kwh,
  ROUND((c.renewable_geothermal * e.active_energy)::numeric, 4) AS renewable_geothermal_kwh,
  ROUND((c.renewable_otherrenewable * e.active_energy)::numeric, 4) AS renewable_otherrenewable_kwh,
  ROUND((c.renewable * e.active_energy)::numeric, 4) AS renewable_kwh,
  ROUND((c.nonrenewable_coal * e.active_energy)::numeric, 4) AS nonrenewable_coal_kwh,
  ROUND((c.nonrenewable_gas * e.active_energy)::numeric, 4) AS nonrenewable_gas_kwh,
  ROUND((c.nonrenewable_nuclear * e.active_energy)::numeric, 4) AS nonrenewable_nuclear_kwh,
  ROUND((c.nonrenewable_oil * e.active_energy)::numeric, 4) AS nonrenewable_oil_kwh,
  ROUND((c.nonrenewable * e.active_energy)::numeric, 4) AS nonrenewable_kwh,
  ROUND((c.hydropumpedstorage * e.active_energy)::numeric, 4) AS hydropumpedstorage_kwh,
  ROUND((c.unknown * e.active_energy)::numeric, 4) AS unknown_kwh,
  ROUND(((c.renewable_biomass * e.active_energy) * cfp_i.renewable_biomass)::numeric, 4) AS renewable_biomass_gco2eq,
  ROUND(((c.renewable_hydro * e.active_energy) * cfp_i.renewable_hydro)::numeric, 4) AS renewable_hydro_gco2eq,
  ROUND(((c.renewable_solar * e.active_energy) * cfp_i.renewable_solar)::numeric, 4) AS renewable_solar_gco2eq,
  ROUND(((c.renewable_wind * e.active_energy) * cfp_i.renewable_wind)::numeric, 4) AS renewable_wind_gco2eq,
  ROUND(((c.renewable_geothermal * e.active_energy) * cfp_i.renewable_geothermal)::numeric, 4) AS renewable_geothermal_gco2eq,
  CAST(NULL AS DOUBLE PRECISION) AS renewable_otherrenewable_gco2eq,
  ROUND(
    (
      ((c.renewable_biomass * e.active_energy) * cfp_i.renewable_biomass) +
      ((c.renewable_hydro * e.active_energy) * cfp_i.renewable_hydro) +
      ((c.renewable_solar * e.active_energy) * cfp_i.renewable_solar) +
      ((c.renewable_wind * e.active_energy) * cfp_i.renewable_wind) +
      ((c.renewable_geothermal * e.active_energy) * cfp_i.renewable_geothermal)
    )::numeric, 4
  ) AS renewable_gco2eq,
  ROUND(((c.nonrenewable_coal * e.active_energy) * cfp_i.nonrenewable_coal)::numeric, 4) AS nonrenewable_coal_gco2eq,
  ROUND(((c.nonrenewable_gas * e.active_energy) * cfp_i.nonrenewable_gas)::numeric, 4) AS nonrenewable_gas_gco2eq,
  ROUND(((c.nonrenewable_nuclear * e.active_energy) * cfp_i.nonrenewable_nuclear)::numeric, 4) AS nonrenewable_nuclear_gco2eq,
  ROUND(((c.nonrenewable_oil * e.active_energy) * cfp_i.nonrenewable_oil)::numeric, 4) AS nonrenewable_oil_gco2eq,
  ROUND(
    (
      ((c.nonrenewable_coal * e.active_energy) * cfp_i.nonrenewable_coal) +
      ((c.nonrenewable_gas * e.active_energy) * cfp_i.nonrenewable_gas) +
      ((c.nonrenewable_nuclear * e.active_energy) * cfp_i.nonrenewable_nuclear) +
      ((c.nonrenewable_oil * e.active_energy) * cfp_i.nonrenewable_oil)
    )::numeric, 4
  ) AS nonrenewable_gco2eq,
  ROUND(((c.hydropumpedstorage * e.active_energy) * cfp_i.hydropumpedstorage)::numeric, 4) AS hydropumpedstorage_gco2eq,
  CAST(NULL AS DOUBLE PRECISION) AS unknown_gco2eq
FROM
  eredes e
  LEFT JOIN cfp c ON e.to_join = c.to_join
  CROSS JOIN cfp_intensity cfp_i;

COMMIT;