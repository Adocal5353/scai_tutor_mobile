class MatiereModel {
  final String? id;
  final String nomMatiere;

  MatiereModel({
    this.id,
    required this.nomMatiere,
  });

  factory MatiereModel.fromJson(Map<String, dynamic> json) {
    return MatiereModel(
      id: (json['id_matiere']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString()),
      nomMatiere: json['nom_matiere'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom_matiere': nomMatiere,
    };

    if (id != null) data['id'] = id;

    return data;
  }
}
