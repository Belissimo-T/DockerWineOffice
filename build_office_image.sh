#!/bin/bash

# store container hash of installed office image
PREV_HASH=$(docker images -q wine_office/install_office)

echo "=>" Building Office install image
if docker build --target wine32_install_office -t wine_office/install_office -f Dockerfile . ; then
    echo " ->" Office Installer Image built
else
    echo " ->" Office Installer Image build failed
    exit 1
fi

# check if container hash has changed
NEW_HASH=$(docker images -q wine_office/install_office)
if [ "$PREV_HASH" == "$NEW_HASH" ]; then
    echo " ->" Office Installer Image already built
    if [ "$(docker images -q wine_office/office_installed)" != "" ]; then
        echo " ->" Office already installed
        exit 0
    fi

    echo " ->" Office not installed
else
    echo " ->" Office Installer Image changed
fi


echo "=>" Removing old Office installed image
docker stop wo_install_office
docker rm -f wo_install_office

echo "=>" Run Office installation
docker container run --name wo_install_office --net=host --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix wine_office/install_office

echo "=>" Creating Image with installed Office
docker commit wo_install_office wine_office/office_installed
