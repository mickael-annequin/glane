# Parcours utilisateur et écrans — Glane (MVP)

## Vocabulaire
- **Structure** : toute organisation qui utilise Glane (association, foyer d'accueil, épicerie sociale, CCAS, entreprise du social…). On ne dit pas « association », car toutes n'en sont pas.
- **Membre** : une personne qui utilise Glane pour sa structure, bénévole ou salariée.

## Les rôles
**Les personnes** (chacune a son propre compte, rattaché à une structure) :
- **Admin** : moi. Je crée les structures et j'invite leur premier responsable. Je gère les catégories.
- **Responsable** : gère sa structure. Il invite les membres, peut nommer un autre responsable, désactive les comptes de ceux qui partent et modifie la fiche de la structure. Il fait aussi tout ce que fait un membre. Il peut y avoir **un ou plusieurs** responsables par structure.
- **Membre** : publie, réserve, clôture et annule au nom de sa structure.

**Les structures dans un échange** :
- **Donateur** : la structure qui publie un surplus.
- **Bénéficiaire** : la structure qui réserve et vient chercher le stock.

Une même structure est donatrice ou bénéficiaire selon les jours. Les annonces, les réservations et les chiffres appartiennent à la **structure**. On garde aussi la **personne** qui a publié ou réservé (« Marie — Restos du Cœur Dreux »).

Personne ne peut s'inscrire sans **invitation** : l'admin invite les responsables, et les responsables invitent leurs membres.

## Parcours

**A. Première connexion** (une fois par personne)
Je reçois un email d'invitation (envoyé par l'admin ou par le responsable de ma structure) → je touche le lien → je choisis mon nom, mon téléphone (facultatif) et mon mot de passe → je suis connecté (« Se souvenir de moi » coché) → accueil.
Mot de passe oublié : « Mot de passe oublié ? » sur la page de connexion → email avec un lien → nouveau mot de passe.

**B. Publier un surplus** (donateur)
Accueil → « ➕ Publier » → formulaire :
- **à remplir** : la catégorie, le produit et la date limite (« À récupérer avant le… », valable aussi pour le non-alimentaire) ;
- **déjà remplis** avec ceux de ma structure, et modifiables : le lieu de récupération et les disponibilités ;
- **facultatifs** : photos, quantité + unité, conservation, et un texte libre (« à garder au frais », « cartons à rapporter »…).

→ « Publier » → page de l'annonce, avec le message « Votre annonce est en ligne ».
Au plus court : une catégorie, un produit, une date, « Publier ».

**C. Trouver et réserver** (bénéficiaire)
Accueil (liste des annonces) → filtre par catégorie, ou bascule sur la carte → je touche une annonce → détail (photos, quantité, date limite, lieu, disponibilités du donateur, texte libre) → « Réserver » → je choisis le jour et l'heure de passage → « Confirmer » → l'annonce disparaît des annonces disponibles et apparaît dans « Mes échanges › Réservations », avec l'adresse, un bouton « Itinéraire » et le téléphone de la personne qui a publié.
Côté donateur, l'annonce passe en « Réservée par Restos du Cœur Dreux (Marie), mardi 14h » dans « Mes échanges › Dons », avec le téléphone de Marie.
Tous les membres des deux structures voient ces échanges, pas seulement les personnes qui les ont faits : n'importe quel membre peut prendre le relais.

**D. Récupération et clôture** (donateur)
Le bénéficiaire passe chercher le stock → un membre de la structure donatrice ouvre « Mes échanges › Dons » → l'annonce → « ✓ Stock récupéré » → l'annonce passe dans l'historique des deux structures.

**E. Le donateur a oublié de clôturer**
3 h après le créneau, un encadré « À faire » apparaît en haut de l'accueil de **tous les membres** de la structure donatrice : « Restos Dreux devait passer hier à 14h chercher « Pommes de terre ». Le stock est-il parti ? » (même encadré en haut de Mes échanges › Dons) → **« ✓ Oui, récupéré »** : l'annonce est clôturée. **« ✗ Non, remettre en ligne »** : l'annonce redevient disponible pour les autres structures, et la réservation est notée « non récupérée » (si la date limite est passée, le bouton dit « ✗ Non, pas récupéré » et l'annonce part dans l'historique). Le premier membre qui répond règle la question pour tout le monde.

