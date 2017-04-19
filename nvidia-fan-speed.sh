#!/usr/bin/env bash

read_gpu_temp() {
    temp=$(nvidia-settings -q GPUCoreTemp | grep -E "GPUCoreTemp" | grep -E "gpu:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
    echo ${temp}
}

read_fan_speed() {
    speed=$(nvidia-settings -q GPUCurrentFanSpeed | grep -E "GPUCurrentFanSpeed" | grep -E "fan:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
    echo ${speed}
}

set_fan_speed() {
    # set new fan speed
    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=${1}"
    # wait 5 seconds for fan to reach new speed level
    sleep 5s
}

print_info() {
    echo "temp is ${1}"
    echo "speed is ${2}"
}

adjust_fan_speed() {
    # get current speed and temp
    temp=$(read_gpu_temp)
    speed=$(read_fan_speed)
    
    # for low temperature
    if (($temp < 50))
    then
        print_info $temp $speed
        if (($speed < 30 || $speed > 35))
        then
            set_fan_speed 30 
        fi        
    elif (($temp >= 50 && $temp < 60))
    then
        print_info $temp $speed
        if (($speed < 45 || $speed > 55))
        then
            set_fan_speed 50 
        fi        
    elif (($temp >= 60 && $temp < 74))
    then
        print_info $temp $speed
        if (($speed < 70 || $speed > 80))
        then
            set_fan_speed 75 
        fi        
    elif (($temp >= 75))
    then
        print_info $temp $speed
        if (($speed < 95))
        then
            set_fan_speed 100
        fi        
    fi
}


while true
do
    adjust_fan_speed
    $(sleep 2s)
done
