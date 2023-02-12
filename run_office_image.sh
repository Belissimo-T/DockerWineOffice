#!/bin/bash

echo "=>" Running Shell in installed Office image
docker run -ti --net=none --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix -v ~/.:/mnt/host:Z --entrypoint=bash wo_office_installed
