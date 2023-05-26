drop procedure if exists create_server;
drop procedure if exists create_serverseries;
drop procedure if exists open_dayall;
drop procedure if exists close_dayall;
drop procedure if exists open_rangeall;
drop procedure if exists close_rangeall;
drop procedure if exists routine_open;
drop procedure if exists check_maintenance;
drop procedure if exists add_maintenance;
delimiter //
create procedure create_server(in name text)
begin
	set @email = concat(name, '@acri.c.titech.ac.jp');
	set @url = concat("https://gw.acri.c.titech.ac.jp/wp/vm/", name);
	insert into wp_users (user_login, user_pass, user_nicename, user_email, user_registered, user_url, display_name) values (name, password(concat(left(replace(uuid(), '-', ''), 8))), name, @email, sysdate(), @url, name);
	insert into wp_usermeta (user_id, meta_key, meta_value) select wp_users.ID, 'wp_capabilities', 'a:1:{s:6:"author";b:1;}' from wp_users where wp_users.user_login = name;
	insert into wp_usermeta (user_id, meta_key, meta_value) select wp_users.ID, 'olbgroup', 'teacher' from wp_users where wp_users.user_login = name;
	insert into wp_usermeta (user_id, meta_key, meta_value) select wp_users.ID, 'active', '1' from wp_users where wp_users.user_login = name;
end;
//

create procedure create_serverseries(in prefix text, in vms int)
begin
	set @num = 0;
	while @num < vms do
		set @num = @num + 1;
		set @name = concat(prefix, lpad(@num, 2, '0'));
		call create_server(@name);
	end while;
end;
//

create procedure open_dayall(in open_date date, in term int, in pattern text)
begin
	create temporary table vserves as
		select wp_users.id from wp_usermeta
		inner join wp_users on wp_usermeta.user_id = wp_users.id
		where wp_usermeta.meta_key='olbgroup' and wp_usermeta.meta_value='teacher'
		and wp_users.user_login like pattern collate utf8mb4_general_ci;
	set @time = maketime(0, 0, 0);
	set @period = maketime(24, 0, 0);
	while @time < @period do
		insert ignore into wp_olb_timetable (date, time, room_id) select open_date, @time, id from vserves;
		set @time = addtime(@time, maketime(term, 0, 0));
	end while;
	drop temporary table vserves;
end;
//

create procedure close_dayall(in close_date date, in pattern text)
begin
	create temporary table vserves as
		select wp_users.id from wp_usermeta
		inner join wp_users on wp_usermeta.user_id = wp_users.id
		where wp_usermeta.meta_key='olbgroup' and wp_usermeta.meta_value='teacher'
		and wp_users.user_login like pattern collate utf8mb4_general_ci;
	delete tt from wp_olb_timetable as tt
		inner join vserves on tt.room_id = vserves.id
		where date = close_date;
	drop temporary table vserves;
end;
//

create procedure open_rangeall(in open_date date, in close_date date, in pattern text)
begin
	set @current_date = open_date;
	while @current_date < close_date do
		call open_dayall(@current_date, 3, pattern);
		set @current_date = date_add(@current_date, interval 1 day);
	end while;
end;
//

create procedure close_rangeall(in open_date date, in close_date date, in pattern text)
begin
	set @current_date = open_date;
	while @current_date < close_date do
		call close_dayall(@current_date, pattern);
		set @current_date = date_add(@current_date, interval 1 day);
	end while;
end;
//

create procedure routine_open(in maintenance text)
begin
	set @today = date_format(current_date(), '%Y-%m-01');
	set @open_date = date_add(@today, interval 1 month);
	set @close_date = date_add(@today, interval 2 month);
  if maintenance = '' then
  	set @maintenance_day = date_sub(@open_date, interval 1 day);
  	set @maintenance_day = date_sub(@maintenance_day, interval weekday(@maintenance_day) day);
  	set @maintenance_day = date_add(@maintenance_day, interval 21 day);
  else
    set @maintenance_day = DATE(maintenance);
  end if;

  set @maintenance_time = '12:00:00';

  call open_rangeall(@open_date, @close_date, '%');
	delete wp_olb_timetable from wp_olb_timetable where date = @maintenance_day and time = @maintenance_time;
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