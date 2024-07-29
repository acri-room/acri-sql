# DB Management Scripts for WordPress OLB System

Before using the scripts, please make sure the OLB plugin of WordPress is installed,
and replace YOUR_DB_PASSWORD in call_mysql.txt with the password of your Wordpress site.

## List of Scripts

- Force Reserve/Cancel
  - registration.sh: force reserve a specific time slot
  - cancellation.sh: force cancel a specific time slot
- Check Reservation Status
  - query.sh: find a user for specific time slot of specific server
  - query_time.sh: list users for specific time slot of all servers
  - query_all.sh: list users for specific date of all servers
  - check_unregistered.sh: list servers opened but not reserved
  - check_closed.sh/sql: list servers not opened for reservation
- Misc.
  - list_user.sh: list all of the regular users
  - list_user.rb: count the number of newly registered users
  - db_routine.sh: call the monthly routine
  - init_procedure.sql: register the monthly routine and other procedures
  - create_accounts.sh: an example for create servers' accounts

## Procedures introduced by init_procedure.sql

- create_server(name)
  - create a server account on WordPress

- create_serverseries(prefix, num)
  - create server accounts
  - name of account is like prefix + 2-digits number

- open_dayterm(date, start_hour, end_hour, term, pattern)
  - open some terms of reservation in a day.
  - the range is from start_hour to **an hour before** end_hour.
  - term must be the duration of a time slot in hour.
  - only the servers matched by pattern are opened. % is a wild-card.

- open_dayall(date, term, pattern)
  - open the date of reservation all-day.
  - term must be the duration of a time slot in hour.
  - only the servers matched by pattern are opened. % is a wild-card.

- open_rangeall(open_date, close_date, pattern)
  - open the all slots of reservation within a range of days
  - the range is from open_date to **a day before** close_date.
  - only the servers matched by pattern are opened. % is a wild-card.

- close_dayterm(date, start_hour, end_hour, term, pattern)
  - close some terms of reservation in a day.
  - the range is from start_hour to **an hour before** end_hour.
  - only the servers matched by pattern are closed. % is a wild-card.

- close_dayall(date, pattern)
  - close the date of reservation all-day.
  - only the servers matched by pattern are closed. % is a wild-card.

- close_rangeall(open_date, close_date, pattern)
  - close the all slots of reservation within a range of days
  - the range is from open_date to **a day before** close_date.
  - only the servers matched by pattern are closed. % is a wild-card.

- routine_open()
  - for cron procedure
  - open from next month to the month after the next.
  - regular maintainance period (12:00- on 3rd Monday) is excluded.
    - WARNING: this procedure cannot open this month. If want, please wrap open\_dayall();

- check_maintenance() 
  - DEPRECATED
  - check maintenance info and if duplicated delete from timetable

- add_maintenance(date, time, server)
  - DEPRECATED
  - add maintenance info
  - paremeter server can be taken only under string
    - all
    - machine's name
    - server prefix(vs0, vs1, vs2, vs3, vs4, vs5, vs6, as0, ag0, vs, as, ag)

## Contributors

- Takefumi MIYOSHI: Director (1st Period, FY 2020-2022)
- Naoki FUJIEDA: Director (2nd Period, FY 2023-)
- Katsunoshin MATSUI: Research Assistant (FY 2020)
- Takuto KANAMORI: Research Assistant (FY 2021)
