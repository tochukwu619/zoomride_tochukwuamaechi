

-- | LOOKING AT THE DATA | ---

SHOW TABLES;
SELECT * FROM trips LIMIT 10;

-- Q1. How many rows are in the trips table?

SELECT COUNT(*) No_of_Trips FROM trips;

-- Q2. Show the 5 longest completed trips.

SELECT trip_id, city, distance_km, fare
FROM trips
WHERE status = 'Completed'
ORDER BY distance_km DESC
LIMIT 5;

-- | COUNT BY A GROUP | --

-- Q3. How many trips happened in each city?

SELECT city, COUNT(trip_id) No_of_Trips
FROM trips
GROUP BY city;
-- There are inconsistent namings of the values in the city column.


-- | CLEAN THE DATA | --

-- Q4a. Find the duplicate trips

SELECT customer_id, driver_id, trip_date, fare, MIN(trip_id) Min_trip_id, MAX(trip_id) Max_trip_id
FROM trips
GROUP BY customer_id, driver_id, trip_date, fare
HAVING COUNT(*) > 1;

-- Q4b. How many Completed trips have a missing fare?

SELECT COUNT(*) Trips_with_Missing_Fares
FROM trips
WHERE status = 'Completed' AND fare IS NULL;

-- Q5a. Make every city have one correct spelling

UPDATE trips
SET city = CASE 
    WHEN city LIKE '%Port-Harcourt%' THEN 'Port Harcourt'
    WHEN city LIKE '%PH%' THEN 'Port Harcourt'
    WHEN city = 'Nairobbi' THEN 'Nairobi'
    WHEN city = 'Kampla' THEN 'Kampala'
    ELSE city
END
WHERE city IN ('PH', 'Nairobbi', 'Kampla', 'Port-Harcourt');


UPDATE trips SET city = TRIM(city);

-- Q5b. Delete the duplicate rows

DELETE FROM trips WHERE trip_id IN (299, 300);

-- Q5c. Rerun Q3

SELECT city, COUNT(trip_id) No_of_Trips
FROM trips
GROUP BY city;


-- | CLEAN DATA ANALYSIS | --

-- Q6. Revenue by City 

SELECT city, COUNT(*) AS No_of_trips, SUM(fare) AS Total_Revenue, ROUND(AVG(fare), 2) AS Average_fare
FROM trips
WHERE status = 'Completed'
GROUP BY city
ORDER BY 3 DESC;

-- Q7. Revenue by Month

SELECT DATE_FORMAT(trip_date, '%Y-%m') Each_Month, 
        COUNT(*) No_of_Trips, SUM(fare) Total_Revenue
FROM trips
WHERE status = 'Completed'
GROUP BY DATE_FORMAT(trip_date, '%Y-%m')
ORDER BY 1;
-- The best month is Decemeber 2025


-- | JOIN TABLES | --

-- Q8. Revenue by Vehicle Type.

SELECT d.vehicle_type, COUNT(t.trip_id) No_of_trips, SUM(fare) Total_Revenue
FROM trips t
INNER JOIN drivers d 
ON t.driver_id = d.driver_id
WHERE t.status = 'Completed'
GROUP BY d.vehicle_type
ORDER BY 3 DESC;


-- | BONUS QUESTIONS | --

-- Q9. Which customers have never booked a trip?

SELECT c.customer_name
FROM customers c
LEFT JOIN trips t 
ON c.customer_id = t.customer_id
WHERE t.customer_id IS NULL;

-- Q10. Who are the top 3 customers by total spend on Completed trips?

SELECT c.customer_name, SUM(t.fare) Total_Revenue, COUNT(t.trip_id) Completed_trips
FROM customers c
INNER JOIN trips t 
ON c.customer_id = t.customer_id
WHERE t.status = 'Completed'
GROUP BY c.customer_name
ORDER BY 2 DESC
LIMIT 3;




