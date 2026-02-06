class DemandeInscriptionModel {
  final String? id;
  final String? idApprenant;
  final String? idClasse;
  final String? status; // 'en_attente', 'acceptee', 'refusee'
  final String? motifRefus;
  final String? dateCreation;

  DemandeInscriptionModel({
    this.id,
    this.idApprenant,
    this.idClasse,
    this.status,
    this.motifRefus,
    this.dateCreation,
  });

  factory DemandeInscriptionModel.fromJson(Map<String, dynamic> json) {
    return DemandeInscriptionModel(
      id: json['_id'] ?? json['id'],
      idApprenant: json['id_apprenant'],
      idClasse: json['id_classe'],
      status: json['status'],
      motifRefus: json['motif_refus'],
      dateCreation: json['date_creation'],
    );
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};

    if (idApprenant != null) data['id_apprenant'] = idApprenant;
    if (idClasse != null) data['id_classe'] = idClasse;
    if (status != null) data['status'] = status;
    if (motifRefus != null) data['motif_refus'] = motifRefus;
    if (dateCreation != null) data['date_creation'] = dateCreation;
    if (id != null) data['id'] = id;

    return data;
  }
}
