#!/bin/bash
while true; do scrot -d 5 '%Y-%m-%d-%H:%M:%S.png' -e 'mv $f ~/Pictures/MediaProject/'; done
