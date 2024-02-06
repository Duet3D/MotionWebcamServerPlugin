#!/bin/bash

# Terminate motion as well when we get SIGTERM
onSigTerm() {
	echo "Caught SIGTERM, shutting down motion"
	kill -SIGTERM $pid
}
trap onSigTerm SIGTERM

# Start motion and keep it running even if it crashes
if [[ -f /usr/bin/libcamerify ]]; then
	# Running on bullseye or later, need libcamerify wrapper
	while true; do
		libcamerify ./motion -c /opt/dsf/sd/sys/motion.conf &
		pid=$!

		wait $pid
		if [[ $? == 143 ]]; then
			# Only shut down if the process was terminated due to SIGTERM
			echo "Child process caught SIGTERM, shutting down as well"
			break
		fi
		sleep 1
	done
else
	# Running on buster
	while true; do
		./motion -c /opt/dsf/sd/sys/motion.conf &
		pid=$!

		wait $pid
		if [[ $? == 143 ]]; then
			# Only shut down if the process was terminated due to SIGTERM
			echo "Child process caught SIGTERM, shutting down as well"
			break
		fi
		sleep 1
	done
fi

