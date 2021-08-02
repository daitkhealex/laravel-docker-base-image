#!/usr/bin/env bash

set -e

role=${CONTAINER_ROLE:-php-fpm}
env=${APP_ENV:-production}

if [ "$role" = "php-fpm" ]; then

    echo "Running PHP-FPM..."
    exec php-fpm

elif [ "$role" = "scheduler" ]; then

    echo "Running the cron..."

    while [ true ]
    do
      cd /var/www/ && php artisan schedule:run --verbose --no-interaction &
      sleep 60
    done

elif [ "$role" = "worker" ]; then

    echo "Running the queue..."

    cd /etc/supervisor/conf.d/
    exec /usr/bin/supervisord -n -c /etc/supervisord.conf

else

    echo "Could not match the container role \"$role\""
    exit 1

fi
