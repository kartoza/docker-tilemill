#--------- Generic stuff all our Dockerfiles should start with so we get caching ------------
FROM ubuntu:trusty
MAINTAINER Tim Sutton<tim@linfiniti.com>

RUN  export DEBIAN_FRONTEND=noninteractive
ENV  DEBIAN_FRONTEND noninteractive
RUN  dpkg-divert --local --rename --add /sbin/initctl
#RUN  ln -s /bin/true /sbin/initctl

# Use local cached debs from host (saves your bandwidth!)
# Change ip below to that of your apt-cacher-ng host
# Or comment this line out if you do not with to use caching
ADD 71-apt-cacher-ng /etc/apt/apt.conf.d/71-apt-cacher-ng

RUN echo "deb http://archive.ubuntu.com/ubuntu trusty main universe" > /etc/apt/sources.list
RUN apt-get -y update && apt-get -y install rpl pwgen

#-------------Application Specific Stuff ----------------------------------------------------

RUN apt-get install -y software-properties-common python-software-properties && \
    add-apt-repository ppa:developmentseed/mapbox && \
    apt-get update && \
    apt-get install -y tilemill fonts-freefont-ttf fonts-ubuntu-font-family-console ttf-ubuntu-font-family edubuntu-fonts fonts-ubuntu-title fonts-liberation

# This script will be called by supervisor to start tilemill
ADD run_tilemill.sh /run_tilemill.sh
EXPOSE 20008
EXPOSE 20009

CMD /run_tilemill.sh
