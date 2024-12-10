# Design Document

By Shreyas Dandavate

Video overview:

High definition: (200 MB): https://drive.google.com/file/d/1gd-qpnvJ3t1OxAXwR7jhxqlVkTzji-lK/view?usp=sharing
Low definition (30 MB): https://drive.google.com/file/d/15L3DHXBreavdqZm953gRnj36CHUmskUz/view?usp=sharing

Link to slideshow: https://docs.google.com/presentation/d/10JBMPD_2iwtwzl5dHHpkSfKOVhrwUjxkqVZSkBdd1XA/edit?usp=sharing


You might have seen some confusing text at the bottom of the illinois_SAT slide - this will be explained in this file.
It just explains how I created the county_code column, since is was not originally in the csv.

Also, the output table on the Conclusion slide is very blurry, I apologize for this.
You will see the table towards the end of this file though, if you are curious!

Links to Raw Data:

https://apps.bea.gov/regional/zip/CAGDP1.zip
https://www2.census.gov/programs-surveys/popest/datasets/2020-2023/counties/asrh/cc-est2023-agesex-all.csv
https://www.isbe.net/Pages/Illinois-State-Report-Card-Data.aspx
https://transition.fcc.gov/oet/info/maps/census/fips/fips.txt

## Scope
### Note: The SAT data is only from Illinois; There is no centralized csv of nationwide SAT data.
In this section you should answer the following questions:

* What is the purpose of your database?

The purpose of my database is to create a schema that allows one to gain insights on the correlation between SAT score, GDP, and population by county in the USA.
These things might seem unrelated, but can still be correlated together, meaning certain columns could be used to predict others.
This could help parents trying to decide which city to move into that has a high GDP and good SAT scores, among many other concepts.

* Which people, places, things, etc. are you including in the scope of your database?

In my database, we have tables for `counties` and `states` defined by their fips code. In addition, we also have tables to store populations, GDP and Schools.
Although schools can have many attributes(columns), we will only be focusing on the SAT data of the schools. If we wanted to, we could add other features, such as founding date, etc.
The 5 digit fips by county are the basis of the schema and connect the name of a county to its fips code, which is what is used in the 3 other data tables (`gdp`, `illinois_SAT`, `populations`).

* Which people, places, things, etc. are *outside* the scope of your database?

As just mentioned, the SAT table only contains schools in Illinois. This is because there was no nationwide dataset available for SAT scores at the school and county level.
However, if we wanted to, we could find all csvs for each state, and either import them all, or combine them into one huge table.
The idea of my project is just to show what we would do given a portion of the data. In this case, the portion being just one state.


## Functional Requirements

In this section you should answer the following questions:

* What should a user be able to do with your database?

A user should be able to utilize queries to answer complex questions concerning SAT scores (Illinois), GDP (nationwide), and population(nationwide) by county.
For instance, what was the GDP of the county (in Illinois, of course) with the highest average SAT math score?
or find the counties with the highest GDP divided by population ratio in 2021(GDP per capita), etc.

* What's beyond the scope of what a user should be able to do with your database?

Something that a user would most likely not be able to do, is analyze trends in SAT scores, because the table only contains the 2022 school year,
whereas the `gdp` and `populations` tables contain 2018-2022.

Something else the user would not be able to do is definitively state any causality between variables.
This is because as of my knowledge, SQLite does not have any hypothesis testing functionality, we cannot prove or disprove anything. However, the data queried from my database can be
used in other statistical tools such as R or Python to do in-depth statistical analysis.



## Representation

### Entities

#### `states` table

The `states` table has:
* an `id` `PRIMARY KEY`, as we are used to in this course
* a `TEXT` column `code` for the 2 digit state code, which has a `NOT NULL`and `UNIQUE` constraint (you will see why even though it is an integer, I choose `TEXT` for fips codes later)
* a `TEXT` column `state_name` for the name of the state, which is also `NOT NULL`and `UNIQUE`

#### `counties` table

