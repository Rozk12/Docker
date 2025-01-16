#!/bin/bash

workspace_path="/path/to/sim_workspace"
workspace_path="/home/ryu/nileworks/ros"
# px4_log_path="/path/to/px4_log"
# px4_log_path="/home/ryu/nileworks/PX4-Autopilot/fs/microsd"
px4_log_path="/fs/microsd"
vnc=false  # Set to true to use VNC, false to use built-in display


if [ "$vnc" = true ]; then
    # Run with VNC viewer in browser
    gnome-terminal --tab -t "vcn" -- bash -c "
    docker run --rm -it --name gazebosim_container \
        --mount type=bind,source=\"${workspace_path}\",target=/root/nileworks/ros \
        --env=\"DISPLAY=:1.0\" \
        --env=\"NO_AT_BRIDGE=1\" \
        -p 6080:6080 gazebosim_image vnc"

    # Wait for 4 seconds
    sleep 4

    # Open VNC viewer in the default browser
    xdg-open "https://localhost:6080" 

    sleep 0.5
    # Start a bash session inside the container
    docker exec -it gazebosim_container bash
else
    # Run with built-in display
    xhost +local:docker
    docker run -it --rm --name gazebosim_container \
        --mount type=bind,source="${workspace_path}",target=/root/nileworks/ros \
        --mount type=bind,source="${px4_log_path}",target=/fs/microsd \
        --network host \
        --env="DISPLAY=$DISPLAY" \
        --env="NO_AT_BRIDGE=1" \
        --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
        gazebosim_image bash
fi