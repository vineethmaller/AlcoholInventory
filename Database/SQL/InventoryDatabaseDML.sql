use inventory;

insert into tblSupplier(CompanyName, ContactName, ContactTitle, City, Country, Phone, Fax) 
values('Radico Khaitan Ltd','Pervez Musharaf','Sales representative',1025,'IND',474835941,286029392);

insert into tblPaymentMode values('Sodexo');

insert into tblcustomer(FirstName, LastName, City, Country, Phone) values('Guest','Account',1024,'IND',0000000000);

truncate table tblcustomer;

select * from tblcustomer;

update tblproduct
set Quantity = 100, MaxQuantityPerOrder = 10
where ID = 136;

select * from tblproduct where Quantity >= 100 and UnitPrice >= 1000;

select * from tblproduct where ProductType = 'Wine' and UnitPrice <= 2000 and UnitPrice > 1000;

select * from tblProduct; 
truncate table tblproduct;
select * from tblProductType;

select * from tblSupplier;		

select cty.ID, cty.Name, cty.CountryCode 
from world.City cty
join world.Country cnty
on cty.CountryCode = cnty.Code
where cnty.Name = 'India';

select * from tblcustomer;