#!/bin/sh
echo "enter sudo password here" | sudo -S nmap -sP 192.168.1.* > nmap-scan.txt && echo "$(date)" > lastscan.txt
