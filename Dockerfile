FROM osrf/ros:melodic-desktop-full

RUN cd ~ && \
    apt-get install -y git && \
    git clone https://github.com/ArduPilot/ardupilot.git && \
    cd ardupilot && \
    git checkout Copter-3.6 && \
    git submodule update --init --recursive

RUN apt-get update && apt-get install -y python-matplotlib python-serial python-wxgtk3.0 python-wxtools python-lxml python-scipy python-opencv ccache gawk python-pip python-pexpect

RUN pip install future pymavlink MAVProxy

ADD bashrclines /bashrclines

RUN echo 'source "/opt/ros/$ROS_DISTRO/setup.bash"' >> ~/.bashrc
RUN cat bashrclines >> ~/.bashrc

RUN . ~/.bashrc && bash -c 'source "/opt/ros/$ROS_DISTRO/setup.bash" && cd ~/ardupilot/ArduCopter && sim_vehicle.py -w'

RUN apt-get install -y wget


RUN sh -c 'echo "deb http://packages.osrfoundation.org/gazebo/ubuntu-stable `lsb_release -cs` main" > /etc/apt/sources.list.d/gazebo-stable.list'

RUN wget http://packages.osrfoundation.org/gazebo.key -O - | apt-key add -

RUN apt-get update && \
    apt-get install -y gazebo9 libgazebo9-dev

RUN cd ~ && \
    git clone https://github.com/khancyr/ardupilot_gazebo.git && \
    cd ardupilot_gazebo && \
    git checkout dev  && \
    mkdir build &&\
    cd build && \
    cmake .. && \
    make -j4 && \
    make install

RUN echo 'source /usr/share/gazebo/setup.sh' >> ~/.bashrc && \
    echo 'export GAZEBO_MODEL_PATH=~/ardupilot_gazebo/models' >> ~/.bashrc

RUN apt-get upgrade -y libignition-math2
RUN apt-get install -y ros-melodic-mavros ros-melodic-mavros-extras

SHELL ["/bin/bash", "-c"]

RUN source /ros_entrypoint.sh && cd ~ && \
    mkdir catkin_ws && cd catkin_ws && \
    mkdir src && \
    catkin_make && \
    echo 'source ~/catkin_ws/devel/setup.bash' >> ~/.bashrc

ADD interiit21 /root/catkin_ws/src/interiit21

RUN source /ros_entrypoint.sh && cd ~/catkin_ws && catkin_make

RUN wget https://raw.githubusercontent.com/mavlink/mavros/master/mavros/scripts/install_geographiclib_datasets.sh && \
    chmod +x install_geographiclib_datasets.sh && \
    ./install_geographiclib_datasets.sh

RUN echo 'export GAZEBO_MODEL_PATH=~/ardupilot_gazebo/models:~/catkin_ws/src/interiit21/models' >> ~/.bashrc