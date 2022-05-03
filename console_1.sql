create table customer
(
    id         int primary key,
    first_name varchar(100) not null,
    last_name  varchar(100) not null,
    city       varchar(100),
    country    varchar(100),
    phone      varchar(100)
);
create table supplier
(
    id            int primary key,
    company_name  varchar(100) not null,
    contact_name  varchar(100),
    contact_title varchar(100),
    city          varchar(100),
    country       varchar(100),
    phone         varchar(100),
    fax           varchar(100)
);
create table product
(
    id              int primary key,
    product_name    varchar(100)                 not null,
    unit_price      decimal(12, 2) default 0,
    package         varchar(100),
    is_discontinued boolean        default false,
    supplier_id     int references supplier (id) not null
);
create table orders
(
    id           int primary key,
    order_date   timestamp      default now(),
    order_number varchar(100),
    total_amount decimal(12, 2) default 0,
    customer_id  int references customer (id) not null
);
create table order_item
(
    id         int primary key,
    unit_price decimal(12, 2) default 0,
    quantity   int            default 1,
    order_id   int references orders (id)  not null,
    product_id int references product (id) not null
);

INSERT INTO customer (id, first_name, last_name, city, country, phone)
VALUES (1, 'Maria', 'Anders', 'Berlin', 'Germany', '030-0074321');
INSERT INTO customer (id, first_name, last_name, city, country, phone)
VALUES (91, 'Zbyszek', 'Piestrzeniewicz', 'Warszawa', 'Poland', '(26) 642-7012');

INSERT INTO supplier (id, company_name, contact_name, city, country, phone, fax)
VALUES (1, 'Exotic Liquids', 'Charlotte Cooper', 'London', 'UK', '(171) 555-2222', NULL);
INSERT INTO supplier (id, company_name, contact_name, city, country, phone, fax)
VALUES (29, 'Forêts d''érables', 'Chantal Goulet', 'Ste-Hyacinthe', 'Canada', '(514) 555-2955', '(514) 555-2921');

INSERT INTO product (id, product_name, supplier_id, unit_price, package, is_discontinued)
VALUES (1, 'Chai', 1, 18.00, '10 boxes x 20 bags', false);
INSERT INTO product (id, product_name, supplier_id, unit_price, package, is_discontinued)
VALUES (78, 'Stroopwafels', 22, 9.75, '24 pieces', false);

INSERT INTO orders (id, order_date, customer_id, total_amount, order_number)
VALUES (1, to_timestamp('Jul  4 2012 ', 'MON DD YYYY'), 85, 440.00, '542378'),
       (830, to_timestamp('May  6 2014 ', 'MON DD YYYY'), 65, 1374.60, '543207');

INSERT INTO order_item (id, order_id, product_id, unit_price, quantity)
VALUES (1, 1, 11, 14.00, 12),
       (2155, 830, 77, 13.00, 2);
select *
from supplier;
select *
from customer;
select *
from order_item;
select *
from orders;
select *
from product;

-- 1) Вывести всех клиентов из страны Canada
--
select *
from customer
where country = 'Canada';

-- 2) Вывести все страны клиентов
--
select country
from customer;

-- 3) Вывести количество всех заказов
--
select max(id) kolichestvo_vseh_zakazov
from orders;

-- 4) Вывести максимальную стоимость заказа
--
select max(unit_price) max_price
from order_item;

-- 5) Найти сумму всех заказов
--
select sum(total_amount) all_sum_of_orders
from orders;

-- 6) Найти сумму всех заказов за 2014 год
--
select sum(total_amount) all_sum_of_orders
from orders
where order_date between ('January 1 2014') and ('December 31 2014');

-- 7) Найти среднюю стоимость всех заказов
--
select avg(unit_price) average
from order_item;

-- 8) Найти среднюю стоимость всех заказов по каждому клиенту
--
select round(avg(total_amount)) as average_total_amount, customer_id
from orders
         join customer c on c.id = orders.customer_id
group by customer_id;

-- 9) Найти всех клиентов, которые живут в Бразилии или Испании
--
select *
from customer
where country = 'Brazil'
   or country = 'Spain';

-- 10 Найти все заказы между 2013ым и 2014ым годами, которые стоили меньше 100.00$
--
select *
from orders
where total_amount < 100
  and order_date between ('January 1 2013') and ('December 31 2014');

-- 11) Найти всех клиентов, которые в одной из стран: Испания, Италия, Германия, Франция.
-- Отсортируйте по странам
--
select *
from customer
where country = 'Spain'
   or country = 'Italy'
   or country = 'Germany'
   or country = 'France' order by country;

-- 12) Найти все страны клиентов, страны которых содержаться в таблице поставщиков
--
SELECT
       customer.id,
       customer.country
FROM customer
 left join supplier on supplier.country = customer.country ;

-- 13) Найти всех клиентов, имена которых начинаются на ‘Jo’
--
select * from customer where first_name like 'Jo%';

-- 14) Найти всех клиентов, имена которых заканчиваются на ‘a’ и имеют длину ровно 4 символа
--
select * from customer where first_name like '%a';

-- 15) Найти количество клиентов по странам
--
select count(*), country from customer group by country;

-- 16) Найти количество клиентов по странам. Вывести в порядке убывания
--
select count(*), customer.country from customer group by customer.country order by count(*) desc;

-- 17) Найти общую сумму стоимости заказов и количество заказов по каждому
-- клиенту (customer_id). Отсортировать по сумме
--
select sum(total_amount), count(*), orders.customer_id
from orders
         join customer c on c.id = orders.customer_id
group by customer_id
order by sum(total_amount) desc;

-- 18) Найти общую сумму стоимости заказов и количество заказов по каждому клиенту
-- (customer_id), у которых общее количество заказов больше 20ти
select sum(total_amount), count(*), customer_id, quantity
from orders
         join order_item oi on orders.id = oi.order_id
where quantity > 20
group by quantity, customer_id;
