INSERT INTO CATEGORIES (CATEGORIES_NAME,CATEGORIES_DESCRIPTION) VALUES 
  ('Électronique',       'Produits high-tech et accessoires'),
  ('Maison & Cuisine',   'Électroménager et ustensiles'),
  ('Sport & Loisirs',    'Articles de sport et plein air'),
  ('Beauté & Santé',     'Produits de beauté, hygiène, bien-être'),
  ('Jeux & Jouets',      'Jouets pour enfants et adultes');



  INSERT INTO PRODUCTS(PRODUCTS_NAME,PRODUCTS_PRICE,PRODUCTS_STOCK,PRODUCTS_CATEGORIES_ID) VALUES
  ('Casque Bluetooth X1000',        79.99,  50,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Électronique')),
  ('Souris Gamer Pro RGB',          49.90, 120,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Électronique')),
  ('Bouilloire Inox 1.7L',          29.99,  80,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Maison & Cuisine')),
  ('Aspirateur Cyclonix 3000',     129.00,  40,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Maison & Cuisine')),
  ('Tapis de Yoga Comfort+',        19.99, 150,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Sport & Loisirs')),
  ('Haltères 5kg (paire)',          24.99,  70,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Sport & Loisirs')),
  ('Crème hydratante BioSkin',      15.90, 200,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Beauté & Santé')),
  ('Gel douche FreshEnergy',         4.99, 300,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Beauté & Santé')),
  ('Puzzle 1000 pièces "Montagne"', 12.99,  95,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Jeux & Jouets')),
  ('Jeu de société "Galaxy Quest"', 29.90,  60,  (select CATEGORIES_ID FROM CATEGORIES where categories_name = 'Jeux & Jouets'));



  INSERT INTO CUSTOMERS (CUSTOMERS_FIRSTNAME, CUSTOMERS_LASTNAME, CUSTOMERS_EMAIL, CUSTOMERS_CREATED_AT) VALUES
  ('Alice',  'Martin',    'alice.martin@mail.com',    '2024-01-10 14:32'),
  ('Bob',    'Dupont',    'bob.dupont@mail.com',      '2024-02-05 09:10'),
  ('Chloé',  'Bernard',   'chloe.bernard@mail.com',   '2024-03-12 17:22'),
  ('David',  'Robert',    'david.robert@mail.com',    '2024-01-29 11:45'),
  ('Emma',   'Leroy',     'emma.leroy@mail.com',      '2024-03-02 08:55'),
  ('Félix',  'Petit',     'felix.petit@mail.com',     '2024-02-18 16:40'),
  ('Hugo',   'Roussel',   'hugo.roussel@mail.com',    '2024-03-20 19:05'),
  ('Inès',   'Moreau',    'ines.moreau@mail.com',     '2024-01-17 10:15'),
  ('Julien', 'Fontaine',  'julien.fontaine@mail.com', '2024-01-23 13:55'),
  ('Katia',  'Garnier',   'katia.garnier@mail.com',   '2024-03-15 12:00');

 
  INSERT INTO ORDERS (orders_customers_id,orders_date,orders_status) VALUES
  ((select customers_id from customers where customers_email = 'alice.martin@mail.com'),    '2024-03-01 10:20', 'PAID'),
  ((select customers_id from customers where customers_email = 'bob.dupont@mail.com'),      '2024-03-04 09:12', 'SHIPPED'),
  ((select customers_id from customers where customers_email = 'chloe.bernard@mail.com'),   '2024-03-08 15:02', 'PAID'),
  ((select customers_id from customers where customers_email = 'david.robert@mail.com'),    '2024-03-09 11:45', 'CANCELLED'),
  ((select customers_id from customers where customers_email = 'emma.leroy@mail.com'),      '2024-03-10 08:10', 'PAID'),
  ((select customers_id from customers where customers_email = 'felix.petit@mail.com'),     '2024-03-11 13:50', 'PENDING'),
  ((select customers_id from customers where customers_email = 'hugo.roussel@mail.com'),    '2024-03-15 19:30', 'SHIPPED'),
  ((select customers_id from customers where customers_email = 'ines.moreau@mail.com'),     '2024-03-16 10:00', 'PAID'),
  ((select customers_id from customers where customers_email = 'julien.fontaine@mail.com'), '2024-03-18 14:22', 'PAID'),
  ((select customers_id from customers where customers_email = 'katia.garnier@mail.com'),   '2024-03-20 18:00', 'PENDING');


  INSERT INTO order_items(order_items_orders_id, order_items_products_id, order_items_quantity, order_items_price) VALUES
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'alice.martin@mail.com' and o.orders_date = '2024-03-01 10:20'), (select products_id from products where products_name = 'Casque Bluetooth X1000'),         1,  79.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'alice.martin@mail.com' and o.orders_date = '2024-03-01 10:20'), (select products_id from products where products_name = 'Puzzle 1000 pièces "Montagne"'), 2,  12.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'bob.dupont@mail.com' and o.orders_date = '2024-03-04 09:12'), (select products_id from products where products_name = 'Tapis de Yoga Comfort+'),        1,  19.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'chloe.bernard@mail.com' and o.orders_date = '2024-03-08 15:02'), (select products_id from products where products_name = 'Bouilloire Inox 1.7L'),          1,  29.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'chloe.bernard@mail.com' and o.orders_date = '2024-03-08 15:02'), (select products_id from products where products_name = 'Gel douche FreshEnergy'),        3,   4.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'david.robert@mail.com' and o.orders_date = '2024-03-09 11:45'), (select products_id from products where products_name = 'Haltères 5kg (paire)'),          1,  24.99),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'emma.leroy@mail.com' and o.orders_date = '2024-03-10 08:10'), (select products_id from products where products_name = 'Crème hydratante BioSkin'),      2,  15.90),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'julien.fontaine@mail.com' and o.orders_date = '2024-03-18 14:22'),(select products_id from products where products_name = 'Jeu de société "Galaxy Quest"'), 1,  29.90),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'katia.garnier@mail.com' and o.orders_date = '2024-03-20 18:00'), (select products_id from products where products_name = 'Souris Gamer Pro RGB'),          1,  49.90),
  ((select o.orders_id from customers c join orders o on o.orders_customers_id = c.customers_id where c.customers_email = 'katia.garnier@mail.com' and o.orders_date = '2024-03-20 18:00'), (select products_id from products where products_name = 'Gel douche FreshEnergy'),        2,   4.99);
