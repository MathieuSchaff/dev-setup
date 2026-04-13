# 🦴 Caveman Plugin Cheatsheet

Le plugin `caveman` réduit drastiquement la consommation de tokens (jusqu'à 75%) en supprimant le "gras" conversationnel (articles, politesses, fioritures) sans sacrifier la précision technique.

## 🚀 Activation & Modes
Activez-le via la commande :
`/caveman [lite|full|ultra|wenyan]`

- **lite** : Phrases complètes, ton professionnel, mais sans fioritures (pas de "je pense que", "certainement").
- **full** (Défaut) : Suppression des articles (le/la/les), fragments autorisés. Style "Sujet Verbe Objet".
- **ultra** : Abréviations massives (DB, auth, fn, impl), flèches pour la causalité (`X -> Y`), suppression des conjonctions.
- **wenyan** : Style littéraire chinois classique (文言文) pour une compression maximale.

---

## 🛠️ Règles de Communication
- **Suppression** : Pas de "Bonjour", "Je serais ravi de vous aider", "Veuillez noter que".
- **Code & Commandes** : **Jamais modifiés**. Le code reste intact et syntaxiquement correct.
- **Synonymes courts** : "fix" au lieu de "implement a solution for", "big" au lieu de "extensive".

**Exemple (Mode full)** :
*IA : "Bug dans middleware auth. Vérification expiration utilise `<` au lieu de `<=`. Fix ci-dessous :"*

---

## 🗜️ Caveman Compress
Le plugin peut compresser vos fichiers de mémoire (ex: `CLAUDE.md`, `todos.md`) pour économiser des tokens d'entrée.

Commande :
`/caveman:compress <filepath>`

- **Sauvegarde** : Crée un backup `.original.md` avant d'écraser le fichier.
- **Préservation** : Ne touche **JAMAIS** aux blocs de code (```...```) ni aux URLs.
- **Action** : Réécrit la prose en style caveman.

---

## 🛑 Exceptions (Auto-Clarity)
L'IA repasse temporairement en mode normal pour :
- Les avertissements de sécurité critiques.
- Les confirmations d'actions irréversibles (ex: `DROP TABLE`).
- Les séquences complexes où le style fragmenté risquerait une mauvaise interprétation.

---

## 💡 Commandes Utiles
- `/caveman-help` : Affiche l'aide rapide.
- `/caveman-commit` : Génère un message de commit ultra-court (format Conventional Commits).
- `/caveman-review` : Génère des commentaires de PR en une seule ligne (ex: `L42: bug: null check manquant`).
