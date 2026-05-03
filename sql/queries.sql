CREATE DATABASE product_analytics;
USE product_analytics;

CREATE TABLE users (
    user_id INT,
    signup_date DATE,
    source VARCHAR(20),
    experiment_group VARCHAR(5)
);

CREATE TABLE events (
    user_id INT,

    event_name VARCHAR(50),
    event_time DATETIME
);

SELECT * FROM users LIMIT 5;
SELECT COUNT(*) FROM users;
SELECT COUNT(*) FROM events;

SELECT 
  COUNT(DISTINCT CASE WHEN event_name = 'signup' THEN user_id END) AS signup,
  COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) AS app_open,
  COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) AS first_order,
  COUNT(DISTINCT CASE WHEN event_name = 'repeat_order' THEN user_id END) AS repeat_order
FROM events;


SELECT 
  u.source,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) AS converted_users,
  ROUND(
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS conversion_rate
FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id
GROUP BY u.source;

SELECT 
  COUNT(DISTINCT CASE WHEN event_name = 'signup' THEN user_id END) AS signup,
  COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) AS app_open,
  COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) AS first_order
FROM events;

SELECT 
  ROUND(AVG(DATEDIFF(e.event_time, u.signup_date)), 2) AS avg_days_to_order
FROM users u
JOIN events e 
ON u.user_id = e.user_id
WHERE e.event_name = 'first_order';


SELECT 
  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'signup' THEN user_id END), 2
  ) AS signup_to_open,

  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END), 2
  ) AS open_to_order
FROM events;

SELECT 
  u.source,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) AS converted_users,
  ROUND(
    COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS conversion_rate
FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id
GROUP BY u.source;

SELECT 
  COUNT(DISTINCT CASE WHEN event_name = 'signup' THEN user_id END) AS signup,
  COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) AS app_open,
  COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) AS first_order
FROM events;

SELECT 
  ROUND(AVG(DATEDIFF(e.event_time, u.signup_date)), 2) AS avg_days_to_order
FROM users u
JOIN events e 
ON u.user_id = e.user_id
WHERE e.event_name = 'first_order';

SELECT 
  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'signup' THEN user_id END), 2
  ) AS signup_to_open,

  ROUND(
    COUNT(DISTINCT CASE WHEN event_name = 'first_order' THEN user_id END) * 100.0 /
    COUNT(DISTINCT CASE WHEN event_name = 'app_open' THEN user_id END), 2
  ) AS open_to_order
FROM events;

SELECT 
  signup_date,
  COUNT(*) AS total_users
FROM users
GROUP BY signup_date
ORDER BY signup_date;

SELECT 
  u.signup_date,
  COUNT(DISTINCT e.user_id) AS returning_users
FROM users u
JOIN events e 
ON u.user_id = e.user_id
WHERE e.event_name = 'app_open'
AND e.event_time > u.signup_date
GROUP BY u.signup_date
ORDER BY u.signup_date;

SELECT 
  u.signup_date,
  COUNT(DISTINCT e.user_id) AS returning_users
FROM users u
JOIN events e 
ON u.user_id = e.user_id
WHERE e.event_name = 'app_open'
AND e.event_time > u.signup_date
GROUP BY u.signup_date
ORDER BY u.signup_date;

SELECT 
  u.signup_date,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE 
      WHEN e.event_name = 'app_open' 
      AND e.event_time > u.signup_date 
      THEN u.user_id 
  END) AS retained_users,
  
  ROUND(
    COUNT(DISTINCT CASE 
        WHEN e.event_name = 'app_open' 
        AND e.event_time > u.signup_date 
        THEN u.user_id 
    END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS retention_rate
FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id
GROUP BY u.signup_date
ORDER BY u.signup_date;

SELECT 
  u.source,
  COUNT(DISTINCT u.user_id) AS total_users,
  COUNT(DISTINCT CASE 
      WHEN e.event_name = 'app_open' 
      AND e.event_time > u.signup_date 
      THEN u.user_id 
  END) AS retained_users,
  
  ROUND(
    COUNT(DISTINCT CASE 
        WHEN e.event_name = 'app_open' 
        AND e.event_time > u.signup_date 
        THEN u.user_id 
    END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS retention_rate
FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id
GROUP BY u.source;


SELECT 
  u.experiment_group,
  COUNT(DISTINCT u.user_id) AS total_users,

  COUNT(DISTINCT CASE 
      WHEN e.event_name = 'first_order' 
      THEN u.user_id 
  END) AS converted_users,

  ROUND(
    COUNT(DISTINCT CASE 
        WHEN e.event_name = 'first_order' 
        THEN u.user_id 
    END) * 100.0 /
    COUNT(DISTINCT u.user_id), 2
  ) AS conversion_rate

FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id

GROUP BY u.experiment_group;

SELECT 
  u.experiment_group,

  COUNT(DISTINCT CASE WHEN e.event_name = 'app_open' THEN u.user_id END) AS app_open,
  COUNT(DISTINCT CASE WHEN e.event_name = 'first_order' THEN u.user_id END) AS first_order

FROM users u
LEFT JOIN events e 
ON u.user_id = e.user_id

GROUP BY u.experiment_group;
