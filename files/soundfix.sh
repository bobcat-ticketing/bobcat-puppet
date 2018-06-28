#!/bin/bash

PM_DEV=/sys/devices/soc0/sound-sgtl5000.24/HiFi/pmdown_time

function write_dev
{
	device=$1
	value=$2

	if [ ! -f $device ]; then
		echo "ERROR: ${device} not found"
		return 1
	fi

	echo $value > $device

	if [ $? != 0 ]; then
		echo "ERROR: Error writing to ${device}"
		return 2
	fi
}

if [ -e $PM_DEV ]; then
	echo "INFO: Device ${PM_DEV} found, fixing sound"

	# Enabling GPIO 125 (if needed)
	if [ ! -d /sys/class/gpio/gpio125 ]; then
		write_dev /sys/class/gpio/export 125
	fi

	# Configure GPIO 125 as output and set GPIO 125 high
	write_dev /sys/class/gpio/gpio125/direction out && \
	write_dev /sys/class/gpio/gpio125/value 1

	# Set sound device power down to 'never'
	write_dev $PM_DEV -1
else
	echo "NOTICE: Device ${PM_DEV} not found, not fixing sound"
fi
