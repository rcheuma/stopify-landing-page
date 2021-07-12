# landing-page
## Présentation
Le mini site de l'entreprise contient 2 pages :
- la page d'acceuil
- la page de contact

Le site est généré par le framework [hugo](https://gohugo.io/) et le thème utilisé est [bigspring](https://themes.gohugo.io/bigspring-hugo-startup-theme/).
Les sources du site sont présentes dans le dossier nommé `website`.

## Procédures
### Faire tourner le site en local (préproduction)
La génération du site peut être simulée en local grâce à une image docker et à docker-compose.

Un service nommé `dev_server` est défini dans le fichier docker-compose.yml.
- Le stage de build du service crée une image docker dont le `Dockerfile` et les scripts associés se trouvent dans le dossier `docker-image`.
- Lorsque le service est lancé la commande exécutée par le container est `hugo server --bind-"0.0.0.0"` avec un mapping du dossier `website` sur le volume `/src` du container et avec un mapping du port 1313 du container sur le port 1313 de la machine qui fait tourner docker. Cette commande permet de lancer hugo en mode serveur afin de voir en live toutes les modifications apportées au site en ouvrant l'URL http://localhost:1313.

### Comment (re)build l'image de l'environnement de dev
`docker-compose build`

### Comment lancer l'environnement de dev
`docker-compose up` ou `docker-compose up -d` pour passer en mode daemon

### Comment stopper l'environnement de dev
CTRL+C ou `docker-compose down`

### Changer la version d'hugo installée dans l'image Docker
\\ À écrire \\

## Procédure d'Intégration et Déploiement Continu sur GitHub Pages
L'intégration et le déploiement continus sur `GitHub Pages` sont effectués via github actions.
Le fichier `.github/workflows/gh-pages.yml` définis les actions effectuées :
- déclenchement du pipeline lors d'un push sur la branche `ci-cd`
- définition d'un job nommé `deploy` qui :
  - est lancé sur un container unbuntu
  - fait un git checkout
  - configure hugo dans la version définie via la variable `hugo-version`
  - lance la commande `hugo --minify -e gh-pages -s website` pour générer les fichiers html en précisant qu'il s'agit de l'environnement hugo `gh-pages`
  - déploie le contenu du dossier website/public contenant les fichiers html (générés par la commande précédente) sur github pages

//WIP// À faire :
- faire une pull request pour merger cette branche dans main et adapter github actions en conséquence

### Vérification
Pour vérifier l'exécution de GitHub Actions il faut client sur l'onglet "Actions" du dépôt sur github.com.  
Pour accéder au site il faut se rendre sur l'url `https://<votreid>.github.io/stopify-landing-page/`.

### Erreurs connues
#### GitHub Actions ne se déclenche pas
Il faut vérifier que la branche sur laquelle vous faites vos modification déclenche bien github actions.

#### Github Actions n'effectue pas l'action `Deploy`
Il faut vérifier que la référence qui déclenche l'etape `Deploy` de GitHub action correspond bien à la branche sur laquelle vous faites vos modification. 

#### Erreur 404
Si vous voyez une erreur 404 "There isn't a GitHub Pages site here." il y a 2 problèmes possible :
- le déploiement sur GitHub Pages n'a pas été efféctué (voir ci-dessus)
- la branche utilisée par GitHub Pages n'est pas paramétrée dans votre repository :
  - cliquer sur `Settings` sur votre repository
  - sélectionner la catégorie `Pages`
  - dans `Source` séléctionner la branche `gh-pages` (dossier `/ (root)` et cliquer sur `Save`

#### Erreur d'affichages des images
Si le FQDN GitHub Pages ne correspond pas à celui configuré comme `baseURL` dans hugo, il se peut que les images ne s'affichent pas correctement.
Changer la propriété `baseURL` pour la valeur correspondant dans le fichier `website/config/gh-pages/config.yml`
