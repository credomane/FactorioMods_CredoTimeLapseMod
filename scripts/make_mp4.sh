#!/bin/bash
# Create a mp4 video from timelapse images.
# Requires ffmpeg to be installed.
# Requires 2 arguments:
#   First is name of the desired timelapse folder.
#   Second is the subfolder to stitch together.


./ffmpeg \
-framerate 3 \
-start_number 0 -i ../../script-output/CTLM/$1/$2/%05d.png \
-c:v libx264 \
-vf "fps=24,format=yuv420p" \
-preset medium \
-crf 23 \
"../../script-output/CTLM/$1_$2.mp4"
