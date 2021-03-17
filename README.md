


# Setting up

**Important:** `shiny-server.sh` must be executable. 

* `chmod u+x shiny-server.sh`

Install docker and docker composer, then run `docker-compose build`.
Should create the required images and install all necessary parts.

* shiny server ([rocker/shiny](https://hub.docker.com/r/rocker/shiny))
* a series of R packages
* latest version of `colorspace`
* latest colorspace shiny apps

# Testing

```
docker-compose up
```

You should then be able to access `http://localhost:3000` to see
the apps.

# Build

Uses `production.yml` to build the container; this is then the one
used in the service.

```
docker-compose -f docker-compose.yml -f production.yml up -d
```

# Autostart

Make sure you enabled the docker service on startup
(`systemctl enable docker`). Create a new service
called `hclwizard.service` by creating the file
`/usr/lib/systemd/system/hclwizard.service` containing:

```
[Unit]
Description=HCLWizard Docker Shiny Service
After=syslog.target network.target docker.service

[Service]
ExecStart=docker run --restart=always hclwizard-docker_shiny
```

Should do the trick.

# Replace the image

In case you make changes to `production.yml` or you want to update
the R package we need to create a new docker image.
To do so we have to do the following step:

1. Stop the docker image (service will no longer be available)
2. Delete the image as we are restricted on disc space; changes in the
  `.yml` will create a new image while the old one still sticks around.
3. Build the new container with the new settings. Within the `Dockerfile`
   you can see that we check out the latest development release
   from R-Forge and install.
4. Start the new image (service back online)

These are the steps to do so

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






