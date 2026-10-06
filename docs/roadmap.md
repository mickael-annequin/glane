# Roadmap — Glane 🌾

On coche chaque étape (`- [x]`) quand elle est terminée et testée.
Le détail des décisions est dans [brainstorming.md](brainstorming.md).

## Phase 0 — Conception ✏️
> Cette phase se fait **sans code** : on travaille sur papier et dans `docs/`.

- [x] **Documents de départ** : `CLAUDE.md`, [brainstorming.md](brainstorming.md) et cette roadmap.
- [x] **Parcours utilisateur et liste des écrans** ([conception/parcours.md](conception/parcours.md)) pour les 3 rôles : donateur, bénéficiaire, admin. *Test :* je peux raconter une annonce de sa publication à sa clôture, écran par écran.
- [x] **Wireframes de chaque écran du MVP** ([conception/wireframes.md](conception/wireframes.md)). *Test :* chaque écran de la liste a son wireframe.
- [x] **Identité visuelle** ([conception/identite.md](conception/identite.md)) : ambiance « Moisson » (brun glaise, blé mûr, coquelicot), polices Fraunces + Source Sans 3, logo épi ([aperçu](conception/identite-apercu.html)). *Test :* une palette, une police et un logo notés dans `docs/`.
- [x] **Schéma de la base de données** ([conception/base-de-donnees.md](conception/base-de-donnees.md)). *Test :* chaque info affichée dans les wireframes a sa place dans le schéma.
- [x] **Catégories et unités** : on part d'une liste provisoire (catégories de l'[écran 12](conception/wireframes.md), unités du [schéma](conception/base-de-donnees.md)), sans validation par les structures. On en reparlera plus tard.

