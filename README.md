# ACRi Room Scheduling System
## TODO
- Refactoring
- Easily Register for Virtual Machine

## File
- init\_procedure.sql
	- Initialize procedure
- create\_accounts.sh
	- An example for create servers' accounts
- README.md
	- This File

## Procedure
- create\_accounts(prefix, num)
	- create accounts
	- name of account is like prefix + 2-digits number

- open\_dayall(date)
	- open the date of reservation all-day.

- routine\_open()
	- for cron procedure
	- open from next month to the month after the next.
	- WARNNING: this procedure cannot open this month. If want, please wrap open\_dayall();

- check\_maintenance()
	- check maintenance info and if duplicated delete from timetable

- add\_maintenance(date, time, server)
	- add maintenance info
	- paremeter server can be taken only under string
		- all
		- machine's name
		- server prefix(vs0, vs1, vs2, vs3, vs4, vs5, vs6, as0, ag0, vs, as, ag)


