class EnseignantModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String? specialite;
  final String? dateEmbauche;
  final String? password;

  EnseignantModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.specialite,
    this.dateEmbauche,
    this.password,
  });

  factory EnseignantModel.fromJson(Map<String, dynamic> json) {
    return EnseignantModel(
      id: json['_id'] ?? json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
      specialite: json['specialite'],
      dateEmbauche: json['date_embauche'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };

    if (telephone != null) data['telephone'] = telephone;
    if (specialite != null) data['specialite'] = specialite;
    if (dateEmbauche != null) data['date_embauche'] = dateEmbauche;
    if (password != null) {
      data['password'] = password;
      data['password_confirmation'] = password;
    }
    if (id != null) data['id'] = id;

    return data;
  }

  String get fullName => '$prenom $nom';
}