**F. Annuler une réservation**
- Bénéficiaire : « Mes échanges › Réservations » → l'annonce → « Annuler ma réservation » → confirmation.
- Donateur : « Mes échanges › Dons » → l'annonce réservée → « Annuler la réservation » → confirmation.
- Dans les deux cas, l'annonce redevient disponible (si la date limite n'est pas passée).

**G. Modifier ou retirer une annonce** (donateur)
« Mes échanges › Dons » → l'annonce → « Modifier » ou « Retirer ». C'est possible **seulement tant qu'elle n'est pas réservée** : on ne change pas le stock sous les pieds de celui qui a réservé. Pour modifier une annonce réservée, il faut d'abord annuler la réservation.

**H. Gérer les membres** (responsable)
« Ma structure » → « 👥 Membres » → « + Inviter un membre » (son email) → il reçoit l'email d'invitation (parcours A).
Dans la liste, pour chaque membre :
- « Nommer responsable » (ou lui retirer ce rôle) ;
- « Désactiver » : il ne peut plus se connecter, mais ses annonces et réservations restent dans l'historique ;
- « Renvoyer l'invitation » si elle est encore en attente.
Il reste toujours au moins un responsable actif par structure.

**I. Gérer les structures** (admin)
Connexion → « Ma structure » → « ⚙️ Admin » → Structures → « + Nouvelle structure » (nom, adresse, email du premier responsable, et le téléphone en option) → le responsable reçoit l'invitation (parcours A). Il complète ensuite la fiche de sa structure (téléphone, disponibilités habituelles) et gère ses membres tout seul.
Je peux aussi modifier une structure, la désactiver (plus personne ne peut s'y connecter, mais l'historique reste) et nommer un nouveau responsable si besoin.
Catégories : ajouter, renommer, changer l'ordre, masquer. La catégorie « Autres » sert de fourre-tout : elle est toujours en dernier, et on ne peut pas la masquer.

