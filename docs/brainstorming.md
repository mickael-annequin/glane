# Brainstorming — Glane 🌾

Décisions prises le 06/10/2026. On pourra les compléter au fil du projet.

## Le besoin
Lors d'une réunion, des responsables de structures sociales d'Eure-et-Loir ont exprimé le besoin de partager leurs surplus de stock entre elles. Les structures se connaissent et agissent sur le même terrain. L'app démarre à l'échelle du département, mais doit pouvoir évoluer.

## Vocabulaire
- **Structure** : toute organisation qui utilise Glane (association, foyer d'accueil, épicerie sociale, CCAS, entreprise du social…). On ne dit pas « association », car toutes n'en sont pas.
- **Membre** : une personne qui utilise Glane pour sa structure, bénévole ou salariée. On ne dit pas « bénévole ».
- **Responsable** : un membre qui gère sa structure dans Glane.

## Principe
- Une structure qui a un surplus publie une **annonce** : produit, catégorie et date limite (avant péremption pour l'alimentaire), lieu de récupération et disponibilités (déjà remplis, modifiables). En option : photos, quantité + unité, conservation et un texte libre.
- Les autres structures consultent les annonces et peuvent **réserver** un stock.
- Dès qu'une annonce est réservée, le stock est attribué à la structure qui réserve et **disparaît des annonces disponibles**.
- Les échanges sont **purement gratuits** : aucune transaction d'argent.

## Accès et comptes
- App **privée** : pas d'inscription ouverte. Personne n'entre sans **invitation**.
- **Un compte par personne**, rattaché à une structure.
- L'admin (moi, pour l'instant) crée les structures légitimes du territoire et invite leur premier **responsable**.
- Le responsable invite ensuite ses **membres** par email, et désactive les comptes de ceux qui partent. Il peut nommer d'autres responsables : une structure a **un ou plusieurs** responsables, pour ne pas être bloquée si l'un d'eux s'absente ou part.
- Les annonces, réservations, conversations et chiffres appartiennent à la **structure** : tous ses membres les voient et peuvent prendre le relais. On garde aussi le nom de la personne qui a publié ou réservé.

## Décisions
| Sujet | Choix | Pourquoi |
|---|---|---|
| Alertes de nouvelles annonces | Par **catégories** : chaque structure coche celles qui l'intéressent (toutes cochées par défaut) | Pas de problème d'orthographe, et les catégories servent aussi aux filtres et aux chiffres. Les alertes « Je recherche… » viendront plus tard. |
| Téléphones | **App Android** (Capacitor) + **iPhone via le site ajouté à l'écran d'accueil** (PWA) | Tout est gratuit. Sur iPhone, les notifications web marchent depuis l'écran d'accueil (iOS 16.4+). Une app iOS native coûterait 99 €/an et demanderait un Mac. |
| Réservation | **Lot entier** | Le plus simple. Pour partager un gros stock, le donateur publie plusieurs annonces (ex. 3 lots de 50 kg). |
| Champs d'une annonce | **Obligatoires** : catégorie, produit, date limite (« À récupérer avant le… »), lieu et disponibilités (déjà remplis avec ceux de la structure, modifiables). **Facultatifs** : photos, quantité + unité, conservation, texte libre. | Publier doit être rapide : avec les champs pré-remplis, il suffit de choisir une catégorie, d'écrire le produit et de donner une date. La date limite évite les annonces oubliées. |
| Quantités | **Quantité + unité** (kg, litres, pièces, cartons, colis, sacs, palettes), facultative | Le stock peut aussi être non alimentaire (lessive, couches, textile…). |
| Photos | Jusqu'à **5 photos** par annonce, appareil photo ou galerie | Facultatives, mais mises en avant : elles rassurent sur l'état du stock. |
| Chiffres clés | Chaque structure voit **ses propres chiffres**. Les totaux du département sont **réservés à l'admin**. On compte toujours le nombre de dons, et les quantités quand elles sont indiquées. | Les chiffres globaux servent à mon information, pour suivre l'impact et faire évoluer l'app. |
| Comptes | **Un compte par personne**, rattaché à sa structure, avec un ou plusieurs **responsables** par structure | Un membre qui part est simplement désactivé, chacun reçoit les notifications sur son téléphone, et on sait qui a fait quoi. |
| Arrivée des membres | **Invitation par email** envoyée par le responsable | Personne ne peut s'inscrire sans être invité par le responsable de sa structure. |
| Droits des membres | **Tout sauf gérer la structure** : publier, réserver, clôturer, annuler | Seuls les responsables gèrent les membres et modifient la fiche de la structure. |
| Lancement | Présenter d'abord un **Proof of Concept** aux structures | Un essai en conditions réelles ne sera peut-être pas possible tout de suite. |

## Règles de fonctionnement (proposées, à confirmer pendant la conception)
- **Créneau de récupération** : la structure qui réserve choisit une date et une heure avant la date limite. Le donateur indique ses disponibilités en texte libre dans l'annonce (« lun–ven 9h–17h »).
- **Annulation** : le donateur comme le réserveur peuvent annuler une réservation. L'annonce redevient alors disponible.
- **Clôture** : c'est le donateur qui clôture l'annonce une fois le stock récupéré.
- **« Stock récupéré ? »** : environ 3 h après le créneau, si le donateur n'a pas clôturé, l'app le lui demande (notification + question sur son accueil).
  - **Oui** → l'annonce est clôturée.
  - **Non** → elle redevient disponible (si la date limite n'est pas passée) et les structures abonnées sont prévenues de nouveau.
  - Sans réponse → un rappel 24 h plus tard, et l'annonce reste réservée tant que le donateur n'a pas répondu.
- **Expiration** : une annonce dont la date limite est passée disparaît toute seule des annonces disponibles.
- **Téléphone** : une fois l'annonce réservée, les deux structures voient le téléphone de la personne de l'autre côté (celle qui a publié ou réservé, ou celui de la structure si elle n'en a pas donné), pour se joindre le jour de la récupération. Les autres structures ne le voient jamais.
- **Accueil** : on arrive directement sur la liste des annonces, avec un encadré « À faire » en haut quand il y a une action en attente.
- **Modifier une annonce** : seulement tant qu'elle n'est pas réservée.
- **Messagerie** : une conversation **privée** par annonce et par structure intéressée, entre le donateur et cette structure (comme Le Bon Coin). Elle permet de poser des questions sans échanger de numéros.

## Fonctionnalités par priorité

### 🥇 MVP — à montrer en Proof of Concept
- Comptes sur invitation (admin → responsables → membres), espace admin pour créer les structures et gérer les catégories, page « Membres » pour les responsables.
- Profil de la structure : adresse (lieu de récupération par défaut), catégories suivies.
- Publier une annonce avec photos.
- Deux vues des annonces : une **liste** (style Le Bon Coin) et une **carte** du département.
- Réserver avec un créneau, annuler, clôturer, question « Stock récupéré ? ».

### 🥈 V1
- Messagerie liée à chaque annonce.
- Notifications : centre de notifications dans l'app, notifications web (iPhone et navigateurs), emails importants.
- App Android avec notifications natives.

### 🥉 Bonus
- Chiffres clés : « Mes chiffres » pour chaque structure, tableau de bord et export CSV pour l'admin.

### 🔮 Plus tard
- Alertes « Je recherche… » par mots-clés (ex. « je cherche des pommes de terre »).
- Annonces de **besoin** : une structure publie ce qu'elle cherche.
- Catégories non alimentaires (lessive, couches, textile…). Il suffira de les ajouter dans l'espace admin.
- App iOS native.
- Extension à d'autres départements.
- Nom de domaine perso.

## ❌ Écarté pour l'instant
- Inscription ouverte au public, ou d'un membre sans invitation.
- Un compte partagé par structure (remplacé par un compte par personne).
- Transactions d'argent.
- Réservation d'une partie seulement d'un stock.
- Totaux du département visibles par les structures.

## Pistes techniques
- **Modèle de données** (détaillé dans [conception/base-de-donnees.md](conception/base-de-donnees.md)) : `organizations` (structures), `users` (comptes Devise, rattachés à une structure, rôle responsable ou membre, `admin` pour moi), `categories`, `category_subscriptions`, `listings` (annonces ; quantité, unité et conservation facultatives), `reservations`, `conversations` + `messages`, `notifications`, appareils pour les notifications push.
- **Invitations** : gem `devise_invitable` (à valider). Elle demande d'envoyer des emails dès la Phase 1 (Brevo).
- **Statuts d'une annonce** : disponible → réservée → récupérée, ou expirée, ou retirée.
- **Géocodage** : API Adresse de l'IGN (`data.geopf.fr/geocodage`), gratuite et sans clé. L'ancienne `api-adresse.data.gouv.fr` est fermée depuis janvier 2026.
- **Hébergement gratuit** : Render s'endort après 15 min sans visite. Un service gratuit de type « cron » (cron-job.org ou une GitHub Action planifiée) appellera toutes les 10–15 min une adresse protégée, qui lance les vérifications (« stock récupéré ? », rappels) et garde l'app éveillée. On rediscutera d'une offre payante (~7 $/mois) avant le lancement si besoin.
- **Play Store** : 25 $ une seule fois. Un compte personnel doit d'abord faire 14 jours de test fermé avec 12 testeurs. Pour les premiers essais, on peut envoyer l'APK directement.
