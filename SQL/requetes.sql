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


-- ====================== Partie 7 : statistique et aggregats =======================

--  9️⃣ Partie 7 – Statistiques & agrégats

-- 1. Calculer le **chiffre d’affaires total** (toutes commandes confondues, hors commandes annulées si souhaité).

SELECT SUM(oi.order_items_quantity * p.products_price) AS total_CA
FROM orders o
JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
JOIN products p ON p.products_id = oi.order_items_products_id


-- 2. Calculer le **panier moyen** (montant moyen par commande).

SELECT round((tmp.total_CA / tmp.nb_orders)) as panier_moyen
FROM (
    SELECT count(o.orders_id) as nb_orders ,SUM(oi.order_items_quantity * p.products_price) AS total_CA
    FROM orders o
    JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
    JOIN products p ON p.products_id = oi.order_items_products_id
) as tmp

-- 3. Calculer la **quantité totale vendue par catégorie**.



SELECT ca.categories_name, sum(oi.order_items_quantity) as quantite_vendue
FROM orders o
JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
JOIN products p ON p.products_id = oi.order_items_products_id
JOIN categories ca ON categories_id = p.products_categories_id
group by categories_id



-- 4. Calculer le **chiffre d’affaires par mois** (au moins sur les données fournies).



SELECT tmp.mois, round(sum(tmp.line_total_amount),2) as CA_mensuel
FROM (

        SELECT EXTRACT(MONTH FROM o.orders_date) as mois, (oi.order_items_quantity * p.products_price ) as line_total_amount
        FROM orders o 
        JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
        JOIN products p ON p.products_id = oi.order_items_products_id
        GROUP BY mois,oi.order_items_quantity,p.products_price
) as tmp
GROUP BY tmp.mois 

-- 5. Formater les montants pour n’afficher que **deux décimales**.

-- =============================== Partie 8 : Logique Conditionnelle ==================================

-- # 🔟 Partie 8 – Logique conditionnelle (CASE)

-- 1. Pour chaque commande, afficher :

--    * l’ID de la commande,
--    * le client,
--    * la date,
--    * le statut,
--    * une version “lisible” du statut en français via `CASE` :

--      * `PAID` → “Payée”
--      * `SHIPPED` → “Expédiée”
--      * `PENDING` → “En attente”
--      * `CANCELLED` → “Annulée”

SELECT o.orders_id, c.customers_lastname, o.orders_date,
        CASE o.orders_status
        	WHEN 'PAID' THEN 'Payé'
        	WHEN 'SHIPPED' THEN 'Expédiée'
        	WHEN 'PENDING' THEN 'En attente'
        	WHEN 'CANCELLED' THEN 'Annulée'
		END AS status
FROM orders o
JOIN customers c ON o.orders_customers_id = c.customers_id






-- 2. Pour chaque client, calculer le **montant total dépensé** et le classer en segments :

--    * `< 100 €`  → “Bronze”
--    * `100–300 €` → “Argent”
--    * `> 300 €`  → “Or”

--    Afficher : prénom, nom, montant total, segment.

SELECT tmp.customers_firstname, tmp.customers_lastname, sum(line_total_amount) as total_CA,
       CASE 
        	WHEN sum(line_total_amount) < 100 THEN 'Bronze'
            WHEN sum(line_total_amount) BETWEEN 100 and 300  THEN 'Argent'
            WHEN sum(line_total_amount) > 300 THEN 'Or'
		END AS segment
FROM (
		SELECT c.customers_id,c.customers_firstname, c.customers_lastname, (oi.order_items_quantity * p.products_price ) as line_total_amount
		FROM customers c
		JOIN orders o ON c.customers_id = o.orders_customers_id
		JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
		JOIN products p ON oi.order_items_products_id = p.products_id
		GROUP BY c.customers_id,oi.order_items_quantity, p.products_price
	 ) as tmp
group by tmp.customers_id,tmp.customers_lastname,tmp.customers_firstname
order by total_CA DESC


---

-- ===================== Partie 9 - Challenge final ============================

-- # 1️⃣1️⃣ Partie 9 – Challenge final

-- Proposer et écrire **5 requêtes d’analyse avancées** supplémentaires parmi, par exemple :

-- 1. Top 5 des clients les plus actifs (nombre de commandes).

SELECT c.customers_firstname || ' ' || c.customers_lastname, count(o.orders_id) AS nb_commandes
FROM customers c
JOIN orders o ON c.customers_id = o.orders_id
ORDER BY nb_commandes DESC
LIMIT 5


-- 2. Top 5 des clients qui ont dépensé le plus (CA total).

SELECT tmp.customers_firstname, tmp.customers_lastname, sum(line_total_amount) as total_CA,
FROM (
		SELECT c.customers_id,c.customers_firstname, c.customers_lastname, (oi.order_items_quantity * p.products_price ) as line_total_amount
		FROM customers c
		JOIN orders o ON c.customers_id = o.orders_customers_id
		JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
		JOIN products p ON oi.order_items_products_id = p.products_id
		GROUP BY c.customers_id,oi.order_items_quantity, p.products_price
	 ) as tmp
group by tmp.customers_id,tmp.customers_lastname,tmp.customers_firstname
order by total_CA DESC
LIMIT 5



-- 3. Les 3 catégories les plus rentables (CA total).

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
ORDER BY total_CA DESC
LIMIT 5

-- 4. Les produits qui ont généré au total **moins de 10 €** de CA.





-- 5. Les clients n’ayant passé **qu’une seule commande**.
-- 6. Les produits présents dans des commandes **annulées**, avec le montant “perdu”.