## Phase 1 — Socle 🧱
- [x] **Créer le projet** : `rails new glane` avec PostgreSQL et Bootstrap, puis Git et GitHub. *Test :* une page d'accueil s'affiche sur `localhost:3000`.
- [ ] **Mise en ligne** sur Render (appli) + Neon (base PostgreSQL), offres gratuites, région Europe. *Test :* le site s'ouvre en HTTPS sur mon téléphone.
- [ ] **Comptes et connexion** : Devise sur `User` (une personne), rattaché à une `Organization`, avec le rôle responsable ou membre. Inscription désactivée, « Se souvenir de moi ». *Test :* impossible de créer un compte soi-même, et on reste connecté après avoir fermé le navigateur.
- [ ] **Emails** via Brevo (offre gratuite) : invitations et mot de passe oublié. *Test :* un email de mot de passe oublié arrive, et son lien fonctionne.
- [ ] **Espace admin** (`admin/`) : créer, modifier et désactiver une structure, inviter son premier responsable, gérer les catégories. *Test :* créer une structure, le responsable reçoit l'invitation, choisit son mot de passe et se connecte.
- [ ] **Membres** (responsables seulement) : inviter par email, nommer ou retirer un responsable, désactiver un compte, renvoyer une invitation. *Test :* inviter un membre qui se connecte, puis le désactiver : il ne peut plus se connecter, et la structure garde au moins un responsable.
- [ ] **Ma structure** : fiche de la structure (adresse géocodée par l'IGN, modifiable par les responsables) et « Mon compte » (nom, téléphone, mot de passe, catégories suivies). *Test :* l'adresse donne le bon point sur une carte, et un membre ne peut pas modifier la fiche.
- [ ] **Données de test** (`seeds`) : 4 structures fictives (Chartres, Dreux, Châteaudun, Nogent-le-Rotrou), chacune avec un responsable et un membre. *Test :* je peux me connecter avec chaque compte.

## Phase 2 — MVP : annonces et réservations 🥇
- [ ] **Publier, modifier et retirer une annonce.** Seuls la catégorie, le produit et la date limite sont à remplir : le lieu et les disponibilités sont déjà remplis, et le reste est facultatif (quantité + unité, conservation, texte libre). *Test :* publier une annonce avec seulement la catégorie, le produit et la date limite, puis une autre avec tous les champs.
- [ ] **Photos d'annonce** : jusqu'à 5, depuis l'appareil photo ou la galerie, avec aperçu avant l'envoi et suppression possible. Elles sont stockées sur Cloudinary et affichées en miniature dans la liste et en galerie sur la page détail. *Test :* prendre 2 photos avec le téléphone, en supprimer une, et retrouver la bonne dans la liste.
- [ ] **Liste des annonces disponibles** (cartes façon Le Bon Coin avec la première photo, date limite la plus proche en premier, filtre par catégorie) et page détail. *Test :* une annonce expirée ou réservée n'apparaît plus.
- [ ] **Carte Mapbox du département** avec les annonces, et bascule Liste ⇄ Carte. *Test :* toucher un repère ouvre l'annonce.
- [ ] **Réserver** en choisissant un créneau. L'annonce est attribuée et disparaît. *Test :* avec 2 comptes sur 2 téléphones, la seconde structure ne peut plus réserver.
- [ ] **« Mes dons » et « Mes réservations »**, annulation d'un côté comme de l'autre. *Test :* une annonce annulée redevient disponible.
- [ ] **Clôture par le donateur** (« Stock récupéré »). *Test :* l'annonce passe dans l'historique des deux structures.
- [ ] **Question « Stock récupéré ? »** sur l'accueil après le créneau, avec Oui / Non. *Test :* répondre Non remet l'annonce en ligne.
- [ ] **Droits d'accès** avec Pundit, et tests des changements de statut. *Test :* `bin/rails test` passe, et une structure ne peut pas modifier l'annonce d'une autre. 🎉 **MVP utilisable**

## Jalon — Présentation du Proof of Concept 🎤
> On ne pourra peut-être pas faire un essai en conditions réelles tout de suite. On commence donc par **montrer** l'app aux responsables de structures, pour la valider et récolter leurs idées avant d'aller plus loin.

- [ ] **Revoir les catégories et les unités** avant de préparer la démo. Les catégories se changent depuis l'espace admin, sans toucher au code ; les unités sont dans le code (une petite modification suffit). *Test :* la liste me convient pour la démo.
- [ ] **Données de démonstration réalistes** : structures fictives du département, annonces variées avec photos (légumes, produits laitiers, épicerie…), quelques réservations et clôtures.
- [ ] **Logo définitif** (idée : un panier, à partir d'un SVG d'inspiration que je fournirai), si possible avant la présentation. *Test :* il reste lisible à la taille d'une icône d'app.
- [ ] **Scénario de démo en 5 minutes** sur 2 téléphones : une structure publie avec photo, l'autre la voit sur la carte, réserve et choisit un créneau, puis le donateur clôture. *Test :* le scénario se déroule de bout en bout sans accroc, sur l'URL en ligne.
- [ ] **Présentation aux structures**, et prise de notes de leurs retours dans `retours-poc.md`. On réajuste ensuite l'ordre des phases 3 à 7 selon ce qui compte le plus pour elles.

## Phase 3 — Messagerie 💬
- [ ] **Conversation privée par annonce**, en temps réel (Turbo Streams), avec un badge pour les messages non lus. *Test :* 2 téléphones échangent sans recharger la page, et une 3ᵉ structure ne voit pas la conversation.

## Phase 4 — Notifications 🔔
- [ ] **Centre de notifications** dans l'app (cloche + badge) pour : nouvelle annonce dans une catégorie suivie, stock réservé, nouveau message, réservation annulée, « stock récupéré ? », stock de nouveau disponible. *Test :* chaque événement crée la bonne notification pour la bonne structure.
- [ ] **Réglages** (par personne) : catégories suivies, notifications activées ou non. *Test :* aucune alerte pour une catégorie non cochée.
- [ ] **PWA installable + notifications web** (VAPID), et page d'aide « Installer Glane sur iPhone ». *Test :* une notification reçue sur un iPhone (site sur l'écran d'accueil) et sur Chrome Android.
- [ ] **Tâche périodique** via un service « cron » externe : question « récupéré ? », rappel 24 h, rappel du créneau la veille. *Test :* un créneau passé déclenche la question, même si l'app dormait.
- [ ] **Emails pour les événements importants** (« votre stock a été réservé »…), pour ceux qui n'ont pas installé l'app. *Test :* l'email arrive à tous les membres concernés.

## Phase 5 — App Android 📱
> L'app Android est une « coquille » qui affiche le site en ligne, comme pour Gambade : je continue à ne modifier que l'app Rails.

- [ ] **Coquille Capacitor** dans `mobile/` qui charge le site en ligne. On reprend la config et `sync-android.sh` de Gambade. *Test :* l'APK s'installe et Glane s'ouvre comme une app.
- [ ] **Notifications natives** : projet Firebase, plugin `@capacitor/push-notifications`, gem `action_push_native`. Le JS choisit Firebase dans l'app Android et les notifications web ailleurs. *Test :* une notification reçue app fermée.
- [ ] **Toucher une notification ouvre la bonne page** (annonce, conversation). *Test :* sur chaque type de notification.
- [ ] **Photos depuis l'app Android** : le bouton photo ouvre bien l'appareil photo et la galerie. *Test :* publier une annonce avec photo depuis l'APK.
- [ ] **Distribution** : APK envoyé directement pour les premiers essais. Pour tout le monde, Play Store (25 $ une fois ; un compte personnel doit d'abord faire 14 jours de test fermé avec 12 testeurs volontaires : structures, proches). Revérifier les règles Android à ce moment-là.

## Phase 6 — Lancement 🚀
- [ ] **Essai en conditions réelles**, si c'est possible, avec 2 ou 3 structures volontaires, puis des corrections à partir de leurs retours.
- [ ] **Mentions légales, politique de confidentialité** (RGPD) et guide d'utilisation d'une page.
- [ ] **Création de toutes les structures** et invitation de leurs responsables, puis décision sur l'hébergement (gratuit ou payant).

## Phase 7 — Chiffres clés 📊 (bonus)
- [ ] **« Mes chiffres »** pour chaque structure, qui ne voit que les siens : nombre de dons faits et de stocks récupérés, quantités **par unité** (quand elles sont indiquées) et par catégorie, évolution par mois (Chart.js, comme Gambade). *Test :* une structure ne voit que ses propres chiffres, et ils correspondent à ses annonces clôturées.
- [ ] **Tableau de bord admin uniquement** : totaux du département, détail donné/reçu par structure, évolution par mois, export CSV. *Test :* la page est inaccessible à un compte non admin.

## Plus tard 🔮
- Alertes « Je recherche… » par mots-clés
- Annonces de besoin (une structure publie ce qu'elle cherche)
- Catégories non alimentaires
- App iOS native
- Autres départements
- Nom de domaine perso
