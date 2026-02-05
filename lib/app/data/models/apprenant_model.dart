class ApprenantModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String? niveauScolaire;
  final String? dateInscription;
  final String? origineCreation; // 'directe' ou 'invitation'
  final String? password;
  final String? idClasse;

  ApprenantModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.niveauScolaire,
    this.dateInscription,
    this.origineCreation,
    this.password,
    this.idClasse,
  });

  factory ApprenantModel.fromJson(Map<String, dynamic> json) {
    return ApprenantModel(
      id: (json['id_apprenant']?.toString() ?? json['_id']?.toString() ?? json['id']?.toString()),
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      niveauScolaire: json['niveau_scolaire'],
      dateInscription: json['date_inscription'],
      origineCreation: json['origine_creation'],
      idClasse: json['id_classe']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };

    if (niveauScolaire != null) data['niveau_scolaire'] = niveauScolaire;
    if (dateInscription != null) data['date_inscription'] = dateInscription;
    if (origineCreation != null) data['origine_creation'] = origineCreation;
    if (password != null) {
      data['password'] = password;
      data['password_confirmation'] = password;
    }
    if (id != null) data['id'] = id;
    if (idClasse != null) data['id_classe'] = idClasse;

    return data;
  }

  String get fullName => '$prenom $nom';
}
