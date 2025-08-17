# RabbitMQ

![RabbitMQ](rabbitmq-1.png)

![RabbitMQ](rabbitmq-2.png)

## Direct

Send message to a special queue

Binding Key = Route Key

![Direct](direct.png)

## Default

Send message to a queue with a unique name.

![Default](default.png)

## Topic

Send message to all queues by special pattern. (The name of the queue doesn`t matter)

Recommended for Pub/Sub scenarios.

![Topic](topic.png)

## Fanout

Send message to all queues - recommended for broadcasting

![Fanout](fanout.png)

## Header

Send message to queue by matching headers

Should add `x-match` to `Binding`.

`any`, `all`

![Header](header.png)
