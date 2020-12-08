


# Setting up

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

# Start

```
docker-compose -f docker-compose.yml -f production.yml up -d
```
