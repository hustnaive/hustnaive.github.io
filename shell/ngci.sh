#!/usr/bin/expect -f

set timeout -1     

set ip "#"
set password "#"

set cmd [lindex $argv 0]

switch $cmd {
	"fumao" { set cmd "fumao.letwx.com" }
	"letwx" { set cmd "letwx2" }
	"ng" { set cmd "ng.letwx.com" }
}

if { ![string compare $cmd ""] } {
	set cmd "ng.letwx.com"
}

spawn ssh root@$ip     

expect {
"*yes/no" { send "yes\r"; exp_continue}  
"*password:" { send "$password\r" }   
}  

expect {
"*Welcome to aliyun*" { send "cd /var/www/$cmd\r" }
}

expect {
"*/var/www/*" { send "svn up\r" }
}

interact
