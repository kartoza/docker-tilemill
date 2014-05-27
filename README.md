docker-ssh
==========

A simple docker container that runs tilemill (https://github.com/mapbox/tilemill).

To build the image do:

```
docker.io build -t kartoza/tilemill git://github.com/timlinux/docker-tilemill
```

To run a container do:

```
docker.io run --name=tilemill -p 1100:22 -p 20008:20008 -p 20009:20009 -d -t kartoza/tilemill
```

Perhaps you might also want to link to a docker container running postgres (see 
https://github.com/timlinux/docker-postgis) and / or to mount your local ~/Documents/Mapbox in 
the container and then work on data from your local filesystem.

To log into your container do:

```
ssh root@localhost -p 1000
```

Default password will appear in docker logs:

```
docker logs <container name> | grep root login password
```

-----------

Tim Sutton (tim@linfiniti.com)
May 2014
