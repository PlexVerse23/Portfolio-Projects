/*Analysis Dataset*/

-- Financial Records of Tata Motors Sales

select * from car_finance limit 10;

CREATE VIEW car_finance_analysis as
select *,
	CASE 
		WHEN revenue_type = 'High' and profit_margin_type = 'High' THEN 'Star'
        WHEN revenue_type = 'High' and profit_margin_type = 'Low' THEN 'Underperformer'
        WHEN revenue_type = 'Low' and profit_margin_type = 'High' THEN 'Niche'
        WHEN revenue_type = 'Low' and profit_margin_type = 'Low' THEN 'Weak'
        End as model_performance
        from (
	select 
	c1.model_id, 
    year, 
    country, 
    c2.price_usd as model_price,
	ntile(3) over(order by c2.price_usd) as price_zone,
    units_sold, 
    round(total_revenue, 2) as total_revenue,
    CASE
		WHEN total_revenue>(select avg(total_revenue) from car_finance) THEN 'High'
        WHEN total_revenue<(select avg(total_revenue) from car_finance) THEN 'Low'
	End as revenue_type,
    round(revenue_per_unit, 2) as revenue_per_unit , 
    profit, 
    round((profit/units_sold), 2) as profit_per_unit, 
    average_profit_margin_pct as profit_margin_pct,
    CASE 
		WHEN average_profit_margin_pct<15 THEN 'Low'
        WHEN average_profit_margin_pct>15 THEN 'High'
	End as profit_margin_type,
    round(net_profit_usd, 2) as net_profit_usd, 
    local_manufacturing_cost_usd, 
    marketing_expense_usd,  
    warranty_cost_usd, 
    operating_expense_usd
	from car_finance c1
	inner join car_specs c2 on c1.model_id = c2.car_model
) pp;

-- Overall Model Performance Analysis
CREATE VIEW overall_performance as
select *,
	CASE 
		when (rev_qtr = 4 or rev_qtr = 3) and (pr_qtr = 4 or pr_qtr = 3) then 'Star'
        when (rev_qtr = 4 or rev_qtr = 3) and (pr_qtr = 1 or pr_qtr = 2) then 'Underperformer'
        when (rev_qtr = 1 or rev_qtr = 2) and (pr_qtr = 4 or pr_qtr = 3) then 'Niche'
        when (rev_qtr = 1 or rev_qtr = 2) and (pr_qtr = 1 or pr_qtr = 2) then 'Weak'
	end as performance
    from(
	select *,
		ntile(4) over (order by total_revenue) as rev_qtr,
		ntile(4) over (order by total_profit) as pr_qtr
		from (
		select 
			model_id, 
			sum(units_sold) as units_sold,
			round(sum(total_revenue), 2) as total_revenue,
			round(sum(profit), 2) as total_profit
		from car_finance
		group by model_id
		) pp1
	) pp2;
    
-- Customer Behaviour Analysis of Tata Motors

select * from car_sales limit 10;

CREATE VIEW customer_behaviour as
select
	c1.car_model,
	salesperson_id,
    CASE
		WHEN customer_age BETWEEN 18 AND 29 THEN 'Young Adults'
		WHEN customer_age BETWEEN 30 AND 44 THEN 'Early Mid-Age'
		WHEN customer_age BETWEEN 45 AND 59 THEN 'Mature Adults'
		WHEN customer_age BETWEEN 60 AND 74 THEN 'Senior Adults'
	end as age_group,
    customer_gender,
    customer_income_group,
    customer_residence_type,
    is_first_time_buyer,
    loyalty_program_member,
    discount_reason,
    feedback_score,
    c2.car_type, c2.car_img_url, c2.fuel_type, c2.transmission, c2.safety_rating,
    CASE
		WHEN c2.seating_capacity=4 THEN '4-Seater'
		WHEN c2.seating_capacity=5 THEN '5-Seater'
		WHEN c2.seating_capacity=7 THEN '7-Seater'
		WHEN c2.seating_capacity=8 THEN '8-Seater'
	end as seating_capacity
from car_sales c1
inner join car_specs c2 on c1.car_model = c2.car_model;

-- Underperformer Models Dataset

CREATE VIEW up_dataset as
with c1 as (
select distinct model_id, total_revenue, total_profit
from overall_performance
where performance = 'Underperformer'
), c2 as (
select car_model, car_type, price_usd, 
	case
		when ntile(3) over (order by price_usd) = 1 THEN 'Tier - 3'
        when ntile(3) over (order by price_usd) = 2 THEN 'Tier - 2'
        when ntile(3) over (order by price_usd) = 3 THEN 'Tier - 1'
        end as price_zone,
        transmission, fuel_type, horsepower, safety_rating, seating_capacity 
from car_specs
where car_model in (select model_id from overall_performance where performance = 'Underperformer')
)

select c1.model_id, total_revenue, total_profit, car_type, price_zone,transmission, fuel_type, horsepower, safety_rating, seating_capacity
from c1
inner join c2 on c1.model_id = c2.car_model;

-- Vehicle Specifications

select * from car_specs;

/* EDA */

-- 1) Underperforming Models and their revenue and profit.

select distinct model_id, total_revenue, total_profit
from overall_performance
where performance = 'Underperformer';

-- 2) Which countries have most underperforming models?

select country, sum(units_sold) as up_model
from car_finance_analysis
where model_id in (select model_id from overall_performance where performance = 'Underperformer')
group by country
order by sum(units_sold) DESC
limit 3;

-- 3) Which years saw the sales of most underperforming models?

select year, sum(units_sold) as up_model
from car_finance_analysis
where model_id in (select model_id from overall_performance where performance = 'Underperformer')
group by year
order by sum(units_sold) DESC
limit 3;

-- 4) What kind of cars are underperforming?

select car_model, car_type, price_usd,transmission, fuel_type, horsepower, safety_rating, seating_capacity 
from car_specs
where car_model in (select model_id from overall_performance where performance = 'Underperformer');


