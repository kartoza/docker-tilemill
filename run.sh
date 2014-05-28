
docker.io run \
	--name=tilemill \
	--link osm-africa-postgis:osm-africa-postgis \
        -v /home/gisdata:/home/gisdata \
        -v /home/timlinux/Documents/MapBox:/Documents/MapBox \
	-p 1100:22 \
	-p 20008:20008 \
	-p 20009:20009 \
	-d \
	-t kartoza/tilemill
