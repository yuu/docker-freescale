#!/bin/bash

METADIR="$HOME/work/fsl-release-bsp/sources"
cd $METADIR/meta-qt5 && /usr/bin/git checkout 1ec7767 &&  /usr/bin/git am ${HOME}/Downloads/patch-qt56/patch-meta-qt5/*
cd $METADIR/meta-fsl-bsp-release && /usr/bin/git checkout fd63989 && /usr/bin/git am ${HOME}/Downloads/patch-qt56/patch-meta-fsl-bsp-release/*
cd $METADIR/meta-openembedded && /usr/bin/git checkout eb4563b && /usr/bin/git am ${HOME}/Downloads/patch-qt56/patch-meta-openembedded/*
