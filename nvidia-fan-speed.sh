#!/usr/bin/env bash


read_gpu_temp() {
    temp=$(nvidia-settings -q GPUCoreTemp | grep -E "GPUCoreTemp" | grep -E "gpu:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
    echo ${temp}
}

read_fan_speed() {
    speed=$(nvidia-settings -q GPUCurrentFanSpeed | grep -E "GPUCurrentFanSpeed" | grep -E "fan:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
    echo ${speed}
}

timestamp() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')]"
}

set_fan_speed() {
    dt=$(timestamp)
    # set new fan speed
    nvidia-settings -a "[gpu:0]/GPUFanControlState=1" -a "[fan:0]/GPUTargetFanSpeed=${1}"
    echo "${dt} setting fan speed to ${1}%"
    echo "sleeping 10s to wait for fan reaching new speed level..."
    # wait 10 seconds for fan to reach new speed level
    sleep 10s
}

print_info() {
    dt=$(timestamp)
    echo "${dt} temp is ${1}"
    echo "${dt} speed is ${2}"
}

adjust_fan_speed() {
    # get current speed and temp
    temp=$(read_gpu_temp)
    speed=$(read_fan_speed)

    # comment or uncomment debug printing here
    #print_info $temp $speed
    
    # for low temperature
    if (($temp < 50))
    then
        if (($speed < 30 || $speed > 35))
        then
            set_fan_speed 30 
        fi        
    elif (($temp >= 50 && $temp < 60))
    then
        if (($speed < 45 || $speed > 55))
        then
            set_fan_speed 50 
        fi        
    elif (($temp >= 60 && $temp < 73))
    then
        if (($speed < 70 || $speed > 80))
        then
            set_fan_speed 75 
        fi        
    elif (($temp >= 73))
    then
        if (($speed < 95))
        then
            set_fan_speed 100
        fi        
    fi
}


# main loop
while true
do
    adjust_fan_speed
    $(sleep 2s)
done
