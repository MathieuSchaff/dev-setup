# 🧒 Ralph & Ralph Wiggum Cheatsheet

Ralph est une méthodologie de développement basée sur une **boucle autonome**. L'IA travaille de manière itérative jusqu'à ce que tous les éléments d'un PRD (Product Requirements Document) soient validés.

---

## 🌀 Le Concept "Ralph"
"Ralph est une boucle Bash" qui lance des instances fraîches de l'IA (Amp ou Claude Code) avec un contexte propre à chaque itération.
- **Mémoire** : Persiste via l'historique Git, `progress.txt` et `prd.json`.
- **Handoff** : Passe le relais à une nouvelle instance quand le contexte est plein.
- **Validation** : S'arrête uniquement quand `passes: true` pour toutes les stories.

---

## 🕹️ Plugin Ralph Wiggum (Claude Code)
Implémente la boucle directement via un **Stop Hook** qui intercepte la fermeture de session et relance le prompt.

### Commande Principale
`/ralph-loop "Description" --completion-promise "DONE" --max-iterations 20`

- `--completion-promise` : La phrase exacte que l'IA doit dire pour arrêter la boucle.
- `--max-iterations` : Sécurité pour éviter les boucles infinies (recommandé).
- `/cancel-ralph` : Arrête manuellement la boucle en cours.

---

## 📋 Workflow Standard
1. **Créer un PRD** : Utiliser `/prd` pour générer les exigences.
2. **Convertir en JSON** : Utiliser `/ralph` pour transformer le markdown en `prd.json`.
3. **Lancer la boucle** :
   ```bash
   # Script Bash original
   ./scripts/ralph/ralph.sh --tool claude 10
   # Ou via le plugin
   /ralph-loop "Implémente prd.json" --completion-promise "COMPLETE"
   ```

---

## 🗃️ Fichiers Clés
| Fichier | Rôle |
| :--- | :--- |
| `prd.json` | La liste des tâches (User Stories) avec leur état de succès. |
| `progress.txt` | Journal d'apprentissage cumulé entre les itérations. |
| `AGENTS.md` | Mis à jour à chaque tour avec les nouveaux patterns découverts. |
| `ralph.sh` | Le moteur de la boucle (si utilisé hors plugin). |

---

## 💡 Meilleures Pratiques
- **Tâches Atomiques** : Chaque story doit être assez petite pour tenir dans une seule fenêtre de contexte (ex: "Ajouter une migration" OK, "Bâtir le dashboard" KO -> à diviser).
- **Boucles de Feedback** : Ralph dépend des tests automatisés et du typecheck. Sans eux, il ne peut pas savoir s'il a réussi.
- **Acceptance Criteria** : Soyez ultra-spécifique. Incluez "Vérifier via le navigateur" pour le frontend.
- **Promesse de Complétion** : Utilisez un tag unique comme `<promise>COMPLETE</promise>` pour éviter les arrêts accidentels.

---

## 🛑 Quand NE PAS utiliser Ralph
- Tâches nécessitant un jugement humain constant ou des décisions de design subjectives.
- Opérations "one-shot" simples.
- Débogage de production complexe sans tests automatisés.
