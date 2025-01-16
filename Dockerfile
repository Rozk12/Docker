FROM osrf/ros:humble-desktop

ENV DEBIAN_FRONTEND=noninteractive
ENV TZ=Asia/Tokyo

WORKDIR /root

# Install basic system utilities
RUN apt update -y && \
    apt install --no-install-recommends -y \
    sudo xterm init systemd snapd vim net-tools curl wget tzdata gnome-terminal software-properties-common && \
    ln -sf /usr/share/zoneinfo/$TZ /etc/localtime && apt clean && rm -rf /var/lib/apt/lists/*

# Install XFCE and VNC related packages for remote desktop access
RUN apt update -y && \
    apt install --no-install-recommends -y \
    xfce4 xfce4-goodies tigervnc-standalone-server novnc websockify dbus-x11 x11-utils x11-xserver-utils x11-apps \
    libcanberra-gtk-module libcanberra-gtk3-module && \
    apt clean && rm -rf /var/lib/apt/lists/*
RUN touch /root/.Xauthority
# Install Git and ROS2 Gazebo
# RUN add-apt-repository ppa:git-core/ppa -y && \
#     apt update -y && \
#     apt install -y git ros-${ROS_DISTRO}-ros-gz && \
#     apt install -y ros-${ROS_DISTRO}-plotjuggler-ros && \
#     apt clean && rm -rf /var/lib/apt/lists/*

# Install build tools for PX4
RUN apt update -y && \
    apt install --no-install-recommends -y \
    build-essential cargo cmake libclang-dev llvm ninja-build python3 python3-pip && \
    apt clean && rm -rf /var/lib/apt/lists/*

# # Install Rust and Cargo
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y && \
#     rm -rf /root/.cargo/registry /root/.cargo/git

# # Configure Git for PX4 directories
# RUN git config --global --add safe.directory "/root/nileworks/PX4-Autopilot" && \
#     git config --global --add safe.directory "/root/nileworks/PX4-Autopilot/*"
# ENV GIT_DISABLE_UNTRACKED_CACHE=1

# # Source ROS2 workspace setup in bashrc
# RUN echo "source /opt/ros/${ROS_DISTRO}/setup.bash" >> /root/.bashrc
# RUN echo "source ~/nileworks/ros/ros_gz_ws/ros2_dev.sh" >> /root/.bashrc

# # Expose VNC and WebSocket ports
# EXPOSE 5901
# EXPOSE 6080

# Set up entrypoint
COPY ./entrypoint.sh /root/entrypoint.sh
RUN chmod +x /root/entrypoint.sh
ENTRYPOINT ["/root/entrypoint.sh"]