class DocumentModel {
  final String? id;
  final String titre;
  final String type; // 'cours', 'exercice', etc.
  final String? matiere;
  final bool estPayant;
  final String? idEnseignant;
  final String? idClasse;
  final String visibilite; // 'public', 'private'
  final double? prix;

  DocumentModel({
    this.id,
    required this.titre,
    required this.type,
    this.matiere,
    this.estPayant = false,
    this.idEnseignant,
    this.idClasse,
    this.visibilite = 'public',
    this.prix,
  });

  factory DocumentModel.fromJson(Map<String, dynamic> json) {
    // Conversion de est_payant: 0/1 (int) vers bool
    bool estPayantValue = false;
    if (json['est_payant'] != null) {
      if (json['est_payant'] is bool) {
        estPayantValue = json['est_payant'];
      } else if (json['est_payant'] is int) {
        estPayantValue = json['est_payant'] == 1;
      } else if (json['est_payant'] is String) {
        estPayantValue = json['est_payant'] == '1' || json['est_payant'].toLowerCase() == 'true';
      }
    }

    return DocumentModel(
      id: (json['id_document']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString()),
      titre: json['titre'] ?? '',
      type: json['type'] ?? '',
      matiere: json['matiere']?.toString(),
      estPayant: estPayantValue,
      idEnseignant: json['id_enseignant']?.toString(),
      idClasse: json['id_classe']?.toString(),
      visibilite: json['visibilite'] ?? 'public',
      prix: json['prix'] != null ? double.tryParse(json['prix'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'titre': titre,
      'type': type,
      'est_payant': estPayant,
      'visibilite': visibilite,
    };

    if (matiere != null) data['matiere'] = matiere;
    if (idEnseignant != null) data['id_enseignant'] = idEnseignant;
    if (idClasse != null) data['id_classe'] = idClasse;
    if (prix != null) data['prix'] = prix;
    if (id != null) data['id'] = id;

    return data;
  }
}
