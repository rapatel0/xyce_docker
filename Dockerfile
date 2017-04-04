FROM queeno/ubuntu-desktop

CMD /usr/bin/vncserver -kill :1 && \
    rm /root/.vnc/xstartup


ADD xstartup /root/.vnc/xstartup

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

ADD trilinos_cmake_serial_amd64.bash 

RUN ./trilinos_cmake_serial_amd64.bash
RUN make
RUN make install
RUN cd ~

#-----------------------------------------------
# Begin Xyce Install 

ADD Xyce-6.6.tar.gz /root/Xyce-6.6.tar.gz
ADD Xyce_Docs-6.6.tar.gz /root/Xyce_Docs-6.6.tar.gz









