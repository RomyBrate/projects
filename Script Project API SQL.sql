--DEFINING TIME PERIOD OF THE WEATHER EVENT (WHAT TIME PERIOD ARE WE ANALYSING)
   -- December 21st to 26th 2022 (Storm was active)

--DEFINING POSSIBLE KPIS (all of this can be split by airport)
   -- Total flights cancelled (grouped by airport/airline)
   -- Total flights delayed (grouped by airport/airline)
  --MISSING -- Cancelation flight rate (cancelled flights on the days excluding the storm Vs cancelled flights on the days of the storm)
      --YoY comparison (2018-2022)
  --MISSING -- Delayed flight rate
      --YoY comparison (2018-2022)
   -- Total flights diverted by airport 
   -- Daily cancelation events
   -- Daily delay events
   -- Counting weather condition events
   -- Weather data by airport (avg wind speed / avg precipitation / avg temperature )
   -- Most frequent weather condition per airport


-- VISUALIZATION
   
-- Line chart with daily cancelation and delays (two lines)
-- Bar chart YoY cancelled and Bar chart YoY delayed
-- Flights cancelled by Airport and Airline
-- Counting weather condition events during storm (Explain interesting results)

   -- FUN FACTS SLIDE -- Map with airports and KPIS on wind, precipitation
   

-- THINGS TO HAVE IN MIND
   -- Which weekday was Christmas? This might affect the air traffic / # of flights
   -- How much does the weather data actually tell us? 
         --What about weather conditions in between origin and destination?


--CREATE COLUMN WITH total_delay
--DELETE air time, tail_number, 


 
 


------------------CREATING A BACKUP TABLE


--Creating a Backup table (just in case)
CREATE TABLE IF NOT EXISTS flights_api_sql_group3_backup AS 
  TABLE  flights_api_sql_group3;

  
--Checking the first 50 rows
SELECT * 
FROM flights_api_sql_group3_backup fasgb;



------------------DROPPING SOME COLUMNS


-- Dropping useless columns
ALTER TABLE flights_api_sql_group3_backup 
DROP COLUMN IF EXISTS distance;






------------------CREATING TIMESTAMP_LOCAL WITH DATE AND TIME FOR DEP AND ARR


--Creating the dep_timestamp_local column as timestamp
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS dep_timestamp_local TIMESTAMP; 
--Updating the dep_timestamp_local with flight date and dep_time
UPDATE flights_api_sql_group3_backup 
SET dep_timestamp_local = flight_date + make_time(dep_time::INT / 100, MOD(dep_time::INT,100), 0)


--Creating the arr_timestamp_local
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS arr_timestamp_local TIMESTAMP;
--Updating the dep_timestamp_local with flight date and arr_time
UPDATE flights_api_sql_group3_backup 
SET arr_timestamp_local = flight_date + make_time(arr_time::INT / 100, MOD(arr_time::INT,100), 0);


--Creating new columns for departure time
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS dep_time_test time;
--Updating the new column with the time from dep_timestamp_local
UPDATE flights_api_sql_group3_backup 
SET dep_time_test = dep_timestamp_local::time 

--Changing name back to dep_time (DOES NOT WORK SINCE IT CHANGES DEP_TIME TO FLOAT8)
   --ALTER TABLE flights_api_sql_group3_backup 
   --RENAME COLUMN dep_time_test TO dep_time;

--Trying to change manually the dep_time to time (DOES NOT WORK)
   --UPDATE flights_api_sql_group3_backup 
   --SET dep_time = dep_time::time 

--Droping dep_time when needed
   --ALTER TABLE flights_api_sql_group3_backup 
   --DROP COLUMN IF EXISTS dep_time;


--Creating new columns for arrival time
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS arr_time_test time;
--Updating the new column with the time from arr_timestamp_local
UPDATE flights_api_sql_group3_backup 
SET arr_time_test = arr_timestamp_local::time 





------------------DEP and ARR Flight Date with HOUR ONLY


