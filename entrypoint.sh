#!/bin/bash
if [ "$1" = "vnc" ]; then
    echo "Starting VNC server..."
    vncserver -localhost no -SecurityTypes None -geometry 1920x1080 --I-KNOW-THIS-IS-INSECURE
    openssl req -new -subj /C=JP -x509 -days 365 -nodes -out /root/self.pem -keyout /root/self.pem
    websockify -D --web=/usr/share/novnc/ --cert=/root/self.pem 6080 localhost:5901
    tail -f /dev/null
else
    exec "$@"
fi