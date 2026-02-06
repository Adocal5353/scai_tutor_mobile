class QuestionModel {
  final String? id;
  final String question;
  final String? questionType; // 'qcm', 'vrai_faux', 'redaction'
  final List<String>? options; // Pour QCM
  final String? correctAnswer;
  final int? points;

  QuestionModel({
    this.id,
    required this.question,
    this.questionType = 'qcm',
    this.options,
    this.correctAnswer,
    this.points = 1,
  });

  factory QuestionModel.fromJson(Map<String, dynamic> json) {
    return QuestionModel(
      id: json['id_question']?.toString() ?? json['id']?.toString(),
      question: json['question'] ?? '',
      questionType: json['type_question'] ?? 'qcm',
      options: json['options'] != null
          ? List<String>.from(json['options'])
          : null,
      correctAnswer: json['reponse_correcte']?.toString(),
      points: json['points'] ?? 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_question': id,
      'question': question,
      'type_question': questionType,
      if (options != null) 'options': options,
      if (correctAnswer != null) 'reponse_correcte': correctAnswer,
      'points': points,
    };
  }
}

class QuizModel {
  final String? id;
  final String titre;
  final String? matiere;
  final String? chapitres;
  final String? description;
  final DateTime? dateCreation;
  final DateTime? dateLimite;
  final String? idEnseignant;
  final String? idClasse;
  final bool? createdWithAi; // Pour tracking interne (pas envoyé au backend)
  final List<QuestionModel>? questions;
  final int? dureeMinutes;
  final int? noteMaximale;

  QuizModel({
    this.id,
    required this.titre,
    this.matiere,
    this.chapitres,
    this.description,
    this.dateCreation,
    this.dateLimite,
    this.idEnseignant,
    this.idClasse,
    this.createdWithAi = false,
    this.questions,
    this.dureeMinutes,
    this.noteMaximale,
  });

  factory QuizModel.fromJson(Map<String, dynamic> json) {
    return QuizModel(
      id: json['id_quiz']?.toString() ?? 
          json['id_evaluation']?.toString() ?? 
          json['id']?.toString(),
      titre: json['titre'] ?? '',
      matiere: json['matiere'] ?? json['nom_matiere'],
      chapitres: json['chapitres'] ?? json['chapitres_concernes'],
      description: json['description'],
      dateCreation: json['date_creation'] != null
          ? DateTime.tryParse(json['date_creation'])
          : null,
      dateLimite: json['date_limite'] != null
          ? DateTime.tryParse(json['date_limite'])
          : null,
      idEnseignant: json['id_enseignant']?.toString(),
      idClasse: json['id_classe']?.toString(),
      createdWithAi: json['created_with_ai'] == 1 || json['created_with_ai'] == true,
      questions: json['questions'] != null
          ? (json['questions'] as List)
              .map((q) => QuestionModel.fromJson(q))
              .toList()
          : null,
      dureeMinutes: json['duree_minutes'],
      noteMaximale: json['note_maximale'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_quiz': id,
      'titre': titre,
      if (matiere != null) 'matiere': matiere,
      if (chapitres != null) 'chapitres_concernes': chapitres,
      if (description != null) 'description': description,
      if (dateCreation != null) 'date_creation': dateCreation!.toIso8601String(),
      if (dateLimite != null) 'date_limite': dateLimite!.toIso8601String(),
      if (idEnseignant != null) 'id_enseignant': idEnseignant,
      if (idClasse != null) 'id_classe': idClasse,
      // Ne pas envoyer createdWithAi au backend
      if (questions != null) 'questions': questions!.map((q) => q.toJson()).toList(),
      if (dureeMinutes != null) 'duree_minutes': dureeMinutes,
      if (noteMaximale != null) 'note_maximale': noteMaximale,
    };
  }

  // Calculer la note maximale basée sur les questions
  int get calculatedMaxScore {
    if (questions == null || questions!.isEmpty) return 0;
    return questions!.fold(0, (sum, q) => sum + (q.points ?? 1));
  }
}
