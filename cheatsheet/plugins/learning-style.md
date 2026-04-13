# 🎓 Learning Style Plugin Cheatsheet

Ce plugin combine le mode **Apprentissage Actif** et le mode **Explicatif**. Il transforme l'IA en un mentor qui vous encourage à écrire les parties les plus significatives du code tout en expliquant les choix d'implémentation.

## 🌟 Philosophie
Au lieu de tout automatiser, l'IA :
- Identifie les points de décision critiques.
- Vous demande d'écrire 5 à 10 lignes de code métier.
- Fournit des insights éducatifs sur les patterns de votre propre codebase.

---

## 🛠️ Fonctionnement

### Mode Apprentissage (Interactif)
L'IA s'arrête et vous demande de contribuer pour :
- **La logique métier** avec plusieurs approches valides.
- **La gestion d'erreurs** (stratégies de retry, fallback).
- **Le choix d'algorithmes** ou de structures de données.
- **L'expérience utilisateur** (UX) et les décisions de design.

**Ce qu'elle fait seule** : Boilerplate, configuration, CRUD simple, code répétitif.

### Mode Explicatif (Insights)
L'IA insère des encadrés structurés pour expliquer les choix techniques :

`★ Insight ─────────────────────────────────────`
- Points clés sur l'implémentation choisie.
- Conventions spécifiques à votre projet.
- Compromis (trade-offs) et décisions de design.
`─────────────────────────────────────────────────`

---

## 💡 Exemple d'Interaction
**Claude** : *"J'ai configuré le middleware d'auth. Pour le timeout, préférez-vous une extension auto de la session ou un timeout strict ? Implémentez `handleSessionTimeout()` dans `auth/middleware.ts` pour définir ce comportement."*

**Vous** : *[Vous écrivez les 10 lignes de logique]*

---

## ✅ Avantages & Précautions
- **Apprentissage** : Vous gardez la maîtrise des décisions architecturales.
- **Connaissance** : Les insights ciblent votre code réel, pas des concepts généraux.
- **Attention** : Ce plugin augmente la consommation de tokens car les instructions sont plus denses et les échanges plus nombreux.

---

## 🚀 Activation
Le plugin s'active automatiquement via un hook `SessionStart`. Il ne nécessite aucune commande manuelle une fois installé.
