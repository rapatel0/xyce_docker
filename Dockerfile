FROM ubuntu:xenial

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update && \
    apt-get install -y --no-install-recommends ubuntu-desktop && \
    apt-get install -y gnome-panel gnome-settings-daemon metacity nautilus gnome-terminal && \
    apt-get install -y tightvncserver && \
    apt-get install -y apt-utils && \
    mkdir /root/.vnc

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd

CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 24 && tail -f /root/.vnc/*:1.log

EXPOSE 5901

RUN apt-get update && \
    apt-get install -y build-essential && \
    apt-get install -y gcc && \
    apt-get install -y g++ && \
    apt-get install -y gfortran && \
    apt-get install -y make && \
    apt-get install -y cmake && \
    apt-get install -y bison && \
    apt-get install -y flex && \
    apt-get install -y libfftw3-dev && \
    apt-get install -y libsuitesparse-dev && \
    apt-get install -y libblas-dev && \
    apt-get install -y liblapack-dev && \
    apt-get install -y libtool && \
    apt-get install -y libopenmpi-dev && \
    apt-get install -y libscotchparmetis-dev


