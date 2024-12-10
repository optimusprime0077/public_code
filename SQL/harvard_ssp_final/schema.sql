-- In this SQL file, write (and comment!) the schema of your database, including the CREATE TABLE, CREATE INDEX, CREATE VIEW, etc. statements that compose it

--Note, the indexes and views are located in the queries.sql file, because I thought it would help to see the indexes right next to the queries, as well as the views.
----------------------------------------------------------
--creates temporary tale for counties csv

CREATE TABLE "counties_temp" (
    "code" TEXT,
    "county_name" TEXT

);

.import --csv --skip 1 county_fips.csv counties_temp


------------------------------------------------------

--Adds the column for state code into the countiess_temp table, so we are able to join them by the 2 digit state fips when necessary
ALTER TABLE "counties_temp"
ADD COLUMN "state_code" TEXT;

--sets the value of the state code column
UPDATE "counties_temp"
SET "state_code" = SUBSTR("code",1,2);

------------------------------------------------------
------------------------------------------------------
--creates temporary table for states csv

CREATE TABLE "states_temp" (
    "code" TEXT,
    "state_name" TEXT
);
.import --csv --skip 1 state_fips.csv states_temp

--creates temporary table for states csv
------------------------------------------------------------
------------------------------------------------------------
--creates temporary table for gdp csv

CREATE TABLE "gdp_temp"(
    "county_fips" TEXT,
    "GeoNAME" TEXT,
    "Region"	 TEXT,
    "TableName"	 TEXT,
    "LineCode"	 TEXT,
    "IndustryClassification" TEXT,
    "Description"	 TEXT,
    "Unit"	 TEXT,
    "2017"	 TEXT,
    "2018"	 TEXT,
    "2019"	 TEXT,
    "2020"	 TEXT,
    "2021"	 TEXT,
    "2022"	 TEXT
);

.import --csv --skip 1 CAGDP1__ALL_AREAS_2017_2022.csv gdp_temp
----------------------------------------------------------------------
--shortens length of the "Description" column for style choice

UPDATE "gdp_temp"
SET "Description" = 'real_gdp'
WHERE "Description" LIKE '%Real GDP%';

UPDATE "gdp_temp"
SET "Description" = 'current_dollar_gdp'
WHERE "Description" LIKE '%Current-dollar GDP%';

UPDATE"gdp_temp"
SET "Description" = 'Chain-type Quantity Index'
WHERE "Description" LIKE 'chain-type%';
-------------------------------------------------------------------------
---------------------------------------------------------------------------
--Creates temporary table for SAT csv

