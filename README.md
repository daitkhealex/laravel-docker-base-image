# The build is designed to work in development mode

### The build consists of the following containers

- php (php:8.4-fpm image is used)
- redis (redis image is used)
- nginx (nginx image is used)
- postgres (postgres:17 image is used without additional modules)
- scheduler (to run cron tasks in the system)
- worker (to run jobs). [Laravel Horizon](https://laravel.com/docs/11.x/horizon) must be installed

### To run the build (rebuild), you must run the following command
docker-compose -f docker-compose-dev.yml up --force-recreate --build

### To restore the archive from the sql file to the database, you must use the following command
cat <file_name>.sql | docker exec -i <postgres_container_name> psql -U postgres

### Or
docker exec -i <postgres_container_name> pg_restore --verbose --clean --no-acl --no-owner -U postgres -d postgres < <file_name>.sql


### To save the database archive to an sql file, the following command is required
docker exec -t <postgres_container_name> pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

### To save the database archive with subsequent archiving, the following command is required
docker exec -t <postgres_container_name> pg_dumpall -c -U postgres | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz

### To enter the php container, you need to run the following command
docker exec -it <php_container_name> /bin/sh

After that, you can run artisan and composer commands

# Before you start
The build uses environment variables that are taken from the .env file, so before you start, you need to create this file

### After building the image, you need to run composer to get third-party packages.
docker exec -it <php_container_name> composer --ignore-platform-reqs --no-scripts install

### And a command to install only dependencies for production
docker exec -it <php_container_name> composer --ignore-platform-reqs --no-scripts install --no-dev

# Additional installed packages
### wkhtmltopdf and a set of fonts for it to use when generating pdf using the package [https://github.com/barryvdh/laravel-snappy](https://github.com/barryvdh/laravel-snappy)