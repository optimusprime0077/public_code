-- In this SQL file, write (and comment!) the typical SQL queries users will run on your database

------------------------------QUERY 1------------------------------
--See the 10 highest counties by GDP

--EXPLAIN QUERY PLAN

SELECT "gdp_2022", "unit", "counties"."county_name"
FROM "gdp"
JOIN "counties" ON "gdp"."county_code" = "counties"."code"
WHERE "description" = 'real_gdp'
AND "unit" = 'Thousands of chained 2017 dollars'
ORDER BY "gdp_2022" DESC
LIMIT 10;

-------------------------ANALYSIS 1-------------------------------

--Current query plan:
--SCAN gdp
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Because we will most commonly be searching the gdp table by its description based on what we want, it is best to create an index on this column
CREATE INDEX "gdp_description"
ON "gdp"("description");

--Final query plan:
--SEARCH gdp USING INDEX gdp_description (description=?)
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Clearly, SQLite now uses the index, reducing runtime by roughly .001 seconds


-----------------------QUERY 2----------------------------
--Highest gdp/population ratio


--EXPLAIN QUERY PLAN

SELECT "counties"."county_name", "gdp_2022", "population_2022", "gdp_2022"/"population_2022"
FROM "gdp"
JOIN "populations" ON "gdp"."county_code" = "populations"."county_code"
JOIN "counties" ON "gdp"."county_code" = "counties"."code"
WHERE "gdp"."description" = 'real_gdp'
ORDER BY "gdp_2022"/"population_2022" DESC
LIMIT 20;

---------------------------------------ANALYSIS 2--------------------------

--Current (and final, it looks like) query plan:
--SEARCH gdp USING INDEX gdp_description (description=?)
--SEARCH populations USING INDEX sqlite_autoindex_populations_1 (county_code=?)
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Firstly, we see once again the "gdp_description" index being used, showing how effective it is.
--Additionally, we see everything else is actually taken care of because of SQLite's autoindexes created on the "populations" and "counties" tables. Neat!

----------------------------QUERY 3---------------------------
--Counties with highest avg reading

--EXPLAIN QUERY PLAN

SELECT "county_code","counties"."county_name", ROUND(AVG("reading_average"),2)
FROM "illinois_SAT"
JOIN "counties" ON "counties"."code" = "illinois_SAT"."county_code"
GROUP BY "county_code"
ORDER BY AVG("reading_average") DESC
LIMIT 10;

--------------------ANALYSIS 3----------------------------

--Current query plan for this query:
--SCAN illinois_SAT
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--USE TEMP B-TREE FOR GROUP BY
--USE TEMP B-TREE FOR ORDER BY

--Everything is taken care of, except of course our "illinois_SAT" table, on which we need to create an index on the "county_code" table,
--because this is what is being used to join the two tables together.
CREATE INDEX "sat_county"
ON "illinois_SAT"("county_code");

--Final query plan for this query:

--SCAN illinois_SAT USING INDEX sat_county
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Now we see, we are still SCANning, but now on an INDEX, which Mr. Zenke menioned is much quicker than a SCAN on a regular column.
------------------------------QUERY 4------------------------------------------
--highest avg math

--EXPLAIN QUERY PLAN

SELECT "county_code","counties"."county_name", ROUND(AVG("math_average"),2)
FROM "illinois_SAT"
JOIN "counties" ON "counties"."code" = "illinois_SAT"."county_code"
GROUP BY "county_code"
ORDER BY AVG("math_average") DESC
LIMIT 10;


--Since this is the exact same as last query, except for the math column, nothing new is needed.

--------------------------QUERY 5-----------------------------------
--Counties (and state of the county) that had the biggest gdp increases from 2018 to 2022 (WORKS)

--EXPLAIN QUERY PLAN

SELECT "counties"."county_name", "states"."state_name", "gdp_2022" - "gdp_2018" AS "gdp_increase"
FROM "gdp" JOIN "counties" ON "gdp"."county_code" = "counties"."code"
JOIN "states" ON "counties"."state_code" = "states"."code"
WHERE "gdp_2018" IS NOT NULL
AND "gdp_2022" IS NOT NULL
AND "description" = 'real_gdp'
ORDER BY "gdp_2022" - "gdp_2018" DESC
LIMIT 10;

------------------------------------ANALYSIS 5-----------------------------------

--Current(and final again) query plan for this query:
--SEARCH gdp USING INDEX gdp_description (description=?)
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--SEARCH states USING INDEX sqlite_autoindex_states_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Again, we see out "gdp_description" index being used"
--SqLite autoindexes are being utilized again.

--------------------------QUERY 6---------------------------
--States that have the most counties

--EXPLAIN QUERY PLAN

