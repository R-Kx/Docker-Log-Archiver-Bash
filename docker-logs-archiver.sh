#!/bin/bash
 set -euo pipefail

 
if [[ -n "${SUDO_USER:-}" ]]; then
    USER_HOME=$(getent passwd "$SUDO_USER" | cut -d: -f6)
else
    USER_HOME="$HOME"
fi

 LOG_DIR="$USER_HOME/Desktop/docker-logs"
 DATE=$(date +%Y-%m-%d-%H-%M-%S-%N)
 TEMP_FILE="docker-logs-$DATE.txt"
 ARCHIVE_NAME="docker-logs-$DATE.tar.gz"

 mkdir -p "$LOG_DIR"

 
 if journalctl -u docker -n 50 > "$LOG_DIR/$TEMP_FILE"; then
 	echo "Docker logs succesfully captured $DATE.."
 	sleep 3
 else
 	echo "Docker logs was unable to capture $DATE, terminating process.."
 	sleep 3
 	exit 2
 fi

 shopt -s nullglob
 files=( "$LOG_DIR"/*.txt )

if [[ ${#files[@]} -gt 0 ]]; then
	echo "Docker logs found succesfully, starting to archieve.."
	sleep 3

	if tar -czf "$LOG_DIR/$ARCHIVE_NAME" -C "$LOG_DIR" "$TEMP_FILE" > /dev/null 2>&1; then
		echo "succesfully archieved: $ARCHIVE_NAME .."
		sleep 5

		rm "$LOG_DIR/$TEMP_FILE"
		echo "Temporary files removed ..."
		sleep 3
		
		if [[ $EUID -eq 0 ]]; then
			journalctl -u docker --vacuum-time=7d 2>/dev/null 
			echo "7 days older logs have been removed"
		else
			echo "Skipping Journalctl vacuum (root privileges required)"
		fi
	else
		echo "Archieving failed, terminating process..."
	fi
else 
	echo "system was unable to find docker logs, terminating process..."
fi