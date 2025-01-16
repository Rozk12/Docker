@echo off

@REM set workspace_path=C:\path\to\workspace
set workspace_path=C:\Users\ryu.ozaki\Documents\nileworks\ros
@REM If you are using WSL, you can use the following path
set workspace_path=\\wsl.localhost\Ubuntu\home\<username>\path\to\workspace

set px4_log_path=C:\Users\ryu.ozaki\Documents\nileworks\PX4-Autopilot\fs\microsd
@REM set vnc=true
set vnc=false


IF /I "%vnc%"=="true" (
    @REM RUN with browser
    docker run -d --rm -it --name ubuntu_container ^
        --mount type=bind,source="%workspace_path%",target=/root/nileworks/ros ^
        --mount type=bind,source="%px4_log_path%",target=/fs/microsd ^
        --env="DISPLAY=:1.0" ^
        --env="NO_AT_BRIDGE=1" ^
        -p 6080:6080 ubuntu_image vnc

    sleep 4 
    start "" "http://localhost:6080"
    docker exec -it ubuntu_container bash
) ELSE (
    @REM RUN with built-in display
    @REM docker run -it --rm --name ubuntu_container ^
    @REM     --mount type=bind,source="%workspace_path%",target=/root/nileworks/ros ^
    @REM     --mount type=bind,source="%px4_log_path%",target=/fs/microsd ^
    @REM     --network host ^
    @REM     --env="DISPLAY=host.docker.internal:0.0" ^
    @REM     --env="NO_AT_BRIDGE=1" ^
    @REM     gazebosim_image bash
    
    docker run -it --rm --name ubuntu_container ^
        --mount type=bind,source="%workspace_path%",target=/root/nileworks/ros ^
        --mount type=bind,source="%px4_log_path%",target=/fs/microsd ^
        --mount type=bind,source="\\wsl.localhost\Ubuntu\tmp\.X11-unix",target=/tmp/.X11-unix ^
        --network host ^
        --env="DISPLAY=:0" ^
        --env="NO_AT_BRIDGE=1" ^
        ubuntu_image bash
)
