--Lab 6--
--Professor Labouseur--
--Database Management--

--1--

select distinct 
c.city, c.name, count(*) maximum  
from customers c
inner join products p on p.city = c.city -- come back to this
group by c.city, c.name
order by maximum desc
limit 1;

--2--

--Gave this one my level best--

select name, city, count(*) maximum from customers
where city in (select city from products)
group by city, name
order by maximum desc
limit 1;

--3--

--I've been working forever on this. Still gonna keep trying--
--It returns nothing, but that can't be right--

select name
from products
group by products.name, priceUSD
having
priceUSD > avg(priceUSD);


--4--

select distinct c.name, o.pid, o.dollars
from orders o
inner join customers c on c.cid = o.cid
order by o.dollars desc;

--5--

--Total in qty--
select c.name, coalesce(o.qty, 0) from customers c
inner join orders o on o.cid = c.cid
order by c.cid;

--Total in dollars--
select c.name, coalesce(o.dollars, 0) from customers c
inner join orders o on o.cid = c.cid
order by c.cid;

--6--

select distinct c.name, p.name, a.name
from customers c, products p
inner join orders o on o.pid = p.pid
inner join agents a on a.aid = o.aid
where a.city = 'New York';

--7--

--will finish  tomorrowr --

select dollars from orders o 
left outer join products p on p.priceUSD = o.dollars
left outer join customers c on c.discount = o.dollars
order by dollars desc
having
 sum(o.qty * p.priceUSD * 1 - c.discount) = o.dollars 

