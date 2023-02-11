#!/bin/bash

echo "=>" Starting build of Office image
docker stop fs_install_office
docker rm -f fs_install_office
# mkdir -p ./docker_build

echo "=>" Building Office install image
docker build --target wine32_install_office -t file_sorter/install_office -f Dockerfile .

echo "=>" Run Office installation
docker container run --name fs_install_office --net=host --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix file_sorter/install_office
#docker container cp fs_install_office:/home/file_sorter/.msoffice/drive_c ./docker_build/.msoffice/
#docker container cp fs_install_office:/home/file_sorter/.msoffice/system.reg ./docker_build/.msoffice/
#docker container cp fs_install_office:/home/file_sorter/.msoffice/user.reg ./docker_build/.msoffice/
#docker container cp fs_install_office:/home/file_sorter/.msoffice/userdef.reg ./docker_build/.msoffice/

echo "=>" Creating Image with installed Office
docker commit fs_install_office fs_office_installed

bash ./run_office_image.sh

# docker exec --privileged fs_office_installed ls -1 /var/log

# docker exec -it fs_install_office /bin/bash

# echo Stopping Container
# docker container rm -f fs_office_build_c

# docker run -it --rm --net=host --ipc=host -e DISPLAY -v /tmp/.X11-unix:/tmp/.X11-unix fs_office_build
