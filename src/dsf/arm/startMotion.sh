#!/bin/bash

if [[ -f /usr/bin/libcamerify ]]; then
	# Running on bullseye, need libcamerify wrapper
	libcamerify ./motion -c /opt/dsf/sd/sys/motion.conf
else
	# Running on buster
	./motion -c /opt/dsf/sd/sys/motion.conf
fi

