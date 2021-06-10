# Ruby on Rails + NoSQL

## Что такое NoSQL и зачем это нужно в реальной жизни

* How do NoSQL databases work? Simply Explained: https://youtu.be/0buKQHokLK8
* sql - структурированные данные (relations), растет вертикально 
* nosql - key - value, растет горизонтально (вширь), добавляем новые сервера (хэш по ключу), минус - запрос
* Когда что юзать: sql - когда запросы не определены, хотим гибкость запросов, field constraints, мелкие и большие проекты; nosql: точно знаем id, быстродействие, средние проект

## NoSQL? Maybe PosgreSQL JSON.

* Разница между JSON vs JSONB полями (вставка дольше, индексация, размер, запросы)
* Faster Operations with the JSONB Data Type in PostgreSQL: https://www.compose.com/articles/faster-operations-with-the-jsonb-data-type-in-postgresql/
* Еще примеры запросов: https://gist.github.com/mankind/1802dbb64fc24be33d434d593afd6221

## Redis

### Базовое взаимодействие через консоль
* redis-cli ( PING / GET / SET )
https://redis.io/commands/get
* redis-benchmark
https://redis.io/topics/benchmarks

### Взаимодействие через гемы
https://github.com/redis/redis-rb

* Базовые команды ( get/set, ping/pong )
redis.setex('exp', 5, 10)
redis.set(:array, [1,2,3].to_json)

* Redis vs HiRedis
https://github.com/redis/hiredis-rb
hiredis.write ["SET", "speed", "awesome"]
hiredis.write ["GET", "speed"]
hiredis.read

### Основные структуры которые могут пригодиться

* Типы в redis: https://redis.io/topics/data-types-intro
* list: https://redis.io/commands#list
RPUSH mylist "one"
RPUSH mylist "two"
RPUSH mylist "three"
LSET mylist 0 "four"
LSET mylist -2 "five"
LRANGE mylist 0 -1

* set: https://redis.io/commands#set
* hash: https://redis.io/commands#hash

### В реальной жизни
* Нужен для Sidekiq и ActionCable
* Кеширование в Rails
Rails.application.configure do
 config.cache_store = :redis_cache_store, { url: "redis://localhost:6379/0" }
end

* Redis-mutex для крутых мьютексов
https://github.com/kenn/redis-mutex

## ElasticSearch 

### Взаимодействие с помощью Elasticvue
Расширение для браузера: https://elasticvue.com/ (красивое), https://chrome.google.com/webstore/detail/elasticsearch-head/ffmkiejjmecolpfloofpjologoblkegm (страшненькое)

### Взаимодействие через гемы

https://github.com/elastic/elasticsearch-ruby
https://github.com/toptal/chewy

## MongoDB

* Mongoid
https://github.com/mongodb/mongoid
https://docs.mongodb.com/mongoid/current/

* Документы и классы ( https://docs.mongodb.com/mongoid/current/tutorials/mongoid-documents/ )
* Ассоциации ( https://docs.mongodb.com/mongoid/current/tutorials/mongoid-relations/ )
* Запросы ( https://docs.mongodb.com/mongoid/current/tutorials/mongoid-queries/ )
