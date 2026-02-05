class EvaluationModel {
  final String? id;
  final String titre;
  final String? dateCreation;
  final String? chapitresConcernes;
  final String? idEnseignant;
  final String? idMatiere;

  EvaluationModel({
    this.id,
    required this.titre,
    this.dateCreation,
    this.chapitresConcernes,
    this.idEnseignant,
    this.idMatiere,
  });

  factory EvaluationModel.fromJson(Map<String, dynamic> json) {
    return EvaluationModel(
      id: (json['id_evaluation']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString()),
      titre: json['titre'] ?? '',
      dateCreation: json['date_creation'],
      chapitresConcernes: json['chapitres_concernes'],
      idEnseignant: json['id_enseignant'],
      idMatiere: json['id_matiere'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'titre': titre,
    };

    if (dateCreation != null) data['date_creation'] = dateCreation;
    if (chapitresConcernes != null) {
      data['chapitres_concernes'] = chapitresConcernes;
    }
    if (idEnseignant != null) data['id_enseignant'] = idEnseignant;
    if (idMatiere != null) data['id_matiere'] = idMatiere;
    if (id != null) data['id'] = id;

    return data;
  }
}
