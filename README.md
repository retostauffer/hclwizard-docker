


# Building container (also locally)

```
docker-compose build
# Alternative:
#    make build
```

# Run container locally

After building, simply run:

```
make run
```

You should then be able to access `http://localhost:3838` to see
the apps.

# Shell access

There is a bash script called login-to-bash to get a live bash shell
of a _running_ container. After building and starting the container,
simply call

```
/bin/bash login-to-bash
# Alternative:
#   make bash
```

# Production build

Uses `production.yml` to build the container; this is then the one
used in the service.

```
docker-compose -f docker-compose.yml -f production.yml up -d
# Alternative:
#    make prodbuild
```

# Old notes

### (1) Adjustments

Adjust your `production.yml`, check out the latest git release of this
repository (hclwizard docker container) or whatever you need to do.

### (2) List running containers

To see all running containers enter `docker ps`

```
docker ps
CONTAINER ID   IMAGE                    COMMAND                  CREATED       ...
400b035029f3   hclwizard-docker_shiny   "/usr/bin/shiny-serv…"   4 weeks ago   ...
```

You can see a running container of `hclwizard-docker_shiny` and the corresponding ID.

### (3) Stop the container

```
docker stop <CONTAINER ID>
```

Next stop the container with the container ID you got from `docker ps`. From now on the
service is offline.

### (4) Delete image

We now delete the existing image of the container. To get the image ID
call `docker images` and search for `hclwizard-docker_shiny`. We can now
delete this image using

```
docker image rm <IMAGE ID>
# You may use
# docker image rm --force <IMAGE ID>
```

Yes, it is gone now. To get it up again we have to build the image once again
(see below). The reason is that the images are stored on `/var` where we are
somehow limited in disc space.

### (5) Build new image

We now need to build the new container calling:

```
docker-compose -f docker-compose.yml -f production.yml up -d
```

This will (by re-using the rocker image) set up a new container and
run trough the `Dockerfile` to install all required R packages
including colorspace from R-forge and start the container once the image
has been built.

### (6) Final check

You should now see your new image built by calling `docker image` and
that the container runs using `docker ps`. If so, you are back online.

```
docker images
docker ps
```

* <https://hclwizard.org:3000/hclwizard> (on your server not changing the port, of course).






