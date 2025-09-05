#!/bin/bash

pgrep grim >/dev/null 2>&1 && killall grim || grim $(xdg-user-dir PICTURES)/$(date +'%s_grim.png') -g $(slurp) 

notify-send "Screenshot in ~/Pictures" 


