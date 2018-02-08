#!/bin/bash
rm -rf /tmp/user
mkdir /tmp/user
cp -R ~/.1C /tmp/user
cp -R ~/.1cv8 /tmp/user
docker run \
    --tty \
    --detach \
    --rm \
    --env DISPLAY \
    --volume $HOME/.Xauthority:/home/user/.Xauthority \
    --volume $HOME:/home/user \
    --net=host \
    --pid=host \
    --ipc=host \
    --name=1c \
    sas/1c-client:i386 bash
