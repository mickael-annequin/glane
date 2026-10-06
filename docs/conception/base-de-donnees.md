# Schéma de la base de données — Glane

Les noms des tables et des colonnes sont en anglais, comme le veut la convention Rails. Les textes affichés restent en français.
Une fois le projet créé, la référence à jour sera `db/schema.rb`. Ce document sert de plan de départ.

## Vue d'ensemble
```
                    ┌──< users (membres) ──< category_opt_outs >── categories
                    │                                                     │
organizations ──────┼──< listings (dons) >────────────────────────────────┘
(structures)        │       │
                    │       └──< reservations
                    │               │
                    └───────────────┘  (la structure bénéficiaire)

──<  =  « un … a plusieurs … »
ex. une structure a plusieurs membres, une annonce a plusieurs réservations (au fil du temps)
```
- Une **annonce** appartient à la structure **donatrice**. Elle garde aussi le membre qui l'a publiée.
- Une **réservation** relie une annonce à la structure **bénéficiaire**. Elle garde aussi le membre qui a réservé.
- Les **photos** des annonces ne sont pas dans une colonne : Active Storage les range dans ses propres tables, et les fichiers sont sur Cloudinary.

## Tables du MVP

### organizations : les structures
| Colonne | Type | Exemple |
|---|---|---|
| name | texte | `Secours Populaire Chartres` |
| address | texte | `12 rue des Écuyers, 28000 Chartres` |
| city | texte | `Chartres` (rempli par le géocodage, pour afficher « Chartres · 3 km ») |
| latitude / longitude | décimal | `48.4469` / `1.4890` (rempli par le géocodage IGN) |
| phone | texte, facultatif | `02 37 00 00 00` |
| usual_schedule | JSON | `{"1": [["09:00", "12:00"], ["14:00", "17:00"]], …}` : le planning habituel (1 = lundi … 7 = dimanche, 2 plages par jour au plus), rempli par le responsable |
| usual_availability_note | texte, facultatif | `Sonner à l'entrée du parking` |
| deactivated_at | date + heure, facultatif | vide = active ; rempli = désactivée le … |

### users : les personnes (colonnes de Devise et de devise_invitable, plus les nôtres)
| Colonne | Type | Exemple |
|---|---|---|
| organization_id | lien → organizations | facultatif pour l'admin seulement |
| name | texte | `Marie Dupont` |
| email | texte | `marie@exemple.fr` |
| encrypted_password | texte | (mot de passe chiffré, jamais en clair) |
| phone | texte, facultatif | `06 12 34 56 78` |
| role | choix | `manager` (responsable) / `member` (membre) |
| admin | vrai/faux | `true` pour moi seulement |
| deactivated_at | date + heure, facultatif | vide = actif ; rempli = désactivé le … |
| *invitation_…* | *devise_invitable* | *jeton et dates de l'invitation (envoyée, acceptée), et qui a invité* |

