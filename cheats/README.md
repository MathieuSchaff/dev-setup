# Guide de Style : Navi Cheatsheets

Ce document définit les standards pour écrire des cheatsheets `navi` robustes, visuelles et faciles à maintenir dans ce dépôt.

## 1. Structure de base
Chaque fichier `.cheat` doit suivre cette structure :

```bash
% tag1, tag2, tag3

# Description de la commande
commande <variable>

$ variable: commande_shell --- --option1 --option2
```

- **Tags (`%`)** : Commencez par le nom de l'outil, puis des sous-catégories (ex: `git, branch, delete`).
- **Description (`#`)** : Courte, explicite, en français.
- **Commande** : La commande réelle avec des placeholders entre `< >`.
- **Variables (`$`)** : La logique pour remplir les placeholders.

---

## 2. Variables Dynamiques (Le "Perfect Match")

C'est ici que `navi` devient puissant. Utilisez systématiquement des commandes shell pour proposer des choix.

### Sélections Multi-colonnes (Tableaux)
Pour les sorties complexes (ex: `docker ps`, `npm list`), utilisez le format table :

```bash
$ container_id: docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}' --- --header-lines 1 --column 1 --delimiter $'\t'
```
- `--header-lines 1` : Ignore la ligne de titre du tableau.
- `--column 1` : La valeur qui sera réellement injectée dans la commande.
- `--delimiter` : Spécifie le séparateur (souvent `\t` ou ` `).

### Previews Riches
Affichez toujours une preview pour aider à la décision :

```bash
# Git : voir le graphe des commits en preview
$ branch_name: git branch --- --preview 'git log --oneline --graph --color=always -n 10 {1}'
```
- `{1}` : Représente la première colonne de la sélection.
- `--color=always` : Crucial pour garder la coloration syntaxique dans la preview `navi`.

---

## 3. Outils Recommandés pour les Variables

Privilégiez ces outils (déjà installés) pour traiter les données :
- **`jq`** : Pour parser le JSON (ex: `package.json`).
- **`fd`** : Alternative rapide à `find`.
- **`bat`** : Pour des previews de fichiers avec coloration (`bat --color=always`).
- **`awk/sed`** : Pour nettoyer les sorties textes (enlever les `*`, les préfixes `origin/`, etc.).

---

## 4. Conventions de Nommage

| Type de variable | Nom recommandé | Exemple |
| :--- | :--- | :--- |
| Identifiant unique | `<id>` ou `<hash>` | `docker stop <container_id>` |
| Chemin fichier | `<path>` ou `<file>` | `bat <file_path>` |
| Nom d'entité | `<name>` | `git checkout <branch_name>` |
| Valeur libre | `<val>` ou `<arg>` | `git commit -m "<message>"` |

---

## 5. Exemple de "Perfect Cheat"

```bash
% docker, container

# Voir les logs d'un container
docker logs -f <container_id>

$ container_id: docker ps -a --format 'table {{.ID}}\t{{.Names}}\t{{.Status}}' --- --header-lines 1 --column 1 --preview 'docker logs --tail 50 {2}'
```
*Ici, on sélectionne l'ID (colonne 1), mais on utilise le Nom (colonne 2) pour générer la preview des logs.*