CREATE TABLE "illinois_SAT_temp"(
    "RCDTS" TEXT,
    "Type" TEXT,
    "School Name" TEXT,
    "District" TEXT,
    "City" TEXT,
    "County" TEXT,
    "District Type" TEXT,
    "District Size" TEXT,
    "School Type" TEXT,
    "Grades Served" TEXT,
    "SAT Reading Average Score" TEXT,
    "SAT Math Average Score" TEXT,
    "SAT Reading Total Students Level 1 %" TEXT,
    "SAT Reading Total Students Level 2 %" TEXT,
    "SAT Reading Total Students Level 3 %" TEXT,
    "SAT Reading Total Students Level 4 %" TEXT,
    "SAT Math Total Students Level 1 %" TEXT,
    "SAT Math Total Students Level 2 %" TEXT,
    "SAT Math Total Students Level 3 %" TEXT,
    "SAT Math Total Students Level 4 %" TEXT,
    "SAT Reading Total Male Students Level 1 %" TEXT,
    "SAT Reading Total Male Students Level 2 %" TEXT,
    "SAT Reading Total Male Students Level 3 %" TEXT,
    "SAT Reading Total Male Students Level 4 %" TEXT,
    "SAT Math Total Male Students Level 1 %" TEXT,
    "SAT Math Total Male Students Level 2 %" TEXT,
    "SAT Math Total Male Students Level 3 %" TEXT,
    "SAT Math Total Male Students Level 4 %" TEXT,
    "SAT Reading Total Female Students Level 1 %" TEXT,
    "SAT Reading Total Female Students Level 2 %" TEXT,
    "SAT Reading Total Female Students Level 3 %" TEXT,
    "SAT Reading Total Female Students Level 4 %" TEXT,
    "SAT Math Total Female Students Level 1 %" TEXT,
    "SAT Math Total Female Students Level 2 %" TEXT,
    "SAT Math Total Female Students Level 3 %" TEXT,
    "SAT Math Total Female Students Level 4 %" TEXT,
    "SAT Reading Total White Students Level 1 %" TEXT,
    "SAT Reading Total White Students Level 2 %" TEXT,
    "SAT Reading Total White Students Level 3 %" TEXT,
    "SAT Reading Total White Students Level 4 %" TEXT,
    "SAT Math Total White Students Level 1 %" TEXT,
    "SAT Math Total White Students Level 2 %" TEXT,
    "SAT Math Total White Students Level 3 %" TEXT,
    "SAT Math Total White Students Level 4 %" TEXT,
    "SAT Reading Total Black or African American Students Level 1 %" TEXT,
    "SAT Reading Total Black or African American Students Level 2 %" TEXT,
    "SAT Reading Total Black or African American Students Level 3 %" TEXT,
    "SAT Reading Total Black or African American Students Level 4 %" TEXT,
    "SAT Math Total Black or African American Students Level 1 %" TEXT,
    "SAT Math Total Black or African American Students Level 2 %" TEXT,
    "SAT Math Total Black or African American Students Level 3 %" TEXT,
    "SAT Math Total Black or African American Students Level 4 %" TEXT,
    "SAT Reading Total Hispanic or Latino Students Level 1 %" TEXT,
    "SAT Reading Total Hispanic or Latino Students Level 2 %" TEXT,
    "SAT Reading Total Hispanic or Latino Students Level 3 %" TEXT,
    "SAT Reading Total Hispanic or Latino Students Level 4 %" TEXT,
    "SAT Math Total Hispanic or Latino Students Level 1 %" TEXT,
    "SAT Math Total Hispanic or Latino Students Level 2 %" TEXT,
    "SAT Math Total Hispanic or Latino Students Level 3 %" TEXT,
    "SAT Math Total Hispanic or Latino Students Level 4 %" TEXT,
    "SAT Reading Total Asian Students Level 1 %" TEXT,
    "SAT Reading Total Asian Students Level 2 %" TEXT,
    "SAT Reading Total Asian Students Level 3 %" TEXT,
    "SAT Reading Total Asian Students Level 4 %" TEXT,
    "SAT Math Total Asian Students Level 1 %" TEXT,
    "SAT Math Total Asian Students Level 2 %" TEXT,
    "SAT Math Total Asian Students Level 3 %" TEXT,
    "SAT Math Total Asian Students Level 4 %" TEXT,
    "SAT Reading Total Native Hawaiian or Other Pacific Islander Students Level 1 %" TEXT,
    "SAT Reading Total Native Hawaiian or Other Pacific Islander Students Level 2 %" TEXT,
    "SAT Reading Total Native Hawaiian or Other Pacific Islander Students Level 3 %" TEXT,
    "SAT Reading Total Native Hawaiian or Other Pacific Islander Students Level 4 %" TEXT,
    "SAT Math Total Native Hawaiian or Other Pacific Islander Students Level 1 %" TEXT,
    "SAT Math Total Native Hawaiian or Other Pacific Islander Students Level 2 %" TEXT,
    "SAT Math Total Native Hawaiian or Other Pacific Islander Students Level 3 %" TEXT,
    "SAT Math Total Native Hawaiian or Other Pacific Islander Students Level 4 %" TEXT,
    "SAT Reading Total American Indian or Alaska Native Students Level 1 %" TEXT,
    "SAT Reading Total American Indian or Alaska Native Students Level 2 %" TEXT,
    "SAT Reading Total American Indian or Alaska Native Students Level 3 %" TEXT,
    "SAT Reading Total American Indian or Alaska Native Students Level 4 %" TEXT,
    "SAT Math Total American Indian or Alaska Native Students Level 1 %" TEXT,
    "SAT Math Total American Indian or Alaska Native Students Level 2 %" TEXT,
    "SAT Math Total American Indian or Alaska Native Students Level 3 %" TEXT,
    "SAT Math Total American Indian or Alaska Native Students Level 4 %" TEXT,
    "SAT Reading Total Two or More Race Students Level 1 %" TEXT,
    "SAT Reading Total Two or More Race Students Level 2 %" TEXT,
    "SAT Reading Total Two or More Race Students Level 3 %" TEXT,
    "SAT Reading Total Two or More Race Students Level 4 %" TEXT,
    "SAT Math Total Two or More Race Students Level 1 %" TEXT,
    "SAT Math Total Two or More Race Students Level 2 %" TEXT,
    "SAT Math Total Two or More Race Students Level 3 %" TEXT,
    "SAT Math Total Two or More Race Students Level 4 %" TEXT,
    "SAT Reading Total Children with Disabilities Students Level 1 %" TEXT,
    "SAT Reading Total Children with Disabilities Students Level 2 %" TEXT,
    "SAT Reading Total Children with Disabilities Students Level 3 %" TEXT,
    "SAT Reading Total Children with Disabilities Students Level 4 %" TEXT,
    "SAT Math Total Children with Disabilities Students Level 1 %" TEXT,
    "SAT Math Total Children with Disabilities Students Level 2 %" TEXT,
    "SAT Math Total Children with Disabilities Students Level 3 %" TEXT,
    "SAT Math Total Children with Disabilities Students Level 4 %" TEXT,
    "SAT Reading Total EL Students Level 1 %" TEXT,
    "SAT Reading Total EL Students Level 2 %" TEXT,
    "SAT Reading Total EL Students Level 3 %" TEXT,
    "SAT Reading Total EL Students Level 4 %" TEXT,
    "SAT Math Total EL Students Level 1 %" TEXT,
    "SAT Math Total EL Students Level 2 %" TEXT,
    "SAT Math Total EL Students Level 3 %" TEXT,
    "SAT Math Total EL Students Level 4 %" TEXT,
    "SAT Reading Total IEP Students Level 1 %" TEXT,
    "SAT Reading Total IEP Students Level 2 %" TEXT,
    "SAT Reading Total IEP Students Level 3 %" TEXT,
    "SAT Reading Total IEP Students Level 4 %" TEXT,
    "SAT Math Total IEP Students Level 1 %" TEXT,
    "SAT Math Total IEP Students Level 2 %" TEXT,
    "SAT Math Total IEP Students Level 3 %" TEXT,
    "SAT Math Total IEP Students Level 4 %" TEXT,
    "SAT Reading Total Non-IEP Students Level 1 %" TEXT,
    "SAT Reading Total Non-IEP Students Level 2 %" TEXT,
    "SAT Reading Total Non-IEP Students Level 3 %" TEXT,
    "SAT Reading Total Non-IEP Students Level 4 %" TEXT,
    "SAT Math Total Non-IEP Students Level 1 %" TEXT,
    "SAT Math Total Non-IEP Students Level 2 %" TEXT,
    "SAT Math Total Non-IEP Students Level 3 %" TEXT,
    "SAT Math Total Non-IEP Students Level 4 %" TEXT,
    "SAT Reading Total Low Income Students Level 1 %" TEXT,
    "SAT Reading Total Low Income Students Level 2 %" TEXT,
    "SAT Reading Total Low Income Students Level 3 %" TEXT,
    "SAT Reading Total Low Income Students Level 4 %" TEXT,
    "SAT Math Total Low Income Students Level 1 %" TEXT,
    "SAT Math Total Low Income Students Level 2 %" TEXT,
    "SAT Math Total Low Income Students Level 3 %" TEXT,
    "SAT Math Total Low Income Students Level 4 %" TEXT,
    "SAT Reading Total Non-Low Income Students Level 1 %" TEXT,
    "SAT Reading Total Non-Low Income Students Level 2 %" TEXT,
    "SAT Reading Total Non-Low Income Students Level 3 %" TEXT,
    "SAT Reading Total Non-Low Income Students Level 4 %" TEXT,
    "SAT Math Total Non-Low Income Students Level 1 %" TEXT,
    "SAT Math Total Non-Low Income Students Level 2 %" TEXT,
    "SAT Math Total Non-Low Income Students Level 3 %" TEXT,
    "SAT Math Total Non-Low Income Students Level 4 %" TEXT,
    "SAT Reading Total Youth in Care Students Level 1 %" TEXT,
    "SAT Reading Total Youth in Care Students Level 2 %" TEXT,
    "SAT Reading Total Youth in Care Students Level 3 %" TEXT,
    "SAT Reading Total Youth in Care Students Level 4 %" TEXT,
    "SAT Math Total Youth in Care Students Level 1 %" TEXT,
    "SAT Math Total Youth in Care Students Level 2 %" TEXT,
    "SAT Math Total Youth in Care Students Level 3 %" TEXT,
    "SAT Math Total Youth in Care Students Level 4 %" TEXT,
    "SAT Reading Total Homeless Students Level 1 %" TEXT,
    "SAT Reading Total Homeless Students Level 2 %" TEXT,
    "SAT Reading Total Homeless Students Level 3 %" TEXT,
    "SAT Reading Total Homeless Students Level 4 %" TEXT,
    "SAT Math Total Homeless Students Level 1 %" TEXT,
    "SAT Math Total Homeless Students Level 2 %" TEXT,
    "SAT Math Total Homeless Students Level 3 %" TEXT,
    "SAT Math Total Homeless Students Level 4 %" TEXT,
    "SAT Reading Total Migrant Students Level 1 %" TEXT,
    "SAT Reading Total Migrant Students Level 2 %" TEXT,
    "SAT Reading Total Migrant Students Level 3 %" TEXT,
    "SAT Reading Total Migrant Students Level 4 %" TEXT,
    "SAT Math Total Migrant Students Level 1 %" TEXT,
    "SAT Math Total Migrant Students Level 2 %" TEXT,
    "SAT Math Total Migrant Students Level 3 %" TEXT,
    "SAT Math Total Migrant Students Level 4 %" TEXT,
    "SAT Reading Total Military Students Level 1 %" TEXT,
    "SAT Reading Total Military Students Level 2 %" TEXT,
    "SAT Reading Total Military Students Level 3 %" TEXT,
    "SAT Reading Total Military Students Level 4 %" TEXT,
    "SAT Math Total Military Students Level 1 %" TEXT,
    "SAT Math Total Military Students Level 2 %" TEXT,
    "SAT Math Total Military Students Level 3 %" TEXT,
    "SAT Math Total Military Students Level 4 %" TEXT,
    "# Students SAT Math Participation" TEXT,
    "# SAT Math Participation - Male" TEXT,
    "# SAT Math Participation - Female" TEXT,
    "# SAT Math Participation - White" TEXT,
    "# SAT Math Participation - Black or African American" TEXT,
    "# SAT Math Participation - Hispanic or Latino" TEXT,
    "# SAT Math Participation - Asian" TEXT,
    "# SAT Math Participation - Native Hawaiian or Other Pacific Islander" TEXT,
    "# SAT Math Participation - American Indian or Alaska Native" TEXT,
    "# SAT Math Participation - Two or More Race" TEXT,
    "# SAT Math Participation - Children with Disabilities" TEXT,
    "# SAT Math Participation - IEP" TEXT,
    "# SAT Math Participation - EL" TEXT,
    "# SAT Math Participation - Low Income" TEXT,
    "% Students SAT Math Participation " TEXT,
    "% SAT Math Participation - Male" TEXT,
    "% SAT Math Participation - Female" TEXT,
    "% SAT Math Participation - White" TEXT,
    "% SAT Math Participation - Black or African American" TEXT,
    "% SAT Math Participation - Hispanic or Latino" TEXT,
    "% SAT Math Participation - Asian" TEXT,
    "% SAT Math Participation - Native Hawaiian or Other Pacific Islander" TEXT,
    "% SAT Math Participation - American Indian or Alaska Native" TEXT,
    "% SAT Math Participation - Two or More Race" TEXT,
    "% SAT Math Participation - Children with Disabilities" TEXT,
    "% SAT Math Participation - IEP" TEXT,
    "% SAT Math Participation - EL" TEXT,
    "% SAT Math Participation - Low Income" TEXT,
    "# Students SAT ELA Participation" TEXT,
    "# SAT ELA Participation - Female" TEXT,
    "# SAT ELA Participation - Male" TEXT,
    "# SAT ELA Participation - White" TEXT,
    "# SAT ELA Participation - Black or African American" TEXT,
    "# SAT ELA Participation - Hispanic or Latino" TEXT,
    "# SAT ELA Participation - Asian" TEXT,
    "# SAT ELA Participation - Native Hawaiian or Other Pacific Islander" TEXT,
    "# SAT ELA Participation - American Indian or Alaska Native" TEXT,
    "# SAT ELA Participation - Two or More Race" TEXT,
    "# SAT ELA Participation - Children with Disabilities" TEXT,
    "# SAT ELA Participation - IEP" TEXT,
    "# SAT ELA Participation - EL" TEXT,
    "# SAT ELA Participation - Low Income" TEXT,
    "% SAT ELA Participation" TEXT,
    "% SAT ELA Participation - Female " TEXT,
    " % SAT ELA Participation - Male" TEXT,
    "% SAT ELA Participation - White" TEXT,
    "% SAT ELA Participation - Black or African American" TEXT,
    "% SAT ELA Participation - Hispanic or Latino" TEXT,
    "% SAT ELA Participation - Asian" TEXT,
    "% SAT ELA Participation - Native Hawaiian or Other Pacific Islander" TEXT,
    "% SAT ELA Participation - American Indian or Alaska Native" TEXT,
    "% SAT ELA Participation - Two or More Race" TEXT,
    "% SAT ELA Participation - Children with Disabilities" TEXT,
    "% SAT ELA Participation - IEP" TEXT,
    "% SAT ELA Participation - EL" TEXT,
    "% SAT ELA Participation - Low Income" TEXT,
    "SAT ELA No Participation Rate - Total" TEXT,
    "SAT ELA No Participation Rate - White" TEXT,
    "SAT ELA No Participation Rate - Black or African American" TEXT,
    "SAT ELA No Participation Rate - Hispanic or Latino" TEXT,
    "SAT ELA No Participation Rate - Asian" TEXT,
    "SAT ELA No Participation Rate - Native Hawaiian or Other Pacific Islander" TEXT,
    "SAT ELA No Participation Rate - American Indian or Alaska Native" TEXT,
    "SAT ELA No Participation Rate - Two or More Races" TEXT,
    "SAT ELA No Participation Rate - Male" TEXT,
    "SAT ELA No Participation Rate - Female" TEXT,
    "SAT ELA No Participation Rate - CWD" TEXT,
    "SAT ELA No Participation Rate - IEP" TEXT,
    "SAT ELA No Participation Rate - EL" TEXT,
    "SAT ELA No Participation Rate - Low Income" TEXT,
    "SAT Math No Participation Rate - Total" TEXT,
    "SAT Math No Participation Rate - White" TEXT,
    "SAT Math No Participation Rate - Black or African American" TEXT,
    "SAT Math No Participation Rate - Hispanic or Latino" TEXT,
    "SAT Math No Participation Rate - Asian" TEXT,
    "SAT Math No Participation Rate - Native Hawaiian or Other Pacific Islander" TEXT,
    "SAT Math No Participation Rate - American Indian or Alaska Native" TEXT,
    "SAT Math No Participation Rate - Two or More Races" TEXT,
    "SAT Math No Participation Rate - Male" TEXT,
    "SAT Math No Participation Rate - Female" TEXT,
    "SAT Math No Participation Rate - CWD" TEXT,
    "SAT Math No Participation Rate - IEP" TEXT,
    "SAT Math No Participation Rate - EL" TEXT,
    "SAT Math No Participation Rate - Low Income" TEXT
);
.import --csv --skip 1 Illinois_School_Report_Card_SAT.csv illinois_SAT_temp
---------------------------------------------
--ultimately, the lines below creates a column for the county code by mapping the county names from this table and the temporary counties table
--(Note: this is what was referred to in the video on the "illinois_SAT" slide in the text at the bottom)

