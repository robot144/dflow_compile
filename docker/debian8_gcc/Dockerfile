FROM gcc:4.9
# based on debian 8

MAINTAINER robot144@protonmail.com

RUN apt-get update 
RUN apt-get install -y subversion
RUN apt-get install -y libtool-bin
RUN apt-get install -y cmake
RUN apt-get install -y flex
RUN apt-get install -y bison
RUN apt-get install -y rsync
RUN apt-get install -y uuid-dev
RUN apt-get install -y vim

#RUN useradd -d /home/ubuntu -ms /bin/bash -g root -G sudo -p ubuntu ubuntu
RUN groupadd -r user --gid 1000
RUN useradd -d /home/user -ms /bin/bash -g user -G sudo -p user user

USER user

#RUN mkdir scripts
#COPY scripts/* /scripts/
#ENV PATH=${PATH}:/scripts
#ENV JULIA_SCRIPTDIR=/scripts
#RUN /scripts/install_packages.sh