--Creating departure flight date with hour only
   --Adding the new column
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS dep_day_hour timestamp;
   -- Updating the columns with flight date and departure time
UPDATE flights_api_sql_group3_backup 
SET dep_day_hour = flight_date + dep_time_test ;
   -- Showing only the hours in the new column
UPDATE flights_api_sql_group3_backup 
SET dep_day_hour = DATE_TRUNC('hour', dep_day_hour);



--Creating arrival flight date with hour only
   --Adding the new column
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS arr_day_hour timestamp;
   -- Updating the columns with flight date and arrival time
UPDATE flights_api_sql_group3_backup 
SET arr_day_hour = flight_date + arr_time_test 
   -- Showing only the hours in the new column
UPDATE flights_api_sql_group3_backup 
SET arr_day_hour = DATE_TRUNC('hour', arr_day_hour)



------------------SCHEDULE TIMES


--Creating new columns for sched_dep_time
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS sched_dep_time_new time;

--Updating the new column with the time from dep_timestamp_local
UPDATE flights_api_sql_group3_backup 
SET sched_dep_time_new = make_time(sched_dep_time::INT / 100, MOD(sched_dep_time::INT,100), 0);

--Dropping sched_dep_time since it was type float8 and we need time type
ALTER TABLE flights_api_sql_group3_backup 
DROP COLUMN IF EXISTS sched_dep_time;



--Creating new columns for sched_arr_time
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS sched_arr_time_new time;

--Updating the new column with the time from arr_timestamp_local
UPDATE flights_api_sql_group3_backup 
SET sched_arr_time_new = make_time(sched_arr_time::INT / 100, MOD(sched_arr_time::INT,100), 0);

--Dropping sched_arr_time since it was type float8 and we need time type
ALTER TABLE flights_api_sql_group3_backup 
DROP COLUMN IF EXISTS sched_arr_time;




------------------DEPARTURE / ARRIVAL DELAY AND TOTAL DELAY


--Creating new dep_delay as interval 
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS dep_delay_new INTERVAL;
--Converting dep_delay_new into Interval and replacing the values 
UPDATE flights_api_sql_group3_backup 
SET dep_delay_new = MAKE_INTERVAL(mins => dep_delay::INT);
--Dropping dep_delay since it was type float8 and we need time type
ALTER TABLE flights_api_sql_group3_backup 
DROP COLUMN IF EXISTS dep_delay;


--Creating new arr_delay as interval 
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS arr_delay_new INTERVAL;
--Converting arr_delay_new into Interval and replacing the values 
UPDATE flights_api_sql_group3_backup 
SET arr_delay_new = MAKE_INTERVAL(mins => arr_delay::INT);
--Dropping arr_delay since it was type float8 and we need time type
ALTER TABLE flights_api_sql_group3_backup 
DROP COLUMN IF EXISTS arr_delay;


--Creating total_delay as interval 
ALTER TABLE flights_api_sql_group3_backup 
ADD COLUMN IF NOT EXISTS total_delay INTERVAL;
--Updating total_delay with the sum of dep_delay_new and arr_delay_new
UPDATE flights_api_sql_group3_backup 
SET total_delay = dep_delay_new + arr_delay_new;



--Creating a final table from the backup that we just cleaned
CREATE TABLE IF NOT EXISTS flights_api_sql_group3_final AS 
  TABLE  flights_api_sql_group3;



--Dropping Arrival Time
ALTER TABLE flights_api_sql_group3_final
DROP COLUMN IF EXISTS arr_time;






------------------QUERIES FOR ANALYSIS


--Counting the amount of flights with a delay of more than 2 hours by day
SELECT count(*), flight_date
FROM flights_api_sql_group3_final
WHERE total_delay > '02:00:00'
GROUP BY flight_date
;


--Counting the amount of flights with a delay of more than 2 hours by airport of origin
SELECT  origin, count(*)
FROM flights_api_sql_group3_final
WHERE total_delay > '02:00:00' AND origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
GROUP BY  origin
;