ALTER TABLE "illinois_SAT_temp"
ADD COLUMN "county_name" TEXT;

UPDATE "illinois_SAT_temp"
SET "county_name" = "county" || ' County';

ALTER TABLE "illinois_SAT_temp"
ADD COLUMN "county_code" TEXT;

UPDATE "illinois_SAT_temp"
SET "county_code" = '17' ||
(SELECT substr("code",3,3)
FROM "counties_temp"
WHERE "county_name" = "illinois_SAT_temp"."county_name" -- This is the column that was used to map the two tables: it was the only commonality between the two, but fortunately it is enough
AND "state_code" = '17');
---------------------------------------------
---------------------------------------------
--creates temporary table for population csv

CREATE TABLE "populations_temp" (
    "SUMLEV" TEXT,
    "STATE" TEXT,
    "COUNTY" TEXT,
    "STNAME" TEXT,
    "CTYNAME" TEXT,
    "YEAR" TEXT,
    "POPESTIMATE" TEXT,
    "POPEST_MALE" TEXT,
    "POPEST_FEM" TEXT,
    "UNDER5_TOT" TEXT,
    "UNDER5_MALE" TEXT,
    "UNDER5_FEM" TEXT,
    "AGE513_TOT" TEXT,
    "AGE513_MALE" TEXT,
    "AGE513_FEM" TEXT,
    "AGE1417_TOT" TEXT,
    "AGE1417_MALE" TEXT,
    "AGE1417_FEM" TEXT,
    "AGE1824_TOT" TEXT,
    "AGE1824_MALE" TEXT,
    "AGE1824_FEM" TEXT,
    "AGE16PLUS_TOT" TEXT,
    "AGE16PLUS_MALE" TEXT,
    "AGE16PLUS_FEM" TEXT,
    "AGE18PLUS_TOT" TEXT,
    "AGE18PLUS_MALE" TEXT,
    "AGE18PLUS_FEM" TEXT,
    "AGE1544_TOT" TEXT,
    "AGE1544_MALE" TEXT,
    "AGE1544_FEM" TEXT,
    "AGE2544_TOT" TEXT,
    "AGE2544_MALE" TEXT,
    "AGE2544_FEM" TEXT,
    "AGE4564_TOT" TEXT,
    "AGE4564_MALE" TEXT,
    "AGE4564_FEM" TEXT,
    "AGE65PLUS_TOT" TEXT,
    "AGE65PLUS_MALE" TEXT,
    "AGE65PLUS_FEM" TEXT,
    "AGE04_TOT" TEXT,
    "AGE04_MALE" TEXT,
    "AGE04_FEM" TEXT,
    "AGE59_TOT" TEXT,
    "AGE59_MALE" TEXT,
    "AGE59_FEM" TEXT,
    "AGE1014_TOT" TEXT,
    "AGE1014_MALE" TEXT,
    "AGE1014_FEM" TEXT,
    "AGE1519_TOT" TEXT,
    "AGE1519_MALE" TEXT,
    "AGE1519_FEM" TEXT,
    "AGE2024_TOT" TEXT,
    "AGE2024_MALE" TEXT,
    "AGE2024_FEM" TEXT,
    "AGE2529_TOT" TEXT,
    "AGE2529_MALE" TEXT,
    "AGE2529_FEM" TEXT,
    "AGE3034_TOT" TEXT,
    "AGE3034_MALE" TEXT,
    "AGE3034_FEM" TEXT,
    "AGE3539_TOT" TEXT,
    "AGE3539_MALE" TEXT,
    "AGE3539_FEM" TEXT,
    "AGE4044_TOT" TEXT,
    "AGE4044_MALE" TEXT,
    "AGE4044_FEM" TEXT,
    "AGE4549_TOT" TEXT,
    "AGE4549_MALE" TEXT,
    "AGE4549_FEM" TEXT,
    "AGE5054_TOT" TEXT,
    "AGE5054_MALE" TEXT,
    "AGE5054_FEM" TEXT,
    "AGE5559_TOT" TEXT,
    "AGE5559_MALE" TEXT,
    "AGE5559_FEM" TEXT,
    "AGE6064_TOT" TEXT,
    "AGE6064_MALE" TEXT,
    "AGE6064_FEM" TEXT,
    "AGE6569_TOT" TEXT,
    "AGE6569_MALE" TEXT,
    "AGE6569_FEM" TEXT,
    "AGE7074_TOT" TEXT,
    "AGE7074_MALE" TEXT,
    "AGE7074_FEM" TEXT,
    "AGE7579_TOT" TEXT,
    "AGE7579_MALE" TEXT,
    "AGE7579_FEM" TEXT,
    "AGE8084_TOT" TEXT,
    "AGE8084_MALE" TEXT,
    "AGE8084_FEM" TEXT,
    "AGE85PLUS_TOT" TEXT,
    "AGE85PLUS_MALE" TEXT,
    "AGE85PLUS_FEM" TEXT,
    "MEDIAN_AGE_TOT" TEXT,
    "MEDIAN_AGE_MALE" TEXT,
    "MEDIAN_AGE_FEM" TEXT
);

