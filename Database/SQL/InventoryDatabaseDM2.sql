create view vAggSupplierProductTypeCost
as
select SupplierName, ProductType, sum(ProductCost) 'TotalCost'
from (select tblsupplier.CompanyName 'SupplierName', tblproduct.ProductType ,tblproduct.SupplierID SupplierID,  (tblproduct.UnitPrice*(9/10)*tblproduct.Quantity) 'ProductCost' 
		from tblProduct
        join tblsupplier
        where tblsupplier.ID = tblproduct.SupplierID) as tblproductcost
group by ProductType, SupplierName
order by SupplierName;

create procedure procAddSupplier(
in SupplierName varchar(30),
in SupplierContact varchar(30),
in Title varchar(20),
in City integer(4),
in Country varchar(3),
in Phone integer(10),
in Fax integer(10),
out ID integer(10)
)
begin

		insert into inventory.tblsupplier(CompanyName,ContactName,ContactTitle,City,Country,Phone,Fax)
		values(SupplierName,SupplierContact,Title,City,Country,Phone,Fax);
    
		return ID
end

