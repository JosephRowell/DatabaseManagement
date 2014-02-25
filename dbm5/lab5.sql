--Q1--
--Getthe cities of agents booking an order for customer “Basics”. This time use joins; no 
--subqueries--
select a.city
from agents a
inner join a.aid on o.aid = c.name

select a.city from agents a
inner join orders.aid on customers.cid = customers.name




select p.name, count(p.name)
from orders o,
	products p
	where o.pid = p.pid
	group by p.name
	having count(p.name) > 2
	order by count(p.name) desc

select distinct a.city --get cities of agents --
from orders o,
	agents a
	where a.aid = o.aid
	inner join o.cid on customers.name

--Get	the	pids	of	products	ordered	through	any	agent	who	makes	at	least	one	order	for	
--a	customer	in	Kyoto.	Use	joins	this	time --	

--2--
select pid from orders --get the pid --

--3--
select name from customers
where cid not in (select cid from orders)

--4--
select * 
from customers c left outer join orders o on o.aid = c.city



select c.name
from customers c 
left outer join orders o on o.cid = c.name--go back to this one--

select name from customers
left outer join orders
on orders.cid = customers.cid
where orders.cid is null

select  name from customers 
where cid not in (select o.cid
	from customers c,
	orders o
where o.cid = c.cid)

--Get	the	names	of	customers who	placed	atleast	one rderthrough	an	
--agent	in	their	--
--city,	along	with	those	agent(s’)	names.--
select city from customers
union all --all gives duplicates --
select city
from agents


select city 
from customers
except
select city from agents


select c1.name, c1.city, 
c2.name, c2.city
 from customers c1,
	customers c2
where c1.city = c2.city 
	and c1.cid != c2.cid 
	and c1.cid > c2.cid --custerms who live in same city –


  ---------------------------------------------------------
--Q1--
--Get the cities of agents booking an order for customer “Basics”. This time use joins; no 
--subqueries--

select city from agents --get city from agents--
  where aid in (select aid from orders --find the orders --
    where cid in (select cid from customers --match cid --
      where name = 'Basics')
      
   )
   order by name desc;

 --select a.city from agents a --
 select a.city from agents a
inner join orders o on o.aid = a.aid
inner join customers c on o.cid = c.cid
where c.name = 'Basics'
--where o.cid = 'c002' debugging code --
  inner join customers c on o.aid  --- 

 -- Get	the pids of products ordered through any agent	who makes at least
 --one	order	for a	customer in Kyoto. Use	joins --
 select p.pid from products p
 


 select distinct pid from orders --Get teh pids of products
  where cid in (select cid from customers
    where city = 'Kyoto')
      order by pid asc

select distinct pid from orders o
inner join customers c on o.cid = c.cid
where city = 'Kyoto'

---------------------------------------------------
--Get the names	of customers who placed	at least one order through an 
--agent in their city, along	with	those	agent(s’) names. --

select distinct c.name, a.name from customers c, agents a
inner join orders o on c.cid = o.cid

select distinct customers.name, agents.name from customers, agents
where customers.cid in (select cid from orders
	where orders.aid in (select aid from orders 
	where agents.city = customers.city) )

--Get	the name and city of customers wholive in the city where --
--the least number of products	are	made.	--

select city, sum(quantity) as "sq"
from products
group by city
order by sq asc
limit 1