The `counties` table has:
* an `id` `PRIMARY KEY`
* a `TEXT` column `code` for the 5 digit county code, which has a `NOT NULL`and `UNIQUE` constraint
* a `TEXT` column `county_name` that has the name of the county, which has a `NOT NULL`constraint. There are multiple counties in USA with the same name, so we actually cannot put a `UNIQUE` constraint here.
* a `TEXT` column `state_code` for the 2 digit state code that the county is in, taken as the first 2 digits of the county code.
This column is a `FOREIGN KEY` that REFERENCES the `code` column in the `states` table. It will be used whenever we need to join `states` and `counties`, which you will see is quite often

#### `gdp` table

The `gdp` table has:
* an `id` `PRIMARY KEY` like usual
* a `TEXT` column `county_code`, which is a `FOREIGN KEY` that REFERENCES the `code` COLUMN in the `counties` table. This will be used to create a joint table. It cannot be `UNIQUE`, as each county has 3 rows (more on this soon)
* a `TEXT` column `description` for the 3 types of gdp descriptions(real, current dollar, and quantity index). There will be a `NOT NULL`and `CHECK` constraint on this column to ensure we dont have any bad descriptions
* a `TEXT` column `unit` for the unit of the measurement of gdp, which has a `NOT NULL`constraint.
* a `REAL` column for each of the years 2018-2022 of gdp values. These columns do not have a `NOT NULL`constraint because some entries have missing data.
In this table, each county has 3 rows, one for each type of GDP.

#### `illinois_SAT` table

The `illinois_SAT` table has:
* an `id` `PRIMARY KEY`
* a `TEXT` column `county_code` column, which is the `FOREIGN KEY` that REFERENCES the `code` column in `counties` We cannot make this column `UNIQUE` because we have multiple schools in the same county.
* a `TEXT` column `school_name` column, which is just the name of the school. This column has a `NOT NULL`constraint, but not a `UNIQUE` contraint because 2 schools could (unlikely) have the same name
* a `REAL` column `reading_average`, which is the average SAT reading score for that school. There is no `NOT NULL`constraint because some values are missing.
* a `REAL` column `math_average`, which is the average SAT math score for that school. There is no `NOT NULL`constraint because some values are missing.

#### `populations` table

The `populations` table has:
* an `id` `PRIMARY KEY`
* a `TEXT` `county_code` column, which is the `FOREIGN KEY` that REFERENCES the `code` column in `counties`. I believe we could make this `UNIQUE`, but for the sake of consistency with other tables, I did not
* 5 `INTEGER` columns, one for each year 2018-2022 (inclusive) that has the population for that year. Fortunately, we are able to put `NOT NULL`constraints on these, because there are no missing values



### Relationships

In this section you should include your entity relationship diagram and describe the relationships between the entities in your database.

https://drive.google.com/file/d/1calJOHwwmgpOIq_yYO5w_AF2myzoAcEN/view?usp=sharing


As seen in the diagram, states have ONE OR MANY counties. (They all have multiple, but just to be safe, I included the ONE option).
Of course, each county belongs to exactly ONE state.

Counties have exactly ONE (or zero, if it is unreported) population number per year.
That population belongs to exactly ONE county.

Counties have ZERO or MANY TYPES of reported GDP.
(Usually, there will be 3 types for each county, unless they are unreported, in which case it will be less than 3.)
Note, if you wanted to consider it in another way, you could say each COUNTY has exactly ONE (or zero if unreported) TYPE of each GDP,
but I chose to say MANY gdps, because each county takes up more than one row in the final table for gdp, as you will see.

## Optimizations

Explained in queries.sql

## Limitations

In this section you should answer the following questions:

* What are the limitations of your design?

Because my project is very data analysis focused, I will not be creating any TRIGGERS, because a data scientist would not likely be creating triggers.
They would only be concerned about ensuring the data we have is correct, easy to work with, and cohesive with other data

* What might your database not be able to represent very well?

Something that my database would not be able to represent well is anything that is not connected to a county fips code that has data for more than one state in the US.
This is because as seen with the SAT table, even if we could find the county name, the data would need to only be from one state, otherwise we could have collisions
where there is more than one state in the us with that same county name.

## PROCESS

VERY IMPORTANT NOTE: FOR THE FINAL TABLES, IF ANY COLUMN IS MISSING A `NOT NULL`CONSTRAINT, IT IS BECAUSE THERE ARE MISSING VALUES FOR THAT COLUMN SOMEWHERE IN THE CSV
(not because of design flaw), and I replace them with NULL

