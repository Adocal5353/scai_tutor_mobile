# Système de Quiz et Devoirs avec IA - Documentation

## 📋 Vue d'ensemble

Système complet de quiz et devoirs intégré avec l'IA pour l'application SCAI Tutor Mobile. Les enseignants peuvent créer des quiz avec l'aide de l'IA, et les étudiants peuvent les résoudre avec assistance IA en temps réel.

---

## 🎯 Fonctionnalités Implémentées

### Pour les Enseignants

#### 1. **Création de Quiz avec IA**
- **Module**: `create_quiz`
- **Route**: `/create-quiz`
- **Fonctionnalités**:
  - ✅ Mode manuel: Création classique de quiz
  - ✅ Mode IA: Génération automatique de questions
  - ✅ Paramètres configurables:
    - Nombre de questions (1-50)
    - Niveau de difficulté (facile, moyen, difficile)
    - Matière et chapitres
  - ✅ Prévisualisation des questions générées
  - ✅ Support QCM et questions ouvertes

#### 2. **Attribution de Devoirs/Quiz**
- **Module**: `assign_homework` (amélioré)
- **Route**: `/assign-homework`
- **Fonctionnalités**:  - ✅ Liste combinée des quiz et évaluations
  - ✅ Attribution de quiz aux classes
  - ✅ Sélection interactive de classe
  - ✅ Chargement de documents payants

### Pour les Étudiants

#### 1. **Liste des Quiz**
- **Module**: `student_quiz`
- **Route**: `/student-quiz`
- **Fonctionnalités**:
  - ✅ Affichage de tous les quiz disponibles
  - ✅ Filtrage: Tous / En cours / Terminés
  - ✅ Informations détaillées:
    - Nombre de questions
    - Durée estimée
    - Date limite
    - Statut
  - ✅ Navigation fluide vers les détails

#### 2. **Résolution de Quiz avec Aide IA**
- **Module**: `quiz_detail`
- **Route**: `/quiz-detail`
- **Fonctionnalités**:
  - ✅ Interface intuitive question par question
  - ✅ Barre de progression
  - ✅ **Aide IA en temps réel**:
    - Bouton d'aide pour chaque question
    - L'IA guide sans donner la réponse directe
    - Explications contextuelles
  - ✅ Support QCM et réponses libres
  - ✅ Sauvegarde automatique des réponses
  - ✅ Soumission avec confirmation

#### 3. **Accès Rapide depuis le Dashboard**
- ✅ Bouton "Mes Quiz" sur le tableau de bord étudiant
- ✅ Design moderne avec gradient
- ✅ Statistiques visuelles

---

## 🗂️ Architecture

### Modèles de Données

#### `QuestionModel` (`quiz_model.dart`)
```dart
- id: String
- question: String
- questionType: String ('qcm', 'vrai_faux', 'redaction')
- options: List<String>
- correctAnswer: String
- points: int
```

#### `QuizModel` (`quiz_model.dart`)
```dart
- id: String
- titre: String
- matiere: String
- chapitres: String
- dateCreation: DateTime
- dateLimite: DateTime
- idEnseignant: String
- idClasse: String
- createdWithAi: bool (tracking interne)
- questions: List<QuestionModel>
- dureeMinutes: int
- noteMaximale: int
```

#### `SubmissionModel` (`submission_model.dart`)
```dart
- id: String
- idQuiz: String
- idApprenant: String
- reponses: Map<String, String>
- dateSubmission: DateTime
- note: double
- feedback: String
```

### Providers

#### `QuizProvider` (`quiz_provider.dart`)
Endpoints API:
- `GET /api/quizzes` - Liste des quiz
- `GET /api/quizzes/{id}` - Quiz par ID
- `POST /api/quizzes` - Créer un quiz
- `POST /api/quizzes/generate` - Générer avec IA
- `PUT /api/quizzes/{id}` - Mettre à jour
- `DELETE /api/quizzes/{id}` - Supprimer
- `GET /api/quizzes/classe/{id_classe}` - Quiz d'une classe
- `GET /api/quizzes/apprenant/{id_apprenant}` - Quiz d'un étudiant
- `POST /api/quizzes/{id}/submit` - Soumettre un quiz
- `POST /api/quizzes/{id}/assign` - Assigner à une classe

