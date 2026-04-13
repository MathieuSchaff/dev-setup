# 🚀 Feature Development Plugin Cheatsheet

Le plugin `feature-dev` propose une approche systématique en 7 phases pour construire de nouvelles fonctionnalités, garantissant une intégration parfaite et une conception de haute qualité.

## 🛠️ Commande Principale
`/feature-dev [description de la feature]`
*Exemple : `/feature-dev Ajouter l'authentification OAuth2`*

---

## 📅 Le Workflow en 7 Phases

### 1. Discovery (Découverte)
- **But** : Clarifier le besoin.
- **Action** : L'IA pose des questions sur le problème à résoudre, les contraintes et les exigences.

### 2. Codebase Exploration (Exploration)
- **But** : Comprendre l'existant.
- **Action** : Lance des agents `code-explorer` en parallèle pour mapper l'architecture, trouver des fonctionnalités similaires et identifier les fichiers clés.

### 3. Clarifying Questions (Clarification)
- **But** : Lever toute ambiguïté.
- **Action** : Présente une liste organisée de questions sur les cas limites (edge cases), la gestion d'erreurs et les points d'intégration.

### 4. Architecture Design (Conception)
- **But** : Proposer des stratégies d'implémentation.
- **Action** : Présente généralement 3 approches via des agents `code-architect` :
  - **Minimal** : Changement rapide, réutilisation maximale.
  - **Clean Architecture** : Élégance, testabilité, abstractions.
  - **Pragmatic** : Le juste milieu (recommandé par défaut).

### 5. Implementation (Réalisation)
- **But** : Écrire le code.
- **Action** : Ne démarre qu'après **votre approbation**. Suit strictement l'architecture choisie et les conventions du projet.

### 6. Quality Review (Revue)
- **But** : Garantir la robustesse.
- **Action** : Lance 3 agents `code-reviewer` (Simplicité, Bugs, Conventions). Seuls les problèmes avec un score de confiance ≥ 80 sont signalés.

### 7. Summary (Résumé)
- **But** : Documenter le travail.
- **Action** : Liste les fichiers modifiés, les décisions clés et suggère les prochaines étapes.

---

## 🤖 Les Agents Spécialisés

- **`code-explorer`** : Trace les flux d'exécution et identifie les dépendances.
- **`code-architect`** : Analyse les patterns et définit la roadmap d'implémentation.
- **`code-reviewer`** : Audite le code pour la qualité et la conformité `CLAUDE.md`.

---

## 💡 Conseils & Bonnes Pratiques
- **Soyez spécifique au début** : Plus votre demande initiale est détaillée, moins il y aura de questions en Phase 3.
- **Ne sautez pas les phases** : Chaque étape nourrit la suivante. L'exploration (Phase 2) évite de casser l'existant.
- **Faites confiance aux recommandations** : L'approche "Pragmatic" est souvent la plus adaptée aux contraintes réelles.
- **Utilisation manuelle** : Vous pouvez invoquer un agent spécifique sans le workflow complet (ex: *"Lance code-explorer pour comprendre comment marche l'auth"*).