The ## Process is a section I added that will contain an exact top to bottom order of what I did in the schema.sql file.
It should be very easy to follow along with my schema.sql and see what each section of code does there through my writings in this section here.

### DATA RETRIEVAL AND BASIC CLEANING

#### 1. Import the state and county csvs into temporary tables.
To do this, I created 2 tables, `states_temp`, and `counties_temp`, with columns for each of the columns directly in the csv file.(No primary keys yet!)
as `TEXT` affinities (even the fips code!), for reasons you will see later in this section.

So I imported the values from the csvs into their respective tables.
Now, you will find that I used an ALTER TABLE on the `counties_temp` table to ADD a COLUMN called `state_code`.
I set this column to be the substring of the county fips, where it was just the first two digits.
This will allow us to create joint tables connecting the counties and states tables by the 2 digit state code being the common key.
This is a reason why I made the fips code columns `TEXT`, even though they are numbers.

#### 2. Import the GDP csv into a temporary table, and make modifications.

To do this, I created a table `gdp_temp`, with all the columns from the csv file, which can be seen in the schema.sql file.
Because I was unable to find out how to directly select certain columns that we wanted,
I decided I would simply leave out unwanted columns when we inserted the values from the temp table into the final table.
This is why you will see the temp table has so many unnecessary columns.
Additionally, all the column type affinities are set to `TEXT`, because I was unsure if any of the thousands of rows had a string where there should have been a number, so just to be safe, I made all type affinities `TEXT`.
They will be converted to reals and integers at the final table when appropriate.
After I imported the gdp csv into `gdp_temp`, you will see three UPDATE statements on the `Description` column here. These just shorten the names of the type of gdp each row contains – nothing fancy.

#### 3. Import the SAT csv into a temporary table, and make modifications.

To do this, I created a table `illinois_SAT_temp` (because the csv only contains data from Illinois) with all the columns from the csv file itself.
As you can see, there are a lot of unwanted columns, which is unfortunate because the schema.sql file has a lot of physical space taken up by those columns
which I don't even intend to use in the final tables.

Additionally, after I imported the SAT csv into the table, you will see an ALTER TABLE statement on `illinois_SAT_temp` where I ADDED a COLUMN `county_name`.
This new column is simply the current `county` column concatenated with the word ‘County’ at the end.
This will allow us to create a column for the county code by mapping the county names to the county names in the `counties_temp` table where the state is Illinois.
Then, I create the new column `county_code` in the table, and use a subquery to map the county names between tables to find the 3 digit county code.
Then, I concatenate this to the string 17, and voila, we have our county codes.
Now, it all makes sense why I made the fips codes all `TEXT` and not `INTEGER`, because if they were integers, I would not be able to use substrings and concatenation like this and greatly simplify
the process of making the tables cohesive.

#### 4. Import the population csv into a temporary table(s), and make modifcations.

First, I followed the same process as before, creating a `TEXT` type affinity for all columns in the CSV.
After I imported all the values into the table, you will find an ALTER TABLE statement where I ADDED a COLUMN called county_fips.
This column is the CONCATENATION of two pre-existing columns, `STATE`, and `COUNTY`, which when concatenated, provide the 5 digit county_fips code that we should be very accustomed to seeing by now!

After this, you will see a creation of a second temporary table called `populations_temp2` (still no affinities (except `TEXT`) or keys).
I wanted to create a second temporary table here so that in the final table section, we can focus on the pivot operation,
which I don't want to be surrounded by anything.
So, then I imported the relevant columns from `populations_temp` to `populations_temp2`

Then, you will see 5 UPDATE statements, which simply change the `year` column to be the exact year 2018-2022 rather than 1-5. Nothing fancy.

### TRANSFERING RELEVANT DATA TO FINAL TABLES + FINAL CLEANING - Note: table columns and constraints are explained further in the ENTITIES section

#### 5. Transfer states and counties values from temp tables to final tables `states` and `counties`

Firstly, I created two new tables, `states`, and `counties`, which will house our final data for their corresponding temp tables.
I created a `PRIMARY KEY` `id` with `INTEGER` type affinity, which I will do for all final tables.
(Note: When inserting into any final table, I will not insert into the `id` column, because sqlite will automatically generate values for the primary key column using the built-in auto-increment feature).
Firstly, I inserted the values into the `states` table from `states_temp`
Then with counties, you will see I created the relevant columns with proper constraints that are explained in the ENTITIES section.
However, when I INSERT the values into this table, you will see the line:
WHERE substr(`code`,3,3) != '000';
This ensures we don't have any states or the whole USA in our table, because any fips code that ends in three zeroes is not a county.

