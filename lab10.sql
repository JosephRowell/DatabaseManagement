--
-- The table of courses.
--
create table Courses (
    num      integer not null,
    name     text    not null,
    credits  integer not null,
  primary key (num)
);


insert into Courses(num, name, credits)
values (499, 'CS/ITS Capping', 3 );

insert into Courses(num, name, credits)
values (308, 'Database Systems', 4 );

insert into Courses(num, name, credits)
values (221, 'Software Development Two', 4 );

insert into Courses(num, name, credits)
values (220, 'Software Development One', 4 );

insert into Courses(num, name, credits)
values (120, 'Introduction to Programming', 4);

select * 
from courses
order by num ASC;


--
-- Courses and their prerequisites
--
create table Prerequisites (
    courseNum integer not null references Courses(num),
    preReqNum integer not null references Courses(num),
  primary key (courseNum, preReqNum)
);

insert into Prerequisites(courseNum, preReqNum)
values (499, 308);

insert into Prerequisites(courseNum, preReqNum)
values (499, 221);

insert into Prerequisites(courseNum, preReqNum)
values (308, 120);

insert into Prerequisites(courseNum, preReqNum)
values (221, 220);

insert into Prerequisites(courseNum, preReqNum)
values (220, 120);

--1--
CREATE OR REPLACE FUNCTION PreReqsFor(int, REFCURSOR) RETURNS refcursor AS
$$
declare
	courseNumD int       := $1;
	resultset   REFCURSOR := $2;
begin
   open resultset for 
      select p.courseNum, preReqNum
      from Prerequisites p
	where p.courseNum = courseNumD;
   return resultset;
end;
$$
language plpgsql;

select PreReqsFor(499, 'results');
Fetch all from results;

--2--

CREATE OR REPLACE FUNCTION IsPreReqFor(int, REFCURSOR) returns refcursor AS 
$$
declare
	courseNumD int       := $1;
	resultset   REFCURSOR := $2;
begin
   open resultset for 
   select p.courseNum, preReqNum,Courses.name
   from Prerequisites p
   INNER JOIN Courses ON (p.courseNum = Courses.num)
       where p.courseNum = courseNumD;
   return resultset;
     
end;
$$ 
language plpgsql;

select IsPreReqFor(308, 'results');
Fetch all from results;

--Attempted Jedi Challenge--
CREATE OR REPLACE FUNCTION allP()
RETURNS SETOF RECORD AS
$$
DECLARE 
preReq RECORD;
BEGIN
 FOR preReq IN (select "preReqNum" from Prerequisites) LOOP
 --RETURN PreReqsFor(int, REFCURSOR), IsPreReqFor(int, REFCURSOR), next preReq;
 RETURN NEXT PreReq;
 END LOOP;
 END;
 $$ LANGUAGE plpgsql; 
SELECT * FROM allP() AS ("allP" varchar(100));

--Ok it doesn't work but I tried--

-----------------------
select *
from Courses, Prerequisites
order by courseNum DESC;