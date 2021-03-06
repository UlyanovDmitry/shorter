# README

## Тестовое задание

Реализовать сервис сокращения ссылок.
Данный сервис должен реализовывать 3 запроса:

- POST /urls который возвращает короткий url
- GET /urls/:short_url который возвращает длинный URL и увеличивает счетчик запросов на 1
- GET /urls/:short_url/stats который возвращает количество переходов по URL

Проект необходимо реализовать на Ruby On Rails.
База - на выбор

## Решение
Решение должно отвечать следующим требованиям
- Быстро работать при больших нагрузках (предполагаем быстрый рост сервиса)
- Имеет структуру API, описаную в задании
- Хорошее покрытие тестами

1. Созадем Rails приложение
2. Для улучшения быстродействия используем Redis & Sidekiq
3. Предполагаем, что наиболее загруженный endpoint - это `GET /urls/:short_url` - закрываем его под кешем

## Как развернуть локально
ruby '3.0.1'
rails '6.1.3'

1. Установить зависимости. PostgreSQL, Redis
2. Скачиваете проект (git clone...)
3. Настраиваете путь к Redis `cp .env.example .env`
4. `cp config/redis-sidekiq.example.yml config/redis-sidekiq.yml`
5. `cp config/database.example.yml config/database.yml`. Настраиваете путь к PostgreSQL
6. `bundle install`
7. `rake db:create db:migrate`
8. `foreman start`

## План развития:
1. Докеризация. Сервис можно быстро развернуть как локально, так и на проде. 
   Но возможно в будущем понадобится маштабирование на нескольких серверах API или в kubernetes.
   Поэтому в будущем нужно добавить возможность собрать все в докере (как локально, так и на проде)
2. Запросы на создание и просмотр статистики должны быть закрыты от публичного доступа.
3. Как правило, сокращатель является полезным инструментом для маркетинга, возможно в будущем 
   понадобится удобный интерфейс просмотра статистики
4. Даже если сервис будет использоваться внутри компании, рекомендуется настроить защиту от атак. 
   Можно использовать как внешние инструменты (нап. cloudflare), так и настроить тротлинг 
   на уровне Rails (напр. gem rack_attack)
5. В задании не было сказано про ограничения, но стоит подумать об этом. Напрмиер, настроить время жизни ссылок. 
   Старые ссылки можно удалять, тем самым освобождая места в базе данных (экономим ресурсы и улучшаем быстродействие)
6. Также, зная предназначение сервиса, можно добавить органичения на сами ссылки. Например, не сокращать ссылки, 
   которые уже являются короткими (clck.ru, bitly. etc).
7. Сократить сам endpoint  GET /urls/:short_url. Это можно сделать на строне nginx.
   Короткие ссылки должны быть ввида `short_host/code`. Сразу после увеличения кол-ва просмотров
   можно не возвращать URL, а перенаправлять клиента
8. Перейти на JSON-ответы. Сервис-сокращатель удобно использовать и внутри сервисной архитектуры. 
   Внутренным сервисам удобней будет обрабатывать JSON ответы создания и статистики (как и вывода ошибок)
