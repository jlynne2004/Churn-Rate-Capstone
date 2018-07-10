{\rtf1\ansi\ansicpg1252\cocoartf1504\cocoasubrtf830
{\fonttbl\f0\fswiss\fcharset0 Helvetica;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
\margl1440\margr1440\vieww10800\viewh8400\viewkind0
\pard\tx720\tx1440\tx2160\tx2880\tx3600\tx4320\tx5040\tx5760\tx6480\tx7200\tx7920\tx8640\pardirnatural\partightenfactor0

\f0\fs24 \cf0 select * from subscriptions limit 100;\
select min(subscription_start), max(subscription_start) from subscriptions;\
with months as (select '2017-01-01' as first_day, '2017-01-31' as last_day union select '2017-02-01' as first_day, '2017-02-28' as last_day union select '2017-03-01' as first_day, '2017-03-31' as last_day),\
cross_join as (select subscriptions.*, months.* from subscriptions cross join months),\
status as (select id, first_day as month,\
case\
	when (segment = '87') and (subscription_start > first_day or subscription_end is null) then 1\
else 0\
end as is_active_87,\
case\
	when (segment = '30') and (subscription_start > first_day or subscription_end is null) then 1\
else 0\
end as is_active_30,\
case\
when (segment = '87') and (subscription_end between first_day and last_day) then 1\
else 0\
end as is_canceled_87,\
case\
when (segment = '30') and (subscription_end between first_day and last_day) then 1\
else 0\
end as is_canceled_30\
from cross_join),\
status_aggregate as (select month, sum(is_active_87) as sum_active_87, sum(is_active_30) as sum_active_30, sum(is_canceled_87) as sum_canceled_87, sum(is_canceled_30) as sum_canceled_30 from status group by month)\
select month, round(1.0 * sum_canceled_87/sum_active_87,2) as churn_rate_87, round(1.0 * sum_canceled_30/sum_active_30,2) as churn_rate_30 from status_aggregate;}