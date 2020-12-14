#!/bin/bash

set -u

docker-compose -f docker-compose.yml -f production.yml up -d