At this point, you might ask: if we already made all tables have a county fips code column, why do we still need a `TEXT` type for all these? Well, if we make them `INTEGER`, all zeroes before the numbers will be
cut out. This can make readability confusing when we see a 4 digit fips code.
It should be possible, but to me, I just chose to keep them as `TEXT`. I will do this for all fips columns in other tables to be consistent.

#### 6. Transfer GDP values from `gdp_temp` to final table `gdp` + final cleaning.

To do this, I created the `id` `INTEGER` column which would be our `PRIMARY KEY`, as usual.
Additionally, I created relevant columns for all columns mentioned in the video, as seen in the schema.sql file for the
final creation of the `gdp` table, and explained in the ENTITIES section.
Finally, I inserted the values from the `gdp_temp` table into the final `gdp` table.
Now, you might get confused as to why I am taking a substring(3,3) of the county code from the table,
this is because the first two characters in the csv for the county code are a space and a double quote, and then the 5 digits. So, we obviously don't want those
unwanted characters.
After this, you will see 5 UPDATE statements. These just set missing values from (NA) to NULL in each of the 5 gdp columns by year.
I chose to do this cleaning here rather than in the temp tables so that it would make sense why we do not apply the `NOT NULL`constraint to the tables,
because we are setting values to NULL here.

#### 7. Transfer SAT values from `illinois_SAT_temp` to final table `illinois_SAT` + final cleaning.

To do this, I made the relevant columns with their relevant type affinities, but if you look at the segment where I inserted the values from the temp table to the final one,
you will see the following interesting condition:
WHERE `School Name` LIKE ‘%High School%’;
I wrote this because the raw SAT csv contains ALL schools in Illinois, including elementary and middle schools, which obviously have no values for the reading and math SAT score columns.
So I thought, instead of cluttering our final table with values we know are going to be empty, we should just filter them out.
This is why I am only selecting schools with ‘High School’ in their name, because only high school students take the SAT.
Of course, some high schools still do not have reading/math values, but this is unavoidable.
After this, you will see 2 UPDATE statements. These just these missing values from an empty string to NULL.
Kind of the same logic here as the `gdp` table

#### 8. Transfer population values from `populations_temp2` to final table `populations` + PIVOTING.

