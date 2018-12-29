#!/bin/bash

# Generate a random secret key and put it into the environment variable file
sed -i "$ s/$/$(docker-compose run --rm sentry-base sentry config generate-secret-key)/" sentry.env

# Run database migrations (build the database)
docker-compose run --rm sentry-base sentry upgrade --noinput

# Startup the whole service
docker-compose up -d


sleep 3
docker-compose exec sentry-base bash -c "pip install sentry-phabricator django-smtp-ssl"
docker-compose restart sentry-base
