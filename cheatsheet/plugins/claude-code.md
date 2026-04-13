# Claude Code — plugins, skills & MCP servers

Référence pour les plugins et MCP servers installés en scope `user` (disponibles sur tous les projets).
Config : `~/.claude/settings.json` (plugins), `~/.claude.json` (MCP servers).

## Sommaire

- [Plugins actifs](#plugins-actifs)
- [Skills par plugin](#skills-par-plugin)
- [Plugins désactivés](#plugins-désactivés)
- [MCP Servers standalone](#mcp-servers-standalone)
- [MCP Servers cloud](#mcp-servers-cloud)
- [Gestion plugins & MCP](#gestion-plugins--mcp)
- [Gotchas](#gotchas)

---

## Plugins actifs

| Plugin | Marketplace | Rôle |
|--------|-------------|------|
| `superpowers` | official | Framework de skills — brainstorming, plans, TDD, debugging, code review, worktrees, subagents |
| `feature-dev` | official | Dev de features guidé — analyse codebase, architecture, review |
| `code-review` | official | Review de pull requests |
| `code-simplifier` | official | Simplification / refactoring du code modifié |
| `typescript-lsp` | official | LSP TypeScript — diagnostics, types, définitions en temps réel |
| `claude-md-management` | official | Audit et amélioration des fichiers `CLAUDE.md` |
| `skill-creator` | official | Création de skills personnalisés |
| `claude-code-setup` | official | Recommandations d'automations Claude Code pour un projet |
| `playwright` | official | Automatisation navigateur — tests E2E, screenshots, formulaires |
| `semgrep` | official | Analyse statique SAST — vulnérabilités, code smells |
| `ralph-loop` | official | Boucle autonome itérative dans la session |
| `frontend-design` | official | Interfaces frontend production avec design soigné |
| `caveman` | `JuliusBrussee/caveman` | Mode compressé (~75% tokens en moins), commits/reviews condensés |

---

## Skills par plugin

### superpowers

| Skill | Déclenchement |
|-------|---------------|
| `/brainstorming` | Avant tout travail créatif — features, composants, modifications de comportement |
| `/writing-plans` | Spec ou requirements pour une tâche multi-étapes, avant de coder |
| `/executing-plans` | Exécution d'un plan écrit, avec checkpoints de review |
| `/test-driven-development` | Avant d'écrire du code d'implémentation |
| `/systematic-debugging` | Bug, test failure, comportement inattendu — avant de proposer un fix |
| `/requesting-code-review` | Après complétion d'une tâche ou feature majeure |
| `/receiving-code-review` | Avant d'implémenter des suggestions de review |
| `/dispatching-parallel-agents` | 2+ tâches indépendantes sans dépendance séquentielle |
| `/verification-before-completion` | Avant de déclarer un travail terminé ou de committer |
| `/finishing-a-development-branch` | Implémentation terminée, tests passent — merge, PR ou cleanup |
| `/using-git-worktrees` | Feature nécessitant isolation du workspace courant |

### feature-dev

| Skill | Usage |
|-------|-------|
| `/feature-dev` | Développement guidé avec compréhension du codebase |
| sous-agent `code-architect` | Design d'architecture pour une feature |
| sous-agent `code-explorer` | Analyse profonde d'un codebase existant |
| sous-agent `code-reviewer` | Review avec filtrage par niveau de confiance |

### code-review

| Skill | Usage |
|-------|-------|
| `/code-review` | Review d'une PR — analyse diffs, problèmes, suggestions |

### code-simplifier

| Skill | Usage |
|-------|-------|
| `/simplify` | Simplifier le code récemment modifié |

### claude-md-management
Outils pour maintenir et améliorer les fichiers `CLAUDE.md` — audit de qualité, capture des apprentissages de session et maintien de la mémoire du projet.

| Outil / Skill | Commande | Usage | Déclencheur |
|---------------|----------|-------|-------------|
| `claude-md-improver` | `audit my CLAUDE.md` | Audit qualité + améliorations alignées sur le codebase | Changements codebase / Maintenance périodique |
| `/revise-claude-md` | `/revise-claude-md` | Mettre à jour `CLAUDE.md` avec les apprentissages de la session | Fin de session / Contexte manquant révélé |

> **Note** : Ces deux outils sont complémentaires. Utilisez `improver` pour la cohérence structurelle et `/revise` pour la mémoire vive de vos sessions.

### claude-code-setup

| Skill | Usage |
|-------|-------|
| `/claude-automation-recommender` | Recommander hooks, subagents, skills, MCP pour un projet |

### playwright

> Pas de skill slash — le plugin expose un MCP server (`npx @playwright/mcp@latest`) avec des outils de navigation, clic, formulaires, screenshots.

### semgrep

> Pas de skill slash — le plugin expose un MCP server (`semgrep mcp`).
> Pré-requis : CLI `semgrep` installé (`pip install semgrep` ou `pipx install semgrep`).

### ralph-loop

| Skill | Usage |
|-------|-------|
| `/ralph-loop` | Démarrer une boucle autonome |
| `/cancel-ralph` | Annuler la boucle en cours |

### frontend-design

| Skill | Usage |
|-------|-------|
| `/frontend-design` | Créer des composants/pages avec un vrai design |

### caveman

Agent avec "mouth smaller, brain same size". Réduit ~75% des tokens de sortie.
Indicateur de statut : `[CAVEMAN]`, `[CAVEMAN:ULTRA]`, etc. dans la barre Claude Code.

| Skill | Usage |
|-------|-------|
| `/caveman <level>` | Switch d'intensité : `lite`, `full` (défaut), `ultra` |
| `/caveman wenyan` | Mode **文言文** (Chinois classique) — compression maximale |
| `/caveman-commit` | Message de commit terse (Conventional Commits, ≤50 chars) |
| `/caveman-review` | Review PR en une ligne : `L42: 🔴 bug: user null. Add guard.` |
| `/caveman:compress` | Compresser un fichier mémoire (`CLAUDE.md`) → gain ~46% tokens |
| `/caveman-help` | Aide rapide (modes, skills, commandes) |
| `"stop caveman"` | Revenir au mode normal |

---

## Plugins désactivés

| Plugin | Raison |
|--------|--------|
| `context7` | Doublon — configuré directement comme MCP server |
| `security-guidance` | Non utilisé |
| `serena` | Doublon — configuré directement comme MCP server |

---

## MCP Servers standalone

| Server | Commande | Rôle | Status |
|--------|----------|------|--------|
| `context7` | `npx -y @upstash/context7-mcp` | Doc à jour pour libs/frameworks (React, Next.js, etc.) | connected |
| `chrome-devtools` | `npx -y chrome-devtools-mcp@latest --no-usage-statistics` | Chrome DevTools complet — performance, network, console, screenshots, automation | connected |
| `mcp-toolbox` | `npx -y @toolbox-sdk/server --prebuilt=<db>` | Connecteur DB (Postgres, MySQL, BigQuery, Firestore) — NL2SQL, schémas | connected |
| `serena` | `uvx --from git+https://github.com/oraios/serena serena` | Compréhension sémantique du code via LSP — refactoring, dépendances | needs config |

### mcp-toolbox — détails

Connecteur DB (Postgres, MySQL, BigQuery, Firestore) — NL2SQL, schémas.
Supporte : Google Cloud (AlloyDB, BigQuery, Spanner, Firestore) et standards (Postgres, MySQL, MongoDB, Redis, Snowflake).

#### Installation (Claude Code)
```bash
claude mcp add -s user toolbox -- npx -y @toolbox-sdk/server --prebuilt=postgres
```
*Note : Remplace `postgres` par ton moteur de base de données.*

#### Configuration (Variables d'env)
Selon la DB, tu devras configurer les variables dans ton shell ou le fichier `~/.claude.json` :
- **Postgres** : `POSTGRES_URL=postgresql://user:pass@host:port/db`
- **BigQuery** : `GOOGLE_APPLICATION_CREDENTIALS=/path/to/key.json`
- **MySQL** : `MYSQL_URL=user:pass@tcp(host:port)/db`

| Commande / Option | Effet |
|-------------------|-------|
| `--prebuilt=postgres` | Active les outils génériques pour PostgreSQL |
| `list_tables` | Lister les tables de la base connectée |
| `describe_table` | Obtenir le schéma d'une table |
| `execute_sql` | Exécuter une requête SQL (lecture seule par défaut) |
| `--config tools.yaml` | Charger des outils personnalisés (NL2SQL sécurisé) |
| `--ui` | Lancer l'interface interactive pour tester les outils |

### chrome-devtools — détails

| Catégorie | Nb outils | Exemples |
|-----------|-----------|----------|
| Input automation | 9 | `click`, `fill`, `fill_form`, `press_key`, `type_text`, `upload_file` |
| Navigation | 6 | `navigate_page`, `new_page`, `select_page`, `wait_for`, `close_page` |
| Emulation | 2 | `emulate`, `resize_page` |
| Performance | 4 | `performance_start_trace`, `performance_stop_trace`, `performance_analyze_insight` |
| Network | 2 | `list_network_requests`, `get_network_request` |
| Debugging | 6 | `evaluate_script`, `take_screenshot`, `lighthouse_audit`, `list_console_messages` |

> Mode slim : ajouter `--slim` pour limiter à 3 outils (navigation, script, screenshot).
> Télémétrie Google désactivée (`--no-usage-statistics`).

---

## MCP Servers cloud

| Server | Status | Notes |
|--------|--------|-------|
| Gmail | connected | Lecture/draft d'emails |
| Google Calendar | needs auth | Nécessite authentification OAuth |
| Figma | failed | Non configuré |

---

## Gestion plugins & MCP

### Plugins

| Commande | Effet |
|----------|-------|
| `claude plugin list` | Lister tous les plugins |
| `claude plugin install <name>@<marketplace> --scope user` | Installer un plugin |
| `claude plugin uninstall <name>@<marketplace> --scope user` | Désinstaller |
| `claude plugin enable <name> --scope user` | Activer |
| `claude plugin disable <name> --scope user` | Désactiver |
| `/reload-plugins` | Recharger en session |

### MCP Servers

| Commande | Effet |
|----------|-------|
| `claude mcp list` | Lister + health check |
| `claude mcp add -s user <name> -- <cmd> [args...]` | Ajouter un serveur |
| `claude mcp remove -s user <name>` | Supprimer un serveur |

---

## Gotchas

### zdiff3 et installs de plugins

Git 2.34.1 ne supporte pas `merge.conflictstyle = zdiff3` (ajouté en 2.35). Certains plugins utilisent `git sparse-checkout` en interne et échouent.
Contournement :
```bash
GIT_CONFIG_GLOBAL=/dev/null claude plugin install <name>@<marketplace> --scope user
```

### semgrep CLI manquant

Le plugin semgrep est installé mais le CLI n'est pas sur la machine. Le MCP échouera tant que `semgrep` n'est pas dans le PATH.
```bash
pipx install semgrep   # ou pip install semgrep
```

### serena needs project config

Serena nécessite un fichier de config projet pour fonctionner. Voir la [doc Serena](https://github.com/oraios/serena) pour le setup par projet.
