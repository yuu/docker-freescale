FROM ubuntu:12.04
MAINTAINER yuu

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update
RUN apt-get install -y --no-install-recommends \
    sudo git sed wget cvs subversion git-core coreutils unzip texi2html texinfo \
    libsdl1.2-dev docbook-utils gawk python-pysqlite2 diffstat help2man \
    make gcc build-essential g++ desktop-file-utils chrpath libgl1-mesa-dev \
    libglu1-mesa-dev mercurial autoconf automake groff curl lzop asciidoc \
    ssh python python3 vim tmux
RUN apt-get clean
ENV DEBIAN_FRONTEND dialog

# user
ENV USERNAME yocto
RUN adduser $USERNAME
ENV HOME /home/$USERNAME
# Add user jenkins to sudoers with NOPASSWD
RUN echo "yocto ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers
# Set password for the yocto user (you may want to alter this).
RUN echo "yocto:yocto" | chpasswd
USER $USERNAME

# git
RUN /bin/bash
RUN git config --global user.name "yocto"
RUN git config --global user.email "dummy@dummy.com"
RUN git config --global color.ui true

RUN mkdir -p $HOME/usrfs/bin
RUN curl http://commondatastorage.googleapis.com/git-repo-downloads/repo > $HOME/usrfs/bin/repo
RUN sudo chmod +x $HOME/usrfs/bin/repo

WORKDIR $HOME/work/fsl-release-bsp
RUN sudo chown -R $USERNAME $HOME/work
RUN $HOME/usrfs/bin/repo init -u git://git.freescale.com/imx/fsl-arm-yocto-bsp.git -b imx-3.10.17-1.0.0_ga

RUN $HOME/usrfs/bin/repo sync

RUN git clone git://github.com/meta-qt5/meta-qt5 -b master-5.6 sources/meta-qt5

ADD patch-meta-qt5 ${HOME}/Downloads/patch-meta-qt5/.
ADD patch-meta-fsl-bsp-release ${HOME}/Downloads/patch-meta-fsl-bsp-release /.
ADD patch-meta-openembedded ${HOME}/Downloads/patch-meta-openembedded/.
RUN cd sources/meta-qt5 && git am ${HOME}/Downloads/patch-meta-qt5/*
RUN cd sources/meta-fsl-bsp-release && git checkout fd63989 && git am ${HOME}/Downloads/patch-meta-fsl-bsp-release/*
RUN cd sources/meta-openembedded && git checkout eb4563b && git am ${HOME}/Downloads/patch-meta-openembedded/*

CMD bash
