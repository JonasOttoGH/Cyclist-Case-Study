
-- File Documents
PortfolioProject4.dbo.Divvy_Trips_2019_Q1
PortfolioProject4.dbo.Divvy_Trips_2019_Q2
PortfolioProject4.dbo.Divvy_Trips_2019_Q3
PortfolioProject4.dbo.Divvy_Trips_2019_Q4

--View and double check data
SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q1

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q2

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q3

SELECT *
FROM PortfolioProject4.dbo.Divvy_Trips_2019_Q4

--Alter columns so that data can be placed together

ALTER TABLE PortfolioProject4.dbo.Divvy_Trips_2019_Q1
DROP COlUMN F16;

ALTER TABLE PortfolioProject4.dbo.Divvy_Trips_2019_Q2
DROP COlUMN F16;


-- Add column for the date of year (standardise date)
PortfolioProject4.dbo.Divvy_Trips_2019_Q1
PortfolioProject4.dbo.Divvy_Trips_2019_Q2
PortfolioProject4.dbo.Divvy_Trips_2019_Q3
PortfolioProject4.dbo.Divvy_Trips_2019_Q4

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q1
ADD Date_ofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q1
SET Date_ofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q2
ADD Date_ofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q2
SET Date_ofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q3
ADD Date_ofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q3
SET Date_ofYear = Convert (Date, start_time)

ALTER Table PortfolioProject4.dbo.Divvy_Trips_2019_Q4
ADD Date_ofYear Date;

UPDATE PortfolioProject4.dbo.Divvy_Trips_2019_Q4
SET Date_ofYear = Convert (Date, start_time)

--Combine useful data into a yearly dataSet using a WITH clasue (CTE)

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
-- Created coloumn 'Day_Week' to change the representation of days of week (numeric) into words (strings)
-- Created coloumn 'TotalMinutes' to find the total ride time in minutes per trip
aggre_data AS(
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
-- Cleaned data to only includ trip ids that where 16 characters and under
clean_ride_id AS (
	SELECT *
	FROM aggre_data
	WHERE LEN(trip_id) <= 16 AND TotalMinutes >= 1
),
-- Created a final table with all the important data to be used for analyzing stage of the project 
final_table AS
(
	SELECT trip_id,start_time, end_time, bikeid, usertype, gender, Ride_LengthV, 
		TotalMinutes, Day_Week, from_station_name, to_station_name, Date_ofYear
	FROM aggre_data
),
-- Queried the total amount of user types (Subscriber/Customer) using bikes
TotalUserType AS
(
	SELECT usertype, COUNT(usertype) as AmountofUsers
	FROM final_table
	GROUP BY usertype
),
-- Queried the total amount of user types using bikes for each day of the week
TotalUsertype_PerDay AS
(
	SELECT Day_Week, COUNT(Day_Week) as Day_of_week_count, usertype, COUNT(usertype) as AmountOfUsers
	From final_table
	GROUP BY Day_Week, usertype
),
--Queried station that of where usertypes (subscriber/customer) started and ended their rides at
UsertypeLocations AS
(
	SELECT from_station_name, COUNT(from_station_name) as StartStationCount, 
			to_station_name, COUNT(to_station_name) as EndStationCount, usertype 
	FROM final_table
	GROUP BY from_station_name, to_station_name, usertype
),
--Queried average ride times and total ride times for usertypes (subscriber/customer)
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

