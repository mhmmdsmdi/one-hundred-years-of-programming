#!/bin/bash

set_manual_time() {
    read -p "Enter date and time (YYYY-MM-DD HH:MM:SS): " datetime
    sudo date -s "$datetime"
    echo "Time manually set to: $datetime"
}

set_ntp_time() {
    read -p "Enter NTP server (e.g., pool.ntp.org): " ntpserver
    sudo timedatectl set-ntp false

    # Configure systemd-timesyncd with new NTP server
    sudo sed -i '/^NTP=/d' /etc/systemd/timesyncd.conf
    echo "NTP=$ntpserver" | sudo tee -a /etc/systemd/timesyncd.conf > /dev/null

    sudo systemctl restart systemd-timesyncd
    sudo timedatectl set-ntp true
    echo "Time syncing with $ntpserver"
}

get_current_ntp() {
    echo "Current NTP settings:"
    grep "^NTP=" /etc/systemd/timesyncd.conf || echo "No NTP server configured in systemd-timesyncd.conf"
}

set_timezone() {
    read -p "Enter timezone (default: Asia/Tehran): " timezone
    timezone=${timezone:-Asia/Tehran}
    sudo timedatectl set-timezone "$timezone"
    echo "Timezone set to: $timezone"
}

check_time_status() {
    timedatectl status
}

while true; do
    echo "Choose an option:"
    echo "1) Set time manually"
    echo "2) Set NTP server and sync time"
    echo "3) Get current NTP server"
    echo "4) Set timezone"
    echo "5) Check time status"
    echo "6) Exit"
    read -p "Enter choice [1-6]: " choice

    case "$choice" in
        1) set_manual_time ;;
        2) set_ntp_time ;;
        3) get_current_ntp ;;
        4) set_timezone ;;
        5) check_time_status ;;
        6) exit 0 ;;
        *) echo "Invalid option. Try again." ;;
    esac
done
