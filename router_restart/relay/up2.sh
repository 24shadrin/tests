#!/bin/bash

echo 27 > /sys/class/gpio/export
echo out > /sys/class/gpio/gpio27/direction
echo 0 > /sys/class/gpio/gpio27/value