.import --csv --skip 1 cc-est2023-agesex-all.csv populations_temp
---------------------------------------------
--adds a column for the county code
ALTER TABLE "populations_temp"
ADD COLUMN "county_fips";

UPDATE "populations_temp"
SET "county_fips" = "STATE" || "COUNTY";

--creates a second temporary table that will allow us in the future to pivot the data.
CREATE TABLE "populations_temp2" (
    "county_code" TEXT,
    "year" TEXT,
    "population" INTEGER
);

--This makes sure that we only add population data from counties that are in the temporary counties table. This is to ensure that the data matches.
INSERT INTO "populations_temp2" ("county_code", "year", "population")
SELECT "county_fips", "YEAR", "POPESTIMATE" FROM "populations_temp"
WHERE "county_fips" IN (
    SELECT DISTINCT("code")
    FROM "counties_temp");

--changes year column from 1-5 to 2018-2022 for style choice

UPDATE "populations_temp2"
SET "year" = '2018'
WHERE "year" = '1';

UPDATE "populations_temp2"
SET "year" = '2019'
WHERE "year" = '2';

UPDATE "populations_temp2"
SET "year" = '2020'
WHERE "year" = '3';

UPDATE "populations_temp2"
SET "year" = '2021'
WHERE "year" = '4';

