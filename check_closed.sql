create temporary table opens as
	select time, sv.user_login from wp_olb_timetable as tt
	inner join wp_users as sv on tt.room_id = sv.id
	where date = @date;

create temporary table vservs as
  select wp_users.user_login from wp_usermeta
	inner join wp_users on wp_usermeta.user_id = wp_users.id
	where wp_usermeta.meta_key='olbgroup' and wp_usermeta.meta_value='teacher' and wp_users.user_login not like "as%";

create temporary table times (time time);
insert into times (time) values
	('00:00:00'), ('03:00:00'), ('06:00:00'), ('09:00:00'),
	('12:00:00'), ('15:00:00'), ('18:00:00'), ('21:00:00');

select vservs.user_login, times.time, 'closed' from times
	cross join vservs
	left join opens on times.time = opens.time and vservs.user_login = opens.user_login
	where opens.time is NULL;
