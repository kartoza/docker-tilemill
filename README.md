docker-ssh
==========

A simple docker container that runs tilemill

To build the image do:

```
docker build -t kartoza/tilemill git://github.com/timlinux/docker-tilemill
```

To run a container do:

```
docker run --name "tilemill" -p 2222:22 -d -t kartoza/tilemill
```

To log into your container do:

```
ssh root@localhost -p 2222
```

Default password will appear in docker logs:

```
docker logs <container name> | grep root login password
```

-----------

Tim Sutton (tim@linfiniti.com)
May 2014
