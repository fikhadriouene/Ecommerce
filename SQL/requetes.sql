-- Lister tous les clients triés par date de création de compte (plus anciens → plus récents).

select * 
from customers
order by customers_date

-- Lister tous les produits (nom + prix) triés par prix décroissant.
-- Lister les commandes passées entre deux dates (par exemple entre le 1er et le 15 mars 2024).
-- Lister les produits dont le prix est strictement supérieur à 50 €.
-- Lister tous les produits d’une catégorie donnée (par exemple “Électronique”).