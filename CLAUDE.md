# Glane 🌾

## Le projet
Application **privée** pour les structures sociales d'Eure-et-Loir (associations, foyers d'accueil, épiceries sociales, CCAS…), qui leur permet de **partager leurs surplus de stock** : d'abord des denrées alimentaires, plus tard aussi du non-alimentaire (lessive, couches, textile…).
Le nom vient du glanage : ramasser ce qui reste après la moisson pour que rien ne soit perdu. C'est aussi un clin d'œil à la Beauce.

- **Principe** : une structure publie une annonce pour son surplus : produit, date limite, lieu et disponibilités, plus en option des photos, une quantité et un texte libre. Une autre la réserve en indiquant quand elle vient la chercher, et le donateur clôture l'annonce une fois le stock récupéré. Tout est **gratuit** : aucune transaction d'argent.
- **Comptes** : pas d'inscription ouverte, tout passe par **invitation**. L'admin (moi) crée les structures du territoire et invite leur premier **responsable**. Les responsables invitent ensuite leurs **membres** par email. Chaque personne a son propre compte, rattaché à sa structure. Les annonces, réservations et chiffres appartiennent à la structure.
- **Origine** : un besoin exprimé par des responsables de structures lors d'une réunion. On présente d'abord un Proof of Concept, avant un éventuel essai en conditions réelles.
- **Territoire** : l'Eure-et-Loir au départ. Ne rien figer dans le code, pour pouvoir s'étendre plus tard.
- **Interface** : en français. **Code** (variables, classes, commits) : en anglais.
- **Support** : un site web pensé d'abord pour le mobile (PWA), puis une **app Android** avec Capacitor. Les iPhone utilisent le site ajouté à l'écran d'accueil.
- **Budget** : gratuit (offres gratuites des services). On ne passe à un service payant que si c'est vraiment nécessaire, et après en avoir discuté.

Décisions détaillées : [docs/brainstorming.md](docs/brainstorming.md). Étapes : [docs/roadmap.md](docs/roadmap.md).

## Stack technique
| Besoin | Choix | Pourquoi |
|---|---|---|
| Framework | Ruby on Rails 8 | Enseigné au Wagon, déjà utilisé pour Gambade |
| Base de données | PostgreSQL | Enseigné au Wagon |
| Front | HTML/ERB, CSS (SCSS), Bootstrap | Enseigné au Wagon |
| JavaScript | Stimulus (+ Turbo) | Standard Rails / Wagon |
| Connexion | Devise (sans inscription) + invitations par email (`devise_invitable`) | Enseigné au Wagon |
| Droits d'accès | Pundit | Enseigné au Wagon |
| Carte | Mapbox GL JS (offre gratuite) | Enseigné au Wagon |
| Géocodage des adresses | API Adresse de l'IGN (`data.geopf.fr/geocodage`) | Gratuite, sans clé, adresses françaises |
| Photos des annonces | Active Storage + Cloudinary (offre gratuite) | Enseigné au Wagon |
| Messagerie en temps réel | Turbo Streams + Solid Cable | Intégré à Rails 8 |
| Notifications web (iPhone, navigateurs) | gem `web-push` + service worker | Gratuit, fonctionne sur iPhone depuis l'écran d'accueil |
| Notifications Android | Firebase Cloud Messaging + `@capacitor/push-notifications` + gem `action_push_native` | Gratuit |
| Emails | Brevo (offre gratuite) | Invitations, mot de passe oublié, événements importants |
| App mobile | Capacitor + Android Studio | Même méthode que Gambade |
| Hébergement | Render + Neon (offres gratuites, région Europe) | Même méthode que Gambade |

Les outils qui ne sont pas encore installés sont **à valider au moment de l'étape concernée**.

Environnement de dev : Windows + VS Code (extension WSL), avec **WSL2 Ubuntu 24.04** (utilisateur `mika`). Ruby (rbenv), Rails, PostgreSQL 16 et Node 24 LTS (nvm) sont déjà installés pour Gambade. Le projet est dans `~/code/mickael-annequin/glane`, et les commandes Rails se lancent dans le terminal Ubuntu.