UPDATE "populations_temp2"
SET "year" = '2022'
WHERE "year" = '5';
---------------------------------------------
---------------------------------------------
---------------------------------------------
--FINAL TABLES
----------------------------------------------
--creates table for states

CREATE TABLE "states" (
    "id" INTEGER,
    "code" TEXT NOT NULL UNIQUE,
    "state_name" TEXT NOT NULL UNIQUE,
    PRIMARY KEY("id")
);
--inserts values
INSERT INTO "states" ("code", "state_name")
SELECT "code", "state_name" FROM "states_temp";

--creates table for counties

CREATE TABLE "counties" (
    "id" INTEGER,
    "code" TEXT NOT NULL UNIQUE,
    "county_name" TEXT NOT NULL,
    "state_code" TEXT,
    PRIMARY KEY ("id"),
    FOREIGN KEY ("state_code") REFERENCES "states"("code")
);
--inserts values

INSERT INTO "counties" ("code", "county_name","state_code")
SELECT "code", "county_name", "state_code" FROM "counties_temp"
WHERE substr("code",3,3) != '000';
-- We dont want any states or the whole USA in this table, just counties. (Any fips code ending in 3 zeroes is not a county. It is either a state, or the whole USA if 00000)
--------------------------------------------
--creates table for gdp

