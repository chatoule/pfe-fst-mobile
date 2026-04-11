class UserModel {
  final int id;
  final String nom;
  final String prenom;
  final String email;
  final String role;
  final String token;

  UserModel({
    required this.id,
    required this.nom,
    required this.prenom,
    required this.email,
    required this.role,
    required this.token,
  });

  // Convertir le JSON reçu de l'API en objet Dart
  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      role: json['role'],
      token: json['token'],
    );
  }

  // Convertir l'objet Dart en JSON pour envoyer à l'API
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'nom': nom,
      'prenom': prenom,
      'email': email,
      'role': role,
      'token': token,
    };
  }
}