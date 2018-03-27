use orders;

delimiter //
create procedure procCreateOrder(
in Customer integer(9),
in PaymentMode varchar(10),
out newID integer(12)
)
begin
	if exists (select * from orders.tblCustomer where ID = Customer)
    then
		if exists (select * from orders.tblPaymentMode where Mode = PaymentMode)
        then
			insert into orders.tblorder (CustomerID, TransactionMode) values(Customer, PaymentMode);
            set newID = last_insert_id();
		else
			set newID = 0;
		end if;
	else
		set newID = 0;
	end if;
end //
delimiter ;

drop procedure procAddOrderItems;

delimiter //
create procedure procAddOrderItems(
in Order_ID integer(12),
in Product_ID integer(10),
in Qnty integer(7),
out newID integer(15)
)
begin
	declare uPrice float;

	if exists (select * from orders.tblorder where ID = Order_ID)
    then
		if exists (select * from inventory.tblproduct where ID = Product_ID and Quantity >= Qty and MaxQuantityPerOrder >= Qty)
        then
			select uPrice = UnitPrice from inventory.tblproduct where ID = Product_ID;
			
            insert into orders.tblorderitems (OrderID, ProductID, OrderQuantity, Price)
            values (Order_ID, Product_ID, Qnty, (uPrice*Qnty));
            
            update inventory.tblproduct set Quantity = Quantity - Qnty where ID = Product_ID;
            
            update orders.tblorder set TotalAmount = TotalAmount + (uPrice*Qnty) where ID = Order_ID;
            
            set newID = last_insert_id();
        else
			set newID = 0;
        end if;
    else
		set newID = 0;
    end if;
end //
delimiter ;

create schema sessions;

use sessions;

drop table roles;

create table tblroles(ID integer(3) primary key auto_increment, roleName varchar(30) unique not null, roleDescription text default null);

drop table roleProfile;

create table tblProfile(profileName varchar(30) primary key, roleID integer(3), foreign key(roleID) references sessions.tblroles(ID));

create table tblUser(ID integer(3) primary key auto_increment,userPass text not null, salt text not null,roleProfile varchar(30), foreign key(roleProfile) references sessions.tblprofile(profileName));

create table tblUserDetails(ID integer(3) primary key, userName varchar(30) not null, createdDate datetime not null, deletedDate datetime default null, UpdatedBy integer(3), foreign key(UpdatedBy) references sessions.tblUser(ID), foreign key(ID) references sessions.tblUser(ID));

create table tblLogin(ID integer(10) primary key auto_increment, loginTime datetime not null, UserID integer(3), logoutTime datetime default null, foreign key(UserID) references sessions.tblUser(ID));