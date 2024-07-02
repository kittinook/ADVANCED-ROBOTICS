

# TurtleBot3 Setup and Teleoperation

This repository contains the steps to set up and control a TurtleBot3 robot using Docker and ROS2. 

## Prerequisites

- Raspberry Pi 5
- Docker installed on the Raspberry Pi
- ROS2 installed

## Tutorial

### 1. Install Docker Compose
```sh
sudo apt-get update
sudo apt-get install docker-compose-v2
```

### 2. Navigate to the directory:
Navigate to the directory where you saved your Dockerfile. For example:

```sh
cd ~/Desktop/
git clone https://github.com/kittinook/ADVANCED-ROBOTICS.git
cd ~/Desktop/ADVANCED-ROBOTICS
```

### 3. Build the Docker image:
Run the following command to build a Docker image from your Dockerfile. You can name the image whatever you like; here we'll name it turtlebot3_image:

```sh
sudo docker build -t my-turtlebot3-image .
```

OUTPUT
```sh
[+] Building 626.5s (7/7) FINISHED                                                                                                            docker:default
 => [internal] load build definition from Dockerfile    0.0s
 => => transferring dockerfile: 687B    0.0s
 => [internal] load metadata for docker.io/tiryoh/ros2-desktop-vnc:latest   1.0s
 => [internal] load .dockerignore   0.0s
 => => transferring context: 2B 0.0s
 => [1/3] FROM docker.io/tiryoh/ros2-desktop-vnc:latest@sha256:fb9a8be4ba421479cf0c15eb9efaa4d656edbb5fa1e7e2b1d2008c572c5c2b20 0.0s
 => CACHED [2/3] RUN apt-get update && apt-get install -y     python3-argcomplete     python3-colcon-common-extensions     libboost-system-dev     bui  0.0s
 => [3/3] RUN apt-get update && apt-get install -y     ros-humble-hls-lfcd-lds-driver     ros-humble-turtlebot3-msgs     ros-humble-dynamixel-sdk     624.3s
 => exporting to image  1.1s 
 => => exporting layers 1.1s 
 => => writing image sha256:6108938559574f5e0ccd3dd9ece46ab625fd22f741c68651df1bcf58549bfb12    0.0s 
 => => naming to docker.io/library/my-turtlebot3-image  0.0s
```
### 4. Run a container from the image:
After the image is built, you can run a container using that image. This will start a container and open a shell inside it:

```sh
docker run -it -p 6080:80  --device=/dev/ttyUSB0  --device=/dev/ttyACM0  --privileged  --shm-size=4096  --security-opt seccomp=unconfined  -v ~/Desktop/ADVANCED-ROBOTICS/ros2_ws:/home/ubuntu/turtlebot3_ws my-turtlebot3-image /bin/bash
```


### 5. List the Docker Container
The command `sudo docker ps -a` is used to list all containers on your system, including those that are currently running, stopped, or exited. Here’s a breakdown of what this command does:

```sh
sudo docker ps -a
```

- **`sudo`**: This prefix is used to run the command with superuser (administrator) privileges. Docker commands often require these privileges.
- **`docker`**: This is the Docker command-line interface.
- **`ps`**: This command lists Docker containers.
- **`-a`**: This flag stands for "all" and ensures that the command lists all containers, not just the ones that are currently running.

### Example Output

When you run `sudo docker ps -a`, you might see output like this:

```sh
CONTAINER ID IMAGE COMMAND CREATED STATUS PORTS NAMES
472cf442c4da   turtlebot3_image                  "/bin/bash -c /entry…"   16 minutes ago   Exited (0) 10 minutes ago             goofy_torvalds
```


### Explanation of the Columns

- **CONTAINER ID**: A unique identifier for each container.
- **IMAGE**: The Docker image that was used to create the container.
- **COMMAND**: The command that was run when the container was started.
- **CREATED**: How long ago the container was created.
- **STATUS**: The current status of the container. This could be `Up` (running), `Exited` (stopped), etc.
- **PORTS**: Port mappings between the host and the container.
- **NAMES**: The name assigned to the container.

### Common Usage

- **Inspect container logs**: If you want to see the logs of a specific container, you can use its CONTAINER ID or NAME:
    ```sh
    sudo docker logs ff89ac00951c
    ```
- **Start a stopped container**: You can restart a container using its CONTAINER ID or NAME:
    ```sh
    sudo docker logs ff89ac00951c
    ```
- **Remove a container**: If you no longer need a container, you can remove it:
    ```sh
    sudo docker rm ff89ac00951c
    ```
- **Run a new shell session in a running container**: You can start a new shell session in a running container using docker exec:
    ```sh
    sudo docker exec -it ff89ac00951c /bin/bash
    ```
### 6. Start the Docker Container

Start the Docker container that contains the necessary environment for the TurtleBot3.

```sh
sudo docker start ff89ac00951c
sudo docker attach ff89ac00951c
```


## Troubleshooting

- Ensure that all necessary ROS2 packages are installed in the Docker container.
- Check that the Docker container is running correctly and that no errors are shown in the logs.
- Verify that the `/dev/ttyACM0` device is available and has the correct permissions.


---

This README provides a step-by-step guide to set up and control the TurtleBot3 robot, along with an optional section for building your own Docker image. You can customize the README further based on your project's specific details and requirements.

##########
# Deploy Code

To save a Docker container to a local file, you need to follow a series of steps that involve committing the container’s state to an image and then exporting that image to a tar file. Here's a step-by-step guide on how to do this:

## 1. Commit the Container to an Image
First, you need to commit the running or stopped container to a new image. This will save the current state of the container.
``` sh
sudo docker commit <container_id_or_name> <new_image_name>
```
For eample:
``` sh
sudo docker commit ff89ac00951c my_turtlebot3_image
```

## 2. Save the image to a tar file:

``` sh
sudo docker save -o my_turtlebot3_image.tar my_turtlebot3_image
```

## 3. Load the image from a tar file (on the same or another machine):
``` sh
sudo docker load -i my_turtlebot3_image.tar
```
This process ensures that you can save the state of your Docker container to a file and later restore it, preserving all the changes made in the container.

After you have loaded the Docker image using the docker load command, you can run a new container from the loaded image. Here are the steps and commands you need to follow:

## 4. Verify the Image is Loaded
List the Docker images to verify that the image was loaded correctly:

``` sh
sudo docker images
```
You should see your image (my_turtlebot3_image) listed in the output.

## 5. Run a Container from the Loaded Image
Now you can run a new container from the loaded image using the docker run command. This command will start a container and open a shell inside it:

``` sh
sudo docker run -it -p 6080:80 --device=/dev/ttyUSB0 --device=/dev/ttyACM0 --privileged --shm-size=512m --security-opt seccomp=unconfined -v ~/Desktop/ADVANCED-ROBOTICS/ros2_ws:/home/ubuntu/turtlebot3_ws my_turtlebot3_image /bin/bash
```

### Delete the Docker Image
Once you have identified the image you want to delete, use the docker rmi command followed by the image ID or the repository and tag name.

#### Delete by Image ID
``` sh
sudo docker rmi <image_id>
```
