-- Cyclistic Case Study
-- File Documents were 4 zipped .cvs files from 2019. Files were briefly looked at in Excel before transfering them to SQL.
PortfolioProject4.dbo.Divvy_Trips_2019_Q1
PortfolioProject4.dbo.Divvy_Trips_2019_Q2
PortfolioProject4.dbo.Divvy_Trips_2019_Q3
PortfolioProject4.dbo.Divvy_Trips_2019_Q4

--Firstly I viewed and double checked the data
SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q1

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q2

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q3

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q4

--Then I altered certain columns so that I could UNION the data sets
-- Column F16 was dropped

ALTER TABLE PortfolioProject4.dbo.Divvy_Trips_2019_Q1
DROP COlUMN F16;

ALTER TABLE PortfolioProject4.dbo.Divvy_Trips_2019_Q2
DROP COlUMN F16;

-- Added an extra column to standardise the date in each individual data set called 'DateofYear'
PortfolioProject4.dbo.Divvy_Trips_2019_Q1
PortfolioProject4.dbo.Divvy_Trips_2019_Q2
PortfolioProject4.dbo.Divvy_Trips_2019_Q3
PortfolioProject4.dbo.Divvy_Trips_2019_Q4

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q1
ADD DateofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q1
SET DateofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q2
ADD DateofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q2
SET DateofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q3
ADD DateofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q3
SET DateofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q4
ADD DateofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q4
SET DateofYear = Convert (Date, start_time)

-- Proceeded with a WITH clause, as I thought it was better modularising each sub-query block by giving a name each so that it will be clearer for extraction in the later part.
-- Combine useful data into a yearly dataset using a WITH clause (CTE) and UNION function

WITH TotalYearData AS
(
	SELECT *
	FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q1
	UNION ALL
	SELECT *
	FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q2
	UNION ALL
	SELECT *
	FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q3
	UNION ALL
	SELECT *
	FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q4
),
-- Created column 'Day_Week' to change the representation of days of week (numeric) into words (strings)
-- Created another column called 'TotalMinutes' to find the total ride time in minutes per trip
AggreData AS(
	SELECT *,
	DATEDIFF(Minute, start_time, end_time) as TotalMinutes,
	CASE
		WHEN Day_of_week = 1 THEN 'Monday'
		WHEN Day_of_week = 2 THEN 'Tuesday'
		WHEN Day_of_week = 3 THEN 'Wednesday'
		WHEN Day_of_week = 4 THEN 'Thursday'
		WHEN Day_of_week = 5 THEN 'Friday'
		WHEN Day_of_week = 6 THEN 'Saturday'
		ELSE 'Sunday'
	END
	AS Day_Week
	FROM TotalYearData
),
-- Cleaned data to get rid of ride times under a minute
-- Cleaned data to only include trip ids that where 16 characters and under
CleanedRideTrips AS (
	SELECT *
	FROM AggreData
	WHERE LEN(trip_id) = 16 AND TotalMinutes >= 1
),
-- Created a final table called 'FinalTable' with all the important data to be used for analysing stage of the project 
FinalTable AS
(
	SELECT trip_id,start_time, end_time, bikeid, usertype, gender, Ride_LengthV, 
		TotalMinutes, Day_Week, from_station_name, to_station_name, Date_ofYear
	FROM aggre_data
),
-- Queried the total amount of user-types (Subscriber/Customer) using Cyclistic bikes
TotalUserType AS
(
	SELECT usertype, COUNT(usertype) as AmountOfUsers
	FROM FinalTable
	GROUP BY usertype
),
-- Queried the total amount of user types using bikes for each day of the week
TotalUsertype_PerDay AS
(
	SELECT Day_Week, COUNT(Day_Week) as Day_of_week_count, usertype, COUNT(usertype) as AmountOfUsers
	From FinalTable
	GROUP BY Day_Week, usertype
),
--Queried the stations where user-types (subscriber/customer) started and ended their rides at
UserTypeLocations AS
(
	SELECT from_station_name, COUNT(from_station_name) as StartStationCount, 
			to_station_name, COUNT(to_station_name) as EndStationCount, usertype 
	FROM final_table
	GROUP BY from_station_name, to_station_name, usertype
),
--Queried average ride times and total ride times for user-types (subscriber/customer)
TotalRideTime AS
(
	SELECT usertype, AVG(TotalMinutes) as AverageMinutes, (SUM(TotalMinutes)/60) as totalhours
	FROM final_table
	GROUP BY usertype
),
-- Queried ride times for (subscriber/customer) per date
BikeTripDates AS
(
	SELECT Date_ofYear, COUNT(usertype) as TotalUserType, usertype
	FROM final_table
	GROUP BY Date_ofYear, usertype
),
-- Queried ride times for customer (only) per date
BikeTripDatesCustomer AS
(
	SELECT Date_ofYear, COUNT(usertype) as CustomerCount
	FROM final_table
	WHERE usertype = 'Customer'
	GROUP BY Date_ofYear
),
-- Queried ride times for subscriber (only) per date
BikeTripDatesSubscriber AS
(
	SELECT Date_ofYear, COUNT(usertype) as SubscriberCount
	FROM final_table
	WHERE usertype = 'Subscriber'
	GROUP BY Date_ofYear
)
