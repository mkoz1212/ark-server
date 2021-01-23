#!/usr/bin/env bash

GOV=$1

for cpu in $(ls -vd /sys/devices/system/cpu/cpu*/cpufreq/); do
    echo "$GOV" > $cpu/scaling_governor
done

cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
