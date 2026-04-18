class PresenceModel {
  final int id;
  final int etudiantId;
  final String nomEtudiant;
  final String prenomEtudiant;
  final int coursId;
  final String dateSeance;
  final String? matiere;
  final bool estPresent;
  final bool estJustifie;
  final String? justificatifUrl;
  final String? statutJustification;
  final String? typeJustificatif;
  final String? motifJustificatif;

  PresenceModel({
    required this.id,
    required this.etudiantId,
    required this.nomEtudiant,
    required this.prenomEtudiant,
    required this.coursId,
    required this.dateSeance,
    this.matiere,
    required this.estPresent,
    this.estJustifie = false,
    this.justificatifUrl,
    this.statutJustification,
    this.typeJustificatif,
    this.motifJustificatif,
  });

  factory PresenceModel.fromJson(Map<String, dynamic> json) {
    return PresenceModel(
      id: json['id'],
      etudiantId: json['etudiantId'],
      nomEtudiant: json['nomEtudiant'],
      prenomEtudiant: json['prenomEtudiant'],
      coursId: json['coursId'],
      dateSeance: json['dateSeance'],
      matiere: json['matiere'],
      estPresent: json['estPresent'],
      estJustifie: json['estJustifie'] ?? false,
      justificatifUrl: json['justificatifUrl'],
      statutJustification: json['statutJustification'],
      typeJustificatif: json['typeJustificatif'],
      motifJustificatif: json['motifJustificatif'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etudiantId': etudiantId,
      'nomEtudiant': nomEtudiant,
      'prenomEtudiant': prenomEtudiant,
      'coursId': coursId,
      'dateSeance': dateSeance,
      'matiere': matiere,
      'estPresent': estPresent,
      'estJustifie': estJustifie,
      'justificatifUrl': justificatifUrl,
      'statutJustification': statutJustification,
      'typeJustificatif': typeJustificatif,
      'motifJustificatif': motifJustificatif,
    };
  }

  bool get estAbsencePenalisante => 
      !estPresent && !estJustifie && statutJustification != 'EN_ATTENTE';
}