CREATE TABLE "gdp" (
    "id" INTEGER,
    "county_code" TEXT,
    "description" TEXT NOT NULL CHECK("description" IN ('real_gdp', 'current_dollar_gdp', 'Chain-type Quantity Index')),
    "unit" TEXT NOT NULL,
    "gdp_2018" REAL,
    "gdp_2019" REAL,
    "gdp_2020" REAL,
    "gdp_2021" REAL,
    "gdp_2022" REAL,
    PRIMARY KEY("id"),
    FOREIGN KEY ("county_code") REFERENCES "counties"("code")
);
--Insert relevant columns where the county is in the counties table itself.
--This is just like what we did earlier with the populations_temp2 table to ensure all tables can be joint.

INSERT INTO "gdp" ("county_code", "description", "unit","gdp_2018","gdp_2019","gdp_2020","gdp_2021","gdp_2022")
SELECT substr("county_fips",3,5), "Description", "Unit", "2018", "2019", "2020", "2021", "2022"
FROM "gdp_temp"
WHERE substr("county_fips",3,5) IN (
    SELECT DISTINCT("code")
    FROM "counties");

--changes values from (NA) to NULL

UPDATE "gdp"
SET "gdp_2018" = NULL
WHERE "gdp_2018" = '(NA)';

UPDATE "gdp"
SET "gdp_2019" = NULL
WHERE "gdp_2019" = '(NA)';

