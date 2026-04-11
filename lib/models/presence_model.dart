class PresenceModel {
  final int id;
  final int etudiantId;
  final String nomEtudiant;
  final String prenomEtudiant;
  final int coursId;
  final String dateSeance;
  final bool estPresent;

  PresenceModel({
    required this.id,
    required this.etudiantId,
    required this.nomEtudiant,
    required this.prenomEtudiant,
    required this.coursId,
    required this.dateSeance,
    required this.estPresent,
  });

  // JSON → objet Dart
  factory PresenceModel.fromJson(Map<String, dynamic> json) {
    return PresenceModel(
      id: json['id'],
      etudiantId: json['etudiantId'],
      nomEtudiant: json['nomEtudiant'],
      prenomEtudiant: json['prenomEtudiant'],
      coursId: json['coursId'],
      dateSeance: json['dateSeance'],
      estPresent: json['estPresent'],
    );
  }

  // objet Dart → JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'etudiantId': etudiantId,
      'nomEtudiant': nomEtudiant,
      'prenomEtudiant': prenomEtudiant,
      'coursId': coursId,
      'dateSeance': dateSeance,
      'estPresent': estPresent,
    };
  }
}