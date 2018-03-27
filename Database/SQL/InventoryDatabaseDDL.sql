create schema orders;

create schema inventory;

use inventory;

drop table tblSupplier;

create table tblSupplier(ID integer(5) primary key auto_increment, CompanyName varchar(50) unique not null, ContactName varchar(30) not null, ContactTitle varchar(20) default 'Sales Manager', City integer(4), Phone integer(11) unique not null, Fax integer(11) unique not null, foreign key(City) references world.city(ID));

drop table tblProduct;

truncate table tblproduct;

select * from tblproduct

create table tblProduct(ID integer(10) primary key auto_increment, SupplierID integer(5), ProductType varchar(10), ProductName varchar(40) not null, Volume integer(5) not null check(Volume > 0), UnitPrice float not null check(UnitPrice >= 0), Quantity integer(7) default 0 check(Quantity >= 0), MaxQuantityPerOrder integer(7) default 2 check(MaxQuantityPerOrder >= 1), IsDiscontinued bit default 0, foreign key(SupplierID) references inventory.tblSupplier(ID), foreign key(ProductType) references inventory.tblproducttype(TypeName));

create table tblProductType(TypeName varchar(10) primary key);

use orders;

drop table tblcustomer;

create table tblCustomer(ID integer(9) primary key auto_increment, FirstName varchar(15) not null, LastName varchar(15) not null, City integer(4), Phone integer(10) unique not null, cashPoints float default 0 check(cashPoints >= 0), foreign key(City) references world.city(ID));

drop table tblorder;

create table tblOrder(ID integer(12) primary key auto_increment, OrderDate datetime default now(), CustomerID integer(9), TotalAmount float default 0 check(TotalAmount >= 0), transactionMode varchar(10), billedBy integer(3), foreign key(transactionMode) references orders.tblpaymentmode(Mode), foreign key(billedBy) references sessions.tbluser(ID));

create table tblPaymentMode(Mode varchar(10) primary key);

drop table tblOrderItems;

create table tblOrderItems(ID integer(15) primary key auto_increment, OrderID integer(12), ProductID integer(10), OrderQuantity integer(7) default 1 check(OrderQuantity >= 1), Price float not null check(Price >= 0), foreign key(OrderID) references orders.tblOrder(ID), foreign key(ProductID) references inventory.tblproduct(ID));

use world;

show create table country;

select * from city where CountryCode = 'IND';