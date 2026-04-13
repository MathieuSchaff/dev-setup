# 🦸 Superpowers Plugin Cheatsheet

Superpowers est un workflow complet de développement logiciel basé sur des "skills" composables. Il impose une discipline de fer : conception avant le code, tests avant l'implémentation, et validation systématique.

## 🌀 Philosophie Core
- **TDD (Test-Driven Development)** : Écrire le test d'abord, le voir échouer, coder le minimum pour qu'il passe.
- **YAGNI & DRY** : Ne pas anticiper les besoins futurs, éviter la répétition.
- **Preuve > Affirmation** : On ne déclare pas un succès sans preuve d'exécution/test.

---

## 📅 Le Workflow Standard

### 1. 🧠 Brainstorming (Design)
Active avant toute ligne de code. L'IA affine vos idées par des questions socratiques, explore les alternatives et génère un document de design validé par vous.

### 2. 🌲 Using Git Worktrees (Isolation)
Crée un espace de travail isolé sur une nouvelle branche avec un environnement propre pour éviter les conflits avec votre travail en cours.

### 3. 📝 Writing Plans (Planification)
Découpe le design approuvé en tâches "bouchées" (2 à 5 minutes). Chaque tâche inclut les chemins de fichiers, le code attendu et les étapes de vérification.

### 4. 🤖 Execution (Subagents / Executing Plans)
Lance des sous-agents pour chaque tâche. Chaque étape subit une double revue : conformité aux specs, puis qualité du code.

### 5. 🧪 Test-Driven Development (TDD)
Cycle strict : **RED** (test échoue) -> **GREEN** (code minimal passe) -> **REFACTOR** (nettoyage). Tout code écrit avant le test est supprimé.

### 6. 🔍 Code Review & Verification
Revue automatique par rapport au plan initial. Les problèmes critiques bloquent la progression. Validation finale via `verification-before-completion`.

### 7. 🏁 Finishing Branch (Finalisation)
Vérification globale des tests, présentation des options (Merge, PR, Discard) et nettoyage du worktree.

---

## 🛠️ Skills Spécialisés

- **`systematic-debugging`** : Processus en 4 phases (Root cause, Defense-in-depth, etc.) pour résoudre les bugs sans deviner.
- **`dispatching-parallel-agents`** : Exécution de tâches indépendantes en simultané.
- **`writing-skills`** : Outil pour créer vos propres skills personnalisés.

---

## 💡 Conseils de Survie
- **Faites confiance au plan** : Si le plan est bon, l'IA peut travailler en autonomie pendant des heures.
- **Répondez aux questions** : La phase de Brainstorming est cruciale pour éviter les erreurs architecturales coûteuses.
- **Ne trichez pas sur les tests** : Le workflow Superpowers est conçu pour supprimer le code non testé.
