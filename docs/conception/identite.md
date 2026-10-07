# Identité visuelle — Glane

Ambiance : **Moisson** 🌾 (les tons chauds de la récolte en Beauce : terre, paille, blé mûr, et quelques coquelicots). Authentique, « terroir », chaleureuse.
Aperçu visuel : ouvrir [identite-apercu.html](identite-apercu.html) dans le navigateur.

## Palette
| Rôle | Nom | Code | Usage |
|---|---|---|---|
| Principale | Brun glaise | `#7A4A24` | En-têtes, titres, boutons principaux (« Réserver », « ✓ Oui, récupérées »), filtre actif |
| Accent | Blé mûr | `#E3A92B` | Bouton « + Publier », logo |
| Urgent | Coquelicot | `#C0392B` | Encadré « À faire », dates limites proches (« avant demain ») |
| Fond | Crème | `#FBF5E9` | Fond de l'app |
| Douce | Paille | `#EADBC0` | Pastilles de catégories, fond des photos manquantes, badges |
| Texte | Brun nuit | `#2D241C` | Textes (plus doux que le noir pur) |
| Succès | Vert pousse | `#5F7F3A` | Messages de confirmation (« Annonce publiée »). Couleur utilitaire, à utiliser peu |

Règles de lisibilité (vérifiées : contraste ≥ 4,5, la norme d'accessibilité web) :
- Sur le **brun glaise**, le coquelicot et le vert pousse, le texte est en **blanc**.
- Sur le **blé mûr** et la paille, le texte est en **brun nuit**, jamais en blanc (illisible).
- Le **coquelicot** est réservé à ce qui est urgent ou à faire. On ne l'utilise pas pour les boutons ordinaires, pour qu'il garde sa force d'alerte.
- Les actions secondaires ou d'annulation (« Annuler la réservation », « ✗ Non, remettre en ligne ») sont des boutons à contour brun nuit, sans fond.

## Polices
- **Fraunces** (Google Fonts), graisses 600 et 800 : le nom « Glane », les titres et le texte des boutons. Ses empattements donnent le côté chaleureux et « terroir ».
- **Source Sans 3** (Google Fonts), graisses 400, 600 et 700 : tout le reste (annonces, formulaires, textes). Très sobre et lisible, même en petit.

## Logo
[logo.svg](logo.svg) (choisi le 07/10/2026) : un **panier** au trait épais et arrondi, brun glaise, avec un **épi de blé mûr** qui en sort, sur un carré crème aux coins arrondis. Le panier évoque « on vient récupérer quelque chose », et l'épi le glanage. La tige de l'épi forme le montant du milieu du panier ; un contour crème détache l'épi du bord du panier, et un petit espace sépare ses grains.

Fichiers :
- `app/assets/images/logo.svg` : le logo dans l'app (accueil, connexion, invitation, mot de passe) ;
- `public/icon.svg` : l'icône d'onglet ;
- `public/icon.png` (512 px) : l'icône d'app, en **carré sans coins arrondis**, car le téléphone arrondit lui-même les coins. Elle se refait en ouvrant `icon.svg` sans le `rx="24"` dans Chrome sans fenêtre (`google-chrome --headless --window-size=512,512 --screenshot=…`).

## Principes
- Gros boutons arrondis (coins de 12 px environ), faciles à toucher d'une main.
- Cartes d'annonces blanches sur fond crème, avec une légère ombre.
- Une annonce sans photo affiche l'icône de sa catégorie sur fond paille.
- La seule couleur vive de l'écran d'accueil est le coquelicot de l'encadré « À faire » : on voit tout de suite s'il y a quelque chose à faire.
- Pas de mode sombre pour l'instant.
