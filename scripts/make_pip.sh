#!/bin/bash
# Create a picture-in-picture timelapse from two sets of timelapses.
# Requires imagemagick program to be installed.
# Requires 3 arguments:
#   First is name of the desired timelapse folder.
#   Second is the subfolder of the primary image.
#   Third is the subfolder of the secondary image scaled to 1/6 primary image and placed in top-right corner.
# Combined images are saved to the subfolder "pip_timelapse" in the desired timelapse folder.
# Combined images can be used with make_mp4.sh <desired timelapse folder" "pip_timelapse"

