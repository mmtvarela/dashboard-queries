BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS balcao_digital (
    timestamp VARCHAR,
    active_power DOUBLE PRECISION,
	cpe VARCHAR,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS cpf_location_entsoe (
    timestamp VARCHAR,
	cpe VARCHAR,
	category VARCHAR,
	sub_category VARCHAR,
	kwh DOUBLE PRECISION,
	gco2eq DOUBLE PRECISION,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS cpf_v2_location_entsoe (
    timestamp VARCHAR,
	cpe VARCHAR,
	category VARCHAR,
	sub_category VARCHAR,
	kwh DOUBLE PRECISION,
	gco2eq DOUBLE PRECISION,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS daily (
    timestamp VARCHAR,
	active_power DOUBLE PRECISION,
	active_power_status bigint,
	cpe VARCHAR,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS energy_breakdown_daily (
	category VARCHAR,
	sub_category1 VARCHAR,
	sub_category2 VARCHAR,
	energy_gwh DOUBLE PRECISION,
	share_perc DOUBLE PRECISION,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS energy_breakdown_montly (
	category VARCHAR,
	sub_category1 VARCHAR,
	sub_category2 VARCHAR,
	gwh DOUBLE PRECISION,
	perc DOUBLE PRECISION,
	date_id VARCHAR
);

CREATE TABLE IF NOT EXISTS metadata (
	cpe VARCHAR,
	agency_name VARCHAR,
	cpe_address VARCHAR,
	lat DOUBLE PRECISION,
	lon DOUBLE PRECISION,
	full_address VARCHAR,
	nr_of_staff bigint,
	total_used_area_of_agency_m2 bigint,
	cluster_nr bigint,
	water_num VARCHAR,
	list_of_amenities VARCHAR
);

CREATE TABLE IF NOT EXISTS monthly (
	timestamp VARCHAR,
	active_power DOUBLE PRECISION,
	active_power_status bigint,
	cpe VARCHAR,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS process_data (
	timestamp VARCHAR,
	active_power DOUBLE PRECISION,
	active_power_status bigint,
	cpe VARCHAR,
	updated bigint,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS process_data_w_cfp (
	timestamp VARCHAR,
	cpe VARCHAR,
	active_energy DOUBLE PRECISION,
	renewable_biomass_kwh DOUBLE PRECISION,
	renewable_hydro_kwh DOUBLE PRECISION,
	renewable_solar_kwh DOUBLE PRECISION,
	renewable_wind_kwh DOUBLE PRECISION,
	renewable_geothermal_kwh DOUBLE PRECISION,
	renewable_otherrenewable_kwh DOUBLE PRECISION,
	renewable_kwh DOUBLE PRECISION,
	nonrenewable_coal_kwh DOUBLE PRECISION, 
	nonrenewable_gas_kwh DOUBLE PRECISION,
	nonrenewable_nuclear_kwh DOUBLE PRECISION,
	nonrenewable_oil_kwh DOUBLE PRECISION,
	nonrenewable_kwh DOUBLE PRECISION,
	hydropumpedstorage_kwh DOUBLE PRECISION,
	unknown_kwh DOUBLE PRECISION,
	renewable_biomass_gco2eq DOUBLE PRECISION,
	renewable_hydro_gco2eq DOUBLE PRECISION,
	renewable_solar_gco2eq DOUBLE PRECISION,
	renewable_wind_gco2eq DOUBLE PRECISION,
	renewable_geothermal_gco2eq DOUBLE PRECISION,
	renewable_otherrenewable_gco2eq bigint,
	renewable_gco2eq DOUBLE PRECISION,
	nonrenewable_coal_gco2eq DOUBLE PRECISION,
	nonrenewable_gas_gco2eq DOUBLE PRECISION,
	nonrenewable_nuclear_gco2eq DOUBLE PRECISION,
	nonrenewable_oil_gco2eq DOUBLE PRECISION,
	nonrenewable_gco2eq DOUBLE PRECISION,
	hydropumpedstorage_gco2eq DOUBLE PRECISION,
	unknown_gco2eq bigint,
	year VARCHAR,
	month VARCHAR,
	day VARCHAR
);

CREATE TABLE IF NOT EXISTS processwcfp_test(
	timestamp timestamp,
	cpe varchar,
	category varchar(19),
	subcategory varchar(19),
	kwh DOUBLE PRECISION,
	gco2eq DOUBLE PRECISION,
	weekday bigint,
	weekday_name varchar(9),
	month_name varchar(9),
	officehours varchar(8),
	year varchar,
	month int,
	day int,
	working DOUBLE PRECISION,
	offwork DOUBLE PRECISION
);

COMMIT;
-- ROLLBACK;