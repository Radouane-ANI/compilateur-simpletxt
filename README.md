# ReadMe.md

## Compilation

Pour compiler le projet, utilisez la commande suivante à la racine du projet `simpletext/` :

  dune build

## Exécution

Une fois compilé, vous pouvez exécuter le programme avec :

  dune exec bin/main.exe

Le fichier d'entrée par défaut est situé dans `bin/test_input.txt`.

Vous pouvez modifier ce fichier ou en créer d'autres pour tester différentes fonctionnalités du langage SimpleText.

## Dossier d'exemples

Le dossier `exemples/` contient plusieurs fichiers SimpleText illustrant différentes fonctionnalités, telles que :

- Définition et usage de macros
- Changement de couleur de texte
- Mise en forme : italique, gras, gras+italique
- Listes simples et imbriquées
- Liens cliquables
- Gestion des erreurs (macro inconnue, macro redéfinie, etc.)
- Titres et sauts de paragraphe

## Fonctionnalités implémentées

Nous avons implémenté les parties suivantes du sujet :

- Le lexer (`ocamllex`) et le parser (`Menhir`) pour le langage SimpleText
- La définition d'un type AST pour représenter la structure du document
- La gestion des macros via `\define`
- La coloration de texte avec `\color{...}{...}`
- La mise en forme : italique (`*`), gras (`**`), et gras+italique (`***`)
- Les titres avec `##`
- Les listes simples avec `\item`, ainsi que les listes complexes et imbriquées
- La détection correcte des paragraphes (sauts de ligne)
- La gestion des erreurs : macro non définie, macro redéfinie
- La transformation du document en une page HTML
- Génération d’un fichier `outpout.html` contenant la version HTML du document SimpleText analysé

## Répartition du travail

Nous avons travaillé en binôme comme suit :

- **Sami** :
  - Ajout du lexer (`ocamllex`) et du parser (`Menhir`) pour SimpleText
  - Définition du type AST
  - Amélioration de la détection des paragraphes dans le lexer
  - Gestion du texte en couleur avec `\color`
  - Gestion des erreurs liées aux macros (`Undefined_macro`, `Duplicate_macro`)
  
- **Radouane** :
  - Implémentation de la transformation du document en page HTML
  - Implémentation des macros (`\define`) dans le code
  - Support des listes imbriquées complexes (`\item`) avec sous-items
  - Gestion combinée du gras et de l'italique (`***`)
  - Items complexes encadrant plusieurs sous-éléments

Nous avons également collaboré pour les tests et la conception du format SimpleText dans son ensemble.

