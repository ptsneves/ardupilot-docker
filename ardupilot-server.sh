#!/bin/bash -ex

new_counter=$(flock -x -w 5 /tmp/instance sh -c 'COUNTER=$(cat /tmp/instance); echo $((COUNTER + 1)) | tee /tmp/instance')
/ardupilot/build/sitl/bin/arducopter --console -M + -I$new_counter --home 0, 0, 653.0, 34.0 --speedup 1