## Écrans du MVP (12)
1. **Connexion** : page fournie par Devise, habillée aux couleurs de Glane. Elle n'a pas de lien « S'inscrire », mais a « Se souvenir de moi » coché et « Mot de passe oublié ? ».
2. **Accepter l'invitation** : « Bienvenue dans Glane, vous rejoignez [structure] ». On y saisit son nom, son téléphone (facultatif) et son mot de passe.
3. **Accueil = liste des annonces disponibles**
   - En haut, un encadré **« À faire »**, seulement s'il y a quelque chose à faire : « Stock récupéré ? », récupération prévue aujourd'hui, et pour les responsables « Complétez la fiche de votre structure » (tant que les disponibilités habituelles ne sont pas remplies).
   - Des filtres par catégorie (pastilles qui défilent) et une bascule **Liste | Carte**.
   - Des cartes façon Le Bon Coin : l'icône de la catégorie (jamais de photo dans la liste), produit, quantité + unité si elle est indiquée, ville et distance (« Dreux · 12 km »), date limite (« avant jeudi »), pastille ❄️ frais / surgelé.
   - Tri par défaut : la date limite la plus proche en premier (le plus urgent d'abord).
   - Les annonces de ma structure apparaissent aussi, avec un badge « Votre structure » (on ne peut pas les réserver).
4. **Carte des annonces** : carte Mapbox de l'Eure-et-Loir avec un repère par annonce. Toucher un repère affiche un résumé en bas de l'écran, et toucher le résumé ouvre le détail.
5. **Détail d'une annonce** :
   - Icône de la catégorie, produit, catégorie, date limite, puis la quantité et la conservation si elles sont indiquées. Ensuite : « Publié par Marie — Secours Populaire Chartres », adresse avec deux boutons, « Voir sur la carte » (la carte des annonces, centrée sur celle-ci) et « Itinéraire » (ouvre Google Maps ou Plans), puis les disponibilités, le texte libre, et les photos s'il y en a (on fait glisser).
   - Le bouton en bas dépend de la situation :
     - **« Réserver »** pour les autres structures ;
     - **« Modifier » / « Retirer »** si c'est une annonce de ma structure et qu'elle est disponible ;
     - **« ✓ Stock récupéré » / « Annuler la réservation »** si c'est une annonce de ma structure et qu'elle est réservée ;
     - **« Annuler ma réservation »** si c'est ma structure qui l'a réservée.
   - Une fois l'annonce réservée, les deux structures voient le téléphone de la personne de l'autre côté (ou celui de la structure si elle n'en a pas donné), avec un bouton « 📞 Appeler ». Les autres structures ne le voient jamais.
6. **Réserver : choix du créneau** (fenêtre qui s'ouvre sur le détail) : rappel des disponibilités du donateur, choix du jour (jusqu'à la date limite) et de l'heure, puis « Confirmer la réservation ».
7. **Formulaire d'annonce** : un seul écran pour publier et pour modifier.
   - En haut, les trois champs **à remplir** : catégorie, produit et date limite.
   - Puis les champs **facultatifs** : quantité + unité, conservation (ambiant / frais / surgelé).
   - Le lieu (adresse de la structure, ou « Autre adresse ») et les disponibilités sont déjà remplis et modifiables.
   - Enfin, une zone de **texte libre**, puis un champ discret « Photos (facultatif) ».
8. **Mes échanges** : deux onglets, **Dons** et **Réservations**, pour toute la structure.
   - Chaque onglet a une partie « En cours » (disponible, ou réservée avec le créneau) et une partie « Historique » (récupérée, non récupérée, expirée, retirée, annulée).
   - Chaque ligne indique qui a publié ou réservé. Toucher une ligne ouvre le détail de l'annonce.
9. **Ma structure** :
   - **Mon compte** : nom, email, téléphone (visible seulement par la structure avec qui on a une réservation en cours), changer de mot de passe, catégories que je suis (elles servent aux alertes de la Phase 4), « Se déconnecter ».
   - **Ma structure** : nom, adresse, téléphone, disponibilités habituelles. Seuls les responsables peuvent les modifier.
   - Liens « 👥 Membres » (responsables seulement) et « ⚙️ Admin » (admin seulement).
10. **Membres** (responsables seulement) : liste des membres (nom, rôle, « invitation en attente » / actif / désactivé), « + Inviter un membre », et pour chaque membre : nommer ou retirer responsable, désactiver, renvoyer l'invitation.
11. **Admin › Structures** : liste (nom, ville, nombre de membres, actif/désactivé) et formulaire de création (nom, adresse, email du premier responsable, téléphone en option) et de modification.
12. **Admin › Catégories** : liste dans l'ordre d'affichage, avec ajout, modification et masquage. « Autres » est toujours en dernier.

## Navigation
Une barre en bas de l'écran avec 4 onglets : 🌾 Annonces · ➕ Publier · 📦 Mes échanges · 🏠 Ma structure.
- « ➕ Publier » est au centre et mis en avant : c'est l'action la plus importante pour que l'app vive.
- Un badge sur « 📦 Mes échanges » signale qu'il y a quelque chose à faire (« Stock récupéré ? »).

## Après le MVP (pour garder de la place dans la navigation)
- **Phase 3 — Messagerie** : bouton « 💬 Poser une question » sur le détail d'une annonce, et un 5ᵉ onglet « 💬 Messages » (liste des conversations, puis la conversation). Les conversations appartiennent aux structures : tous les membres des deux structures les voient, et chaque message affiche le nom de son auteur.
- **Phase 4 — Notifications** : une cloche 🔔 en haut de l'écran (liste des notifications) et des réglages de notifications dans « Mon compte ». Chacun reçoit les notifications sur son propre téléphone. Ajout d'une page d'aide « Installer Glane sur iPhone ».
- **Phase 7 — Chiffres** : « Mes chiffres » (ceux de la structure) dans « Ma structure », et « Tableau de bord » dans l'espace admin.
