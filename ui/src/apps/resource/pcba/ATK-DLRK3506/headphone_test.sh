#!/bin/sh
gst-play-1.0 /userdata/ui/src/apps/resource/audio/*mp3
#amixer sset Speaker 127,127
for i in {1..1000}; do
	gst-play-1.0 /userdata/ui/src/apps/resource/audio/*mp3
        sleep 1
done

