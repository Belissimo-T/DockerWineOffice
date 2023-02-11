#!/bin/bash

echo "=>" Running Shell in installed Office image
docker run -ti --net=host --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix --entrypoint=bash fs_office_installed
