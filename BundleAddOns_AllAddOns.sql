------------------------- Query to pull users with bundle add_ons and all add_ons ----------------------------------------

CREATE TEMP FUNCTION STRING_DEDUP(str STRING) AS (
(SELECT STRING_AGG(item ORDER BY item) FROM (
SELECT DISTINCT item FROM UNNEST(SPLIT(str)) item 
)) 
);
----------------------------------------------------------------------------------------------------------------------
with daily_status as (
Select * , DATE_TRUNC(day, month) as change_month
from `fubotv-prod.data_insights.daily_status_static_update` t1
where final_status_restated like '%paid%'
and day >= '2021-01-01'
AND day <= current_date()-1
),
add_on as (
select account_code, change_month, STRING_DEDUP(add_ons) as addons_sorted,STRING_DEDUP(bundle_add_on_list) as bundle_addons_sorted
FROM daily_status
)
select DISTINCT change_month, account_code, bundle_addons_sorted, addons_sorted
from add_on
"""