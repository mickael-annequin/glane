# Wireframes — Glane (MVP)

Croquis simples : seulement l'organisation des éléments, sans couleurs ni design.
La liste des écrans et les parcours sont dans [parcours.md](parcours.md).

**Légende**
- `[ Bouton ]` : bouton ou lien. Les gros boutons encadrés sont les actions principales, en bas de l'écran, sous le pouce.
- `( Pastille )` : choix à toucher (filtres, conservation, jour).
- `*` : champ obligatoire.
- Barre d'onglets en bas : 🌾 Annonces · ➕ Publier · 📦 Mes échanges · 🏠 Ma structure.
- Sur les écrans de détail et les formulaires, la barre d'onglets est masquée et une flèche **←** permet de revenir.

## Écran 1 : Connexion
```
┌───────────────────────────────┐
│                               │
│          [logo épi]           │
│             Glane             │
│    Partageons nos surplus     │
│   pour que rien ne se perde   │
│                               │
│ Email                         │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ Mot de passe                  │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ [x] Se souvenir de moi        │
│                               │
│ ┌───────────────────────────┐ │
│ │       SE CONNECTER        │ │
│ └───────────────────────────┘ │
│     Mot de passe oublié ?     │
│                               │
│ Pas de compte ? Demandez au   │  ← pas de lien « S'inscrire »
│ responsable de votre          │
│ structure.                    │
└───────────────────────────────┘
```

## Écran 2 : Accepter l'invitation
On arrive ici en touchant le lien de l'email d'invitation.
```
┌───────────────────────────────┐
│         [logo] Glane          │
│                               │
│ Bienvenue !                   │
│ Vous rejoignez                │
│ Secours Populaire Chartres    │
│ (invité par Paul Martin)      │
│                               │
│ Prénom et nom                 │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ Téléphone (facultatif)        │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ Visible seulement par la      │  ← rassure sur l'usage
│  structure avec qui vous avez │    du numéro
│  un échange en cours.         │
│ Mot de passe                  │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │      REJOINDRE GLANE      │ │
│ └───────────────────────────┘ │
└───────────────────────────────┘
```

## Écran 3 : Accueil = liste des annonces
```
┌───────────────────────────────┐
│ Glane         Secours Pop. 28 │  ← nom de ma structure
│ ┌───────────────────────────┐ │  ← seulement s'il y a
│ │ À FAIRE                   │ │    quelque chose à faire
│ │ Restos Dreux devait passer│ │
│ │ hier à 14h. Les pommes de │ │
│ │ terre sont-elles parties ?│ │
│ │ [✓ Oui, récupérées]       │ │  ← Oui : l'annonce est close
│ │ [✗ Non, remettre en ligne]│ │  ← Non : elle redevient
│ └───────────────────────────┘ │    disponible pour les autres
│ (Tout)(Légumes)(Laitier)(…)   │  ← défile sur le côté
│       [ Liste | Carte ]       │
│ ┌───────────────────────────┐ │
│ │ ┌─────┐ Yaourts nature    │ │
│ │ │photo│ 40 pièces · Frais │ │  ← les plus urgents
│ │ └─────┘ Chartres · 3 km   │ │    en premier
│ │         avant demain      │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ ┌─────┐ Carottes          │ │
│ │ │photo│ 25 kg             │ │  ← quantité seulement
│ │ └─────┘ Dreux · 12 km     │ │    si elle est indiquée
│ │         avant jeudi       │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ ┌─────┐ Lessive           │ │  ← sans photo : icône
│ │ │icône│ Votre structure   │ │    de la catégorie ;
│ │ └─────┘ Chartres · 0 km   │ │    pas réservable
│ │         avant le 30/11    │ │
│ └───────────────────────────┘ │
├───────────────────────────────┤
│   🌾      ➕      📦      🏠  │
└───────────────────────────────┘
```

