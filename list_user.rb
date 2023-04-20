#!/usr/bin/ruby
# list_user.rb
# count the number of newly registered users

WP_LIST_USER_QUERY = "/usr/local/acri/list_user.sh"
WP_LIST_USER_QUERY_DATA = "/usr/local/acri/wp_user.dat"
WP_USER_COUNT_FILE = "/usr/local/acri/wp_user_count.csv"

system(WP_LIST_USER_QUERY)
users = []
open(WP_LIST_USER_QUERY_DATA){|f| users = f.read.strip.split("\n")}

prev_total = 0
if File.exist?(WP_USER_COUNT_FILE) then
  data = []
  open(WP_USER_COUNT_FILE){|f|
    lines = f.read.strip.split("\n")
    data = lines.map{|x| x.split(/\s*,\s*/)} if lines != nil
  }
  data.each{|d| prev_total += d[1].to_i }
end

t = Time.now
t -= 24 * 60 * 60
diff = users.size - prev_total
new_data = format("%04d-%02d-%02d,%d", t.year, t.month, t.day, diff)
system("touch #{WP_USER_COUNT_FILE}")
system("echo #{new_data} >> #{WP_USER_COUNT_FILE}")
