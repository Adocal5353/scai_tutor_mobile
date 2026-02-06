class Invitation {
  final String? id;
  final String? nom;
  final String? prenom;
  final String? email;
  final String? type;
  final String? idParent;
  final String? statut;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Invitation({
    this.id,
    this.nom,
    this.prenom,
    this.email,
    this.type,
    this.idParent,
    this.statut,
    this.createdAt,
    this.updatedAt,
  });

  factory Invitation.fromJson(Map<String, dynamic> json) {
    return Invitation(
      id: json['_id'] as String? ?? json['id'] as String?,
      nom: json['nom'] as String?,
      prenom: json['prenom'] as String?,
      email: json['email'] as String?,
      type: json['type'] as String?,
      idParent: json['id_parent'] as String?,
      statut: json['statut'] as String?,
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : null,
      updatedAt: json['updated_at'] != null
          ? DateTime.parse(json['updated_at'] as String)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'type': type,
      'id_parent': idParent,
      'statut': statut,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}

class InvitationsList {
  final List<Invitation>? apprenants;
  final List<Invitation>? responsables;

  InvitationsList({
    this.apprenants,
    this.responsables,
  });

  factory InvitationsList.fromJson(Map<String, dynamic> json) {
    return InvitationsList(
      apprenants: json['apprenants'] != null
          ? (json['apprenants'] as List)
              .map((item) => Invitation.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
      responsables: json['responsables'] != null
          ? (json['responsables'] as List)
              .map((item) => Invitation.fromJson(item as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'apprenants': apprenants?.map((item) => item.toJson()).toList(),
      'responsables': responsables?.map((item) => item.toJson()).toList(),
    };
  }
}
