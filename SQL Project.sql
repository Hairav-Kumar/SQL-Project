-- Retrieve the total number of orders placed.
select count(order_id) as total_order from orders;

-- Calculate the total revenue generated from pizza sales.
select round(sum(pizzas.price*order_details.quantity),2) from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id;

-- Identify the highest-priced pizza.
select pizza_types.name,pizzas.price from pizzas inner join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id order by price desc limit 1;

-- Identify the most common pizza size ordered.
select pizzas.size,count(order_details.quantity) as count from pizzas inner join order_details on pizzas.pizza_id=order_details.pizza_id group by pizzas.size order by
count desc limit 1;

-- List the top 5 most ordered pizza types along with their quantities.
select pizza_types.name,sum(order_details.quantity) as quantity from pizzas inner join order_details on pizzas.pizza_id=order_details.pizza_id inner join pizza_types 
on pizzas.pizza_type_id = pizza_types.pizza_type_id group by pizza_types.name order by quantity desc limit 5;

-- Join the necessary tables to find the total quantity of each pizza category ordered.
select pizza_types.category,sum(order_details.quantity) from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id inner join pizza_types on pizzas.
pizza_type_id = pizza_types.pizza_type_id group by pizza_types.category;

-- Determine the distribution of orders by hour of the day.
select hour(order_time) ,count(order_id) from orders group by hour(order_time);

-- Join relevant tables to find the category-wise distribution of pizzas.
select pizza_types.category as cat , count(name) from pizza_types group by cat;

-- Group the orders by date and calculate the average number of pizzas ordered per day.
select avg(quantity) from (
select orders.order_date as date, sum(order_details.quantity) as quantity from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id
inner join orders on order_details.order_id = orders.order_id group by date) as hk;

-- Determine the top 3 most ordered pizza types based on revenue.
select pizza_types.name  as name ,sum(pizzas.price*order_details.quantity) as rvn from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id
inner join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id group by name order by rvn desc limit 3;

-- Calculate the percentage contribution of each pizza type to total revenue (Based on category)
select pizza_types.category as ctg, (sum(pizzas.price*order_details.quantity)/(select sum(pizzas.price*order_details.quantity) from pizzas inner join order_details on pizzas.
pizza_id = order_details.pizza_id))*100 as rvn from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id inner join
pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id group by ctg;

-- Analyze the cumulative revenue generated over time.
select date, sum(rvn) over(order by date) as cum_sum from 
(select orders.order_date as date,sum(pizzas.price*order_details.quantity) as rvn from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id
inner join orders on order_details.order_id = orders.order_id group by date) as tab;

-- Determine the top 3 most ordered pizza types based on revenue for each pizza category.
select nm,rvn from(select ctg, nm,rvn, rank() over (partition by ctg order by rvn desc) as rnk from (select pizza_types.category as ctg,pizza_types.name as nm , 
sum(pizzas.price*order_details.quantity) as rvn from pizzas inner join order_details on pizzas.pizza_id = order_details.pizza_id
inner  join pizza_types on pizzas.pizza_type_id = pizza_types.pizza_type_id group by ctg,nm) as sal) as sale where rnk<=3;



