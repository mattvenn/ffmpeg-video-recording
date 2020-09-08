framerate=30
screensize=2560x1600
webcamsize=1280x800
thread_queue_size=1024
webcamdevice=/dev/video2 # either 0 or 2 depending on usb
v4l2-ctl -d $webcamdevice --set-ctrl=power_line_frequency=1 # 50 hz
v4l2-ctl -d $webcamdevice --set-ctrl=focus_auto=0           # no auto focus
v4l2-ctl -d $webcamdevice -L

# vcodec h264 was important for webcam
# -c:v libx264rgb -crf 0 and -preset ultrafast says don't try to make small file sizes
# removed the half sizing of the screen

ffmpeg -loglevel error -stats \
    -f alsa -ac 2 -sample_fmt s16 -thread_queue_size $thread_queue_size -i hw:1,0 -async 1 \
    -f v4l2 -video_size $webcamsize -framerate $framerate -vcodec h264 -thread_queue_size $thread_queue_size -i $webcamdevice\
    -f x11grab -video_size $screensize -framerate $framerate -thread_queue_size $thread_queue_size -i :0.0+0,0 \
    -map 0:a:0 $1.wav \
    -map 1:v:0 -c:v libx264 -crf 20 -preset ultrafast $1-webcam.mkv \
    -map 2:v:0 -c:v libx264 -crf 20 -preset ultrafast $1-screen.mkv \

# afterwards
# ffmpeg -i interview-screen.mkv -strict -2 -f mp4 interview-screen.mp4
# works for making them openable in premier
