How I set up tile stream in docker:
===================================

Setup docker and run a docker instance::

    sudo apt-get install linux-image-extra-`uname -r`
    sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 36A1D7869245C8950F966E92D8576A8BA88D21E9
    sudo sh -c "echo deb http://get.docker.io/ubuntu docker main \
    	>> /etc/apt/sources.list.d/docker.list"
    sudo apt-get update
    sudo apt-get install lxc-docker
    sudo docker pull ubuntu
    sudo docker run -i -p 22 -p 80 -t ubuntu:12.04 /bin/bash


Setup docker instance to run ssh::

    apt-get update
    apt-get install -y openssh-server supervisord
    mkdir /var/run/sshd
    echo "[program:sshd]" > /etc/supervisor/conf.d/sshd.conf
    echo "user=root" >> /etc/supervisor/conf.d/sshd.conf
    echo "command=/usr/sbin/sshd -D" >> /etc/supervisor/conf.d/sshd.conf
    echo "autorestart=true" >> /etc/supervisor/conf.d/sshd.conf
    echo "stopsignal=INT" >> /etc/supervisor/conf.d/sshd.conf

    echo "[program:tilemill]" >> /etc/supervisor/conf.d/tilemill.conf
    echo "user=root" >> /etc/supervisor/conf.d/tilemill.conf
    echo "command=/usr/bin/nodejs /usr/share/tilemill/index.js --server=true" >> /etc/supervisor/conf.d/tilemill.conf
    echo "autorestart=true" >> /etc/supervisor/conf.d/tilemill.conf
    echo "stopsignal=INT" >> /etc/supervisor/conf.d/tilemill.conf

    passwd

Follow the prompts to set a root password - I set mine to 'tilestream'. From
another terminal use fabgis to install tilemill::

    sudo apt-get install python-dev python-virtualenv
    mkdir tilestream-fab
    cd tilestream-fab
    virtualenv venv
    source venv/bin/activate
    pip install fabgis
    cat "from fabgis.tilemill import setup_tilemill, start_tilemill" > fabfile.py
    sudo docker ps -a | grep bash

Make a note of the port number that ssh runs on in your docker instance then::

    fab -H root@localhost:49153 setup_tilemill
    fab -H root@localhost:49153 start_tilemill


Committing and starting your instance::

    docker commit 01027d6b3052 \
        linfiniti/tilemill \
        -run='{"Cmd": ["supervisord"], "PortSpecs": ["22", "20008", "20009"], "Hostname": "tilemill"}' \
        -author="Tim Sutton <tim@linfiniti.com>"

Starting the committed instance::

    sudo docker run -d \
        -name="tilemill" \
        -p 2222:22 \
        -v /home/gisdata:/home/gisdata \
        -v /home/timlinux/Documents/MapBox:/Documents/MapBox \
        linfiniti/tilemill \
        supervisord -n

Under this scenario, we share our gisdata directory from /home/gisdata to
a similarly named directory in the docker container. We also share our
MapBox directory to /Documents/MapBox which is where the docker installed
tilemill will look for and store its docs.

If you are using a linked container for postgis you might want to add the -link
option like this::

    sudo docker run -d \
        -name="tilemill" \
        -p 2222:22 \
        -link postgis:pg \
        -v /home/gisdata:/home/gisdata \
        -v /home/timlinux/Documents/MapBox:/Documents/MapBox \
        linfiniti/tilemill \
        supervisord -n

With the ``-link`` option in place you can refer to the postgis database
host and port using these environment variables in your tilemill vm::



Connecting to the running instance with ssh port forwarding::

ssh localhost -p2222 -l root -L 20009:localhost:20009 -L 20008:localhost:20008


Now open your browser at: http://localhost:20009

Killing the running instance::

    sudo docker kill tilemill
    sudo docker rm tilemill

