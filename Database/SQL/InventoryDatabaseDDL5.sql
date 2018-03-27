use sessions;

drop procedure procCreateLoginSession;

delimiter //
create procedure procCreateLoginSession(
in user_ID integer(3),
in user_pass text,
out newID integer(10),
out userProfile varchar(30)
)
begin
	if exists (select userProfile = roleProfile from sessions.tbluser where ID = user_ID and userPass = user_pass)
    then
		insert into sessions.tbllogin (loginTime, UserID)
        values (now(), user_ID);
        
        set newID = last_insert_id();
    else
		set newID = 0;
	end if;

end //
delimiter ;

drop procedure procAddUser;

delimiter //
create procedure procAddUser(
in user_name varchar(30),
in user_pass text,
in user_salt text,
in user_profile varchar(30),
in user_createdBy integer(3),
out newID integer(3)
)
begin
	if exists (select * from sessions.tblprofile where profileName = user_profile)
    then
		insert into sessions.tbluser(userPass, salt, roleProfile)
        values (user_pass, user_salt, user_profile);
        
        set newID = last_insert_id();
        
        insert into sessions.tbluserdetails (ID, userName, createdDate, UpdatedBy)
        values (newID, user_name, now(), user_createdBy);
    else
		set newID = 0;
    end if;
end //
delimiter ;

drop trigger before_login_insert;

delimiter //
create trigger before_login_insert before insert
on sessions.tbllogin
for each row
begin
	update sessions.tbllogin set logoutTime = now() where UserID = NEW.UserID and logoutTime = null;
end //
delimiter ;