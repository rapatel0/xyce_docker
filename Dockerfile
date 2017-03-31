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


# ---------------------------------------------
# Everything after here is related to xyce install
# 


# Xyce install prerequisites
RUN apt-get update && \
    apt-get install -y \
	build-essential \
   	gcc \
	g++ \
    	gfortran \
    	make \
    	cmake \
    	bison \
    	flex \
    	libfftw3-dev \
    	libsuitesparse-dev \
    	libblas-dev \
    	liblapack-dev \
    	libtool 
    

# Need to fix this, libparametis not being found
# ubuntu parallel libs	
#RUN apt-get update && \
    #apt-get install -y \
	#libopenmpi-dev \
	    #libparmetis-dev 

# install git for source cloning
RUN apt-get update && \
    apt-get install -y \
	git	

# tRILINOS SOURCE INSTALL 
RUN mkdir trilinos_src && \
    cd trilinos_src && \
    git clone -b trilinos-release-12-6-branch --single-branch https://github.com/trilinos/Trilinos.git . && \
    cd ~


RUN mkdir Trilinos12.6 

ADD trilinos_cmake_serial.bash

RUN ./trilinos_cmake_serial.bash
RUN make
RUN make install
RUN cd ~

#-----------------------------------------------
# Begin Xyce Install 