--Counting the amount of flights with a delay of more than 2 hours by airport of destination
SELECT  dest, count(*)
FROM flights_api_sql_group3_final
WHERE total_delay > '02:00:00' 
   AND dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
GROUP BY  dest
;



--Counting the amount of flights with a delay of more than 2 hours by airport of destination
SELECT   count(*)
FROM flights_api_sql_group3_final
WHERE total_delay > '02:00:00' AND 
                              dest  IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND 
                              origin  IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
;


---WEATHER DATA BY AIRPORT BY DAY 

--Checking the average wind_speed by airport by day
SELECT time , max(average_wind_speed) AS max_wind_speed, faa
FROM weather_data_group3 wdg  
WHERE average_wind_speed IS NOT NULL 
GROUP BY 1,3
ORDER BY 2 DESC; 

--Checking the average precipitation by airport by day
SELECT time , max(total_precipitation) AS max_total_precipitation, faa
FROM weather_data_group3 wdg  
WHERE total_precipitation IS NOT NULL 
GROUP BY 1,3
ORDER BY 2 DESC; 

--Checking the average temperature by airport by day
SELECT time , max(temperature) AS max_temperature, faa
FROM weather_data_group3 wdg  
WHERE temperature  IS NOT NULL 
GROUP BY 1,3
ORDER BY 2 DESC; 




-- Total flights cancelled (grouped by airport/airline) during storm

--by airport
SELECT origin, count(cancelled)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
                  AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
GROUP BY 1;
--by airline
SELECT airline, count(cancelled)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
               AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
GROUP BY 1
ORDER BY 2 DESC;


-- Total flights delayed (grouped by airports/airline) 
SELECT count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00'
;

--Total delayed flights During storm period
SELECT count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00' 
                  AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
;


--total delayed by airport
SELECT origin, count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00'
GROUP BY 1;
--total delayed by airline
SELECT airline, count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00'
GROUP BY 1
ORDER BY 2 DESC;



--Total delayed flights During storm period per airline
SELECT airline, count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00' 
                  AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
GROUP BY 1
ORDER BY 2 DESC;

--Total delayed flights During storm period per origin airport
SELECT origin, count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00' 
                  AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
GROUP BY 1
ORDER BY 2 DESC;

--Total delayed flights During storm period per dest airport
SELECT dest, count(*)
FROM flights_api_sql_group3_final fasgf 
WHERE origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') AND total_delay > '03:00:00' 
                  AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )
GROUP BY 1
ORDER BY 2 DESC;



--Average delay before 2022
SELECT avg(total_delay)
FROM flights_api_sql_group3_final fasgf
WHERE flight_date < '2022-12-01'



--Counting weather condition events during storm
SELECT  weather_condition, count(weather_condition)
FROM weather_data_group3 wdg 
WHERE time > '2022-12-21' AND time < '2022-12-26'
GROUP BY 1
ORDER BY 2 DESC;




-- Cancelation flight rate (cancelled flights on the days excluding the storm Vs cancelled flights on the days of the storm)


--Cancelled flights on the storm days
SELECT sum(cancelled)
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' ) 
;


--Cancelled flights rest of the month
SELECT sum(cancelled)
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
      OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND (flight_date < '2022-12-21' OR flight_date > '2022-12-26') 
      AND flight_date > '2021-12-31'; 


--% of december flights that were cancelled during the storm
SELECT sum(cancelled)*100.00 / (SELECT sum(cancelled) 
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
      OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date > '2022-12-01')
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' );
   
   

 --Delayed flights on the storm days
SELECT count(total_delay)
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' ) AND total_delay > '03:00:00' 
;


--Delayed flights rest of the month
SELECT count(total_delay)
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
      OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND (flight_date < '2022-12-21' OR flight_date > '2022-12-26') 
      AND flight_date > '2021-12-31' AND total_delay > '03:00:00' ; 


