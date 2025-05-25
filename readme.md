Documentation de l'API Backend (Création d'Areas)
Vue d'ensemble

Cette API est conçue pour créer et gérer des "Areas", qui consistent en des actions et des réactions déclenchées par divers services. Elle prend en charge l'authentification, la gestion des services et l'écoute des événements afin d'automatiser ces zones.
Authentification

L'authentification est gérée via un jeton Bearer. L'API possède des routes spécifiques pour enregistrer de nouveaux utilisateurs et connecter des utilisateurs existants. Une inscription ou une connexion réussie renvoie un jeton qui doit être inclus dans l'en-tête Authorization des requêtes suivantes.
Routes d'authentification

    POST /register
        Description : Enregistre un nouvel utilisateur.
        Body :
            email : string
            password : string
        Réponses :
            200 : Le compte existe déjà.
            201 : Compte créé avec succès.

    POST /login
        Description : Connecte un utilisateur.
        Body :
            email : string
            password : string
        Réponses :
            200 : Connexion réussie, retourne le jeton Bearer.
            401 : Identifiants invalides.

Utilisation du Jeton Bearer

Dans chaque requête authentifiée, incluez le jeton dans l'en-tête Authorization :

plaintext

Authorization: Bearer <token>

Ajout d'un Nouveau Service

Pour intégrer un nouveau service avec l'API, celui-ci doit interagir avec le système d'événements. Le service capture les événements et déclenche les actions/réactions appropriées. Chaque nouvel événement doit être stocké dans la collection d'événements de la base de données.
Étapes pour Ajouter un Nouveau Service

    Configuration du Service : Implémentez la logique du service pour détecter les événements.
    Capture d'Événements : Assurez-vous que chaque événement est capturé et ajouté à la collection d'événements.
    Mise à Jour de la Base de Données : Ajoutez la configuration du service dans la base de données, en veillant à respecter la structure pour l'écoute des événements.
    Écoute des Événements : Assurez-vous que l'écouteur global d'événements capture l'événement et déclenche toutes les zones associées.

Exemple de Flux

    Lorsque le service détecte un événement (par exemple, un fichier est téléchargé), il envoie les données de l'événement à la collection d'événements.
    L'écouteur d'événements, surveillant constamment cette collection, traitera l'événement et exécutera toutes les actions ou réactions associées.

Gestion des Actions et Réactions

La configuration des actions et des réactions par service est gérée via une route dédiée, permettant une configuration flexible et optimisée.
Routes pour la Gestion des Actions/Réactions

    POST /services/{serviceId}/action-reaction
        Description : Configure des actions et des réactions pour un service spécifique.
        Body :
            action : string (nom de l'action à déclencher)
            reaction : string (réaction correspondante à exécuter)
        Réponses :
            200 : Action et réaction configurées avec succès.
            400 : Configuration invalide.

Gestion des Événements

Les événements sont le cœur du système d'automatisation de l'API. Chaque événement déclenche des actions et réactions spécifiques selon des configurations prédéfinies.
Écouteur d'Événements

    L'écouteur surveille la collection d'événements de la base de données pour détecter les changements.
    Lorsqu'un nouvel événement est ajouté à la collection, l'écouteur déclenche toutes les zones associées (actions/réactions).

Structure de la Base de Données

    Collection d'Événements : Stocke tous les événements déclenchés par les services.
        Chaque entrée contient :
            eventId : Identifiant unique de l'événement.
            serviceId : Le service qui a généré l'événement.
            timestamp : Heure de capture de l'événement.
            payload : Données associées à l'événement.

Cycle de Vie d'un Événement

    Un service détecte un événement et l'envoie à la collection d'événements.
    L'écouteur traite l'événement et vérifie les actions ou réactions configurées pour le service.
    Si une action/réaction est trouvée, l'écouteur déclenche l'action.

Services Disponibles

### Services Disponibles

- **Actualités** : Agrège les actualités dans diverses catégories comme l'environnement, la santé, la technologie, le sport et la finance, pour des mises à jour en temps réel.


![Le Monde Logo](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/lemonde.png?raw=true)

- **CoinMarketCap** : Suivi des prix des cryptomonnaies, y compris Bitcoin, Ethereum, Solana et Tether, fournissant des informations à jour sur le marché des actifs numériques.


![CoinMarketCap](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/coinmarketcap.png?raw=true)

- **Discord** : Intègre avec Discord pour gérer les mentions, messages et partages de fichiers dans les communautés, facilitant la communication.


![Discord](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/discord-logo%20(1).png?raw=true)

- **Stocks** : Intègre les données financières via l'API Finnhub pour fournir des informations de marché en temps réel, avec actions et réactions basées sur les événements financiers.


![Stocks](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/stocks-logo.png?raw=true)

- **Football** : Offre des mises à jour sur les derniers matchs de football, avec prise en charge de ligues telles que la Ligue 1, la Premier League, la Serie A, etc.


![Football](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/sport-logo.png?raw=true)

- **GitHub** : Connecte aux dépôts GitHub pour suivre des activités telles que les pushs, pull requests, issues, etc., pour le suivi des workflows de développement.


![GitHub](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/github-logo%20(1).png?raw=true)

- **Google Maps** : Permet la planification d'itinéraires et le calcul du temps de trajet, pour obtenir la distance et le temps estimé entre deux adresses.


![Google Maps](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/google-map-logo.png?raw=true)

- **Quotes** : Propose une variété de citations, offrant des options comme des citations inspirantes, de santé, d'humour et d'affaires pour la motivation ou le partage.


![Quotes](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/quote-logo.png?raw=true)

- **Revolut** : Connexion avec Revolut pour des opérations bancaires, avec prise en charge de la récupération de solde de compte et le suivi des transactions.

![Revolut](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/revolut.png?raw=true)

- **Slack** : Prend en charge les intégrations Slack pour recevoir et réagir aux messages, ainsi que pour envoyer des messages, idéal pour la collaboration en équipe.


![Slack](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/slack-logo%20(1).png?raw=true)

- **Telegram** : Gère les interactions de messages sur Telegram, avec des fonctionnalités pour recevoir des messages, photos et fichiers, ainsi que pour envoyer des messages directement.


![Telegram](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/telegram-logo%20(1).png?raw=true)

- **Heure** : Fournit l'heure actuelle pour différentes zones horaires, utile pour la planification et la coordination mondiale.


![Heure](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/time-logo.png?raw=true)

- **Trello** : Intègre avec Trello pour la gestion de projets et de tâches, avec support des actions et réactions basées sur les activités de cartes et de tableaux.


![Trello](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/trello.png?raw=true)

- **Météo** : Récupère les conditions météorologiques actuelles et les prévisions, permettant aux utilisateurs de rester informés des changements météorologiques.



![Météo](https://github.com/EpitechPromo2027/B-DEV-500-PAR-5-1-area-yanis.lazreq/blob/main/screenshots/weather-logo.png?raw=true)


Conclusion

Cette API offre un cadre flexible pour créer et gérer des zones. En suivant les étapes décrites, vous pouvez facilement ajouter de nouveaux services, gérer des actions et réactions, et assurer l'authentification et la gestion des événements.