SELECT "states"."state_name", COUNT("county_code")
FROM "states"
JOIN "counties"
ON "states"."code" = "counties"."state_code"
GROUP BY "counties"."state_code"
ORDER BY COUNT("county_code") DESC
LIMIT 10;

------------------------------ANALYSIS 6-------------------------------

--Current query plan for this query:
--SCAN counties
--SEARCH states USING INDEX sqlite_autoindex_states_1 (code=?)
--USE TEMP B-TREE FOR GROUP BY
--USE TEMP B-TREE FOR ORDER BY

--From this, we see that everything is taken care of except for the counties table.
--The most effective solution would be to create an index for this table on the state_code column.
--This would be used whenever we look for the state name based on some queries done to any of the 3 data tables
CREATE INDEX "counties_state"
ON "counties"("state_code");

--Final query plan for this query:
--SCAN counties USING COVERING INDEX counties_state
--SEARCH states USING INDEX sqlite_autoindex_states_1 (code=?)
--USE TEMP B-TREE FOR ORDER BY

--Now, even though it still shows as a SCAN, Mr. Zenke mentioned that a SCAN on a covering index is much faster on a SCAN on a regular column, so efficiency is improved.
---------------------------QUERY 7---------------------------

--States with the highest real gdp for year 2022
--EXPLAIN QUERY PLAN

SELECT "states"."state_name", SUM("gdp_2022")
FROM "states" JOIN "counties" ON "states"."code" = "counties"."state_code"
JOIN "gdp" ON "gdp"."county_code" = "counties"."code"
WHERE "gdp"."description" = 'real_gdp'
GROUP BY "counties"."state_code"
ORDER BY SUM("gdp_2022") DESC
LIMIT 10;

---------------------------------ANALYSIS 7--------------------------------

--Current (and final again) query plan:
--SEARCH gdp USING INDEX gdp_description (description=?)
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--SEARCH states USING INDEX sqlite_autoindex_states_1 (code=?)
--USE TEMP B-TREE FOR GROUP BY
--USE TEMP B-TREE FOR ORDER BY

--Again, we see our "gdp_description" index being used.
--And again, the autoindexes on the counties and states columns are used, meaning we dont really need to do anything.

----------------------------QUERY 8--------------------------------
--2022 GDP of counties in Illinois with highest average SAT score
--EXPLAIN QUERY PLAN

SELECT "counties"."county_name", "gdp"."gdp_2022", ROUND(AVG("reading_average" + "math_average"),2)
FROM "counties"
JOIN "gdp" ON "counties"."code" = "gdp"."county_code"
JOIN "illinois_SAT" ON "counties"."code" = "illinois_SAT"."county_code"
GROUP BY "illinois_SAT"."county_code"
ORDER BY AVG("reading_average" + "math_average") DESC
LIMIT 10;
-------------------------------ANALYSIS 8------------------------

--Current query plan for this query:
--SCAN gdp
--SEARCH counties USING INDEX sqlite_autoindex_counties_1 (code=?)
--SEARCH illinois_SAT USING AUTOMATIC COVERING INDEX (county_code=?)
--USE TEMP B-TREE FOR GROUP BY
--USE TEMP B-TREE FOR ORDER BY

--First, we need to create an index on the county_code column on the gdp table.
CREATE INDEX "gdp_county_code"
ON "gdp"("county_code");

--Final query plan for this query:
--SCAN illinois_SAT USING sat_county
--SEARCH counties USING INDEX sat_county (code=?)
--SEARCH gdp USING INDEX gdp_county (county_code=?)
--USE TEMP B-TREE FOR ORDER BY

--Also, if we are creating index on the county codes of the "gdp" and "illinois_SAT" table, we might as well create one for the populations table.
CREATE INDEX "populations_county_code"
ON "populations"("county_code");


---------------------------VIEWS-------------------
--Because we know that our SAT values only come from Illinois, it might be nice to have views for the gdp and populations that are just from illinois.
CREATE VIEW "illinois_gdp" AS
SELECT *
FROM "gdp"
WHERE substr("county_code",1,2)= '17';

CREATE VIEW "illinois_populations" AS
SELECT *
FROM "populations"
WHERE substr("county_code",1,2)= '17';

--Additionally, if we are too lazy to write JOIN statements, it would be nice to have one mega table, which is all 5 tables joined together.
--However, I dont reccomend it because it is very memory inefficient, so I will comment it out.
/*
CREATE VIEW "mega_table" AS
SELECT *
FROM "states"
JOIN "counties" ON "states"."code" = "counties"."state_code"
JOIN "gdp" ON "counties"."code" = "gdp"."county_code"
JOIN "illinois_SAT" ON "counties"."code" = "illinois_SAT"."county_code"
JOIN "populations" ON "counties"."code" = "populations"."county_code";
*/



