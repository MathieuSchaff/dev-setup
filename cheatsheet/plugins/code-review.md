# 🔍 Code Review Plugin Cheatsheet

Le plugin `code-review` automatise la revue des Pull Requests en utilisant plusieurs agents spécialisés travaillant en parallèle pour auditer les changements.

## 🚀 Commande Principale
`/code-review [--comment]`
- **Sans flag** : Affiche les résultats directement dans le terminal.
- `--comment` : Poste la revue en tant que commentaire sur la PR GitHub.

---

## 🤖 Architecture des Agents
Le plugin lance 4 agents indépendants pour garantir une couverture exhaustive :
1. **Agents #1 & #2 (Conformité)** : Vérifient le respect des directives définies dans les fichiers `CLAUDE.md`.
2. **Agent #3 (Bugs)** : Scanne les changements à la recherche de bugs évidents.
3. **Agent #4 (Histoire)** : Analyse le contexte historique via `git blame` pour détecter des régressions ou des incohérences contextuelles.

---

## 📊 Score de Confiance (Threshold: 80)
Chaque problème détecté reçoit un score de 0 à 100. Seuls les scores **≥ 80** sont remontés pour minimiser le bruit (faux positifs).

- **0 - 25** : Faux positif probable / Peu fiable.
- **50** : Problème réel mais mineur.
- **75** : Problème important et hautement probable.
- **100** : Certitude absolue, bug ou violation critique.

---

## ✅ Ce qui est filtré (Faux Positifs)
- Problèmes pré-existants (non introduits par la PR).
- Code qui "ressemble" à un bug mais qui est intentionnel.
- Nits pédants (micro-détails de style).
- Problèmes déjà couverts par les linters standards.
- Lignes avec des commentaires d'ignorance (ex: `// eslint-disable-line`).

---

## 💡 Meilleures Pratiques
- **Maintenance CLAUDE.md** : Plus vos fichiers de guidelines sont clairs, plus les agents de conformité seront précis.
- **Workflow Standard** :
  1. Créer la PR.
  2. Exécuter `/code-review` en local.
  3. Corriger les points remontés.
  4. Exécuter `/code-review --comment` pour la revue finale.
- **Format des Liens** : Les agents utilisent le format de lien exact `https://github.com/owner/repo/blob/[SHA]/path#L[début]-L[fin]` pour pointer vers le code.

---

## 🛠️ Configuration
Le seuil de confiance peut être modifié dans `commands/code-review.md` (par défaut `80`). Vous pouvez également y ajouter des agents spécialisés (Sécurité, Performance, Accessibilité).
