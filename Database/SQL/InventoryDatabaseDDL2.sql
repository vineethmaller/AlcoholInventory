use inventory;

drop view vSupplier;

create view vSupplier 
as 
select supplier.ID, supplier.CompanyName, supplier.ContactName, supplier.ContactTitle,
		city.CityName, city.CountryName, supplier.Phone, supplier.Fax 
from inventory.tblsupplier supplier 
join (select cty.ID, cty.Name as 'CityName', cnty.Name as 'CountryName'
		from world.city cty
        join world.country cnty
        on cty.CountryCode = cnty.Code) city 
on supplier.City = city.ID;

drop view vcityandcountry;

use world;

create view vcityandcountry
as
select cty.ID, cty.Name as 'CityName', cnty.Name as 'CountryName'
from world.city cty
join world.country cnty
on cty.CountryCode = cnty.Code;

use orders;

drop view vcustomer;

create view vCustomer 
as 
select customer.ID, customer.FirstName, customer.LastName, city.CityName, 
		city.CountryName, customer.Phone 
from orders.tblCustomer customer 
join world.vcityandcountry city 
on customer.City = city.ID;


