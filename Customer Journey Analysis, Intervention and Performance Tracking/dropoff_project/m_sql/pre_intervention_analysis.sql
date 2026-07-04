select * from first_transformations;

#Total Unique Users
select count(distinct user_id) as users_count from first_transformations;

#Total Users by Region
select region, count(user_id) as users
from first_transformations
group by region
order by count(user_id) DESC;

#Total Users by age groups
select age_group, count(user_id) as users
from first_transformations
group by age_group
order by age_group;

#Duration of the data collection
select min(stage1_date) as earliest_entry, max(stage1_date) as latest_entry
from first_transformations;

#Total Conversions by month
select month(entry_date) as month_num,count(*) as total_users, sum(converted) as total_conversions, round(sum(converted)*100.0/count(*), 2) as conversion_rate
from first_transformations
group by month_num
order by month_num;

#Slight decline in the month of March

#Exit Stage Analysis
select exit_stage, count(*) as users_count
from first_transformations
where exit_stage<>'Converted'
group by exit_stage
order by exit_stage; 

#Drop Off
with c1 as(
	select exit_stage, count(*) as users_count
	from first_transformations
	where exit_stage<>'Converted'
	group by exit_stage
	order by exit_stage
), c2 as(
	select * from(
		select users_count, lead(users_count) over(order by exit_stage) as next
		from c1
	) pp
    where next is not null
)

select 
	concat('stage ',row_number() over(order by users_count desc) , ' to ', row_number() over(order by users_count desc) + 1) as stage,
    users_count-next as users_dropped,
    round((users_count-next)*100.0/users_count, 2) as perc_drop
from c2;

#A massive drop from Stage 3-> Stage 4 can be noticed, shows a major bottleneck

#Users Segment from stage 3->4
select segment, round(sum(case when exit_stage='stage3' then 1 else 0 end)*100.0/nullif(sum(stage3_reached), 0), 2) as dropped_perc
from first_transformations
group by segment
order by dropped_perc desc;

#Paid Search and Social Media bring in quantity of traffic but not in quality, lower intent users drop off at committment stage, unlike email and referral.

#Users segmented by segment and device type from stage 3->4
select segment, device, round(sum(case when exit_stage='stage3' then 1 else 0 end)*100.0/nullif(sum(stage3_reached), 0), 2) as dropped_perc
from first_transformations
group by segment, device
order by dropped_perc desc;

#Tablet experience seems bad from 3->4, even email users affected, paid_search seems bad across all devices, referral and desktop seems the best combo for high intent users and no UI friction

#Conversions Trend by segment and month
select segment, month(entry_date) as month_num, count(*) as total_users, sum(converted) as total_conversions, round(sum(converted)*100.0/count(*), 2) as conversion_rate
from first_transformations
group by month_num, segment
order by segment, month_num;

#Paid Search shows a major drop in Feb, slight improvement in March, but crash can be noticed
#Referral is rock-solid and stable
#Social is very low, not counted as stable, rather low quality
#Email is Volatile showing variation in campaign quality, not structural problem coz it showed better results earlier
#Oganic is healthy, but declined so its a signal we cant ignore.