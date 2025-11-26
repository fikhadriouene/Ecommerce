-- =========================== Parties 3 - REQUETES SQL DE BASE ================================================


-- Lister tous les clients triés par date de création de compte (plus anciens → plus récents).

SELECT * 
FROM customers
ORDER BY customers_created_at DESC;

-- Lister tous les produits (nom + prix) triés par prix décroissant.

SELECT products_name, products_price  
FROM products
ORDER BY products_price DESC;

-- Lister les commandes passées entre deux dates (par exemple entre le 1er et le 15 mars 2024).

SELECT orders_id
FROM orders
WHERE orders_date BETWEEN '2024-03-01' and '2024-03-15';  

-- Lister les produits dont le prix est strictement supérieur à 50 €.

SELECT *  
FROM products 
WHERE products_price > 50;

-- Lister tous les produits d’une catégorie donnée (par exemple “Électronique”).

SELECT p.products_name 
FROM products p 
join categories c
on p.products_categories_id = c.categories_id
WHERE c.categories_name = 'Électronique'
GROUP BY p.products_categories_id,p.products_id


-- =========================== Partie 4 – Jointures simples ================================================

-- # 6️⃣ Partie 4 – Jointures simples

-- 1. Lister tous les produits avec le nom de leur catégorie.

SELECT p.products_name, c.categories_name
FROM produits p
JOIN categories c
ON p.products_categories_id = c.categories_id 

-- 2. Lister toutes les commandes avec le nom complet du client (prénom + nom).

SELECT o.orders_id, c.customers_firstname || ' ' ||c.customers_lastname
FROM customers c
JOIN O

-- 3. Lister toutes les lignes de commande avec :

--    * le nom du client,
--    * le nom du produit,
--    * la quantité,
--    * le prix unitaire facturé.
-- 4. Lister toutes les commandes dont le statut est `PAID` ou `SHIPPED`.