Again, I created an id column, and transferred the relevant values, as seen in schema.sql. Now, you will see where the magic happens.
I had to search the SQLite3 documentation for how to pivot (https://www.sqlitetutorial.net/sqlite-case/), and I produced the code you see.
The most important line occurs 5 times, once for each year. Here is one of them:

`MAX(CASE WHEN "year" = "2018" THEN "population" ELSE NULL END)`

Lets see what each keyword does:

* The `MAX` statement simply acts as a way to aggregate each row, but since there is only one value, it just selects that.
* The `CASE` statement creates a case, or condition that will either be true or false for each row.
* The `WHEN` statement is that condition here, when the year from `populations_temp2` is equal to the year we want.
* For each row, one of the 5 cases will be true, because each row is one of the 5 years! When the case is satisfied, THEN we will take the data in the `population` column for that row.
* If the row is not the year we are looking for, (`ELSE`) we select a `NULL` value and do nothing
Then the CASE `END`s.
And when we have 5 of these statements, one for each year, we effectively pivot our data when we insert it into our final `populations` table.

### CREATING QUERIES AND INDEXES

Note: all the explanations for this part are located in the queries.sql file itself.
I wanted to do it there so for your ease of readability, as the QUERY PLAN can be seen right next to the query itself, as well as my explanations for creating relevant indexes and views.

### DATA CONCLUSIONS (The fun part)

This is not a part of the schema.sql file itself.
Rather, it is the output of each of the 7 queries included there. This is the fun part where I will explain what I could guess, based on the output.

#### Query 1(counties with highest real GDP)

|  gdp_2022   |               unit                |    county_name     |
|-------------|-----------------------------------|--------------------|
| 790016435.0 | Thousands of chained 2017 dollars | Los Angeles County |
| 780965530.0 | Thousands of chained 2017 dollars | New York County    |
| 417565020.0 | Thousands of chained 2017 dollars | Cook County        |
| 402792333.0 | Thousands of chained 2017 dollars | Harris County      |
| 382786734.0 | Thousands of chained 2017 dollars | Santa Clara County |
| 367176011.0 | Thousands of chained 2017 dollars | King County        |
| 299773355.0 | Thousands of chained 2017 dollars | Dallas County      |
| 298240414.0 | Thousands of chained 2017 dollars | Maricopa County    |
| 270440831.0 | Thousands of chained 2017 dollars | Orange County      |
| 257341197.0 | Thousands of chained 2017 dollars | San Diego County   |

* This makes sense!
* We know Los Angeles in California, and New York county in New York contribute significantly to GDP.
* We also see Cook County from Illinois in third place.

#### Query 2(Highest real GDP/population ratio = gdp per capita)

|     county_name     |  gdp_2022   | population_2022 | "gdp_2022"/"population_2022" |
|---------------------|-------------|-----------------|------------------------------|
| Loving County       | 5423583.0   | 43              | 126129.837209302             |
| Glasscock County    | 2093218.0   | 1141            | 1834.54688869413             |
| McMullen County     | 908593.0    | 568             | 1599.63556338028             |
| Martin County       | 6677211.0   | 5216            | 1280.14014570552             |
| Upton County        | 3929483.0   | 3109            | 1263.90575747829             |
| Culberson County    | 2288356.0   | 2196            | 1042.05646630237             |
| Borden County       | 464480.0    | 572             | 812.027972027972             |
| Reagan County       | 2239205.0   | 3141            | 712.895574657752             |
| Kenedy County       | 241052.0    | 343             | 702.775510204082             |
| Reeves County       | 8050242.0   | 11770           | 683.962786745964             |
| Eureka County       | 1095674.0   | 1917            | 571.556598852374             |
| Storey County       | 2243778.0   | 4177            | 537.174527172612             |
| Butte County        | 1366945.0   | 2758            | 495.629079042785             |
| New York County     | 780965530.0 | 1597451         | 488.88230687514              |
| North Slope Borough | 5116686.0   | 10603           | 482.569650099029             |
| Irion County        | 679303.0    | 1549            | 438.542930923176             |
| La Salle County     | 2247116.0   | 6537            | 343.753403702004             |
| Karnes County       | 4796419.0   | 15018           | 319.378013051005             |
| Sherman County      | 572795.0    | 1951            | 293.590466427473             |
| King County         | 63481.0     | 217             | 292.539170506912             |

* Loving county has an insane GDP per capita at 126,129!
* This is probably some data gathering error, because a county with population of 43 is unlikely (but possible, for sure, we don't know) to produce 5 million * thousand chained dollars worth of GDP.
* It also makes sense we don't see Los Angeles here, because its population is so high that it significantly reduces its GDP per capita.
* Note, if we wanted to, we could see the state that these counties are in by joining the states table with the current output, which I will do in later queries.

#### Query 3(Illinois counties with highest average SAT reading score)

| county_code |    county_name    | ROUND(AVG("reading_average"),2) |
|-------------|-------------------|---------------------------------|
| 17097       | Lake County       | 526.27                          |
| 17203       | Woodford County   | 505.8                           |
| 17107       | Logan County      | 505.67                          |
| 17189       | Washington County | 503.55                          |
| 17133       | Monroe County     | 502.23                          |
| 17085       | Jo Daviess County | 500.67                          |
| 17179       | Tazewell County   | 500.03                          |
| 17093       | Kendall County    | 496.52                          |
| 17111       | McHenry County    | 496.08                          |
| 17019       | Champaign County  | 495.86                          |

* We see that Lake county has the highest average reading standing at 526.27/800 points.
* Now, let's check the math score and see if there are any commonalities.

#### Query 4(Illinois counties with highest average SAT math score)

| county_code |    county_name    | ROUND(AVG("math_average"),2) |
|-------------|-------------------|------------------------------|
| 17097       | Lake County       | 515.36                       |
| 17085       | Jo Daviess County | 498.68                       |
| 17203       | Woodford County   | 492.72                       |
| 17027       | Clinton County    | 489.07                       |
| 17179       | Tazewell County   | 487.47                       |
| 17009       | Brown County      | 487.1                        |
| 17133       | Monroe County     | 486.13                       |
| 17111       | McHenry County    | 483.38                       |
| 17107       | Logan County      | 480.73                       |
| 17019       | Champaign County  | 480.32                       |


* There we see Lake county in first place by a significant amount again.
* We also see a few counties from the last table, but there are some new ones.
* So, I think we can claim that reading and math scores are correlated by county!
* If one is high, the other is likely commensurately high too.

#### Query 5(counties (and state they are in) that had the biggest GDP increase from 2018 to 2022)


|     county_name      | state_name | gdp_increase |
+----------------------|------------|--------------|
| Santa Clara County   | CALIFORNIA | 80374946.0   |
| King County          | WASHINGTON | 66248190.0   |
| New York County      | NEW YORK   | 54534456.0   |
| Los Angeles County   | CALIFORNIA | 49928077.0   |
| Maricopa County      | ARIZONA    | 49772211.0   |
| San Francisco County | CALIFORNIA | 46821054.0   |
| Dallas County        | TEXAS      | 41645759.0   |
| Travis County        | TEXAS      | 34636678.0   |
| San Mateo County     | CALIFORNIA | 31297887.0   |
| San Diego County     | CALIFORNIA | 26822609.0   |


* We see that actually, Los Angeles and New York County do not take first or second place!
* In fact, Santa Clara county’s gdp increased nearly double that of Los Angeles’s.
* Maybe, Santa Clara county is on track to surpass Los Angeles in the future… who knows!

#### Query 6(states that have the most counties)


|   state_name   | COUNT("county_code") |
|----------------|----------------------|
| TEXAS          | 254                  |
| GEORGIA        | 159                  |
| VIRGINIA       | 136                  |
| KENTUCKY       | 120                  |
| MISSOURI       | 115                  |
| KANSAS         | 105                  |
| ILLINOIS       | 102                  |
| NORTH CAROLINA | 100                  |
| IOWA           | 99                   |
| TENNESSEE      | 95                   |


* We don't see California or New York. This plays exactly into our assumptions, because since they have counties with such high GDP,
* it would make sense that the counties are bigger, meaning the state has less of them overall. Very nice.
* Also, Texas has about 100 counties more than second place which is very interesting.

#### Query 7(states with highest real GDP)


|  state_name  | SUM("gdp_2022") |
|--------------|-----------------|
| CALIFORNIA   | 3171153846.0    |
| TEXAS        | 1928312376.0    |
| NEW YORK     | 1763607977.0    |
| FLORIDA      | 1034047433.0    |
| ILLINOIS     | 864330551.0     |
| PENNSYLVANIA | 772738739.0     |
| OHIO         | 690293686.0     |
| GEORGIA      | 655963615.0     |
| NEW JERSEY   | 646922956.0     |
| WASHINGTON   | 641980251.0     |


* Nothing surprising here. California, New York, and Illinois are here.
* However, Texas we might infer is here because of its oil production, and some of those little counties have such a high gdp.

#### Query 8(gdp of counties with highest average SAT score)

This is the table that was very blurry in the slides. I added the ROUND function after recording the slides, so it looks a little different now

|    county_name    |  gdp_2022  | ROUND(AVG("reading_average" + "math_average"),2) |
|-------------------|------------|--------------------------------------------------|
| Lake County       | 64003388.0 | 1041.63                                          |
| Jo Daviess County | 839608.0   | 999.35                                           |
| Woodford County   | 1217623.0  | 998.52                                           |
| Monroe County     | 910027.0   | 988.37                                           |
| Tazewell County   | 6030735.0  | 987.5                                            |
| Logan County      | 1065928.0  | 986.4                                            |
| McHenry County    | 11736282.0 | 979.45                                           |
| Brown County      | 429955.0   | 978.1                                            |
| Clinton County    | 1074062.0  | 977.1                                            |
| Champaign County  | 11570401.0 | 976.18                                           |

* We should expect to see Lake County first. However, I am surprised that Cook county is not on this list, especially given its high GDP. Interesting.
* From this, it is hard to say any correlation between gdp and test score, because the highest scoring counties have very varying real gdps.

















