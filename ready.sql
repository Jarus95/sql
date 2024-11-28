SELECT DISTINCT Country FROM Customers;

SELECT product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued
	FROM public.products;


--having
SELECT category_id, Sum(unit_price * units_in_stock)
from public.products where discontinued <> 1
group by category_id HAVING Sum(unit_price * units_in_stock) < 5000
order by sum

--union
select country from customers
	union all
select country from employees  --union bir xil columndagi tablelarni birlashtiradi


select country from customers
	INTERSECT all --all duplicateni ham oladi
select country from employees  --intersect birinchi tableni chiqaradi ikkinchi tableda ham bor bolsagina kesishma


select country from customers
	EXCEPT 
select country from employees    --except birinchi table da bor va 2chi tableda yoq malumotlarni chiqaradi



select product_name, suppliers.company_name from products
inner join suppliers on products.supplier_id = suppliers.supplier_id

select * from products

SELECT category_name, sum(products.units_in_stock) from products
inner join categories on products.category_id = categories.category_id
GROUP by category_name
ORDER by sum(products.units_in_stock) DESC


select category_name, sum(units_in_stock) from products 
INNER join categories on products.category_id = categories.category_id
	WHERE products.discontinued <> 1
GROUP by category_name
HAVING sum(units_in_stock) > 500
ORDER by sum desc


select *  from public.customers
	left join public.orders on public.customers.customer_id = public.orders.customer_id
where order_id is null





Create table teacher
(
	teacher_id serial,
	first_name varchar,
	last_name varchar,
	birth_date date,
	phone_number varchar,
	title varchar
)



alter table teacher add column middle_name varchar;
alter table teacher drop column middle_name;
alter table teacher rename birth_date to birthdate  
alter table teacher ALTER COLUMN phone_number SET DATA TYPE VARCHAR(32);

CREATE TABLE excam 
(
	exam_id serial,
	exam_name varchar(256),
	exam_date date
)

insert into excam (exam_id, exam_name, exam_date) VALUES (1, 'jasur', '16-03-1995')
insert into excam(exam_id, exam_name, exam_date) VALUES(1, 'Sunnat', '24-03-1995')
INSERT into excam(exam_id, exam_name, exam_date) VALUES(3, 'Umida', '21-01-2001')

TRUNCATE excam;



SELECT * FROM public.products
ORDER BY product_id ASC 

alter table public.products add constraint ChK_products_unit_price CHECK(unit_price > 0)

select * from products
INSERT INTO products VALUES ( 'Chaiii', 8, 1, '10 boxes x 30 bags', 22, 39, 0, 10, 1);

alter table products
	alter column product_id set default nextval('public.product_seq')


SELECT max(product_id) from products 

create SEQUENCE if not exists product_seq START WITH 78 OWNED by products.product_id

INSERT INTO public.products(
	 product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued)
	VALUES ('Chaiii', 8, 1, '10 boxes x 30 bags', 22, 39, 0, 10, 1) RETURNING *;



drop TABLE if exists exam;
create table exam(
	exam_id int,
	exam_name varchar(128),
	exam_date date,

    CONSTRAINT PK_exam_exam_id PRIMARY KEY (exam_id)
)

SELECT * FROM EXAM
INSERT INTO exam(exam_id, exam_name, exam_date) VALUES(null, '2ewe2', NOW()) RETURNING *
alter table exam DROP CONSTRAINT pk_exam_exam_id 
alter TABLE exam ADD CONSTRAINT PKK_exam_exam_id PRIMARY KEY (exam_id)

drop table if exists person
	
CREATE TABLE person(
	person_id int,
	person_name varchar(50),
	last_name varchar(50),

	CONSTRAINT PK_person_person_id PRIMARY KEY(person_id) 
	
)


select * from password
select * from person
	
create table password(
	password_id int,
	password_number int  NOT NULL,
	password_registration_date DATE,
	person_id int,

	CONSTRAINT PK_password_password_id PRIMARY KEY(password_id)
)

	ALTER TABLE password 
		ADD CONSTRAINT FK_password_person FOREIGN KEY(person_id) REFERENCES person(person_id)

insert into person VALUES(1, 'jASUR', 'Sulaymonov')
INSERT into password VALUES(1, 870, now(), 1)
DELETE from password where password_id = 1

select * from book
	
create table book(
	book_id serial,
	isbn int not null,
	book_name varchar(128),

	constraint PK_book_book_id primary key(book_id)
)


alter table book
add column weight int 

alter table book add constraint chk_weight CHECK (weight > 0 and weight < 100)


insert into book(isbn, book_name, weight) 
	values(1, 'birbalo', 10)


create SEQUENCE seq1;

drop table student
create table if not exists student(
	student_id int DEFAULT nextval('seq1'),
	full_name text,
	student_course int DEFAULT 1,

	CONSTRAINT PK_student_student_id PRIMARY KEY(student_id)
)
SELECT * from student
alter table student alter COLUMN student_id set default nextval('seq1');
insert into student(full_name) values ('Jasur')

ALTER TABLE student alter column student_course drop DEFAULT --default qiymatni olib tashlash



