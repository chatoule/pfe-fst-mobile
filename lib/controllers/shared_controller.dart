import 'package:get/get.dart';
import 'package:flutter/material.dart';

class SharedController extends GetxController {
  static SharedController get to => Get.find();

  // ===== FICHES DE POINTAGE =====
  var fichesPointage = <Map<String, dynamic>>[].obs;

  // ===== SIGNATURES FIN DE SEMESTRE =====
  var signatureSuperviseur = ''.obs;
  var signatureChefDep = ''.obs;
  var semestre = 'S1 - 2025/2026'.obs;

  @override
  void onInit() {
    super.onInit();
    _initDonneesMock();
  }

  void _initDonneesMock() {
    fichesPointage.value = [
      {
        'id': 1,
        'enseignantId': 1,
        'enseignantNom': 'Ali Moussa',
        'matiere': 'Algorithme',  // ← vrai nom
        'dateSeance': '2024-03-15',
        'heureDebut': '08h00',
        'heureFin': '10h00',
        'duree': 120,
        'contenu': 'Introduction aux algorithmes de tri',
        'statut': 'EN_ATTENTE',
        'confirmerSuperviseur': false,
        'valideChefDep': false,
        'dateSoumission': '2024-03-15 10:05',
      },
      {
        'id': 2,
        'enseignantId': 1,
        'enseignantNom': 'Ali Moussa',
        'matiere': 'Structure de Donnees', // ← vrai nom
        'dateSeance': '2024-03-14',
        'heureDebut': '10h00',
        'heureFin': '12h00',
        'duree': 115,
        'contenu': 'Les listes chainees',
        'statut': 'CONFIRME',
        'confirmerSuperviseur': true,
        'valideChefDep': false,
        'dateSoumission': '2024-03-14 12:10',
      },
      {
        'id': 3,
        'enseignantId': 1,
        'enseignantNom': 'Ali Moussa',
        'matiere': 'Programmation Java', // ← vrai nom
        'dateSeance': '2024-03-13',
        'heureDebut': '14h00',
        'heureFin': '16h00',
        'duree': 110,
        'contenu': 'Programmation orientee objet',
        'statut': 'VALIDE',
        'confirmerSuperviseur': true,
        'valideChefDep': true,
        'dateSoumission': '2024-03-13 16:05',
      },
    ];
  }
  // ===== SUPERVISEUR CONFIRME =====
  void confirmerParSuperviseur(int ficheId) {
    final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
    if (index != -1) {
      final fiche = Map<String, dynamic>.from(fichesPointage[index]);
      fiche['confirmerSuperviseur'] = true;
      fiche['statut'] = fiche['valideChefDep'] == true ? 'VALIDE' : 'CONFIRME';
      fichesPointage[index] = fiche;
      fichesPointage.refresh();
    }
  }

  // ===== CHEF DEP VALIDE =====
  void validerParChefDep(int ficheId) {
    final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
    if (index != -1) {
      final fiche = Map<String, dynamic>.from(fichesPointage[index]);
      fiche['valideChefDep'] = true;
      fiche['statut'] = fiche['confirmerSuperviseur'] == true ? 'VALIDE' : 'EN_ATTENTE_SUPERVISEUR';
      fichesPointage[index] = fiche;
      fichesPointage.refresh();
    }
  }

  // ===== REJETER =====
  void rejeterFiche(int ficheId, String par) {
    final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
    if (index != -1) {
      final fiche = Map<String, dynamic>.from(fichesPointage[index]);
      fiche['statut'] = 'REJETE';
      fiche['rejeterPar'] = par;
      fichesPointage[index] = fiche;
      fichesPointage.refresh();
    }
  }

  // ===== SIGNER FIN DE SEMESTRE =====
  void signerSuperviseur(String signature) {
    signatureSuperviseur.value = signature;
  }

  void signerChefDep(String signature) {
    signatureChefDep.value = signature;
  }

  // ===== STATS =====
  int get totalSeances => fichesPointage.length;
  int get seancesConfirmees => fichesPointage.where((f) => f['confirmerSuperviseur'] == true).length;
  int get seancesValidees => fichesPointage.where((f) => f['statut'] == 'VALIDE').length;
  int get seancesEnAttente => fichesPointage.where((f) => f['statut'] == 'EN_ATTENTE').length;
}