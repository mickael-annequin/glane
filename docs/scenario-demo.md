# Scénario de démo — Glane en 5 minutes

Deux téléphones, deux structures : on suit **une annonce de sa publication à sa clôture**, sur le site en ligne (https://glane-3vyb.onrender.com).

| | Téléphone 1 : le **donateur** | Téléphone 2 : le **bénéficiaire** |
|---|---|---|
| Compte | `chartres@demo.test` | `dreux@demo.test` |
| Structure | Épicerie solidaire Le Grenier, Chartres (Claire Moulin) | Foyer d'hébergement Les Tilleuls, Dreux (Samir Haddad) |
| Mot de passe | celui de `DEMO_PASSWORD` dans Render | le même |

## À préparer

**La veille**
- [ ] Dans Render : « Manual Deploy » › « Deploy latest commit ». La démo est recréée avec des dates fraîches, et ce qui a été publié pendant une répétition disparaît.
- [ ] Une répétition complète du scénario ci-dessous, puis un nouveau « Manual Deploy » pour tout remettre à neuf.
- [ ] Charger les deux téléphones.

**10 minutes avant**
- [ ] Ouvrir le site sur un téléphone : l'offre gratuite de Render **endort le site** après 15 minutes sans visite, et le réveil prend environ 50 secondes. Il faut le réveiller avant de commencer, puis ne pas le laisser dormir.
- [ ] Se connecter sur les deux téléphones (« Se souvenir de moi » coché), et laisser chacun sur l'accueil.
- [ ] Vérifier le réseau (Wi-Fi de la salle, ou partage de connexion).
- [ ] Si possible, projeter l'écran d'un téléphone, ou faire passer les téléphones.

## Le déroulé

### 1. Le constat (30 s), sans téléphone
« Vous l'avez dit à la réunion : certaines structures ont des surplus qui finissent à la poubelle, pendant que d'autres manquent de tout, à quelques kilomètres. Glane, c'est un outil pour se passer ces surplus entre structures du département. Gratuit, et privé : on n'y entre que sur invitation. Chaque structure a un responsable, qui invite ensuite ses membres. »

### 2. Ce qu'on voit en arrivant (45 s), téléphone 1 (Chartres)
- **L'accueil** : les annonces des autres structures, la date limite la plus proche en premier. Sur chaque annonce : l'icône de la catégorie, le **nom de la structure** qui donne (on se connaît : on sait tout de suite où aller et qui appeler), la ville et la distance.
- **L'encadré « À faire »** (15 s) : « Le stock est-il parti ? » pour les Brioches. « Si on oublie de clôturer, Glane pose la question 3 h après le créneau de passage. Si personne n'est venu, on répond Non, et l'annonce est de nouveau proposée aux autres. » Répondre « Oui » : l'annonce part dans l'historique.
- **Liste ⇄ Carte** : toucher « Carte », montrer les repères dans le département, puis revenir à la liste.

### 3. Publier un surplus (1 min), téléphone 1 (Chartres)
- Toucher **➕ Publier**.
- Catégorie **Fruits et légumes**, produit **Potimarrons**, à récupérer avant **dans 3 jours**.
- Le dire : « Seules ces 3 informations sont obligatoires. Le lieu et les horaires sont déjà remplis avec ceux de la structure. »
- Facultatif : quantité **2 cagettes**. On peut aussi prendre une photo en direct (📷), ce qui montre que c'est possible, mais rarement utile.
- Toucher **Publier** → « Votre annonce est en ligne. »

### 4. Réserver (1 min), téléphone 2 (Dreux)
- Rafraîchir l'accueil : les **Potimarrons** apparaissent, avec « Épicerie solidaire Le Grenier », « Chartres » et la distance.
- Toucher l'annonce → **Réserver**.
- Choisir **un jour** et **une heure** : Glane ne propose que les horaires d'ouverture du donateur (ici, du lundi au vendredi, 9h–12h et 14h–17h).
- **Confirmer la réservation** → « C'est réservé ! ». L'annonce disparaît de la liste des autres structures : personne d'autre ne peut la réserver.
- Montrer le **téléphone du donateur** sur la page de l'annonce, pour s'appeler en cas de besoin.

### 5. Côté donateur (45 s), téléphone 1 (Chartres)
- Toucher **📦 Mes échanges** › **Dons** : les Potimarrons sont « Réservée par Foyer d'hébergement Les Tilleuls », avec le jour et l'heure du passage.
- Le dire : « Bientôt, une notification arrivera sur le téléphone à ce moment-là. »
- Ouvrir l'annonce → **✓ Stock récupéré** (le jour J, une fois le stock parti) → « Oui » → elle passe dans l'**historique** des deux structures.

### 6. La suite, et vos avis (1 min)
- Ce qui arrive ensuite : la **messagerie** entre structures, les **notifications** sur le téléphone, l'**app Android**, puis le non-alimentaire (hygiène, bébé… déjà visibles dans les catégories).
- Les questions à leur poser (réponses à noter dans `docs/retours-poc.md`) :
  - Les **catégories** et les **unités** vous parlent-elles ? Que manque-t-il ?
  - Qui publierait et qui réserverait dans votre structure ? Plutôt des salariés, des membres bénévoles ?
  - Qu'est-ce qui vous **empêcherait** de l'utiliser ?
  - Seriez-vous partants pour un **essai en conditions réelles** ?

## Les questions qu'on risque de me poser
On n'en parle pas pendant la démo pour rester sous 5 minutes, mais il faut avoir la réponse :
- **« Qui a accès ? Comment on entre ? »** Seulement sur invitation : l'admin crée la structure et invite son responsable par email, puis le responsable invite ses membres (salariés ou bénévoles) depuis « Ma structure › Membres ». Si quelqu'un part, le responsable désactive son compte. Montrable en 20 s sur le téléphone 1 : 🏠 Ma structure › Membres.
- **« Combien ça coûte ? »** Rien : Glane est gratuit, et il n'y a jamais d'argent entre structures.
- **« Et si la structure ne vient pas ? »** Le donateur peut annuler la réservation, et Glane lui demande 3 h après le créneau si le stock est parti : répondre « Non » remet l'annonce en ligne.
- **« Il faut installer une application ? »** Non, pour l'instant c'est un site, à ajouter sur l'écran d'accueil du téléphone. Une app Android viendra ensuite.
- **« Et le non-alimentaire ? »** C'est prévu : les catégories Hygiène, entretien et Bébé existent déjà.

## Si quelque chose ne va pas
- **La page tourne longtemps** : le site se réveille (50 s environ). En profiter pour parler du constat.
- **Plus de réseau** : continuer à l'oral, et montrer les captures d'écran du téléphone, prises pendant la répétition.
- **Une mauvaise manipulation** (mauvaise annonce réservée…) : « Annuler ma réservation » remet l'annonce en ligne. Tout est recréé au prochain « Manual Deploy ».
