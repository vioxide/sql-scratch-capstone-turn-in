/* Codeacademy Capstone
Learn SQL from Scratch
Jon Kalasz
June 19 Cohort
CoolTShirts: First and Last Touch Attribution
*/

/*
Task 1:

How many campaigns and sources does CoolTShirts use? Which source is used for each campaign?

Use three queries, one for the number of distinct campaigns, one for the number of distinct sources,
one to find how they are related.
*/
SELECT COUNT(DISTINCT utm_campaign) AS 'No_Campaigns'
FROM page_visits;

SELECT COUNT(DISTINCT utm_source) AS 'No_Sources'
FROM page_visits;

SELECT DISTINCT 
    utm_campaign AS 'Campaign',
    utm_source AS 'Source'
FROM page_visits;
    
/*
Task 2:
What pages are on the CoolTShirts website?
Find the distinct values of the page_name column.
*/
SELECT DISTINCT 
    page_name AS 'CTS Pages'
FROM page_visits;

/*
TASK 3:
How many first touches is each campaign responsible for?
You'll need to use the first-touch query from the lesson (also provided in the hint below). 
Group by campaign and count the number of first touches for each.
*/
WITH first_touch AS (
    SELECT 
        user_id,
        MIN(timestamp) as first_touch_at
    FROM page_visits
    GROUP BY user_id
    ),
ft_attr AS (
    SELECT
        ft.user_id,
        ft.first_touch_at,
        pv.utm_source,
        pv.utm_campaign
    FROM first_touch ft
    JOIN page_visits pv
        ON ft.user_id = pv.user_id
        AND ft.first_touch_at = pv.timestamp
    )
SELECT 
    ft_attr.utm_source AS Source,
    ft_attr.utm_campaign AS Campaign,
    COUNT(*) AS ‘First Touches’
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*
Task 4:
How many last touches is each campaign responsible for?
Starting with the last-touch query from the lesson, group by campaign and count the number of last touches for each.
*/
WITH last_touch AS (
    SELECT
        user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    GROUP BY user_id
    ),
ft_attr AS (
    SELECT
        lt.user_id,
        lt.last_touch_at,
        pv.utm_source,
        pv.utm_campaign
    FROM last_touch lt
    JOIN page_visits pv
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
    )
SELECT 
    ft_attr.utm_source AS Source,
    ft_attr.utm_campaign AS Campaign,
    COUNT(*) AS 'Last Touches'
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;

/*
Task 5:
How many visitors make a purchase?
Count the distinct users who visited the page named 4 - purchase.
*/
SELECT COUNT(DISTINCT user_id) AS 'Number Visitors that Purchase'
FROM page_visits
WHERE page_name = '4 - purchase';

/*
Task 6:
How many last touches on the purchase page is each campaign responsible for?
This query will look similar to your last-touch query, but with an additional WHERE clause.
*/
WITH last_touch AS (
    SELECT
        user_id,
        MAX(timestamp) as last_touch_at
    FROM page_visits
    WHERE page_name = ‘4 - purchase’
    GROUP BY user_id
    ),
ft_attr AS (
    SELECT
        lt.user_id,
        lt.last_touch_at,
        pv.utm_source,
        pv.utm_campaign
    FROM last_touch lt
    JOIN page_visits pv
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
    )
SELECT 
    ft_attr.utm_source AS Source,
    ft_attr.utm_campaign AS Campaign,
    COUNT(*) AS ‘Last Touches to Purchase’
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
