#!/bin/bash

gnome-terminal -- roslaunch interiit21 interiit_world1.launch &&
sleep 5
cd ~/ardupilot/ArduCopter/ && sim_vehicle.py -v ArduCopter -f gazebo-iris --console
