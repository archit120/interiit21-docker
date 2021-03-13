First build the docker image. This may take a long time

```
docker build . -t interiit
```
We need to do some config to get display working

Next up, we start a container with the image.

```
docker run --name interiit_c \
    --env="DISPLAY" \
    --env="QT_X11_NO_MITSHM=1" \
    --volume="/tmp/.X11-unix:/tmp/.X11-unix:rw" \
    -t -d interiit bash
```


The container is named 'interiit_c'.

To get GUI working run
```
xhost +local:root
```
This command might be a security vulnerability (http://wiki.ros.org/docker/Tutorials/GUI) so when done just type. The command is systemwide so no need to re-execute in different terminals
```
xhost -local:root
```


To start a bash shell in the container use

```
docker exec -it interiit_c bash
```

The workspace is pre-configured in `~\catkin_ws\interiit21`. To run the world just open two terminals, execute the above command in both and type

```
cd ~\catkin_ws\interiit21
roslaunch interiit21 interiit_world1.launch
```

and

```
cd ~/ardupilot/ArduCopter/
sim_vehicle.py -v ArduCopter -f gazebo-iris --console
```