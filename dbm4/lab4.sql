--Joey Rowell--
--Database Management--
--Lab 4 --

-- 1 --
-- Get  the  cities  of  agents  booking  an  order  for  customer  “Basics” --

select city from agents --get city from agents--
  where aid in (select aid from orders --find the orders --
    where cid in (select cid from customers --match cid --
      where name = 'Basics')
      
   )
   order by name desc;
  
 ;
 
 -- 2 --    --check this one later again--
 -- Get  the  pids  of  products  ordered  through  any  agent  who  makes  at  least  one  order  for  
--a  customer  in  Kyoto.    (This  is  not  the  same  as  asking  for  pids  of  products  ordered  by  a  
--customer  in  Kyoto.) --

 select distinct pid from orders --Get teh pids of products
  where cid in (select cid from customers
    where city = 'Kyoto')
      order by pid asc
;

-- 3 --
-- Find  the  cids  and  names  of  customers  who  never  placed  an  order  through  agent a03 --

select cid, name from customers -- not 1,2,3 or 6. This spits out the right answer but not sure if right --
  select cid, name from customers --get cid, name from customers --
  where cid not in (select cid from orders --find the orders --
    where aid not in (select aid from agents --match cid --
      where name != 'Brown'))
  ;
  
-- 4 --
-- Get  the  cids  and  names  of  customers  who  ordered  both  product  p01  and p07 --

select cid, name from customers
  where cid in (select cid from orders
    where pid in (select pid from products
      where name = 'comb'
      or name = 'case')
     )
 ;

 -- 5 --
 -- Get  the  pids  of  products  ordered  by  any  customers  who  ever  placed  an  order  through  
-- agent  a03.

--should have p03, p05, p04, p07, 
select pid from orders
  where aid in (select aid from agents
    where name = 'Brown')
    order by pid asc;


-- 6 --
-- Get  the  names  and  discounts  of  all  customers  who  place  orders  through  agents  in  Dallas  or  Duluth

select name, discount from customers  --Get the names and discounts from all customers
where cid in (select cid from orders  --who place orders
		where aid in (select aid from agents --from agents
			where city = 'Dallas' --in Dallas or Duluth --
			or city = 'Duluth')
		)
order by name asc;


-- 7 --

--Find  all  customers  who  have  the  same  discount  as  that  of  any  customers  in  Dallas  or  Kyoto. --

select * from customers  --Get the names and discounts from all customers
where discount in (select discount from customers
	where city = 'Dallas'
	or city = 'Kyoto');




