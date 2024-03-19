#!/bin/bash

ip_address= #UPDATE

cat /usr/local/zeek/logs/current/conn.log | nc $ip_address 5555
#cat /usr/local/zeek/logs/current/conn.log | nc $ip_address input_port
#cat /usr/local/zeek/logs/current/http.log | nc $ip_address input_port
#cat /usr/local/zeek/logs/current/dns.log | nc $ip_address input_port
#cat /usr/local/zeek/logs/current/stderr.log | nc $ip_address input_port

