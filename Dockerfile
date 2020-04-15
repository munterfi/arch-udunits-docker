ARG VERSION=latest
FROM archlinux:$VERSION
LABEL maintainer="info@munterfinger.ch"
USER root

# Files: Copy and pull
ADD https://www.unidata.ucar.edu/downloads/udunits/udunits-2.2.26.tar.gz /usr/local/src

# pacman: Update and add libs
RUN pacman -Syu --noprogressbar --noconfirm \
    && pacman -S --needed --noprogressbar --noconfirm base-devel gmp

# UDUNITS 2: Install from source and link to /lib
WORKDIR /usr/local/src
RUN tar -xzf udunits-2.2.26.tar.gz \
    && cd ./udunits-2.2.26/ \
    #&& autoconf \
    # Fix gmp, check and adjust version: ls /usr/lib | grep gmp
    && ln -s /usr/lib/libgmp.so.10.4.0 /usr/lib/libgmp.so.3 \
    && ./configure --prefix=/opt \
    && make \
    && make install \
    # Symlink
    && ln -s /opt/lib/libudunits2.so "/lib/libudunits2.so" \
    && ln -s /opt/lib/libudunits2.so.0 "/lib/libudunits2.so.0" \
    && ln -s /opt/lib/libudunits2.so.0.1.0 "/lib/libudunits2.so.0.1.0"
    #&& ldconfig -v
    #&& rm -rf udunits*

WORKDIR /
CMD ["/usr/bin/bash"]
