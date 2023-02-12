#!/bin/bash

echo "=>" Starting build of Office image
docker stop wo_install_office
docker rm -f wo_install_office

echo "=>" Building Office install image
docker build --target wine32_install_office -t wine_office/install_office -f Dockerfile .

echo "=>" Run Office installation
docker container run --name wo_install_office --net=host --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix wine_office/install_office

echo "=>" Creating Image with installed Office
docker commit wo_install_office wo_office_installed
