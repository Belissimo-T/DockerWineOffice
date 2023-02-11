FROM archlinux/archlinux:latest as wine32

USER root
ENV LANG C.UTF-8

# enable multilib
RUN echo "[multilib]" >> /etc/pacman.conf
RUN echo "Include = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
# RUN cat /etc/pacman.d/mirrorlist
# RUN cat /etc/pacman.conf
RUN pacman -Syyu --noconfirm

# add user
ARG SERVICE_NAME="file_sorter"
ENV SERVICE_NAME=${SERVICE_NAME}

RUN groupadd -r $SERVICE_NAME && useradd -r -g $SERVICE_NAME $SERVICE_NAME
ENV HOME="/home/$SERVICE_NAME"
RUN mkdir -p $HOME
RUN chown -R $SERVICE_NAME:$SERVICE_NAME $HOME
# give user sudo rights
RUN echo "$SERVICE_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# switch to user
WORKDIR $HOME

# install yay
RUN pacman -Syu --noconfirm git base-devel

USER $SERVICE_NAME:$SERVICE_NAME
RUN git clone https://aur.archlinux.org/yay.git
WORKDIR yay
RUN makepkg -si --noconfirm
WORKDIR ..

# I don't know which packages exactly are needed.
# I just installed every optional wine dep that was installed on my system.
RUN yay -Syu --noconfirm wine winetricks wine-mono wine_gecko giflib libldap lib32-libldap gnutls lib32-gnutls v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libxcomposite lib32-libxcomposite libxinerama opencl-icd-loader gst-plugins-base-libs sdl2 libgphoto2 sane cups samba libva lib32-libva gtk3 lib32-vulkan-icd-loader ffmpeg

# set up wine
ENV WINEARCH win32
ENV WINEPREFIX $HOME/.msoffice
RUN mkdir $WINEPREFIX

FROM wine32 as wine32_install_office
ARG SERVICE_NAME="file_sorter"
ENV SERVICE_NAME=${SERVICE_NAME}

# copy files
COPY docker_resources/*.* ./

ENV WINEPREFIX $HOME/.msoffice
ENV WINEARCH win32

# install office
CMD ["bash", "install_office.sh"]

FROM wine32 as wine32_office

COPY --from=wine32_install_office $WINEPREFIX $WINEPREFIX

ENV WINEPREFIX $HOME/.msoffice
CMD ["wine", "powerpnt.exe"]