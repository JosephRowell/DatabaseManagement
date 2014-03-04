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


select p.name
from products p
where p.priceUSD > (
	select avg(p.priceUSD) from p
);



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

select o.ordno, round((o.qty * p.priceUSD) * (1 - c.discount / 100)) from orders o
inner join customers c on c.cid = o.cid
inner join products p on p.pid = o.pid
group by o.ordno, c.discount, p.priceUSD
order by ordno asc;


