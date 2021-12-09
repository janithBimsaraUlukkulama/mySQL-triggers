create database triggers;
use triggers;
show tables;

-- before insert trigger -------------------------------------------------------------------------------------------------------------------------------------
create table customers
(cust_id int, age int, name varchar(20));

delimiter //
create trigger age_verify
before insert on customers
for each row 
if new.age < 0 then set new.age = 0;
end if; // 

insert into customers values(1, 20, "sam"), (2, -20, "kane");
select * from customers;

-- after insert trigger -----------------------------------------------------------------------------------------------------------------------------------------
create table customers1
( id int auto_increment primary key, name varchar(20) not null, email varchar(30), birth_date date);

create table message
( id int auto_increment, messageId int, message varchar(300) not null, primary key (id, messageId));

delimiter //
create trigger check_null_dob
after insert on customers1
for each row
begin
if new.birth_date is null then
insert into message(messageId, message) values (new.id, concat('Hi ', new.name, ' , please update your bith date'));
end if;
end //
delimiter ;

insert into customers1(name, email, birth_date) 
values 
("cus1", "cus1@email.com", null),
("cus2", "cus2@email.com", "1996-06-06"),
("cus3", "cus3@email.com", "1997-07-07");

select * from customers1;
select * from message;

-- before update trigger ---------------------------------------------------------------------------------------------
 create table employees
 (id int primary key, emp_name varchar(20), age int, salary float);
 
 insert into employees values
 (1, "emp_1", 18,  100000),
 (2, "emp_2", 19, 132121),
 (3, "emp_3", 17, 144112),
 (4, "emp_4", 20, 1045454),
 (5, "emp_5", 11, 105454),
 (6, "emp_6", 60, 104111),
 (7, "emp_7", 40, 1000044),
 (8, "emp_8", 25, 100444),
 (9, "emp_9", 26, 107444);

delimiter //
create trigger upd_trigger
before update on employees
for each row 
begin if new.salary = 100000 then 
set new.salary = 110000;
elseif new.salary > 100000 then
set new.salary = new.salary * 110/100;
end if;
end //
delimiter ;

update employees
set 
	salary = 100000
where 
	id = 1;
    
select * from employees where id =1;

-- before delete trigger ----------------------------------------------------------------- 
create table salary
(eid int primary key, validFrom date not null, amount float not null);

insert into salary 
values 
(1, '2020-10-10', 98000),
(2, '2020-10-20', 88000),
(3, '2020-10-11', 198000);

select * from salary;

create table salaryDelete(
id int primary key auto_increment, eid int, validFrom date not null, amount float not null, deleteDate timestamp default now());

delimiter //
create trigger salary_delete
before delete on salary
for each row
begin
insert into salaryDelete (eid, validFrom, amount)
value(old.eid, old.validFrom, old.amount);
end //
delimiter ;

delete from salary where eid = 2;

select * from salaryDelete;


