class ParentModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String? telephone;
  final String? password;

  ParentModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.telephone,
    this.password,
  });

  factory ParentModel.fromJson(Map<String, dynamic> json) {
    return ParentModel(
      id: json['_id'] ?? json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      telephone: json['telephone'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
    };

    if (telephone != null) data['telephone'] = telephone;
    if (password != null) {
      data['password'] = password;
      data['password_confirmation'] = password;
    }
    if (id != null) data['id'] = id;

    return data;
  }

  String get fullName => '$prenom $nom';
}
