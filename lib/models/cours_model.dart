class CoursModel {
  final int id;
  final String matiere;
  final String enseignantNom;
  final String enseignantPrenom;
  final String dateSeance;
  final String heureDebut;
  final String heureFin;
  final String salle;
  final String statut;

  CoursModel({
    required this.id,
    required this.matiere,
    required this.enseignantNom,
    required this.enseignantPrenom,
    required this.dateSeance,
    required this.heureDebut,
    required this.heureFin,
    required this.salle,
    required this.statut,
  });

  factory CoursModel.fromJson(Map<String, dynamic> json) {
    return CoursModel(
      id: json['id'],
      matiere: json['matiere'],
      enseignantNom: json['enseignantNom'],
      enseignantPrenom: json['enseignantPrenom'],
      dateSeance: json['dateSeance'],
      heureDebut: json['heureDebut'],
      heureFin: json['heureFin'],
      salle: json['salle'],
      statut: json['statut'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'matiere': matiere,
      'enseignantNom': enseignantNom,
      'enseignantPrenom': enseignantPrenom,
      'dateSeance': dateSeance,
      'heureDebut': heureDebut,
      'heureFin': heureFin,
      'salle': salle,
      'statut': statut,
    };
  }
}