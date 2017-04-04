FROM ubuntu:16.04

ENV DEBIAN_FRONTEND noninteractive
ENV USER root

RUN apt-get update && \
    apt-get install -y firefox && \
    apt-get install -y lxde-core && \
    apt-get install -y lxterminal && \
    apt-get install -y tightvncserver && \
    apt-get install -y xrdp && \
    mkdir /root/.vnc

ADD xstartup /root/.vnc/xstartup
ADD passwd /root/.vnc/passwd

RUN chmod 600 /root/.vnc/passwd

CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 24 && tail -f /root/.vnc/*:1
.log

EXPOSE 5901



#FROM queeno/ubuntu-desktop

#CMD /usr/bin/vncserver -kill :1 && \
    #rm /root/.vnc/xstartup


#ADD xstartup /root/.vnc/xstartup

#CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 24 && tail -f /root/.vnc/*:1.log

#EXPOSE 5901


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
RUN mkdir /root/trilinos_src && \
    cd /root/trilinos_src && \
    git clone -b trilinos-release-12-6-branch --single-branch https://github.com/trilinos/Trilinos.git . && \
    cd ~


RUN mkdir /root/Trilinos12.6 

ADD trilinos_cmake_serial_amd64.bash /root/Trilinos12.6/trilinos_cmake_serial_amd64.bash 
RUN cd /root/Trilinos12.6/ && \
   ./trilinos_cmake_serial_amd64.bash && \
    make && \
    make install

#-----------------------------------------------
# Begin Xyce Install 

ADD Xyce-6.6.tar.gz /root/Xyce-6.6.tar.gz
ADD Xyce_Docs-6.6.tar.gz /root/Xyce_Docs-6.6.tar.gz



