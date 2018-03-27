use inventory;
use orders;
use world;

drop procedure procAddSupplier;

Delimiter //
create procedure procAddSupplier(
in Name varchar(30),
in Contact varchar(30),
in Title varchar(20),
in CityID integer(4),
in phNo integer(10),
in faxNo integer(10),
out newID integer(5) 
)
BEGIN

	if not exists (select * from inventory.tblSupplier
    where CompanyName = Name or Phone = phno or Fax = faxNo)
    then
		insert into inventory.tblsupplier (CompanyName,ContactName,ContactTitle,City,Phone,Fax) 
		values (Name,Contact,Title,CityID,phNo,faxNo);
		set newID = last_insert_id();
    else
		set newID = 0;
	end if;
END//
Delimiter ;

drop procedure procAddProduct;

delimiter //
create procedure procAddProduct(
in Supplier integer(5),
in Type varchar(10),
in Name varchar(40),
in Vol integer(5),
in Price float,
Qty integer(7),
maxQuantity integer(7),
out newID integer(10)
)
begin

	if Qty is null
    then
		Set Qty = 0;
	end if;
    
    if maxQuantity is null
    then
		Set maxQuantity = 2;
	end if;

	if not exists (select * from inventory.tblproduct 
    where ProductName = Name and Volume = Vol)
    then
		insert into inventory.tblproduct (SupplierID, ProductType, ProductName, Volume, UnitPrice, Qty, MaxQuantityPerOrder)
        values (supplier, Type, Name, Vol, Price, Qty, maxQuantity);
        
        set newID = last_insert_id();
	else
		set newID = 0;
	end if;
end //
delimiter ;

drop procedure procAddProductType;

delimiter //
create procedure procAddProductType(
in Type varchar(10),
out result bool
)
begin
	if exists (select * from inventory.tblProductType where TypeName = Type)
	then
		set result = false;
	else
		insert into inventory.tblProductType values(Type);
        set result = true;
	end if;
end //
delimiter ;

drop procedure procSelectProductbyName;

delimiter //
create procedure procSelectProductbyName(
in Name varchar(40)
)
begin

	set Name = lower(Name);
	select * from inventory.tblproduct where lower(ProductName) like concat('%',Name,'%');
end //
delimiter ;

CALL procSelectProductbyName('Jim');

drop procedure procRestockProduct;

delimiter //
create procedure procRestockProduct(
in ProductID integer(10),
in Qty integer(7),
out result varchar(30)
)
begin

	if Qty >= 0
    then
		if exists (select ID from inventory.tblproduct where ID = ProductID)
		then
			update inventory.tblproduct set Quantity = Qty where ID = ProductID; 
			set result = 'True';
		else
			set result = 'Product does not exist';
		end if;
	else
		set result = 'Quantity less than zero';
	end if;
end //
delimiter ;

drop procedure procDiscontinueProduct;

delimiter //
create procedure procDiscontinueProduct(
in ProductID integer(10) 
)
begin
	update inventory.tblproduct set IsDiscontinued = '1' where ID = ProductID;
end //
delimiter ;

drop procedure procAddCustomer;

delimiter //
create procedure procAddCustomer(
in fName varchar(15),
in lName varchar(15),
in cityID integer(4),
in cntryCode varchar(3),
in phNo integer(10),
out newID integer(9)
)
begin
	if exists (select * from world.city where ID = cityID and CountryCode = cntryCode)
    then
		if exists (select * from orders.tblCustomer where Phone = phNo)
        then
			insert into orders.tblCustomer (FirstName, LastName, City, Country, Phone)
            values (fName, lName, cityID, cntryCode, phNo);
            
            set newID = last_insert_ID();
		else
			set newID = 1; -- Indicates that the user already exists as Phone is considered as secondary key
		end if;
	else
		set newID = 0; -- Indicates that City/ CountryCode is incorrect.
	end if;
end //
delimiter ;

drop procedure procGetProductForID;

delimiter //
create procedure procGetProductForID(
in ProductID integer(10)
)
begin
	select * from inventory.tblproduct where ID = ProductID;
end //
delimiter ;



show create procedure procAddProduct;

delete from tblsupplier where CompanyName = 'Jim Beam Breweries';

Call procAddSupplier('Jim Beam Breweries','Bigus Dickus','Sales Representative',1025,'IND',287642734,273234232,@newID);
select @newID

