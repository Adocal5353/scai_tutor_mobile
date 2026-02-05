class ResponsableModel {
  final String? id;
  final String nom;
  final String prenom;
  final String email;
  final String? fonction;
  final String? origineCreation; // 'directe' ou 'invitation'
  final String? password;

  ResponsableModel({
    this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    this.fonction,
    this.origineCreation,
    this.password,
  });

  factory ResponsableModel.fromJson(Map<String, dynamic> json) {
    return ResponsableModel(
      id: json['_id'] ?? json['id'],
      nom: json['nom'] ?? '',
      prenom: json['prenom'] ?? '',
      email: json['email'] ?? '',
      fonction: json['fonction'],
      origineCreation: json['origine_creation'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'name': '$prenom $nom',
    };

    if (fonction != null) data['fonction'] = fonction;
    if (origineCreation != null) data['origine_creation'] = origineCreation;
    if (password != null) {
      data['password'] = password;
      data['password_confirmation'] = password;
    }
    if (id != null) data['id'] = id;

    return data;
  }

  String get fullName => '$prenom $nom';
}
