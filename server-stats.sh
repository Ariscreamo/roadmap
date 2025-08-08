#!/bin/bash

get_cpu_usage(){
	echo "Total CPU Usage:"
	mpstat | awk '/all/ {usage = 100 - $12; printf("%.2f%%\n", usage)}'
}

get_memory_usage(){
	echo "Total Memory Usage:"
	free -h | awk '/Mem:/ {used = $3; free = $4; total = $2; percent = (used/total) * 100; printf("Used: %s, Free: %s, Total: %s (%.2f%%)\n", used, free, total, percent)}'
}

get_disk_usage(){
	echo "Total Disk Usage:"
	df -h | awk '$NF=="/" {used = $3; free = $4; total = $2; percent = (used/total) *100; printf("Used: %s, Free: %s, Total: %s (%.2f%%)\n", used, free, total, percent)}'
}

get_top_cpu_processes(){
	echo "Top 5 Processes by CPU Usage:"
	ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
}

get_top_memory_processes(){
	echo "Top 5 Processes by Memory Usage:"
	ps -eo pid,comm,%mem --sort=-%mem | head -n 6
}

get_additional_stats(){
	echo "Additional Server Stats:"
	echo "OS Version: $(lsb_release -d | cut -f2-)"
	echo "Uptime: $(uptime -p)"
	echo "Load Average: $(uptime | awk -F'load average:' '{ print $2 }')"
	echo "Logged In Users: $(who | wc -l)"
	echo "Failed Loggin Attempts (last 10):"
	lastb | head -n 10
}

main(){
	get_cpu_usage
	get_memory_usage
	get_disk_usage
	get_top_cpu_processes
	get_top_memory_processes
	get_additional_stats
}

main
