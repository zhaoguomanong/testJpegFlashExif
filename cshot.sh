#!/usr/bin/env bash
index=0
while true
do
    ((index++))
    echo "taking picture $index"
    adb shell input keyevent 27
    sleep 1
done