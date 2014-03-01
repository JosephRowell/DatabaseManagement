--1--

select a.city from agents a
	inner join orders o on o.aid = a.aid
	inner join customers c on o.cid = c.cid
		where c.name = 'Basics';

--2--

select distinct pid from orders o
	inner join customers c on o.cid = c.cid
		where city = 'Kyoto'


--3--

select name from customers
	where cid not in (select cid from orders);

--4--

select name from customers
	left outer join orders on orders.cid = customers.cid
		where orders.cid is null;

--5--

--Get	the	names	of	customers	who	placed	at	least	one	order	through	an	agent	in	their	
--city,	along	with	those	agent(s’)	names.
--corrected --


select distinct c.name, a.name
	from agents a
		inner join orders o on o.aid = a.aid
		inner join customers c on c.cid = o.cid
			where c.city = a.city;
	


--6--

select c1.name, c1.city, a1.name, a1.city
	from customers c1,
		agents a1
			where c1.city = a1.city;

--7--

select city, sum(quantity) as "sq"
	from products
		group by city
		order by sq asc
	limit 1