--% of total flights in December 22 delayed during the storm
SELECT count(total_delay)*100.00 / (SELECT count(total_delay) 
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA')
      OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date > '2022-12-01' AND total_delay > '03:00:00')
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' ) AND total_delay > '03:00:00' ;  
   
   
   
   
--YoY comparison total cancelled
SELECT EXTRACT(YEAR FROM flight_date)::INT , sum(cancelled)
FROM flights_api_sql_group3_final fasgf
GROUP BY 1;

   --YoY comparison total delayed
SELECT EXTRACT(YEAR FROM flight_date)::INT , avg(total_delay)
FROM flights_api_sql_group3_final fasgf
GROUP BY 1;



--Total cancelled flights by day where origin or destination was one of the top 8 airports
SELECT count(*), flight_date
FROM flights_api_sql_group3_final
WHERE cancelled = 1 AND (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR
                        dest  IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
GROUP BY flight_date, origin , dest
;

--Total cancelled flights by day (same as above since table only contains origin or dest of the 8 airports)
SELECT count(*), flight_date
FROM flights_api_sql_group3_final
WHERE cancelled = 1
GROUP BY flight_date
;


--Diverted flights on the storm days
SELECT sum(diverted)
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )


   -- Total flights diverted by airport 
SELECT sum(diverted), origin, dest
FROM flights_api_sql_group3_final fasgf 
WHERE (origin IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA') OR dest IN ('ATL', 'DFW', 'DEN', 'ORD', 'LAX', 'JFK', 'EWR', 'LGA'))
      AND flight_date IN ('2022-12-21', '2022-12-22', '2022-12-23', '2022-12-24', '2022-12-25', '2022-12-26' )      
GROUP BY 2, 3;








-- OTHER QUERIES



SELECT make_time(dep_time::INT / 100, MOD(dep_time::INT,100), 0)
FROM flights_api_sql_group3 fasg 

-- Change flight date to include only date yyyy-mm-dd

SELECT make_date(foo.flight_year, foo.flight_month, foo.flight_day) AS new_flight_date_list
FROM (
      SELECT DISTINCT EXTRACT (DAY FROM f.flight_date)::INT AS flight_day, 
      EXTRACT (MONTH FROM f.flight_date)::INT AS flight_month, 
      EXTRACT (YEAR FROM f.flight_date)::INT AS flight_year
      FROM flights_api_sql_group3 f) 
AS foo
;

-- Change format for dep_time and arr_time in timestamp and for sched_dep_time and sched_arr_time

SELECT   flight_date,
flight_date + make_time(f.dep_time::INT / 100, MOD(f.dep_time::INT,100), 0) AS flight_date_departure,
         origin,
         dest, 
         make_time(f.dep_time::INT / 100, MOD(f.dep_time::INT,100), 0) AS dep_time_f,
         make_time(f.arr_time::INT / 100, MOD(f.arr_time::INT,100), 0) AS arr_time_f,
         make_time(f.sched_dep_time::INT / 100, MOD(f.sched_dep_time::INT,100), 0) AS sched_dep_time_f,
         make_time(f.sched_arr_time::INT / 100, MOD(f.sched_arr_time::INT,100), 0) AS sched_arr_time_f,
         MAKE_INTERVAL(mins => f.actual_elapsed_time::INT) AS actual_elapsed_time_f, actual_elapsed_time 
FROM flights_api_sql_group3 f ;



-- Combine flight_date with dep_time f, arr_time_f, sched_dep_time_f, sched_arr_time_f

SELECT   flight_date + make_time(f.dep_time::INT / 100, MOD(f.dep_time::INT,100), 0) AS flight_date_departure,
         flight_date + make_time(f.arr_time::INT / 100, MOD(f.arr_time::INT,100), 0) AS flight_date_arrival,
         flight_date + make_time(f.sched_dep_time::INT / 100, MOD(f.sched_dep_time::INT,100), 0) AS flight_date_sched_dep_time_f,
         flight_date + make_time(f.sched_arr_time::INT / 100, MOD(f.sched_arr_time::INT,100), 0) AS flight_date_sched_arr_time_f,
         origin,
         dest
FROM flights_api_sql_group3 f ;














