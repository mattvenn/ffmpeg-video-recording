framerate=30
screensize=2560x1440
webcamsize=1280x800
webcamsize=1920x1080
webcamdevice=/dev/video0 # either 0 or 2 depending on usb

# setup the webcam to 50hz and no autofocus
v4l2-ctl -d $webcamdevice --set-ctrl=power_line_frequency=1 # 50 hz
v4l2-ctl -d $webcamdevice --set-ctrl=focus_auto=0           # no auto focus
#v4l2-ctl -d $webcamdevice -L


#-f alsa -ac 2 -sample_fmt s16 -thread_queue_size $thread_queue_size -i hw:1,0 \
#-map 0:a:0 $1.wav \

ffmpeg -loglevel warning -stats \
    -f v4l2 -video_size $webcamsize -framerate $framerate -vcodec h264 -i $webcamdevice\
    -f x11grab -video_size $screensize -framerate $framerate  -i :1.0+0,0 \
    -map 0:v:0 -c:v h264_nvenc -preset slow $1-webcam.mp4 \
    -map 1:v:0 -c:v h264_nvenc -preset slow $1-screen.mp4 \

#ffmpeg -f x11grab -framerate 60 -video_size 2560x1440 -i :1.0+0,0 -c:v h264_nvenc -preset fast test.mkv
#ffmpeg -f x11grab -framerate 30 -video_size 2560x1440 -i :1.0+0,0 -c:v h264_nvenc -preset slow test.mp4