#### `AiProvider` (amélioré)
- `POST /api/ai/ask` - Poser une question à l'IA
- `POST /api/ai/generate-quiz` - Générer un quiz

---

## 🎨 Interface Utilisateur

### Thème & Couleurs
- **Bleu foncé**: `SC_ThemeColors.darkBlue` - Actions principales
- **Vert**: `SC_ThemeColors.normalGreen` - Succès, validation
- **Bleu clair**: `SC_ThemeColors.lightBlue` - Fond, aide IA
- **Gris clair**: `#F2F5F8` - Fond général

### Composants Clés

#### Create Quiz View
- Switch pour mode IA
- Formulaire adaptatif selon le mode
- Sélection de matière avec ajout rapide
- Indicateur de questions générées

#### Student Quiz View
- Chips de filtrage
- Cards de quiz avec icônes
- Pull-to-refresh
- États vides élégants

#### Quiz Detail View
- Progress bar
- Section aide IA pliable/dépliable
- Options radio stylisées (A, B, C, D)
- Boutons de navigation contextuels

---

## 🔄 Flux de Travail

### Création et Attribution de Quiz

```
Enseignant
    ↓
Créer Quiz (mode manuel ou IA)
    ↓
[Si IA] Générer questions → Prévisualiser → Valider
    ↓
[Si manuel] Saisir infos → Créer
    ↓
assign_homework → Sélectionner Quiz
    ↓
Choisir Classe → Assigner
    ↓
Quiz disponible pour les étudiants
```

### Résolution de Quiz par l'Étudiant

```
Étudiant
    ↓
Dashboard → "Mes Quiz"
    ↓
student_quiz → Voir liste
    ↓
Sélectionner Quiz
    ↓
quiz_detail → Répondre question par question
    ↓
[Besoin d'aide] → Bouton Aide IA → Recevoir indices
    ↓
Soumettre → Confirmation
    ↓
Quiz enregistré
```

---

## 📡 Endpoints Backend Requis

### Quiz Management
```
GET    /api/quizzes                        - Liste tous les quiz
GET    /api/quizzes/{id}                   - Quiz spécifique
POST   /api/quizzes                        - Créer quiz manuel
POST   /api/quizzes/generate               - Générer quiz avec IA
PUT    /api/quizzes/{id}                   - Modifier quiz
DELETE /api/quizzes/{id}                   - Supprimer quiz
GET    /api/quizzes/classe/{id_classe}     - Quiz d'une classe
GET    /api/quizzes/apprenant/{id}         - Quiz d'un étudiant
POST   /api/quizzes/{id}/submit            - Soumettre réponses
POST   /api/quizzes/{id}/assign            - Assigner à classe
GET    /api/quizzes/{id}/submissions       - Voir soumissions
```

### IA Assistance
```
POST   /api/ai/ask                         - Question à l'IA
POST   /api/ai/generate-quiz               - Générer quiz
```

#### Format de Requête - Génération Quiz
```json
{
  "matiere": "Mathématiques",
  "chapitres": "Chapitre 1, Chapitre 2",
  "nombre_questions": 10,
  "niveau": "moyen"
}
```

#### Format de Réponse - Génération Quiz
```json
{
  "questions": [
    {
      "question": "Quelle est la formule du théorème de Pythagore?",
      "type_question": "qcm",
      "options": ["a² + b² = c²", "a + b = c", "a² - b² = c²", "a × b = c"],
      "reponse_correcte": "a² + b² = c²",
      "points": 1
    }
  ]
}
```

#### Format de Requête - Aide IA
```json
{
  "text": "Je suis en train de répondre à cette question...",
  "temperature": 0.7
}
```

#### Format de Soumission Quiz
```json
{
  "id_apprenant": "123",
  "reponses": {
    "question_id_1": "réponse_1",
    "question_id_2": "réponse_2"
  },
  "date_submission": "2026-02-06T10:30:00.000Z"
}
```

---

## 🔐 Sécurité & Confidentialité

