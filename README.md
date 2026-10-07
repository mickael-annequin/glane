# Glane 🌾

Application privée qui permet aux structures sociales d'Eure-et-Loir de partager leurs surplus de stock. Elle est gratuite, et l'accès se fait uniquement sur invitation.

- **En ligne** : https://glane-3vyb.onrender.com (offre gratuite de Render : le site s'endort après 15 min sans visite, et le premier chargement prend alors environ 50 s).
- **Où on en est, et la suite** : [docs/roadmap.md](docs/roadmap.md) (encadré « 📍 Où on en est » en haut).
- **Les décisions** : [docs/brainstorming.md](docs/brainstorming.md). **La conception** (parcours, wireframes, identité, base de données) : [docs/conception/](docs/conception/).
- **Les règles de travail avec Claude** : [CLAUDE.md](CLAUDE.md).

## Relancer le projet sur l'ordi
Dans le terminal Ubuntu (WSL), depuis `~/code/mickael-annequin/glane` :

```bash
git pull
bundle install
bin/rails db:prepare
bin/dev
```

Ouvrir ensuite http://localhost:3000. `bin/dev` lance le serveur et la compilation du CSS ; `Ctrl + C` pour l'arrêter.

- **Clé Mapbox** : la carte a besoin du fichier `.env` (ignoré par Git), qui contient la ligne `MAPBOX_API_KEY=…`. Sans lui, la carte affiche « clé Mapbox manquante ».
- **Clé maître** : `config/master.key` (ignorée par Git) ouvre `config/credentials.yml.enc`. Il faut la garder en lieu sûr : elle est aussi dans Render (`RAILS_MASTER_KEY`).

## Comptes de test (sur l'ordi seulement)
Créés par `bin/rails db:seed`, avec le mot de passe `password` :

| Compte | Rôle |
|---|---|
| `admin@glane.test` | admin (espace admin : structures et catégories) |
| `chartres.responsable@glane.test`, `chartres.membre@glane.test` | Chartres : planning du lundi au vendredi, 9h–12h et 14h–17h |
| `dreux.responsable@glane.test`, `dreux.membre@glane.test` | Dreux : mardi et jeudi, 10h–16h |
| `chateaudun.responsable@glane.test`, `chateaudun.membre@glane.test` | Châteaudun : mercredi, 14h–17h |
| `nogent.responsable@glane.test`, `nogent.membre@glane.test` | Nogent-le-Rotrou : planning vide (pour voir l'encadré « À faire ») |

Ces comptes sont rappelés sur la page de connexion locale (bandeau « Version locale »). Mon vrai email ne marche qu'en ligne, pas sur l'ordi.

Pour repartir d'une base propre : `bin/rails db:reset` (efface toutes les données locales et recrée celles de test).

## Données de démonstration (pour présenter Glane)
Le fichier `db/seeds/demo.rb` crée 6 structures fictives dans de vraies villes du département, avec 19 annonces : 12 disponibles, 3 réservées et 4 récupérées (l'historique). Il ne se lance que si la variable `DEMO_PASSWORD` existe. À chaque fois, il efface la démo précédente (avec ce qui a été créé pendant une présentation) et la recrée, avec des dates comptées à partir du jour même.

- **En ligne** : avec `DEMO_PASSWORD` dans Render, chaque mise en ligne recrée la démo. La veille d'une présentation : « Manual Deploy » › « Deploy latest commit » pour avoir des dates fraîches. Avant un vrai essai : retirer la variable et effacer la démo.
- **Sur l'ordi** : `DEMO_PASSWORD=demo1234 bin/rails db:seed`.

| Compte (mot de passe : `DEMO_PASSWORD`) | Structure |
|---|---|
| `chartres@demo.test` (responsable), `chartres.membre@demo.test` | Épicerie solidaire Le Grenier, Chartres : 1er téléphone de la démo (donateur). Sa question « Le stock est-il parti ? » attend dans l'encadré « À faire » |
| `dreux@demo.test` | Foyer d'hébergement Les Tilleuls, Dreux : 2e téléphone (réserve) |
| `chateaudun@demo.test`, `nogent@demo.test`, `luce@demo.test`, `bonneval@demo.test` | Les autres structures |

## Tests et vérifications
Les mêmes vérifications que la CI de GitHub, à lancer avant d'envoyer :

```bash
bin/rails db:test:prepare test
bin/rails test:system   # le parcours complet dans Chrome (sans fenêtre)
bin/rubocop
bin/brakeman --no-pager
bin/bundler-audit
bin/importmap audit
```

La CI (onglet « Actions » du dépôt GitHub) relance tout ça à chaque `git push`.

## Mise en ligne
Chaque `git push` sur `main` redéploie le site automatiquement sur Render (script `bin/render-build.sh` : assets, migrations et seed de l'admin). La base de données de production est sur Neon.

Variables d'environnement à remplir dans Render (onglet « Environment »), jamais dans le code :

| Variable | À quoi elle sert |
|---|---|
| `DATABASE_URL` | la base Neon (adresse directe, sans `-pooler`) |
| `RAILS_MASTER_KEY` | le contenu de `config/master.key` (`cat config/master.key; echo` pour la copier sans rien coller en trop) |
| `ADMIN_EMAIL`, `ADMIN_PASSWORD`, `ADMIN_NAME` | le compte admin, créé au premier déploiement seulement |
| `SMTP_USERNAME`, `SMTP_PASSWORD`, `MAIL_FROM` | les emails via Brevo (port 2525). La clé SMTP expire le 06/10/2027, ou après 90 jours sans envoi |
| `CLOUDINARY_URL` | les photos des annonces (compte de Gambade pour le Proof of Concept, dossier `glane/`) |
| `MAPBOX_API_KEY` | la carte |
| `APP_HOST` | facultatif : l'adresse du site dans les liens des emails |
| `DEMO_PASSWORD` | facultatif : crée les données de démonstration (voir plus haut), avec ce mot de passe (6 caractères au moins) |

## Technique
Rails 8.1 · Ruby 3.4 · PostgreSQL · Devise + devise_invitable · Stimulus/Turbo · Bootstrap 5 (SCSS) · Mapbox GL JS · Active Storage + Cloudinary · API Adresse de l'IGN pour les adresses. Le détail est dans [CLAUDE.md](CLAUDE.md).
