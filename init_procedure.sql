drop procedure if exists create_accounts;
drop procedure if exists open_dayall;
drop procedure if exists routine_open;
drop procedure if exists check_maintenance;
drop procedure if exists add_maintenance;
delimiter //
create procedure create_accounts(in prefix text, in vms int)
begin
	set @num = 0;
	while @num < vms do
		set @num = @num + 1;
		set @name = concat(prefix, lpad(@num, 2, '0'));
		set @email = concat(@name, '@acri.c.titech.ac.jp');
		set @url = concat("https://gw.acri.c.titech.ac.jp/wp/vm/", @name);
		insert into wp_users (user_login, user_pass, user_nicename, user_email, user_url, display_name) values (@name, password(concat(left(replace(uuid(), '-', ''), 8))), @name, @email, @url, @name);
		insert into wp_usermeta (user_id, meta_key, meta_value) select wp_users.ID, 'wp_capabilities', 'a:1:{s:6:"author";b:1;}' from wp_users where wp_users.user_login = @name;
		insert into wp_usermeta (user_id, meta_key, meta_value) select wp_users.ID, 'olbgroup', 'teacher' from wp_users where wp_users.user_login = @name;
	end while;
end;
//

create procedure open_dayall(in open_date date)
begin
	CREATE TEMPORARY TABLE vserves as SELECT user_id FROM wp_usermeta WHERE meta_key = 'olbgroup' and meta_value="teacher";
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "00:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "03:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "06:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "09:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "12:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "15:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "18:00:00", user_id FROM vserves;
	INSERT INTO wp_olb_timetable (date, time, room_id) SELECT open_date, "21:00:00", user_id FROM vserves;
	drop temporary table vserves;
end;
//

create procedure routine_open()
begin
	set @today = current_date();
	set @open_date = date_add(@today, interval 1 month);
	set @close_date = date_add(@today, interval 2 month);

	while @open_date < @close_date do
		call open_dayall(@open_date);
		set @open_date = date_add(@open_date, interval 1 day);
	end while;
	call check_maintenance();
end;
//

create procedure check_maintenance()
begin
	delete tt from wp_olb_timetable as tt, wp_olb_scheduled_maintenance as sm where tt.date = sm.date and tt.time = sm.time and tt.room_id = sm.room_id;
end;
//

create procedure add_maintenance(in exdate date, in extime time, in name text)
begin
	if name = 'all' then create temporary table vserves as select user_id as id from wp_usermeta where meta_key = 'olbgroup' and meta_value = 'teacher';
	else create temporary table vserves as select id from wp_users where user_login regexp concat('^', name, '[0-9]{2,3}$');
	end if;

	insert into wp_olb_scheduled_maintenance (date, time, room_id) select exdate, extime, id from vserves;
	call check_maintenance();
	drop temporary table vserves;
end;
//
delimiter ;
