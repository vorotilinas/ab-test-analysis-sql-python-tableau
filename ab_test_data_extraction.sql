-- Description:
-- This SQL script extracts and aggregates user interaction data for A/B testing analysis.
-- It consolidates sessions, new account creations, orders, and custom events
-- across test and control groups for further statistical testing and visualization.

-- Author: Alexander Vorotilin
-- Created: 2025-04-19

-- Step 1: Base session information enriched with test, country, device, etc.
WITH session_info AS (
    SELECT 
        s.date,
        s.ga_session_id,
        sp.country,
        sp.device,
        sp.continent,
        sp.channel,
        ab.test,
        ab.test_group
    FROM `DA.ab_test` ab
    JOIN `DA.session` s ON ab.ga_session_id = s.ga_session_id
    JOIN `DA.session_params` sp ON sp.ga_session_id = ab.ga_session_id
),

-- Step 2: Count of new accounts created per test group
account AS (
    SELECT 
        si.date,
        si.country,
        si.device,
        si.continent,
        si.channel,
        si.test,
        si.test_group,
        COUNT(DISTINCT acs.ga_session_id) AS new_account_cnt
    FROM `DA.account_session` acs
    JOIN session_info si ON acs.ga_session_id = si.ga_session_id
    GROUP BY 
        si.date, si.country, si.device, si.continent,
        si.channel, si.test, si.test_group
),

-- Step 3: Count of sessions that led to orders
session_with_orders AS (
    SELECT 
        si.date,
        si.country,
        si.device,
        si.continent,
        si.channel,
        si.test,
        si.test_group,
        COUNT(DISTINCT o.ga_session_id) AS session_with_orders
    FROM `DA.order` o
    JOIN session_info si ON o.ga_session_id = si.ga_session_id
    GROUP BY 
        si.date, si.country, si.device, si.continent,
        si.channel, si.test, si.test_group
),

-- Step 4: Count of events per event_name (e.g., add_to_cart, begin_checkout)
events AS (
    SELECT 
        si.date,
        si.country,
        si.device,
        si.continent,
        si.channel,
        si.test,
        si.test_group,
        ep.event_name,
        COUNT(ep.ga_session_id) AS event_cnt
    FROM `DA.event_params` ep
    JOIN session_info si ON ep.ga_session_id = si.ga_session_id
    GROUP BY 
        si.date, si.country, si.device, si.continent,
        si.channel, si.test, si.test_group, ep.event_name
),

-- Step 5: Total session count per group
session AS (
    SELECT 
        si.date,
        si.country,
        si.device,
        si.continent,
        si.channel,
        si.test,
        si.test_group,
        COUNT(DISTINCT si.ga_session_id) AS session_cnt
    FROM session_info si
    GROUP BY 
        si.date, si.country, si.device, si.continent,
        si.channel, si.test, si.test_group
)

-- Final UNION of all key events for export
SELECT 
    s.date,
    s.country,
    s.device,
    s.continent,
    s.channel,
    s.test,
    s.test_group,
    'session' AS event_name,
    s.session_cnt AS value
FROM session s

UNION ALL

SELECT 
    swo.date,
    swo.country,
    swo.device,
    swo.continent,
    swo.channel,
    swo.test,
    swo.test_group,
    'session with orders' AS event_name,
    swo.session_with_orders AS value
FROM session_with_orders swo

UNION ALL

SELECT 
    e.date,
    e.country,
    e.device,
    e.continent,
    e.channel,
    e.test,
    e.test_group,
    e.event_name,
    e.event_cnt AS value
FROM events e

UNION ALL

SELECT 
    a.date,
    a.country,
    a.device,
    a.continent,
    a.channel,
    a.test,
    a.test_group,
    'new account' AS event_name,
    a.new_account_cnt AS value
FROM account a;
