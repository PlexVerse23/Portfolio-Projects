select * from sec_transformations;

#Total Conversions by month
select month(entry_date) as month_num,count(*) as total_users, sum(converted) as total_conversions, round(sum(converted)*100.0/count(*), 2) as conversion_rate
from sec_transformations
group by month_num
order by month_num;

#A significant imporvement and Stability achienved

#Exit Stage Analysis
select exit_stage, count(*) as users_count
from sec_transformations
where exit_stage<>'Converted'
group by exit_stage
order by exit_stage; 

#Drop Off
with c1 as(
	select exit_stage, count(*) as users_count
	from sec_transformations
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

#Stage 3-> 4 Drop Rate restored to normal, major improvement

#Users Segment from stage 3->4
select segment, round(sum(case when exit_stage='stage3' then 1 else 0 end)*100.0/nullif(sum(stage3_reached), 0), 2) as dropped_perc
from sec_transformations
group by segment
order by dropped_perc desc;

#Paid_Search and Social show healthier dropped_perc, even though they are still our weakest meaning our low_intent user problem is genuine, but interventions worked.

#Users segmented by segment and device type from stage 3->4
select segment, device, round(sum(case when exit_stage='stage3' then 1 else 0 end)*100.0/nullif(sum(stage3_reached), 0), 2) as dropped_perc
from sec_transformations
group by segment, device
order by dropped_perc desc;

#The problem with the Tablet UI is fixed, now genuine users can be retained who were hitting friction, a significant drop in dropped_perc in all the categories especially paid_search.

#Conversions Trend by segment and month
select segment, month(entry_date) as month_num, count(*) as total_users, sum(converted) as total_conversions, round(sum(converted)*100.0/count(*), 2) as conversion_rate
from sec_transformations
group by month_num, segment
order by segment, month_num;

#A Healthier and stable conversion rate can be observed across all categories.
#Referral jsut got better with our interventions.
#Email Campaigns and Organic users converion rate also improved showing high drive of high-intent users.
#Social Media's quality also improved, still the lowest but definitely better.