### categories : les catégories (gérées par l'admin)
| Colonne | Type | Exemple |
|---|---|---|
| name | texte | `Fruits et légumes` |
| icon | texte | `🥕` (affiché quand une annonce n'a pas de photo) |
| position | entier | `1` (ordre d'affichage) |
| hidden | vrai/faux | `true` = masquée, plus proposée à la publication |
| catch_all | vrai/faux | `true` pour « Autres » seulement : toujours en dernier, impossible à masquer |

### category_opt_outs : les catégories qu'une personne ne suit **pas**
| Colonne | Type | Exemple |
|---|---|---|
| user_id | lien → users | |
| category_id | lien → categories | |

Par défaut, une personne suit toutes les catégories : on enregistre seulement celles qu'elle a décochées dans « Mon compte ». Ainsi, une catégorie ajoutée plus tard par l'admin est suivie automatiquement par tout le monde. Elles servent aux alertes de la Phase 4.

### listings : les annonces
| Colonne | Type | Exemple |
|---|---|---|
| organization_id | lien → organizations | la structure donatrice |
| user_id | lien → users | le membre qui a publié (`Marie`) |
| category_id | lien → categories | |
| title | texte | `Carottes` (le « produit ») |
| available_until | date | `2026-10-09` (« À récupérer avant le… », jour compris) |
| quantity | décimal, facultatif | `25` |
| unit | choix, facultatif | `kg` / `liter` / `piece` / `box` (carton) / `parcel` (colis) / `bag` (sac) / `pallet` (palette)… |
| storage | choix, facultatif | `ambient` (ambiant) / `chilled` (frais) / `frozen` (surgelé) |
| address | texte | `Place Métézeau 28100 Dreux` (le lieu de récupération, copié de la structure, modifiable) |
| city | texte | `Dreux` |
| latitude / longitude | décimal | (données par la suggestion d'adresse de l'IGN choisie) |
| schedule | JSON | le planning de récupération (copié de la structure, modifiable) ; vide pour les annonces publiées avant le planning |
| availability_note | texte, facultatif | `Sonner à l'entrée du parking` |
| description | texte long, facultatif | `Cagettes à rapporter` (le texte libre) |
| status | choix | `available` (disponible) / `reserved` (réservée) / `picked_up` (récupérée) / `withdrawn` (retirée) |

Les mêmes noms de colonnes que pour les structures (`address`, `city`, `latitude`, `longitude`) : le champ d'adresse à suggestions sert aux deux.
| *photos* | *Active Storage* | *jusqu'à 5, stockées sur Cloudinary* |

### reservations : les réservations
| Colonne | Type | Exemple |
|---|---|---|
| listing_id | lien → listings | |
| organization_id | lien → organizations | la structure bénéficiaire |
| user_id | lien → users | le membre qui a réservé (`Paul`) |
| pickup_at | date + heure | `2026-10-07 14:00` (le créneau choisi) |
| status | choix | `active` (en cours) / `picked_up` (récupérée) / `not_picked_up` (non récupérée) / `cancelled` (annulée) |
| cancelled_by_id | lien → users, facultatif | qui a annulé (pour afficher « annulée par le donateur ») |
| closed_at | date + heure, facultatif | quand la réservation s'est terminée (récupérée, non récupérée ou annulée) |

## Tables et colonnes prévues après le MVP

### Phase 3 — Messagerie
**conversations** : une par annonce et par structure intéressée.
| Colonne | Type | Exemple |
|---|---|---|
| listing_id | lien → listings | |
| organization_id | lien → organizations | la structure qui pose des questions |

**messages**
| Colonne | Type | Exemple |
|---|---|---|
| conversation_id | lien → conversations | |
| user_id | lien → users | l'auteur (son nom et sa structure sont affichés) |
| body | texte long | `Les carottes sont-elles lavées ?` |
| read_at | date + heure, facultatif | vide = pas encore lu par l'autre structure |

### Phase 4 — Notifications
- **notifications** : `user_id`, `kind` (nouvelle annonce, stock réservé, nouveau message…), `listing_id`, `read_at`. C'est la liste de la cloche 🔔.
- **web_push_subscriptions** : `user_id`, `endpoint`, `p256dh_key`, `auth_key`. Un abonnement par navigateur ou iPhone.
- **Appareils Android** : la table est créée par la gem `action_push_native`, un enregistrement par téléphone.
- **users** gagne `notifications_enabled` (vrai/faux).
- **reservations** gagne `confirmation_asked_at` et `reminder_sent_at`, pour ne pas envoyer deux fois la question « Stock récupéré ? » ni le rappel des 24 h.

### Phase 7 — Chiffres
Aucune table en plus : tout se calcule à partir des annonces et des réservations (statut `picked_up`, `closed_at` pour le mois, quantité et unité, catégorie, structures).

## D'où vient chaque info des écrans
La plupart des infos sont une colonne. Les autres **se calculent** à l'affichage, sans être stockées :
| Info affichée | D'où elle vient |
|---|---|
| Distance « Dreux · 12 km » | calculée entre les coordonnées de ma structure et celles de l'annonce |
| Annonce « expirée » | `available_until` est passée et l'annonce est encore `available` |
| Badge « Votre structure » | l'annonce appartient à ma structure |
| « À faire : stock récupéré ? » | une réservation `active` de mes dons dont le créneau date de plus de 3 h |
| « Récupération prévue aujourd'hui » | une réservation `active` de ma structure dont le créneau est aujourd'hui |
| « Complétez la fiche de votre structure » | `usual_schedule` est vide (responsables seulement) |
| Téléphone du contact | `users.phone` de la personne, sinon `organizations.phone` |
| « Invitation en attente » | `invitation_accepted_at` est vide |
| Nombre de membres d'une structure | on compte ses `users` actifs |

## Choix expliqués
- **Tout appartient à la structure, mais on garde la personne** : chaque annonce et chaque réservation a un `organization_id` (pour les droits, l'historique et les chiffres) et un `user_id` (pour « Publié par Marie »).
- **Une seule réservation active par annonce** : un **index unique** dans la base l'interdit. Même si deux structures touchent « Réserver » à la même seconde, une seule réussit, et l'autre voit « Déjà réservée ».
- **On garde l'historique des réservations** : une annonce peut être réservée, annulée, réservée par une autre structure, puis récupérée. Chaque étape reste une ligne de `reservations`.
- **« Expirée » n'est pas un statut stocké** : il se déduit de la date limite. Il n'y a pas besoin d'une tâche planifiée qui passerait chaque nuit changer les statuts.
- **Désactiver plutôt que supprimer** (`deactivated_at`) : une structure ou un membre désactivé ne peut plus se connecter, mais ses annonces et réservations restent dans l'historique et dans les chiffres. On garde aussi la date de la désactivation.
- **Adresse, ville, coordonnées et disponibilités copiées sur l'annonce** : le lieu peut être différent de l'adresse de la structure. Si la structure déménage, les anciennes annonces gardent leur vrai lieu.
- **Quantité en décimal** : on peut écrire `2.5` kg. Elle est facultative, comme l'unité.
- **Choix (`role`, `unit`, `storage`, `status`) en anglais dans la base**, traduits en français à l'affichage, comme le veut la convention Rails (`enum`).
- **Pas de colonne « alimentaire ou non » sur les catégories pour l'instant** : rien ne s'en sert encore. On l'ajoutera avec une migration si besoin.