UPDATE "gdp"
SET "gdp_2020" = NULL
WHERE "gdp_2020" = '(NA)';

UPDATE "gdp"
SET "gdp_2021" = NULL
WHERE "gdp_2021" = '(NA)';

UPDATE "gdp"
SET "gdp_2022" = NULL
WHERE "gdp_2022" = '(NA)';
-------------------------------------------
--creates table for sat data

CREATE TABLE "illinois_SAT"(
    "id" INTEGER,
    "county_code" TEXT,
    "school_name" TEXT NOT NULL,
    "reading_average" REAL,
    "math_average" REAL,
    PRIMARY KEY("id"),
    FOREIGN KEY ("county_code") REFERENCES "counties"("code")

);
--inserts relevant values, once again only adding rows where the county code is in the counties table.
INSERT INTO "illinois_SAT" ("county_code", "school_name", "reading_average", "math_average")
SELECT "county_code", "School Name", "SAT Reading Average Score", "SAT Math Average Score"
FROM "illinois_SAT_temp"
WHERE "School Name" LIKE '%High School%' -- We only want high schools, because middle schools and lower dont have SAT data, but the csv still has them
AND "county_code" IN (
    SELECT DISTINCT("code")
    FROM "counties");
--sets blank values to NULL

UPDATE "illinois_SAT"
SET "reading_average" = NULL
WHERE "reading_average" = '';

