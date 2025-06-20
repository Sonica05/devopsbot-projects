#!/bin/bash

# Start MySQL container
docker run -d \
  --name mydb \
  -e MYSQL_ROOT_PASSWORD=pass123 \
  -e MYSQL_DATABASE=wordpress_db \
  -v mysql_data:/var/lib/mysql \
  mysql:5.7

# Start WordPress container
docker run -d \
  --name wordpress \
  -e WORDPRESS_DB_HOST=mydb \
  -e WORDPRESS_DB_USER=root \
  -e WORDPRESS_DB_PASSWORD=pass123 \
  -e WORDPRESS_DB_NAME=wordpress_db \
  -p 80:80 \
  --link mydb:mysql \
  wordpress

