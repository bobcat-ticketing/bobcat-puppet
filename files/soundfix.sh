#!/bin/sh

DEV=/sys/devices/soc0/sound-sgtl5000.24/HiFi/pmdown_time

if [ -f $DEV ]; then
	echo "Device $DEV found, fixing sound"
	echo 125 > /sys/class/gpio/export
	echo out > /sys/class/gpio/gpio125/direction
	echo 1 > /sys/class/gpio/gpio125/value
	echo -1 > /sys/devices/soc0/sound-sgtl5000.24/HiFi/pmdown_time
else
	echo "Device $DEV not found, not fixing sound"
fi