## Écran 4 : Carte des annonces
Même en-tête et mêmes filtres que la liste : on bascule de l'une à l'autre sans perdre ses filtres.
```
┌───────────────────────────────┐
│ Glane         Secours Pop. 28 │
│ (Tout)(Légumes)(Laitier)(…)   │
│       [ Liste | Carte ]       │
│ ┌───────────────────────────┐ │
│ │       Dreux               │ │
│ │         ●                 │ │  ← un repère par annonce
│ │                   Chartres│ │
│ │               ●  ●        │ │  ← Eure-et-Loir entier
│ │   Nogent                  │ │
│ │     ●          Châteaudun │ │
│ │                    ●      │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │  ← apparaît quand on
│ │ ┌─────┐ Carottes · 25 kg  │ │    touche un repère
│ │ │photo│ Dreux · av. jeudi │ │
│ │ └─────┘           [Voir →]│ │
│ └───────────────────────────┘ │
├───────────────────────────────┤
│   🌾      ➕      📦      🏠  │
└───────────────────────────────┘
```

## Écran 5 : Détail d'une annonce
Vue d'une autre structure, quand l'annonce est disponible :
```
┌───────────────────────────────┐
│ ←                             │  ← barre d'onglets masquée
│ ┌───────────────────────────┐ │
│ │                           │ │
│ │           photo           │ │  ← on fait glisser
│ │                           │ │
│ └───────────────────────────┘ │
│             ● ○ ○             │
│ Carottes                      │
│ Fruits et légumes             │
│ À récupérer avant jeudi 9/10  │
│ 25 kg · Frais                 │  ← seulement si indiqués
│ ───────────────────────────── │
│ Publié par Marie              │
│ Restos du Cœur Dreux · 12 km  │
│ 12 rue …, Dreux               │
│ [ Voir sur la carte ]         │  ← carte centrée sur l'annonce
│ [ Itinéraire ]                │  ← ouvre Google Maps ou Plans
│ Disponibilités :              │
│ lun–ven 9h–17h                │
│ « Cagettes à rapporter »      │  ← texte libre
│ ┌───────────────────────────┐ │
│ │         RÉSERVER          │ │  ← change selon la
│ └───────────────────────────┘ │    situation (voir plus bas)
└───────────────────────────────┘
```

Le bas de l'écran change selon la situation.

**Ma structure a réservé l'annonce :**
```
┌───────────────────────────────┐
│ …                             │
│ ┌───────────────────────────┐ │
│ │ ✓ Réservée par votre      │ │
│ │   structure (Paul)        │ │
│ │ Passage : mardi 14h       │ │
│ │ Contact : Marie           │ │  ← le téléphone n'est
│ │ 06 12 34 56 78            │ │    visible qu'à partir
│ │ [Appeler]   [Itinéraire]  │ │    de la réservation
│ └───────────────────────────┘ │
│    Annuler ma réservation     │
└───────────────────────────────┘
```

**C'est une annonce de ma structure, et elle est réservée :**
```
┌───────────────────────────────┐
│ …                             │
│ ┌───────────────────────────┐ │
│ │ Réservée par Épicerie     │ │
│ │ sociale Anet (Julie)      │ │
│ │ Passage : mardi 14h       │ │
│ │ [Appeler Julie]           │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │     ✓ STOCK RÉCUPÉRÉ      │ │
│ └───────────────────────────┘ │
│    Annuler la réservation     │
└───────────────────────────────┘
```

**C'est une annonce de ma structure, et elle est disponible :**
```
┌───────────────────────────────┐
│ …                             │
│ ┌───────────────────────────┐ │
│ │ Votre annonce est en ligne│ │
│ └───────────────────────────┘ │
│ [ Modifier ]    [ Retirer ]   │  ← seulement tant qu'elle
│                               │    n'est pas réservée
└───────────────────────────────┘
```

## Écran 6 : Réserver (choix du créneau)
```
┌───────────────────────────────┐
│ (détail de l'annonce, grisé)  │
│                               │
├───────────────────────────────┤
│ Quand passez-vous ?        ✕  │  ← fenêtre qui monte
│                               │    du bas de l'écran
│ Disponibilités du donateur :  │
│ lun–ven 9h–17h                │
│                               │
│ Jour                          │
│ (Auj.)(Demain)(Mer 8)(Jeu 9)  │  ← jusqu'à la date limite
│ Heure                         │
│ ┌───────────────────────────┐ │
│ │ 14:00                   ▾ │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ CONFIRMER LA RÉSERVATION  │ │
│ └───────────────────────────┘ │
└───────────────────────────────┘
```