UPDATE "illinois_SAT"
SET "math_average" = NULL
WHERE "math_average" = '';
-------------------------------------------
--creates final table for population data

CREATE TABLE "populations"(
    "id" INTEGER,
    "county_code" TEXT NOT NULL UNIQUE,
    "population_2018" INTEGER NOT NULL,
    "population_2019"INTEGER NOT NULL,
    "population_2020"INTEGER NOT NULL,
    "population_2021" INTEGER NOT NULL,
    "population_2022" INTEGER NOT NULL,
    PRIMARY KEY ("id"),
    FOREIGN KEY("county_code") REFERENCES "counties"("code")
);
--pivots the table from rows into columns for normalization

INSERT INTO "populations" ("county_code", "population_2018", "population_2019", "population_2020", "population_2021", "population_2022")
SELECT
    "county_code",
    MAX(CASE WHEN "year" = '2018' THEN "population" ELSE NULL END),
    MAX(CASE WHEN "year" = '2019' THEN "population" ELSE NULL END),
    MAX(CASE WHEN "year" = '2020' THEN "population" ELSE NULL END),
    MAX(CASE WHEN "year" = '2021' THEN "population" ELSE NULL END),
    MAX(CASE WHEN "year" = '2022' THEN "population" ELSE NULL END)
FROM
    "populations_temp2"
GROUP BY
    "county_code";


----------INDEXES and VIEWS-----------
--Note: as per the instructions online, I am supposed to include indexes and views in the schema.sql file. So, I will do that.
--However, the reasoning behind each index and view you see below is located in queries.sql.

CREATE INDEX "gdp_description"
ON "gdp"("description");

CREATE INDEX "sat_county"
ON "illinois_SAT"("county_code");

CREATE INDEX "counties_state"
ON "counties"("state_code");

CREATE INDEX "gdp_county_code"
ON "gdp"("county_code");

CREATE INDEX "populations_county_code"
ON "populations"("county_code");
-------------VIEWS-----------------------
CREATE VIEW "illinois_gdp" AS
SELECT *
FROM "gdp"
WHERE substr("county_code",1,2) = '17';

CREATE VIEW "illinois_populations" AS
SELECT *
FROM "populations"
WHERE substr("county_code",1,2) = '17';








