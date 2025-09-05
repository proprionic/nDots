#!/bin/bash

grim -g "$(slurp)" -t png - | wl-copy -t image/png

notify-send "Screenshot copied to clipboard"