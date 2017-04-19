#!/usr/bin/env bash



function read_gpu_temp {
    var_gpu_temp = $(nvidia-settings -q GPUCoreTemp | grep -E "GPUCoreTemp" | grep -E "gpu:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
}

function read_fan_speed {
    var_fan_speed = $(nvidia-settings -q GPUCurrentFanSpeed | grep -E "GPUCurrentFanSpeed" | grep -E "fan:0" | grep -E "[0-9]{1,3}*.$" --only-matching | grep -E "[0-9]*" --only-matching)
}

printf "${var_gpu_temp}\n"
printf "${var_fan_speed}\n"

