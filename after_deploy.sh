#!/bin/bash
# Скрипт выполняется после деплоя Render

export PGPASSWORD=$DATABASE_PASSWORD

psql -h $DATABASE_HOST \
     -p $DATABASE_PORT \
     -U $DATABASE_USER \
     -d $DATABASE_NAME \
     -f ./after_deploy.sql