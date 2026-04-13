#!/bin/bash
script_dir=$(dirname "$0")
/usr/bin/amixer -c 0 cset name='ADC Data Select' 'Right Right' > /dev/null
/usr/bin/amixer -c 0 cset name='ALC Capture Max PGA' '7' > /dev/null
/usr/bin/amixer -c 0 cset name='ALC Capture Min PGA' '3' > /dev/null
/usr/bin/amixer -c 0 cset name='ALC Capture Function' 'Stereo' > /dev/null
recordfunc(){
	echo "当前状态正在录音，请讲话..."
	/usr/bin/arecord -r 441000 -f S16_LE -c 2 -d 5 ${script_dir}/.record.wav  -D plughw:0,0
	echo "当前状态正在播放，请使用耳机听..."
	/usr/bin/aplay ${script_dir}/.record.wav
}
recordfunc
recordfunc
recordfunc
recordfunc
	echo "程序已经执行完成，如需要重测，请重新点击。"