drop table student
create table if not exists student(
	student_id int GENERATED always as identity,
	full_name text,
	student_course int DEFAULT 1,

	CONSTRAINT PK_student_student_id PRIMARY KEY(student_id)
)
SELECT * from student
alter table student alter COLUMN student_id set default nextval('seq1');
insert into student(full_name) values ('Jasur')

ALTER TABLE student alter column student_course drop DEFAULT --default qiymatni olib tashlash





insert into customers(customer_id, contact_name, city, country, company_name)
values 
('AAAAA', 'Alfred Mann', NULL, 'USA', 'fake_company'),
('BBBBB', 'Alfred Mann', NULL, 'Austria','fake_company');

SELECT * from customers
	
select contact_name,region,country from customers
	order by contact_name,
		CASE WHEN region is NULL THEN country
		ELSE region
		END;

SELECT product_id, product_name, supplier_id, category_id, quantity_per_unit, unit_price, units_in_stock, units_on_order, reorder_level, discontinued
	FROM public.products;



select product_name, unit_price,
CASE WHEN unit_price >= 100 THEN 'too expensive'
	 WHEN unit_price >= 50 and unit_price < 100 THEN 'average'
		ELSE 'low price'
END as Discription
from public.products


SELECT contact_name, 
	Coalesce(order_id::text, 'No orders')
	from customers
left join orders using(customer_id)



select first_name,last_name, 
	Coalesce(NULLIF(title, 'Sales Representative'), 'Sales Stuff')
from employees


select concat(first_name, ' ',last_name), 
	Coalesce(NULLIF(title, 'Sales Representative'), 'Sales Stuff')
from employees

CREATE OR REPLACE FUNCTION get_season(month_number int) RETURNS text AS $$
DECLARE season TEXT;
	BEGIN
	IF month_number BETWEEN 3 AND 5 THEN season = 'Spring';
	ELSEIF month_number BETWEEN 6 AND 8 THEN season = 'Summar';
	ELSEIF month_number BETWEEN 9 AND 11 THEN season = 'Autumn';
	ELSEIF month_number = 1 OR month_number = 12 OR month_number = 2 THEN season = 'Winter';
	ELSE season = 'Unknown season';
END IF;
RETURN season;
END;
$$LANGUAGE plpgsql;

SELECT * from get_season(14);



select * 
into customers_temp
from customers   --table backup


CREATE OR REPLACE FUNCTION get_freight() RETURNS real as $$
BEGIN
	Return AVG(freight) from orders;
END;
	
$$ LANGUAGE plpgsql


select get_freight()



CREATE OR REPLACE FUNCTION get_random_number(number1 int, number2 int) RETURNS INT AS $$
BEGIN
	RETURN FLOOR(RANDOM() * ((number2 - number1 + 1) + number1)):: INTEGER;
END;
	
$$LANGUAGE plpgsql


SELECT get_random_number(22, 33)


SELECT employee_id, territory_id
	FROM public.employee_territories;

SELECT get_season(1);

CREATE OR REPLACE FUNCTION get_min_max_extension(reg_id int) RETURNS TABLE(min_value TEXT, max_value TEXT) AS $$

	BEGIN
	RETURN QUERY 
	SELECT
	MIN(extension), MAX(extension) from employees
	JOIN public.employee_territories USING(employee_id)
	JOIN public.territories USING(territory_id)
	WHERE public.territories.region_id = reg_id;
	END;
$$ LANGUAGE plpgsql


SELECT * FROM get_min_max_extension(1)



create or replace function should_increase_salary(
	cur_salary numeric,
	max_salary numeric DEFAULT 80, 
	min_salary numeric DEFAULT 30,
	increase_rate numeric DEFAULT 0.2
	) returns bool AS $$
declare
	new_salary numeric;
begin
	
	IF min_salary > max_salary 	THEN 
		RAISE EXCEPTION 'min_salary must less than max_salary'   USING HINT= 'min_salary must less than max_salary',
		ERRCODE = 'FDFD3';
	END IF;

	IF min_salary < 0 OR max_salary < 0 THEN
		RAISE EXCEPTION 'must no be less than 0'
		USING HINT = 'must no be less than 0',
		ERRCODE = 'P00P';
		END IF;
		
	END IF;
	if cur_salary >= max_salary or cur_salary >= min_salary then 		
		return false;
	end if;
	
	if cur_salary < min_salary then
		new_salary = cur_salary + (cur_salary * increase_rate);
	end if;
	
	if new_salary > max_salary then
		return false;
	else
		return true;
	end if;	
end;
$$ language plpgsql;

EXPLAIN  SELECT  * from should_increase_salary(40, 45, 65)
SELECT should_increase_salary(40, 0, 65)




select * from pg_am









drop table test
create table test(
	test_id serial,
	decription text,

	constraint PK_test_test_id PRIMARY KEY(test_id),
	constraint Uk_test_description UNIQUE (decription)
)
EXPLAIN
SELECT * FROM test where decription = 'hd'
create UNIQUE index idx_test_test_desc on test(decription)


alter TABLE test drop CONSTRAINT uk_test_description
insert into test(decription) VALUES('hdd')





SELECT *


FROM TABLE1


NATURAL JOIN TABLE2;





WITH cte_name AS (
    SELECT query
)
SELECT *
FROM cte_name;