## Écran 7 : Formulaire d'annonce
Le même écran sert à publier et à modifier. Au plus court : catégorie, produit, date, « Publier ».
```
┌───────────────────────────────┐
│ ←  Publier un surplus         │
│ Catégorie *                   │
│ ┌───────────────────────────┐ │
│ │ Fruits et légumes       ▾ │ │
│ └───────────────────────────┘ │
│ Produit *                     │
│ ┌───────────────────────────┐ │
│ │ ex. Carottes              │ │
│ └───────────────────────────┘ │
│ À récupérer avant le *        │
│ ┌───────────────────────────┐ │
│ │ jj/mm/aaaa                │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │   📷 AJOUTER DES PHOTOS   │ │  ← appareil photo ou
│ └───────────────────────────┘ │    galerie, 5 maximum
│ [mini✕] [mini✕] [ + ]         │  ← aperçu, ✕ pour retirer
│ Quantité         Unité        │
│ ┌─────────┐ ┌───────────────┐ │
│ │ 25      │ │ kg          ▾ │ │  ← facultatif
│ └─────────┘ └───────────────┘ │
│ Conservation                  │
│ (Ambiant) (Frais) (Surgelé)   │  ← facultatif
│ Lieu de récupération          │
│ ┌───────────────────────────┐ │
│ │ 12 rue …, Chartres        │ │  ← adresse de la structure,
│ └───────────────────────────┘ │    modifiable
│ Disponibilités                │
│ ┌───────────────────────────┐ │
│ │ lun–ven 9h–17h            │ │  ← déjà rempli, modifiable
│ └───────────────────────────┘ │
│ Informations complémentaires  │
│ ┌───────────────────────────┐ │
│ │ ex. à garder au frais,    │ │  ← texte libre, facultatif
│ │ cagettes à rapporter…     │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │          PUBLIER          │ │
│ └───────────────────────────┘ │
│         * obligatoire         │
└───────────────────────────────┘
```

## Écran 8 : Mes échanges
Onglet « Dons » ci-dessous. L'onglet « Réservations » a la même forme : en cours (avec le créneau et le bouton « Itinéraire »), puis l'historique.
```
┌───────────────────────────────┐
│ Mes échanges                  │
│  [ Dons (3) | Réservations ]  │
│ EN COURS                      │
│ ┌───────────────────────────┐ │
│ │ (!) Pommes de terre       │ │  ← à faire : mis en avant,
│ │ Réservée par Restos Dreux │ │    mêmes boutons que sur
│ │ (Paul) · hier 14h         │ │    l'accueil
│ │ Sont-elles parties ?      │ │
│ │ [✓ Oui, récupérées]       │ │
│ │ [✗ Non, remettre en ligne]│ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ Yaourts nature · 40 pièces│ │
│ │ Réservée par Épicerie     │ │
│ │ sociale Anet · jeu. 10h   │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │ Lessive · 12 bidons       │ │
│ │ Disponible · avant 30/11  │ │
│ │ publiée par Marie         │ │
│ └───────────────────────────┘ │
│ HISTORIQUE                    │  ← toute la structure,
│ Pain · récupéré le 2/10       │    avec qui a fait quoi
│   par CCAS Lucé (Julie)       │
│ Lait · expiré le 28/09        │
│ Œufs · non récupérés le 25/09 │
├───────────────────────────────┤
│   🌾      ➕      📦      🏠  │
└───────────────────────────────┘
```

## Écran 9 : Ma structure
Les formulaires « Modifier mon compte » et « Modifier la structure » reprennent les mêmes champs. « Modifier mon compte » ajoute les catégories suivies, à cocher (toutes cochées par défaut).
```
┌───────────────────────────────┐
│ Ma structure                  │
│ MON COMPTE                    │
│ Marie Dupont                  │
│ marie@exemple.fr              │
│ 06 12 34 56 78                │
│ Catégories suivies : toutes   │  ← pour les alertes (Phase 4)
│ [ Modifier mon compte ]       │
│ ───────────────────────────── │
│ MA STRUCTURE                  │
│ Secours Populaire Chartres    │
│ 12 rue …, 28000 Chartres      │
│ 02 37 00 00 00                │
│ Disponibilités habituelles :  │
│ lun–ven 9h–17h                │
│ [ Modifier la structure ]     │  ← responsables seulement
│ ───────────────────────────── │
│ Membres (5)                 › │  ← responsables seulement
│ Admin                       › │  ← admin seulement
│ ───────────────────────────── │
│ Se déconnecter                │
├───────────────────────────────┤
│   🌾      ➕      📦      🏠  │
└───────────────────────────────┘
```

