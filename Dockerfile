FROM queeno/ubuntu-desktop

RUN apt-get update && apt-get install -y apt-utils autocutsel

CMD echo "autocutsel -fork &" >> /root/.vnc/xstartup

# Xyce install prerequisite
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
#RUN mkdir $HOME/trilinos_src && \
    #cd  $HOME/trilinos_src && \
    #git clone -b trilinos-release-12-6-branch --single-branch https://github.com/trilinos/Trilinos.git . && \
    #cd ~

ADD trilinos-12.6.3-Source.tar.bz2 /root/

RUN mkdir  /root/Trilinos12.6 

ADD trilinos_cmake_serial_amd64.bash  /root/Trilinos12.6/trilinos_cmake_serial_amd64.bash 



RUN cd  /root/Trilinos12.6/ && \
    chmod +x trilinos_cmake_serial_amd64.bash && \
    ./trilinos_cmake_serial_amd64.bash &&\
    make -j 4 && \
    make install

##-----------------------------------------------
## Begin Xyce Install 

ADD Xyce-6.6.tar.gz  /root/
ADD Xyce_Docs-6.6.tar.gz  /root/
CMD mkdir /root/xyce_build && \
    cd /root/xyce_build && \
    /root/Xyce-6.6/configure  \
    CXXFLAGS="-O3 -std=c++11" \
    ARCHDIR="/root/XyceLibs/Serial" \
    CPPFLAGS="-I/usr/include/suitesparse" && \
    make && \
    sudo make install 


CMD /usr/bin/vncserver -kill :1

CMD /usr/bin/vncserver :1 -geometry 1280x800 -depth 24 && tail -f /root/.vnc/*:1.log

