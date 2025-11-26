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
JOIN orders o
ON c.customers_id = o.orders_customers_id

-- 3. Lister toutes les lignes de commande avec :

--    * le nom du client,
--    * le nom du produit,
--    * la quantité,
--    * le prix unitaire facturé.


SELECT c.customers_firstname || ' ' || c.customers_lastname, 
       p.products_name, order_items_quantity, p.products_price
FROM customers c
JOIN orders o ON c.customers_id = o.orders_customers_id
JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
JOIN products p ON p.products_id = oi.order_items_products_id
       
-- 4. Lister toutes les commandes dont le statut est `PAID` ou `SHIPPED`.

SELECT orders_id FROM orders WHERE orders_status IN ('PAID','SHIPPED')

-- ========================= Partie 5 – Jointures avancées ==============================    
-- # 7️⃣ Partie 5 – Jointures avancées

-- 1. Afficher le détail complet de chaque commande avec :

--    * date de commande,
--    * nom du client,
--    * liste des produits,
--    * quantité,
--    * prix unitaire facturé,
--    * montant total de la ligne (quantité × prix unitaire).

SELECT o.orders_id,o.orders_date, c.customers_lastname, p.products_name, oi.order_items_quantity,
    p.products_price, (oi.order_items_quantity * p.products_price ) as line_total_amount
FROM orders o
JOIN customers c ON c.customers_id = o.orders_customers_id
JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
JOIN products p ON p.products_id = oi.order_items_products_id
group by orders_id,c.customers_lastname,p.products_name, oi.order_items_quantity,
    p.products_price
order by o.orders_id ASC

-- 2. Calculer le **montant total de chaque commande** et afficher uniquement :

--    * l’ID de la commande,
--    * le nom du client,
--    * le montant total de la commande.

SELECT tmp.orders_id, tmp.customers_lastname, sum(tmp.line_total_amount) as total_amount
FROM (
	    SELECT o.orders_id,o.orders_date, c.customers_lastname, p.products_name, oi.order_items_quantity,
	       p.products_price, (oi.order_items_quantity * p.products_price ) as line_total_amount
	    FROM orders o
	    JOIN customers c ON c.customers_id = o.orders_customers_id
	    JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
	    JOIN products p ON p.products_id = oi.order_items_products_id
	    group by orders_id,c.customers_lastname,p.products_name, oi.order_items_quantity,
	        p.products_price
	    order by o.orders_id ASC
) AS tmp
GROUP BY tmp.orders_id, tmp.customers_lastname

-- 3. Afficher les commandes dont le montant total **dépasse 100 €**.

SELECT tmp2.orders_id, tmp2.total_amount
FROM (
        SELECT tmp.orders_id, tmp.customers_lastname, sum(tmp.line_total_amount) as total_amount
        FROM (
                SELECT o.orders_id,o.orders_date, c.customers_lastname, p.products_name, oi.order_items_quantity,
                p.products_price, (oi.order_items_quantity * p.products_price ) as line_total_amount
                FROM orders o
                JOIN customers c ON c.customers_id = o.orders_customers_id
                JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
                JOIN products p ON p.products_id = oi.order_items_products_id
                group by orders_id,c.customers_lastname,p.products_name, oi.order_items_quantity,
                    p.products_price
                order by o.orders_id ASC
        ) AS tmp
        GROUP BY tmp.orders_id, tmp.customers_lastname
) AS tmp2
WHERE tmp2.total_amount > 100

-- 4. Lister les catégories avec leur **chiffre d’affaires total** 
-- (somme du montant des lignes sur tous les produits de cette catégorie).

-- ---
SELECT tmp2.categories_name, sum(tmp2.total_amount) as total_CA
FROM (
        SELECT tmp.categories_name, tmp.orders_id, tmp.customers_lastname, sum(tmp.line_total_amount) as total_amount
        FROM (
                SELECT ca.categories_name,o.orders_id,o.orders_date, c.customers_lastname, p.products_name, oi.order_items_quantity,
                p.products_price, (oi.order_items_quantity * p.products_price ) as line_total_amount
                FROM orders o
                JOIN customers c ON c.customers_id = o.orders_customers_id
                JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
                JOIN products p ON p.products_id = oi.order_items_products_id
                JOIN categories ca ON categories_id = p.products_categories_id
                group by orders_id,c.customers_lastname,p.products_name, oi.order_items_quantity,
                    p.products_price,ca.categories_name

        ) AS tmp
        GROUP BY tmp.orders_id, tmp.customers_lastname,tmp.categories_name
) AS tmp2
group by tmp2.categories_name



-- # 8️⃣ Partie 6 – Sous-requêtes

-- 1. Lister les produits qui ont été vendus **au moins une fois**.

SELECT p.products_id, p.products_name, oi.order_items_quantity
FROM products p
JOIN order_items oi ON p.products_id = oi.order_items_products_id
WHERE oi.order_items_quantity > 0



-- 2. Lister les produits qui **n’ont jamais été vendus**.

SELECT products_id, products_name
FROM products
WHERE products_id not in (

                            SELECT p.products_id
                            FROM products p
                            JOIN order_items oi ON p.products_id = oi.order_items_products_id
                            WHERE oi.order_items_quantity > 0
                        )


-- 3. Trouver le client qui a **dépensé le plus** (TOP 1 en chiffre d’affaires cumulé).

SELECT tmp.customers_id, tmp.customers_lastname, sum(line_total_amount) as total_CA
FROM (
		SELECT c.customers_id, c.customers_lastname, (oi.order_items_quantity * p.products_price ) as line_total_amount
		FROM customers c
		JOIN orders o ON c.customers_id = o.orders_customers_id
		JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
		JOIN products p ON oi.order_items_products_id = p.products_id
		GROUP BY c.customers_id,oi.order_items_quantity, p.products_price
	 ) as tmp
group by tmp.customers_id,tmp.customers_lastname
order by total_CA DESC
LIMIT 1




-- 4. Afficher les **3 produits les plus vendus** en termes de quantité totale.

SELECT p.products_id, p.products_name, sum(oi.order_items_quantity) as total
FROM products p
JOIN order_items oi ON p.products_id = oi.order_items_products_id
WHERE oi.order_items_quantity > 0
GROUP BY p.products_id,p.products_name
ORDER BY total DESC
LIMIT 3

-- 5. Lister les commandes dont le montant total est **strictement supérieur à la moyenne** de toutes les commandes.

SELECT tmp.orders_id, tmp.total_amount
FROM (
        SELECT o.orders_id, SUM(oi.order_items_quantity * p.products_price) AS total_amount
        FROM orders o
        JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
        JOIN products p ON p.products_id = oi.order_items_products_id
        GROUP BY o.orders_id
     ) AS tmp

WHERE tmp.total_amount > (
        SELECT avg(tmp2.total_amount) as total_amount_avg
        FROM (
                SELECT 
                    o2.orders_id,
                    SUM(oi2.order_items_quantity * p2.products_price) AS total_amount
                FROM orders o2
                JOIN order_items oi2 ON oi2.order_items_orders_id = o2.orders_id
                JOIN products p2 ON p2.products_id = oi2.order_items_products_id
                GROUP BY o2.orders_id
             ) AS tmp2
     )
ORDER BY tmp.total_amount DESC;