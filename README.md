# Руководство по работе со сборкой docker для Laravel

### Сборка состоит из следующих контейнеров

- php (используется образ php:7.4-fpm)
- redis (используется образ redis)
- nginx (используется образ nginx)
- postgres (используется образ postgres:12 без дополнительных модулей)
- scheduler (для запуска выполнения cron-задач в системе)
- worker (для запуска job-ов)

### Для запуска сборки необходимо выполнить следующую команду
docker-compose -f docker-compose-dev.yml up --force-recreate --build

### Для восстановления архива из файла sql в базу данных необходима следующая команда
cat <имя_файла>.sql | docker exec -i <название_postgres_контейнера> psql -U postgres

### Для сохранения архива базы данных в файл sql необходима следующая команда
docker exec -t <название_postgres_контейнера> pg_dumpall -c -U postgres > dump_`date +%d-%m-%Y"_"%H_%M_%S`.sql

### Для сохранения архива базы данных с последующей архивацией необходима следующая команда
docker exec -t <название_postgres_контейнера> pg_dumpall -c -U postgres | gzip > dump_`date +%d-%m-%Y"_"%H_%M_%S`.gz

### Для входа в контейнер php необходимо выполнить следующую команду
docker exec -it <название_php_контейнера> /bin/sh

После этого доступно выполнение artisan и composer команд

# Перед началом работы
Сборка использует переменные окружения, которые берутся из .env-файла, поэтому перед началом работы необходимо создать данный файл

### После сборки образа необходимо запустить composer для получения сторонних пакетов. 
docker exec -it <название_php_контейнера> composer --ignore-platform-reqs --no-scripts install

### И команда для установки только зависимостей для production
docker exec -it <название_php_контейнера> composer --ignore-platform-reqs --no-scripts install --no-dev

# Дополнитель установленные пакеты
### wkhtmltopdf и набор шрифтов к нему для использования при генерации pdf с помощью пакета [https://github.com/barryvdh/laravel-snappy](https://github.com/barryvdh/laravel-snappy)