## Structure des dossiers (Rails standard)
```
glane/
├── app/
│   ├── models/                  # Les données (structures, personnes, annonces, réservations…)
│   ├── controllers/             # La logique des pages
│   │   └── admin/               # L'espace admin (comptes des structures, catégories)
│   ├── policies/                # Les droits d'accès (Pundit)
│   ├── views/                   # Les pages HTML (ERB)
│   │   └── pwa/                 # Manifest et service worker de la PWA
│   ├── javascript/controllers/  # Contrôleurs Stimulus (carte, photos, notifications…)
│   └── assets/stylesheets/      # Le CSS
├── config/
│   ├── routes.rb                # Les URLs de l'app
│   └── credentials.yml.enc      # Clés API chiffrées (Mapbox, Cloudinary, Firebase…)
├── db/
│   ├── migrate/                 # Historique des modifications de la base
│   └── schema.rb                # Référence : état actuel de la base
├── docs/                        # Roadmap, décisions et conception
├── test/                        # Les tests
└── mobile/                      # Projet Capacitor (app Android)
```
- **Ne jamais mettre de clé API en dur dans le code** : toujours passer par `config/credentials.yml.enc` (ou un `.env` ignoré par Git).
- Pour connaître la structure de la base, se référer à `db/schema.rb` (généré automatiquement, ne pas le modifier à la main).

## Conventions de code
- Conventions Rails : modèles au singulier (`Listing`), tables et contrôleurs au pluriel (`listings`, `ListingsController`), routes REST (`resources`).
- Vocabulaire de l'interface : dire **« structure »** et jamais « association » (il y a aussi des foyers, des CCAS, des entreprises du social…), et **« membre »** et jamais « bénévole » (il y a aussi des salariés).
- Vocabulaire du code : une structure = `Organization`, une personne = `User` (rôle `manager` = responsable, ou `member` = membre), une annonce = `Listing`, une réservation = `Reservation`.
- Ruby : 2 espaces d'indentation, `snake_case` pour les méthodes et variables, `CamelCase` pour les classes.
- JavaScript : `camelCase`, un contrôleur Stimulus par fonctionnalité.
- CSS : un fichier par composant dans `stylesheets/components/`, comme au Wagon.
- Noms dans le code en anglais, textes affichés en français.
- Code simple et lisible avant tout : pas d'abstraction prématurée. Commenter seulement ce qui n'est pas évident.
- Git : petits commits fréquents, messages courts en anglais au présent (ex. `Add listing reservation`).
- Ne jamais committer de secrets (mots de passe, clés API) : voir la règle sur les credentials plus haut.

## Règles de travail avec Claude
- **Toujours répondre en français.**
- Je suis débutant (Prepwork du Wagon fait, bootcamp en cours) : expliquer simplement ce que tu fais et pourquoi, sans jargon inutile.
- Je construis en « vibe coding », mais je veux apprendre au passage : explique les notions nouvelles quand elles apparaissent.
- Avancer **par petites étapes**, une chose à la fois.
- **Demander mon accord avant** : toute grosse modification, l'ajout d'une dépendance (gem, package npm) et toute commande qui installe quelque chose.
- Privilégier les technologies du Wagon (HTML/CSS, JavaScript, Rails, PostgreSQL). Si une autre est vraiment plus adaptée, expliquer pourquoi avant de la proposer.
- À la fin de chaque étape : dire **comment tester le résultat moi-même** (commande à lancer, page à ouvrir, ce que je dois voir).
- Je suis sur Windows avec VS Code : donner les commandes adaptées (terminal Ubuntu/WSL pour Rails).
- Les commandes avec `sudo` (mot de passe), c'est moi qui les lance ; Claude vérifie le résultat ensuite.
- Dans un bloc de commandes à copier-coller, ne jamais mettre de ligne après `exec bash` (elle serait perdue) : `exec bash` seul, dans son propre bloc.
