# Use Ubuntu:16.04 image as parent image
FROM ubuntu:16.04

ENV AUTHOR aggresss
ENV DEBIAN_FRONTEND noninteractive

# Modify apt-get to aliyun mirror
WORKDIR /
RUN sed -i 's/archive.ubuntu/mirrors.aliyun/g' /etc/apt/sources.list
RUN apt-get update

# Modify timezone to GTM+8
ENV TZ=Asia/Shanghai
RUN apt-get -y install tzdata
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# Install necessary library
RUN apt-get -y install apt-utils
RUN apt-get -y install git
RUN apt-get -y install python python-dev python-pip
RUN apt-get -y install lib32z1 libglib2.0-dev libsm6 libxrender1 libxext6 libice6 libxt6 libfontconfig1 libcups2 

# Clone the docker-opencv-python repository
RUN git clone https://github.com/aggresss/docker-opencv-python.git /docker-opencv-python

# Modify pip mirror
WORKDIR /docker-opencv-python
RUN mkdir -p /root/.pip
RUN cp -f pip.conf /root/.pip/

# Install necessary python-library
RUN pip install --upgrade pip
RUN pip install numpy scipy matplotlib pillow
RUN pip install opencv-python
RUN pip install ipython==5.5.0
RUN pip install jupyter

# Modify Jupter run arguments
WORKDIR /docker-opencv-python
RUN mkdir -p /root/.jupyter
RUN cp -f jupyter_config.py /root/.jupyter/
RUN mkdir -p /root/volume

# Make startup run file
WORKDIR /docker-opencv-python
RUN cp -f run.sh /
RUN chmod +x /run.sh
CMD /run.sh
