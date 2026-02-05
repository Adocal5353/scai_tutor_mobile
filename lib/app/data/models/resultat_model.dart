class ResultatModel {
  final String? id;
  final String? idApprenant;
  final String? idEvaluation;
  final String? dateOuverture;
  final String? dateSoumission;
  final int? tempsPasse; // en secondes
  final double? note;
  final int? rang;
  final String? appreciation;

  ResultatModel({
    this.id,
    this.idApprenant,
    this.idEvaluation,
    this.dateOuverture,
    this.dateSoumission,
    this.tempsPasse,
    this.note,
    this.rang,
    this.appreciation,
  });

  factory ResultatModel.fromJson(Map<String, dynamic> json) {
    return ResultatModel(
      id: json['_id'] ?? json['id'],
      idApprenant: json['id_apprenant'],
      idEvaluation: json['id_evaluation'],
      dateOuverture: json['date_ouverture'],
      dateSoumission: json['date_soumission'],
      tempsPasse: json['temps_passe'],
      note: json['note']?.toDouble(),
      rang: json['rang'],
      appreciation: json['appreciation'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (idApprenant != null) data['id_apprenant'] = idApprenant;
    if (idEvaluation != null) data['id_evaluation'] = idEvaluation;
    if (dateOuverture != null) data['date_ouverture'] = dateOuverture;
    if (dateSoumission != null) data['date_soumission'] = dateSoumission;
    if (tempsPasse != null) data['temps_passe'] = tempsPasse;
    if (note != null) data['note'] = note;
    if (rang != null) data['rang'] = rang;
    if (appreciation != null) data['appreciation'] = appreciation;
    if (id != null) data['id'] = id;

    return data;
  }
}
