BEGIN TRANSACTION;
CREATE TABLE IF NOT EXISTS "time_season" (
	"t_season"	text,
	PRIMARY KEY("t_season")
);
CREATE TABLE IF NOT EXISTS "time_periods" (
	"t_periods"	integer,
	"flag"	text,
	PRIMARY KEY("t_periods"),
	FOREIGN KEY("flag") REFERENCES "time_period_labels"("t_period_labels")
);
CREATE TABLE IF NOT EXISTS "time_period_labels" (
	"t_period_labels"	text,
	"t_period_labels_desc"	text,
	PRIMARY KEY("t_period_labels")
);
CREATE TABLE IF NOT EXISTS "time_of_day" (
	"t_day"	text,
	PRIMARY KEY("t_day")
);
CREATE TABLE IF NOT EXISTS "technology_labels" (
	"tech_labels"	text,
	"tech_labels_desc"	text,
	PRIMARY KEY("tech_labels")
);
CREATE TABLE IF NOT EXISTS "technologies" (
	"tech"	text,
	"flag"	text,
	"sector"	text,
	"subsector"	text,
	"tech_desc"	text,
	"tech_category"	text,
	"cap_units",
	"color"	text,
	"plot_order"	text,
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("subsector") REFERENCES "subsector_labels"("subsector"),
	PRIMARY KEY("tech"),
	FOREIGN KEY("flag") REFERENCES "technology_labels"("tech_labels")
);
CREATE TABLE IF NOT EXISTS "tech_reserve" (
	"tech"	text,
	"notes"	text,
	PRIMARY KEY("tech")
);
CREATE TABLE IF NOT EXISTS "tech_exchange" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_ramping" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_curtailment" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_flex" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_variable" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_annual" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_mga" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech")--,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "tech_groups" (
	"region" text,
	"group_name" text,
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("region", "group_name", "tech"),
	FOREIGN KEY("region") REFERENCES "regions"("regions"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "tech_asynchronous" (
	"tech"	text,
	"notes"	TEXT,
	PRIMARY KEY("tech")--,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "sector_labels" (
	"sector"	text,
	"description"	text,
	"color"	text,
	"plot_order"	text,
	PRIMARY KEY("sector")
);
CREATE TABLE IF NOT EXISTS "subsector_labels" (
	"subsector"	text,
	"description"	text,
	"color"	text,
	"plot_order"	text,
	PRIMARY KEY("subsector")
);
CREATE TABLE IF NOT EXISTS "regions" (
	"regions"	TEXT,
	"plot_order"	integer,
	"region_note"	TEXT,
	PRIMARY KEY("regions")
);
CREATE TABLE IF NOT EXISTS "data_sources" (
	"reference"	text,
	"source"	text
);
CREATE TABLE IF NOT EXISTS "groups" (
	"group_name"	text,
	"notes"	text,
	PRIMARY KEY("group_name")
);
CREATE TABLE IF NOT EXISTS "commodity_labels" (
	"comm_labels"	text,
	"comm_labels_desc"	text,
	PRIMARY KEY("comm_labels")
);
CREATE TABLE IF NOT EXISTS "commodities" (
	"comm_name"	text,
	"flag"	text,
	"comm_desc"	text,
	"units"	text,
	FOREIGN KEY("flag") REFERENCES "commodity_labels"("comm_labels"),
	PRIMARY KEY("comm_name")
);
CREATE TABLE IF NOT EXISTS "TechOutputSplit" (
	"regions"	TEXT,
	"periods"	integer,
	"tech"	text,
	"output_comm"	text,
	"to_split"	real,
  "source"	text,
	"to_split_notes"	text,
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	PRIMARY KEY("regions","periods","tech","output_comm"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "TechInputSplit" (
	"regions"	TEXT,
	"periods"	integer,
	"input_comm"	text,
	"tech"	text,
	"ti_split"	real,
  "source"	text,
	"ti_split_notes"	text,
	PRIMARY KEY("regions","periods","input_comm","tech"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "TechInputSplitAverage" (
	"regions"	TEXT,
	"periods"	integer,
	"input_comm"	text,
	"tech"	text,
	"ti_split"	real CHECK("ti_split" < 1.0),
	"ti_split_notes"	text,
	PRIMARY KEY("regions","periods","input_comm","tech"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "tech_variable"("tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "StorageDuration" (
	"regions"	text,
	"tech"	text,
	"duration"	real,
	"duration_notes"	text,
	PRIMARY KEY("regions","tech")
);
CREATE TABLE IF NOT EXISTS "SegFrac" (
	"season_name"	text,
	"time_of_day_name"	text,
	"segfrac"	real CHECK("segfrac" >= 0 AND "segfrac" <= 1),
	"segfrac_notes"	text,
	PRIMARY KEY("season_name","time_of_day_name"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day")
);
CREATE TABLE IF NOT EXISTS "PlanningReserveMargin" (
	"regions"	text,
	"reserve_margin"	REAL,
  "source" text,
	PRIMARY KEY("regions"),
	FOREIGN KEY("regions") REFERENCES "regions"
);
CREATE TABLE IF NOT EXISTS "Output_V_Capacity" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"tech"	text,
	"vintage"	integer,
	"capacity"	real,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","scenario","tech","vintage"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "Output_VFlow_Out" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"vflow_out"	real,
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE IF NOT EXISTS "Output_VFlow_In" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"vflow_in"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector")
);
CREATE TABLE IF NOT EXISTS "Output_VStorageSOC" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"tech"	text,
	"vintage"	integer,
	"level"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","tech","vintage"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector")
);
CREATE TABLE IF NOT EXISTS "Output_Objective" (
	"scenario"	text,
	"objective_name"	text,
	"total_system_cost"	real
);
CREATE TABLE IF NOT EXISTS "Output_Emissions" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"emissions_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"emissions"	real,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","scenario","t_periods","emissions_comm","tech","vintage"),
	FOREIGN KEY("emissions_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "Output_Employment" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"tech"	text,
	"vintage"	integer,
	"jobs"	real,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","scenario","t_periods","tech","vintage"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "Output_ImplicitEmissionsPrice" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"emissions_comm"	text,
	"emissions_price"	real,
	PRIMARY KEY("regions","scenario","t_periods","emissions_comm"),
	FOREIGN KEY("emissions_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "Output_Curtailment" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"t_season"	text,
	"t_day"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"curtailment"	real,
	PRIMARY KEY("regions","scenario","t_periods","t_season","t_day","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("t_day") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("t_season") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "Output_Costs" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"output_name"	text,
	"tech"	text,
	"vintage"	integer,
	"output_cost"	real,
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	PRIMARY KEY("regions","scenario","output_name","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "Output_Duals" (
	"constraint_name"	text,
	"scenario"	text,
	"dual"	real,
	PRIMARY KEY("constraint_name","scenario")
);
CREATE TABLE IF NOT EXISTS "Output_CapacityByPeriodAndTech" (
	"regions"	text,
	"scenario"	text,
	"sector"	text,
	"t_periods"	integer,
	"tech"	text,
	"capacity"	real,
	PRIMARY KEY("regions","scenario","t_periods","tech"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MyopicBaseyear" (
	"year"	real,
	"notes" text
);
CREATE TABLE IF NOT EXISTS "LinkedTechs" (
	"primary_region"	text,
	"primary_tech"	text,
	"emis_comm" text,
 	"linked_tech"	text,
	"tech_linked_notes"	text,
	FOREIGN KEY("primary_tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("linked_tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name"),
	PRIMARY KEY("primary_region","primary_tech", "emis_comm")
);
CREATE TABLE IF NOT EXISTS "MinGenGroupWeight" (
	"regions"	text,
	"tech"	text,
	"group_name"	text,
	"act_fraction"	REAL,
	"tech_desc"	text,
	PRIMARY KEY("tech","group_name","regions")
);
CREATE TABLE IF NOT EXISTS "MinGenGroupTarget" (
	"periods"	integer,
	"group_name"	text,
	"min_act_g"	real,
	"notes"	text,
	PRIMARY KEY("periods","group_name")
);
CREATE TABLE IF NOT EXISTS "MinCapacity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"mincap"	real,
	"mincap_units"	text,
	"mincap_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MinActivity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"minact"	real,
	"minact_units"	text,
  "source"	text,
	"minact_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MinSeasonalActivity" (
	"regions"	text,
	"periods"	integer,
	"season_name" text,
	"tech"	text,
	"minact"	real,
	"minact_units"	text,
	"minact_notes"	text,
	PRIMARY KEY("regions","periods","season_name","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MinAnnualCapacityFactor" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"min_acf"	real,
	"source" text,
	"min_acf_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MaxAnnualCapacityFactor" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"max_acf"	real,
	"source" text,
	"max_acf_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MinNewCapacity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"mincap"	real,
	"mincap_units"	text,
	"mincap_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MaxNewCapacity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"maxcap"	real,
	"maxcap_units"	text,
	"maxcap_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MinActivityGroup" (
	"regions"	text,
	"t_periods"	integer,
	"group_name"	text,
	"min_act_g"	real,
	"notes"	text,
	PRIMARY KEY("regions","t_periods","group_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MaxActivityGroup" (
	"regions"	text,
	"t_periods"	integer,
	"group_name"	text,
	"max_act_g"	real,
	"notes"	text,
	PRIMARY KEY("regions","t_periods","group_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MinCapacityGroup" (
	"regions"	text,
	"t_periods"	integer,
	"group_name"	text,
	"min_cap_g"	real,
	"notes"	text,
	PRIMARY KEY("regions","t_periods","group_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MaxCapacityGroup" (
	"regions"	text,
	"t_periods"	integer,
	"group_name"	text,
	"max_cap_g"	real,
	"notes"	text,
	PRIMARY KEY("regions","t_periods","group_name"),
	FOREIGN KEY("t_periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MinCapacityShare" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"group_name" text,
	"mincapshare"	real,
	"mincapshare_notes"	text,
	PRIMARY KEY("regions","periods","tech","group_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MaxCapacityShare" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"group_name" text,
	"maxcapshare"	real,
	"maxcapshare_notes"	text,
	PRIMARY KEY("regions","periods","tech","group_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MaxNewCapacityShare" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"group_name" text,
	"maxcapshare"	real,
	"maxcapshare_notes"	text,
	PRIMARY KEY("regions","periods","tech","group_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MinNewCapacityShare" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"group_name" text,
	"maxcapshare"	real,
	"maxcapshare_notes"	text,
	PRIMARY KEY("regions","periods","tech","group_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
	FOREIGN KEY("group_name") REFERENCES "groups"("group_name")
);
CREATE TABLE IF NOT EXISTS "MaxCapacity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"maxcap"	real,
	"maxcap_units"	text,
	"maxcap_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MaxActivity" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"maxact"	real,
	"maxact_units"	text,
  "source" text,
	"maxact_notes"	text,
	PRIMARY KEY("regions","periods","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "MaxSeasonalActivity" (
	"regions"	text,
	"periods"	integer,
	"season_name" text,
	"tech"	text,
	"minact"	real,
	"minact_units"	text,
	"minact_notes"	text,
	PRIMARY KEY("regions","periods","season_name","tech"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "RampUp" (
	"regions"	text,
	"tech"	text,
	"ramp_up"	real,
  "source" text,
	"reamp_up_notes" text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "RampDown" (
	"regions"	text,
	"tech"	text,
	"ramp_down"	real,
  "source" text,
	"reamp_down_notes" text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "LifetimeTech" (
	"regions"	text,
	"tech"	text,
	"life"	real,
  "source" text,
	"life_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "LifetimeProcess" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"life_process"	real,
	"life_process_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "LifetimeLoanTech" (
	"regions"	text,
	"tech"	text,
	"loan"	real,
  "source" text,
	"loan_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "GrowthRateSeed" (
	"regions"	text,
	"tech"	text,
	"growthrate_seed"	real,
	"growthrate_seed_units"	text,
	"growthrate_seed_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "GrowthRateMax" (
	"regions"	text,
	"tech"	text,
	"growthrate_max"	real,
	"growthrate_max_notes"	text,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "GlobalDiscountRate" (
	"rate"	real
);
CREATE TABLE IF NOT EXISTS "ExistingCapacity" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"exist_cap"	real,
	"exist_cap_units"	text,
	"exist_cap_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "EmissionLimit" (
	"regions"	text,
	"sector" text,
	"periods"	integer,
	"emis_comm"	text,
	"emis_limit"	real,
	"emis_limit_units"	text,
	"emis_limit_notes"	text,
	PRIMARY KEY("regions","periods","sector","emis_comm"),
	FOREIGN KEY("sector") REFERENCES "sector_labels"("sector"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE IF NOT EXISTS "EmissionActivity" (
	"regions"	text,
	"emis_comm"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"emis_act"	real,
	"emis_act_units"	text,
  "source" text,
	"emis_act_notes"	text,
	PRIMARY KEY("regions","emis_comm","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "OutputBasedStandard" (
	"regions"	text,
	"period"	integer,
	"emis_comm"	text,
	"input_comm"	text,
	"tech"	text,
	"output_comm"	text,
	"offset"	real,
	"offset_units"	text,
  "source" text,
	"notes"	text,
	PRIMARY KEY("regions","emis_comm","input_comm","tech","period","output_comm"),
	FOREIGN KEY("period") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "Efficiency" (
	"regions"	text,
	"input_comm"	text,
	"tech"	text,
	"vintage"	integer,
	"output_comm"	text,
	"efficiency"	real CHECK("efficiency" > 0),
  "source" text,
	"eff_notes"	text,
	PRIMARY KEY("regions","input_comm","tech","vintage","output_comm"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "EfficiencyVariable" (
	"regions"	text,
	"input_comm"	text,
	"tech"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"output_comm"	text,
	"efficiencyvar"	real CHECK("efficiencyvar" > 0),
	"source"	text,
	"eff_notes"	text,
	PRIMARY KEY("regions","input_comm","tech","season_name","time_of_day_name","output_comm"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("output_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("input_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE IF NOT EXISTS "EmploymentPerCapacity" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"tech"	text NOT NULL,
	"vintage"	integer NOT NULL,
	"employment_cap"	real,
	"employment_cap_units"	text,
  "source" text,
	"employment_cap_notes"	text,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","periods","tech","vintage"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "DiscountRate" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"tech_rate"	real,
  "source" text,
	"tech_rate_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "DemandSpecificDistribution" (
	"regions"	text,
	"periods"	integer,
	"season_name"	text,
	"time_of_day_name"	text,
	"demand_name"	text,
	"dsd"	real CHECK("dsd" >= 0 AND "dsd" <= 1),
	"dsd_notes"	text,
	PRIMARY KEY("regions","periods","season_name","time_of_day_name","demand_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
	FOREIGN KEY("demand_name") REFERENCES "commodities"("comm_name")
);
CREATE TABLE IF NOT EXISTS "Demand" (
	"regions"	text,
	"periods"	integer,
	"demand_comm"	text,
	"demand"	real,
	"demand_units"	text,
  "source" text,
	"demand_notes"	text,
	PRIMARY KEY("regions","periods","demand_comm"),
	FOREIGN KEY("demand_comm") REFERENCES "commodities"("comm_name"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "CostVariable" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"tech"	text NOT NULL,
	"vintage"	integer NOT NULL,
	"cost_variable"	real,
	"cost_variable_units"	text,
  "source" text,
	"cost_variable_notes"	text,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","periods","tech","vintage"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "CostVariableVariable" (
	"regions"	text,
	"tech"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"costvarvar"	real,
	"source"	text,
	"eff_notes"	text,
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
	PRIMARY KEY("regions","tech","season_name","time_of_day_name")
);
CREATE TABLE IF NOT EXISTS "CostInvest" (
	"regions"	text,
	"tech"	text,
	"vintage"	integer,
	"cost_invest"	real,
	"cost_invest_units"	text,
  "source" text,
	"cost_invest_notes"	text,
	PRIMARY KEY("regions","tech","vintage"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "CostEmissions" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"emis_comm"	text NOT NULL,
	"emis_penalty"	real,
	"emis_penalty_units"	text,
	"emis_penalty_notes"	text,
	PRIMARY KEY("regions","periods","emis_comm"),
	FOREIGN KEY("regions") REFERENCES "regions"("regions"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("emis_comm") REFERENCES "commodities"("comm_name")
);
CREATE TABLE IF NOT EXISTS "CostFixed" (
	"regions"	text NOT NULL,
	"periods"	integer NOT NULL,
	"tech"	text NOT NULL,
	"vintage"	integer NOT NULL,
	"cost_fixed"	real,
	"cost_fixed_units"	text,
  "source" text,
	"cost_fixed_notes"	text,
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	PRIMARY KEY("regions","periods","tech","vintage"),
	FOREIGN KEY("periods") REFERENCES "time_periods"("t_periods"),
	FOREIGN KEY("vintage") REFERENCES "time_periods"("t_periods")
);
CREATE TABLE IF NOT EXISTS "CapacityToActivity" (
	"regions"	text,
	"tech"	text,
	"c2a"	real,
	"c2a_notes"	TEXT,
	PRIMARY KEY("regions","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech")
);
CREATE TABLE IF NOT EXISTS "CapacityFactorTech" (
	"regions"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"tech"	text,
	"cf_tech"	real CHECK("cf_tech" >= 0 AND "cf_tech" <= 1),
	"cf_tech_notes"	text,
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season"),
	PRIMARY KEY("regions","season_name","time_of_day_name","tech"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day")
);
CREATE TABLE IF NOT EXISTS "CapacityFactorProcess" (
	"regions"	text,
	"season_name"	text,
	"time_of_day_name"	text,
	"tech"	text,
	"vintage"	integer,
	"cf_process"	real CHECK("cf_process" >= 0 AND "cf_process" <= 1),
	"cf_process_notes"	text,
	FOREIGN KEY("time_of_day_name") REFERENCES "time_of_day"("t_day"),
	PRIMARY KEY("regions","season_name","time_of_day_name","tech","vintage"),
	FOREIGN KEY("tech") REFERENCES "technologies"("tech"),
	FOREIGN KEY("season_name") REFERENCES "time_season"("t_season")
);
CREATE TABLE IF NOT EXISTS "CapacityCredit" (
	"regions"	text,
	"periods"	integer,
	"tech"	text,
	"vintage" integer,
	"cc_tech"	real CHECK("cc_tech" >= 0 AND "cc_tech" <= 1),
  "source" text,
	"cc_tech_notes"	text,
	PRIMARY KEY("regions","periods","tech","vintage")
);

COMMIT;
