class ClasseModel {
  final String? id;
  final String nomClasse;
  final String? niveauScolaire;
  final String? idEnseignant;
  final List<String>? apprenantsIds;

  ClasseModel({
    this.id,
    required this.nomClasse,
    this.niveauScolaire,
    this.idEnseignant,
    this.apprenantsIds,
  });

  factory ClasseModel.fromJson(Map<String, dynamic> json) {
    return ClasseModel(
      id: json['_id'] ?? json['id'],
      nomClasse: json['nom_classe'] ?? '',
      niveauScolaire: json['niveau_scolaire'],
      idEnseignant: json['id_enseignant'],
      apprenantsIds: json['apprenants_ids'] != null
          ? List<String>.from(json['apprenants_ids'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom_classe': nomClasse,
    };

    if (niveauScolaire != null) data['niveau_scolaire'] = niveauScolaire;
    if (idEnseignant != null) data['id_enseignant'] = idEnseignant;
    if (apprenantsIds != null) data['apprenants_ids'] = apprenantsIds;
    if (id != null) data['id'] = id;

    return data;
  }
}
