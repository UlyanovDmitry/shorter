[![Ruby on Rails CI](https://github.com/UlyanovDmitry/shorter/actions/workflows/rubyonrails.yml/badge.svg?branch=master)](https://github.com/UlyanovDmitry/shorter/actions/workflows/rubyonrails.yml)


# README

## Тестовое задание

Реализовать сервис сокращения ссылок.
Данный сервис должен реализовывать 3 запроса:

- API Создание короткой ссылки
- Endpoint редиректа на оригинальную ссылку
- API статистики кликов

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

## Можно развернуть в докере

```
docker-compose up -d
```

## План развития:
1. Запросы на создание и просмотр статистики должны быть закрыты от публичного доступа. Сейчас добавил API JWT
2. Как правило, сокращатель является полезным инструментом для маркетинга, возможно в будущем 
   понадобится удобный интерфейс просмотра статистики
3. Даже если сервис будет использоваться внутри компании, рекомендуется настроить защиту от атак. 
   Можно использовать как внешние инструменты (нап. cloudflare), так и настроить тротлинг 
   на уровне Rails (напр. gem rack_attack)
4. В задании не было сказано про ограничения, но стоит подумать об этом. Напрмиер, настроить время жизни ссылок. 
   Старые ссылки можно удалять, тем самым освобождая места в базе данных (экономим ресурсы и улучшаем быстродействие)
5. Также, зная предназначение сервиса, можно добавить органичения на сами ссылки. Например, не сокращать ссылки, 
   которые уже являются короткими (clck.ru, bitly. etc).
6. Сократить сам endpoint  GET /urls/:short_url. Это можно сделать на строне nginx.
   Короткие ссылки должны быть ввида `short_host/code`. Сразу после увеличения кол-ва просмотров
   можно не возвращать URL, а перенаправлять клиента
7. Сменить хранение статистики с Postgres на ClickHouse. Он хорошо работает с большими данными и множеством 
   аналитический запросов. 
