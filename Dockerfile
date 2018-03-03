# Use Ubuntu:16.04 image as parent image
FROM ubuntu:16.04


MAINTAINER AUTHOR aggresss
ENV DEBIAN_FRONTEND noninteractive

EXPOSE 8888 
VOLUME /root/volume
USER root

# Modify apt-get to aliyun mirror
WORKDIR /
RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list
RUN apt-get update

# Modify timezone to GTM+8
ENV TZ=Asia/Shanghai
RUN apt-get -y install tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary library
RUN apt-get -y install apt-utils git python python-dev python-pip \
	lib32z1 libglib2.0-dev libsm6 libxrender1 \
	libxext6 libice6 libxt6 libfontconfig1 libcups2 

# Clone the docker-opencv-python repository
RUN git clone https://github.com/aggresss/docker-opencv-python.git /docker-opencv-python

# Modify pip mirror
WORKDIR /docker-opencv-python
RUN mkdir -p /root/.pip
RUN cp -f pip.conf /root/.pip/

# Modify Jupter run arguments
WORKDIR /docker-opencv-python
RUN mkdir -p /root/.jupyter
RUN cp -f jupyter_config.py /root/.jupyter/
RUN mkdir -p /root/volume

# Install necessary python-library
RUN pip install --upgrade pip
RUN pip install numpy scipy matplotlib pillow opencv-python ipython==5.5.0 tensorflow keras h5py
RUN pip install jupyter jupyterlab

# Make startup run file
WORKDIR /docker-opencv-python
RUN cp -f run.sh /
RUN chmod +x /run.sh
WORKDIR /root/volume
CMD /run.sh


