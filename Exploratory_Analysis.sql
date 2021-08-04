use Google_CaseStudy

/*SELECT *
FROM Google_CaseStudy..[202006-tripdata]*/

-- Average ride time per rider
SELECT member_casual, CAST(AVG(CAST(ride_length as FLOAT)) as datetime) as AVGRideTime
FROM Google_CaseStudy..[202006-tripdata]
GROUP BY member_casual
ORDER BY 2

-- Average starting and ending position per rider type
SELECT member_casual, AVG(start_lat) as AVGStartLat, AVG(start_lng) as AVGStartLng, AVG(end_lat) as AVGEndLat, AVG(end_lng) as AVGEndLNG
FROM Google_CaseStudy..[202006-tripdata]
GROUP BY member_casual

-- Counting how many casual riders and annual riders
SELECT COUNT(member_casual) as CasualRiders
FROM Google_CaseStudy..[202006-tripdata]
WHERE member_casual = 'casual'

SELECT COUNT(member_casual) as AnnualRiders
FROM Google_CaseStudy..[202006-tripdata]
WHERE member_casual = 'member'

-- Which day has the most riders and who are they (casual or members)?
CREATE VIEW RidesPerDay AS
SELECT day_of_week, COUNT(ride_id) as NumberOfRides, member_casual
FROM Google_CaseStudy..[202006-tripdata]
GROUP BY day_of_week, member_casual

CREATE VIEW HighestPerDay AS
SELECT day_of_week, MAX(NumberOfRides) as NumberOfRides
FROM RidesPerDay
GROUP BY day_of_week

SELECT RD.day_of_week, HD.NumberOfRides, RD.member_casual
FROM RidesPerDay RD
RIGHT JOIN HighestPerDay HD
	ON RD.NumberOfRides = HD.NumberOfRides
ORDER BY 2 DESC

-- Average ride length for casual and annual riders per day
SELECT member_casual, day_of_week, CAST(AVG(CAST(ride_length as float)) as datetime) as AverageRide
FROM Google_CaseStudy..[202006-tripdata]
GROUP BY member_casual, day_of_week
ORDER BY 2,1


-- What type of bike does each rider use the most?
CREATE VIEW MostUsedBikes AS
SELECT rideable_type, COUNT(ride_id) as NumberOfRides, member_casual
FROM Google_CaseStudy..[202006-tripdata]
GROUP BY rideable_type, member_casual
ORDER BY 2

CREATE VIEW HighestUsedBikes AS
SELECT rideable_type, MAX(NumberOfRides) as NumberOfRides
FROM MostUsedBikes
GROUP BY rideable_type

SELECT HB.Rideable_type, HB.NumberOfRides, MB.member_casual
FROM MostUsedBikes MB
INNER JOIN HighestUsedBikes HB
	ON MB.NumberOfRides = HB.NumberOfRides
ORDER BY 2
