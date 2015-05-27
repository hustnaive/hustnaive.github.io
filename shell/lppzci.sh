#!/usr/bin/expect -f

set timeout -1     

set ips(0) "#"
set ips(1) "#"
set password "#"

set cmd [lindex $argv 0]

set i [array startsearch ips]
while { [array anymore ips $i] } {
	set ip $ips([array nextelement ips $i])

	spawn ssh root@$ip     
	expect {
	 "*yes/no" { send "yes\r"; exp_continue }  
	 "*password:" { send "$password\r"; exp_continue }   
	 "*Welcome to aliyun*" { send "cd /var/www/lppz.letwx.com\r"; exp_continue }
	 "*/var/www/lppz.letwx.com#" { send "svn up\r";  }
	}  

	expect {
		"*revision*" { 
	 	#没有带exit 每个服务器操作完后，等待手动退出
		if { [string compare $cmd "exit"] } {
			interact
		}
		if { ![string compare $cmd "exit"] } {
			send "exit\r" 
		}
	 }
	}
}