## Écran 10 : Membres (responsables seulement)
```
┌───────────────────────────────┐
│ ←  Membres                    │
│ ┌───────────────────────────┐ │
│ │    + INVITER UN MEMBRE    │ │  ← demande son email
│ └───────────────────────────┘ │
│ Marie Dupont      Responsable │  ← ⋯ : nommer ou retirer
│ marie@exemple.fr            ⋯ │    responsable, désactiver,
│ ───────────────────────────── │    renvoyer l'invitation
│ Paul Martin            Membre │
│ paul@exemple.fr             ⋯ │
│ ───────────────────────────── │
│ julie@exemple.fr       Membre │
│ Invitation en attente       ⋯ │
│ ───────────────────────────── │
│ Luc Bernard (désactivé)       │
│ luc@exemple.fr              ⋯ │
└───────────────────────────────┘
```

## Écran 11 : Admin › Structures
```
┌───────────────────────────────┐
│ ←  Admin                      │
│  [ Structures | Catégories ]  │
│ ┌───────────────────────────┐ │
│ │   + NOUVELLE STRUCTURE    │ │
│ └───────────────────────────┘ │
│ Secours Populaire Chartres    │
│ Chartres · 5 membres  Active ›│
│ ───────────────────────────── │
│ Restos du Cœur Dreux          │
│ Dreux · 3 membres     Active ›│
│ ───────────────────────────── │
│ Foyer d'Accueil Chartrain     │
│ Chartres · 0 membre           │
│ Invitation en attente       › │  ← responsable pas encore inscrit
└───────────────────────────────┘
```

**Formulaire « Nouvelle structure »** (le même sert à modifier, sans l'email du responsable). On ne demande que l'essentiel : le responsable complète ensuite la fiche (téléphone, disponibilités habituelles) dans « Ma structure », et un « À faire » le lui rappelle tant que ce n'est pas fait.
```
┌───────────────────────────────┐
│ ←  Nouvelle structure         │
│ Nom *                         │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ Adresse *                     │
│ ┌───────────────────────────┐ │
│ │                           │ │  ← suggestions d'adresses (IGN)
│ └───────────────────────────┘ │
│ Téléphone (facultatif)        │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ Email du 1er responsable *    │
│ ┌───────────────────────────┐ │
│ │                           │ │
│ └───────────────────────────┘ │
│ ┌───────────────────────────┐ │
│ │     CRÉER ET ENVOYER      │ │
│ │       L'INVITATION        │ │
│ └───────────────────────────┘ │
└───────────────────────────────┘
```

## Écran 12 : Admin › Catégories
La liste ci-dessous est provisoire : on la revoit avant la démo du Proof of Concept, et l'admin peut la modifier à tout moment. La catégorie **« Autres »** sert de fourre-tout : elle est toujours en dernier, et on ne peut pas la masquer.
```
┌───────────────────────────────┐
│ ←  Admin                      │
│  [ Structures | Catégories ]  │
│ ┌───────────────────────────┐ │
│ │   + NOUVELLE CATÉGORIE    │ │
│ └───────────────────────────┘ │
│ ↕ Fruits et légumes         ✎ │  ← ↕ : glisser pour changer
│ ↕ Produits laitiers, œufs   ✎ │    l'ordre ; ✎ : renommer
│ ↕ Viande, poisson           ✎ │
│ ↕ Épicerie sèche            ✎ │
│ ↕ Conserves                 ✎ │
│ ↕ Pain, viennoiseries       ✎ │
│ ↕ Surgelés                  ✎ │
│ ↕ Boissons                  ✎ │
│ ↕ Hygiène (masquée)         ✎ │  ← plus proposée à la publication
│   Autres                    ✎ │  ← fourre-tout, toujours en dernier
└───────────────────────────────┘
```
