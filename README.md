


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
