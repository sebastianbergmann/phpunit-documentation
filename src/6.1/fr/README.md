## Comment construire la documentation

Pour compiler la documentation en français, les pré-requis sont les suivants :

- Apache Ant
- PHP 5 (avec les extensions DOM, PRCE, SPL et Tokenizer)
- Ruby
- xsltproc

Pour compiler la documentation en français :

    cd build
    ant build-fr-6.1

Attention, la documentation est en cours de traduction (cf. tableau ci dessous)


## Contributions attendues

 * Traduire les fichiers encore en anglais
 * Mettre à jour les fichiers existants
 * Partir à la chasse aux typos et aux fautes d'orthographes, de grammaire et de syntaxes
 * Détecter le franglais et les anglicismes
 * Revue de pair sur les PR


## Plan

| Fichier                           | Etat      | Contributeurs     | Nb ligne revues/Total    |
| --------------------------------- | :-------: | :---------------: | :----------------------: |
| annotations.xml                   | OK        | @brice @gbprod    | done                     |
| assertions.xml                    | OK        | @gbprod           | done                     |
| bibliography.xml                  | OK        | @gbprod           | done                     |
| book.xml                          | OK        | @gbprod           | done                     |
| code-coverage-analysis.xml        | OK        | @brice @gbprod    | done                     |
| configuration.xml                 | OK        | @gbprod           | done                     |
| copyright.xml                     | OK        | @gbprod           | done                     |
| database.xml                      | OK        | @gbprod           | done                     |
| extending-phpunit.xml             | OK        | @gbprod           | done                     |
| fixtures.xml                      | OK        | @gbprod           | done                     |
| incomplete-and-skipped-tests.xml  | OK        | @gbprod           | done                     |
| index.xml                         | OK        | @gbprod           | done                     |
| installation.xml                  | OK        | @brice @methylbro @gbprod | done             |
| logging.xml                       | OK        | @gbprod           | done                     |
| organizing-tests.xml              | OK        | @gbprod           | done                     |
| other-uses-for-tests.xml          | OK        | @gbprod           | done                     |
| risky-tests.xml                   | OK        | @gbprod           | done                     |
| test-doubles.xml                  | OK        | @brice @gbprod    | done                     |
| testing-practices.xml             | OK        | @gbprod           | done                     |
| textui.xml                        | OK        | @gbprod           | done                     |
| writing-tests-for-phpunit.xml     | OK        | @gbprod           | done                     |

## Guide de traduction

Dans ce fichier sont recensées les règles de traductions utilisées de manière à garantir la cohérence d'ensemble.
Sont notamment visés les termes techniques.

actual:			constatée (valeur)
array:			traduit par tableau sauf quand on fait explicitement référence à PHP
assertion:		traduit par asssertion, plus parlant que affirmation
composable:		composable (rien trouvé de mieux)
expected:		attendue (valeur)
framework:		framework
isolated:		indépendant (isolé est ambigu, étanche un peu moins...)
notice:			remarque
return:			retourne plutôt que renvoie
requirements:	pré-requis
extension:		extensions
code coverage:	couverture de code
appendix:       annexe
fixture:        fixture (pas trouvé mieux en français)
stub:           bouchon

verbe ing: 	traduits par l'infinitif dans les titres: testing => tester

## Historique du projet de traduction

14/02/2017 : Je relance le projet de traduction de la doc de PHPUnit afin de permettre à des francophones de mieux appréhender ce produit. La dernière version française complète est lié à la version 4.3 de phpunit. C'est cette version qui est dupliquée dans les répertoires 4.4 à 6.0. La traduction commence à la version 6.1 avec un travail en cours de récupération des fichiers manquants et mise à jour des fichiers existant.

03/03/2017 : J'ai ajouté un tableau d'avancement ppur mesurer le travail à fournir pour arriver au bout des traductions.
