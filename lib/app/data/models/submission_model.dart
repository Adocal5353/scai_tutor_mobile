class SubmissionModel {
  final String? id;
  final String idQuiz;
  final String idApprenant;
  final Map<String, String>? reponses; // id_question -> reponse
  final DateTime? dateSubmission;
  final double? note;
  final String? feedback;

  SubmissionModel({
    this.id,
    required this.idQuiz,
    required this.idApprenant,
    this.reponses,
    this.dateSubmission,
    this.note,
    this.feedback,
  });

  factory SubmissionModel.fromJson(Map<String, dynamic> json) {
    return SubmissionModel(
      id: json['id_submission']?.toString() ?? json['id']?.toString(),
      idQuiz: json['id_quiz']?.toString() ?? '',
      idApprenant: json['id_apprenant']?.toString() ?? '',
      reponses: json['reponses'] != null
          ? Map<String, String>.from(json['reponses'])
          : null,
      dateSubmission: json['date_submission'] != null
          ? DateTime.tryParse(json['date_submission'])
          : null,
      note: json['note']?.toDouble(),
      feedback: json['feedback'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id != null) 'id_submission': id,
      'id_quiz': idQuiz,
      'id_apprenant': idApprenant,
      if (reponses != null) 'reponses': reponses,
      if (dateSubmission != null) 'date_submission': dateSubmission!.toIso8601String(),
      if (note != null) 'note': note,
      if (feedback != null) 'feedback': feedback,
    };
  }
}
