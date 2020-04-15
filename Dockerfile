ARG VERSION=latest
FROM archlinux:$VERSION
LABEL maintainer="info@munterfinger.ch"
USER root

# Files: Copy and pull
ADD https://www.unidata.ucar.edu/downloads/udunits/udunits-2.2.26.tar.gz /usr/local/src

# pacman: Update and add libs
RUN pacman -Syu --noprogressbar --noconfirm \
    && pacman -S --noprogressbar --noconfirm base-devel gmp

# UDUNITS 2: ./configure and copy for archgis docker
WORKDIR /usr/local/src
RUN tar -xzf udunits-2.2.26.tar.gz \
    && cp -r udunits-2.2.26 orig \
    && mkdir diff \
    && cd ./udunits-2.2.26/ \
    && ./configure --prefix=/opt \
    && cd - \
    && LANG=C diff -aqr orig udunits-2.2.26 | \
      awk -F'[ :]' '/^Only in/{system("cp -a "$3"/"$NF " diff")}' \
    && tar -czvf udunits-configure.tar.gz diff

WORKDIR /
CMD ["/usr/bin/bash"]
