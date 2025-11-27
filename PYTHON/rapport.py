import psycopg
from datetime import *




# 1. Chiffre d’affaires total.
# 2. Panier moyen.
# 3. Article le plus commandé (en quantité totale).
# 4. Top 3 clients par montant dépensé.
# 5. Chiffre d’affaires par catégorie.


DSN = "dbname=postgres user=admin password=admin host=localhost port=5432"


def chiffre_affaires_total() :
        requete = """
            SELECT SUM(oi.order_items_quantity * p.products_price) AS total_ca
            FROM orders o
            JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
            JOIN products p ON p.products_id = oi.order_items_products_id
        """
        try :
            with psycopg.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur.execute(requete)
                    row = cur.fetchall()
                    print(row[0][0])
                    return row[0][0]
        except psycopg.errors.SyntaxError as e: 
            print ("Erreur SQL : ", e)
        except psycopg.errors.UniqueViolation as e:
            print ("Violation Unique : ", e)
        except psycopg.OperationalError as e:
            print ("Problème de connection :" , e)
        except Exception as e:
            print ("Autre erreurs : ", e)
        

def panier_moyen() :
        
        requete = """
            SELECT round((tmp.total_CA / tmp.nb_orders),2) as panier_moyen
            FROM (
                SELECT count(o.orders_id) as nb_orders ,SUM(oi.order_items_quantity * p.products_price) AS total_CA
                FROM orders o
                JOIN order_items oi ON oi.order_items_orders_id = o.orders_id
                JOIN products p ON p.products_id = oi.order_items_products_id
            ) as tmp
        """
        try :
            with psycopg.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur = conn.cursor()
                    cur.execute(requete)
                    row = cur.fetchall()
                    print(row[0][0])
                    return row[0][0]
        except psycopg.errors.SyntaxError as e: 
            print ("Erreur SQL : ", e)
        except psycopg.errors.UniqueViolation as e:
            print ("Violation Unique : ", e)
        except psycopg.OperationalError as e:
            print ("Problème de connection :" , e)
        except Exception as e:
            print ("Autre erreurs : ", e)

def article_le_plus_commande() :
        requete = """
            SELECT p.products_name
            FROM products p
            JOIN order_items oi ON p.products_id = oi.order_items_products_id
            WHERE oi.order_items_quantity > 0
            GROUP BY p.products_name
            LIMIT 1
        """
        try :
            with psycopg.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur = conn.cursor()
                    cur.execute(requete)
                    row = cur.fetchall()
                    print(row[0][0])
                    return row[0][0]
        except psycopg.errors.SyntaxError as e: 
            print ("Erreur SQL : ", e)
        except psycopg.errors.UniqueViolation as e:
            print ("Violation Unique : ", e)
        except psycopg.OperationalError as e:
            print ("Problème de connection :" , e)
        except Exception as e:
            print ("Autre erreurs : ", e)

def les_trois_clients_par_montant() :
        requete = """
            SELECT tmp.nom_complet, sum(line_total_amount) as total_CA
            FROM (
                    SELECT c.customers_lastname || ' ' || c.customers_firstname as nom_complet, (oi.order_items_quantity * p.products_price ) as line_total_amount
                    FROM customers c
                    JOIN orders o ON c.customers_id = o.orders_customers_id
                    JOIN order_items oi ON o.orders_id = oi.order_items_orders_id
                    JOIN products p ON oi.order_items_products_id = p.products_id
                    GROUP BY c.customers_id,oi.order_items_quantity, p.products_price
                ) as tmp
            group by tmp.nom_complet
            order by total_CA DESC
            LIMIT 3
        """
        try :
            chaine = ""
            with psycopg.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur = conn.cursor()
                    cur.execute(requete)
                    row = cur.fetchall()
                    print(row[0][0])
                    return row
        except psycopg.errors.SyntaxError as e: 
            print ("Erreur SQL : ", e)
        except psycopg.errors.UniqueViolation as e:
            print ("Violation Unique : ", e)
        except psycopg.OperationalError as e:
            print ("Problème de connection :" , e)
        except Exception as e:
            print ("Autre erreurs : ", e)
            
def chiffre_affaires_par_categories() :
        requete = """
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
        """
        try :
            chaine = ""
            with psycopg.connect(DSN) as conn:
                with conn.cursor() as cur:
                    cur = conn.cursor()
                    cur.execute(requete)
                    row = cur.fetchall()
                    print(row[0][0])
                    return row
        except psycopg.errors.SyntaxError as e: 
            print ("Erreur SQL : ", e)
        except psycopg.errors.UniqueViolation as e:
            print ("Violation Unique : ", e)
        except psycopg.OperationalError as e:
            print ("Problème de connection :" , e)
        except Exception as e:
            print ("Autre erreurs : ", e)    
    


top_trois_par_montant = les_trois_clients_par_montant()
chiffre_affaires_par_categorie = chiffre_affaires_par_categories()
chiffre_affaires_tot = chiffre_affaires_total()
panier_moy = panier_moyen()
article_le_plus_cmd = article_le_plus_commande()
    
    
# 1. Chiffre d’affaires total.
# 2. Panier moyen.
# 3. Article le plus commandé (en quantité totale).
# 4. Top 3 clients par montant dépensé.
# 5. Chiffre d’affaires par catégorie.

with open("rapport.txt", "w", encoding="UTF-8") as f:
    #f.write(f"Rapport établi à : {datetime.now(timezone.utc).strftime("%H:%M:%S")}€ \n")
    f.write(f"Rapport établi le {datetime.now().date()} à {datetime.now().time().strftime("%H:%M:%S")} \n")
    f.write(f"--------------------------------------\n\n")
    f.write(f"Chiffre d'affaires : {chiffre_affaires_tot}€ \n")
    f.write(f"Panier moyen : {panier_moy}€\n")
    f.write(f"Article le plus commandé  : {article_le_plus_cmd}\n")
    f.write(f"Top 3 clients par montant dépensé :\n")
    for c in top_trois_par_montant :
        f.write(f" - {c[0]} \n")
    
    f.write(f"Chiffre d’affaires par catégorie :\n")
    for cat in chiffre_affaires_par_categorie :
        f.write(f" - {cat[0]} - Chiffre d'affaires : {cat[1]}€ \n")
    