### Protection des Données
- ✅ Les quiz créés avec IA ne sont **pas marqués** côté étudiant
- ✅ Le champ `createdWithAi` est utilisé uniquement en interne (non envoyé au backend)
- ✅ Les étudiants ne peuvent pas distinguer un quiz IA d'un quiz manuel

### Authentification
- ✅ Toutes les routes utilisent `UserService` pour l'authentification
- ✅ Vérification de l'ID enseignant/étudiant avant chaque action
- ✅ Token Bearer dans les headers API

---

## 🚀 Routes GetX

### Routes Ajoutées
```dart
Routes.STUDENT_QUIZ  = '/student-quiz'
Routes.QUIZ_DETAIL   = '/quiz-detail'
```

### Bindings
- `StudentQuizBinding`
- `QuizDetailBinding`
- `CreateQuizBinding` (amélioré)

---

## 📝 Points Importants

### Pour les Développeurs Backend

1. **L'endpoint `/api/ai/generate-quiz` doit retourner des questions structurées**
   - Format JSON avec tableau de questions
   - Chaque question doit avoir: question, type, options, réponse correcte

2. **L'endpoint `/api/ai/ask` doit adapter sa réponse**
   - Pour l'aide quiz: donner des indices, ne pas révéler la réponse
   - Température recommandée: 0.7 pour de la créativité modérée

3. **Gestion des soumissions**
   - Stocker les réponses de l'étudiant
   - Calculer la note automatiquement
   - Permettre la consultation ultérieure

### Pour les Tests

1. **Tester la génération IA**:
   - Matière: "Mathématiques"
   - Chapitres: "Algèbre, Géométrie"
   - Nombre: 5
   - Niveau: "moyen"

2. **Tester l'aide IA**:
   - Sélectionner une question
   - Cliquer sur icône aide
   - Vérifier que la réponse est un indice, pas la solution

3. **Tester l'attribution**:
   - Créer un quiz
   - Aller dans assign_homework
   - Sélectionner le quiz
   - Choisir une classe

---

## ✅ Checklist de Déploiement

- [x] Modèles de données créés
- [x] Providers implémentés
- [x] Routes configurées
- [x] UI enseignant (création avec IA)
- [x] UI étudiant (liste + détail)
- [x] Aide IA intégrée
- [x] Navigation depuis dashboard
- [x] Attribution aux classes
- [ ] Tests backend endpoints
- [ ] Tests E2E flux complet
- [ ] Documentation API backend

---

## 🎓 Utilisation

### Créer un Quiz avec IA (Enseignant)

1. Aller dans "Assigner des devoirs"
2. Cliquer "Donner des quiz pratiques"
3. Activer le switch "Générer avec l'IA"
4. Remplir: matière, chapitres, nombre de questions, difficulté
5. Cliquer "Générer les Questions"
6. Vérifier les questions générées
7. Sélectionner date limite
8. Cliquer "Créer le Quiz"
9. Assigner à une classe depuis assign_homework

### Résoudre un Quiz (Étudiant)

1. Dashboard → "Mes Quiz"
2. Sélectionner un quiz
3. Répondre aux questions
4. Si besoin d'aide: cliquer sur l'icône aide (en haut à droite)
5. Lire les indices de l'IA
6. Soumettre le quiz

---

## 🐛 Troubleshooting

### Quiz ne s'affiche pas pour l'étudiant
- Vérifier que le quiz a bien été assigné à la classe de l'étudiant
- Vérifier `id_classe` dans la base de données

### Aide IA ne fonctionne pas
- Vérifier endpoint `/api/ai/ask`
- Vérifier le format de la requête (text, temperature)
- Vérifier les logs backend

### Questions non générées
- Vérifier endpoint `/api/ai/generate-quiz`
- Vérifier les paramètres envoyés
- Vérifier que le provider AI est correctement initialisé

---

## 📞 Support

Pour toute question ou problème, vérifier:
1. Les logs du provider concerné (console Flutter)
2. Les erreurs Get.snackbar affichées
3. Les réponses API dans les logs réseau

---

**Développé avec ❤️ pour SCAI Tutor Mobile**
