## Разные  задачи (mysql, интеграция с геокоддингом, manticore)

# 1.а) Mysql
1. Напрямую, с подзапросом:

```
SELECT s1.article, s1.dealer, s1.price
FROM shop s1
WHERE s1.price = (
    SELECT MAX(s2.price)
    FROM shop s2
    WHERE s2.article = s1.article
)
ORDER BY s1.article, s1.dealer;
```

2. А в Mysql 8+ можно использовать оконные функции
```
WITH ranked_prices AS (
    SELECT 
        article,
        dealer,
        price,
        RANK() OVER (PARTITION BY article ORDER BY price DESC) as price_rank
    FROM shop
)
SELECT article, dealer, price
FROM ranked_prices
WHERE price_rank = 1
ORDER BY article, dealer;
```

## 1.б) 2 таблицы, индексы и ошибки

Ошибки:
   - при создании кавычки при создании таблиц например `orders`
   - разные типы колонок int/bigint. Будет ошибка при создании внешнего ключа

Непонятности
   - не понятно что такое "товары больше 100", (100 это total, count(order.id) или sum(total)?). Пусть просто "заказы с total > 100"
   - не понятно что такое "не оплатили вчера месяц назад". 
      - Допустим "заказы уже месяц не оплачены, на вчерашний день". Но как они могут иметь заказ возрастом 1 месяц, если самому пользователю 2 недели?
      - Пусть "неоплаченные заказы возрастом 1 день (со вчера)". Буду считать так.
- 

### Количество оплаченных заказов с total > 100 за вчера
```
SELECT u.id, u.name, COUNT(*) as paid_orders_count
FROM user u
INNER JOIN order o ON u.id = o.user_id
WHERE o.status = 'paid'
  AND o.total > 100
  AND DATE(o.created_at) = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY)
GROUP BY u.id, u.name;
```
Индексы для ускорения
```
CREATE INDEX idx_order_status_created_total ON order(status, created_at, total);
```
такой составной индекс потому что
- идет фильтрация по этим полям
- колонка status первая потому что самая селективная, но я бы сделал тесты с разными индексами

## >2х-недельные клиенты, на вчерашний день которые не оплатили вчера
```
SELECT DISTINCT u.email FROM user u 
INNER JOIN order o ON u.id = o.user_id 
WHERE 
	o.status IN ('new', 'cancelled') 
	AND DATE(o.created_at) = DATE_SUB(CURRENT_DATE, INTERVAL 1 DAY)
	AND u.created_at <= CURDATE() - INTERVAL 2 WEEK;
```
Индексы для ускорения
```
CREATE INDEX idx_order_status_created ON order (status, created_at); 
CREATE INDEX idx_user_created_at ON user (created_at);
```


# 2. PHP, Геокодинг
пакет https://github.com/hflabs/dadata-php
метод \Dadata\DadataClient::suggest
с аргументами https://confluence.hflabs.ru/pages/viewpage.action?pageId=1023737934
данные много https://dadata.ru/api/suggest/address/

```
$query = "площадь"; // что ищем
$limit = 5; // количество результатов
$limitToMoscowRegionArguments = ["locations" => ["region" => "москва"]]; // можно ограничивать по коду, но так понятней 

$result = $DadataClient->suggest("address", $query, $limit, $limitToMoscowRegionArguments);

```
запустил на одном из прошлых проектов (без вывода метро, улицы и прочего).
Результат:
```
[
    {
      "suggestion": "г Москва, метро Площадь Гагарина",
      "longitude": 37.585833,
      "latitude": 55.706944
    },
    {
      "suggestion": "г Москва, метро Площадь Ильича",
      ...
    },
    {
      "suggestion": "г Москва, метро Площадь Революции",
      ...
    },
    {
      "suggestion": "г Москва, метро Преображенская площадь",
      ...
    },
    {
      "suggestion": "г Москва, метро Площадь трёх вокзалов (МЦД-2)",
      ...
    }
]
```
Псевдокод для сохранения запроса:
```
if($this->hasSaved($query)) {
	$this->updateCount($query)
} else {
	$this->insertNew($query)
}
```

без репозитория

# 3. Manticore search

- запустить init.sh
- посетить http://localhost

Можно посмотреть файл ``/manticore/etc/manticore.conf``
