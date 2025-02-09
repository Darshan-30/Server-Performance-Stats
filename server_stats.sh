#!/bin/bash

# Script: server-stats.sh
# Description: Analyzes basic server performance stats.

# Function to print a separator line
print_separator() {
    echo "--------------------------------------------------"
}

# Get OS version
os_version=$(cat /etc/os-release | grep "PRETTY_NAME" | cut -d '"' -f 2)

# Get server uptime
uptime=$(uptime -p)

# Get load average
load_avg=$(uptime | awk -F 'load average:' '{print $2}' | xargs)

# Get logged-in users
logged_in_users=$(who | wc -l)

# Get failed login attempts
failed_logins=$(sudo lastb | wc -l)

# Get CPU usage
cpu_usage=$(top -bn1 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}')

# Get memory usage
memory_total=$(free -m | awk '/Mem:/ {print $2}')
memory_used=$(free -m | awk '/Mem:/ {print $3}')
memory_free=$(free -m | awk '/Mem:/ {print $4}')
memory_usage_percent=$(free | awk '/Mem:/ {printf("%.2f%"), $3/$2*100}')

# Get disk usage
disk_total=$(df -h / | awk '/\// {print $2}')
disk_used=$(df -h / | awk '/\// {print $3}')
disk_free=$(df -h / | awk '/\// {print $4}')
disk_usage_percent=$(df -h / | awk '/\// {print $5}')

# Get top 5 processes by CPU usage
top_cpu_processes=$(ps -eo pid,ppid,cmd,%cpu --sort=-%cpu | head -n 6)

# Get top 5 processes by memory usage
top_memory_processes=$(ps -eo pid,ppid,cmd,%mem --sort=-%mem | head -n 6)

# Output the stats
echo "Server Performance Stats"
print_separator
echo "OS Version: $os_version"
echo "Uptime: $uptime"
echo "Load Average: $load_avg"
echo "Logged-in Users: $logged_in_users"
echo "Failed Login Attempts: $failed_logins"
print_separator
echo "CPU Usage: $cpu_usage"
print_separator
echo "Memory Usage:"
echo "  Total: ${memory_total}MB"
echo "  Used: ${memory_used}MB"
echo "  Free: ${memory_free}MB"
echo "  Usage: $memory_usage_percent"
print_separator
echo "Disk Usage:"
echo "  Total: $disk_total"
echo "  Used: $disk_used"
echo "  Free: $disk_free"
echo "  Usage: $disk_usage_percent"
print_separator
echo "Top 5 Processes by CPU Usage:"
echo "$top_cpu_processes"
print_separator
echo "Top 5 Processes by Memory Usage:"
echo "$top_memory_processes"
print_separator
