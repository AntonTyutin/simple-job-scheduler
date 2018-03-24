# Простой скрипт обработки событий

Основные характеристики:

* событие может иметь данные;
* по одному обработчику на каждый тип события;
* по одному работающему процессу обработки на каждый тип события;
* события, произошедшие во время работы обработчика, будут задержаны, а по его завершению
  будет обработано последнее из них;
* события хранятся в файлах, что обеспечивает их обработку после перезапуска очереди;
* настройка обработчиков производится в простом sh-файле.

### Установка и использование

Склонируйте репозиторий:

```sh
git clone https://github.com/AntonTyutin/simple-job-scheduler.git \
    && cd simple-job-scheduler/src
```

Положите скпипты воркеров в директорию `workers`.

Создайте файл воркеров `workers.list` вида:

```sh
# listen_and_do /event/file/to/listen command args

listen_and_do /events/evnt-1 ping.sh '#1'
listen_and_do /events/evnt-2 ping.sh '#2'
```

Запустите скрипт-диспетчер, передав первым аргументом файл воркеров:

```sh
nohup src/.dispatcher.sh workers.list >/dev/null
```

Теперь можно посылать события в обработку, создавая файлы, указанные
в переменных `EVENT` в файле воркеров.

Содержимое файла события отправляется на STDIN скрипта-обработчика.

### Docker

Для запуска в виде докер-сервиса в папке `docker` подготовлен `docker-compose` файл.

Для ваших процедур выливки могут понадобиться сторонние утилиты внутри контейнера с
диспетчером. Для этого вы можете создать `Dockerfile` и указать его параметром
`build` в `docker-compose.yml`.