#!/bin/bash

TIMESTAMP=$(date +%f-%h-%m-%s)

LOGFILE='/tmp/$TIMESTAMP-$0.log'

ID=$(id -u)

if [ ID -ne 0 ] ; then