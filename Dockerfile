# Use Ubuntu:16.04 image as parent image
FROM ubuntu:16.04

MAINTAINER AUTHOR aggresss
ENV DEBIAN_FRONTEND noninteractive

EXPOSE 8888 
EXPOSE 6006
VOLUME /root/volume
USER root

# Modify apt-get to aliyun mirror
RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list
RUN apt-get update

# Clone the docker-opencv-python repository
RUN apt-get -y install git
RUN git clone https://github.com/aggresss/docker-opencv-python.git /docker-opencv-python
WORKDIR /docker-opencv-python

# Modify timezone to GTM+8
ENV TZ=Asia/Shanghai
RUN apt-get -y install tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Modify locale
RUN apt-get -y install locales
RUN locale-gen en_US.UTF-8
RUN echo "LANG=\"en_US.UTF-8\"" > /etc/default/locale && \
    echo "LANGUAGE=\"en_US:en\"" >> /etc/default/locale && \
    echo "LC_ALL=\"en_US.UTF-8\"" >> /etc/default/locale

# Install necessary library
RUN apt-get -y install apt-utils python python-dev python-pip \
    lib32z1 libglib2.0-dev libsm6 libxrender1 \
    libxext6 libice6 libxt6 libfontconfig1 libcups2 

# Modify pip mirror
RUN mkdir -p /root/.pip
RUN cp -f pip.conf /root/.pip/

# Modify Jupter run arguments
RUN mkdir -p /root/.jupyter
RUN cp -f jupyter_config.py /root/.jupyter/

# Install necessary python-library
RUN pip install --upgrade pip
RUN pip install numpy scipy matplotlib pillow opencv-python ipython==5.5.0 tensorflow keras h5py
RUN pip install jupyter jupyterlab

# Make startup run file
RUN cp -f run.sh /
RUN chmod +x /run.sh
WORKDIR /root/volume
CMD /run.sh


