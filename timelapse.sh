#!/bin/bash
while true; do scrot -d 30 '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f ~/Pictures/MediaProject/'; done
