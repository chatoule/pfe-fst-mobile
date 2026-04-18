import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/presence_model.dart';

class PresenceController extends GetxController {
  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var presences = <PresenceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    chargerDonneesFictives();
  }

  void chargerDonneesFictives() {
    presences.value = [
      // L'étudiante Aminata Sow (ID 2 dans AuthController)
      PresenceModel(
        id: 1, etudiantId: 2,
        nomEtudiant: 'Sow', prenomEtudiant: 'Aminata',
        coursId: 1, dateSeance: '2024-03-10', estPresent: true,
      ),
      PresenceModel(
        id: 2, etudiantId: 2,
        nomEtudiant: 'Sow', prenomEtudiant: 'Aminata',
        coursId: 2, dateSeance: '2024-03-12', estPresent: false, estJustifie: false,
      ),
      PresenceModel(
        id: 3, etudiantId: 2,
        nomEtudiant: 'Sow', prenomEtudiant: 'Aminata',
        coursId: 3, dateSeance: '2024-03-14', estPresent: false, estJustifie: false,
      ),
       PresenceModel(
        id: 4, etudiantId: 2,
        nomEtudiant: 'Sow', prenomEtudiant: 'Aminata',
        coursId: 4, dateSeance: '2024-03-15', estPresent: false, estJustifie: false,
      ),
      // Une absence avec justificatif en attente pour Aminata Sow
      PresenceModel(
        id: 5, etudiantId: 2,
        nomEtudiant: 'Sow', prenomEtudiant: 'Aminata',
        coursId: 5, dateSeance: '2024-03-16', estPresent: false, estJustifie: false,
        justificatifUrl: 'certificat_medical_aminata.pdf',
        statutJustification: 'EN_ATTENTE',
      ),
    ];
  }

  // Valider ou Rejeter un justificatif (Action Chef de Département)
  void traiterJustificatif(int presenceId, bool estValide) {
    final index = presences.indexWhere((p) => p.id == presenceId);
    if (index != -1) {
      final p = presences[index];
      presences[index] = PresenceModel(
        id: p.id,
        etudiantId: p.etudiantId,
        nomEtudiant: p.nomEtudiant,
        prenomEtudiant: p.prenomEtudiant,
        coursId: p.coursId,
        dateSeance: p.dateSeance,
        estPresent: p.estPresent,
        estJustifie: estValide,
        justificatifUrl: p.justificatifUrl,
        statutJustification: estValide ? 'VALIDE' : 'REJETE',
      );
      
      presences.refresh(); // Crucial pour mettre à jour l'UI partout
      
      Get.snackbar(
        estValide ? 'Justificatif Validé' : 'Justificatif Rejeté',
        'L\'absence de ${p.prenomEtudiant} a été mise à jour.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: estValide ? Colors.green : Colors.red,
        colorText: Colors.white,
      );
    }
  }

  // Calculer le nombre d'absences non justifiées (pénalisantes)
  int get nombreAbsencesNonJustifiees {
    return presences.where((p) => p.estAbsencePenalisante).length;
  }

  // Vérifier si l'étudiant est envoyé en session de rattrapage
  bool get estEnSessionRattrapage {
    return nombreAbsencesNonJustifiees >= 3;
  }

  // Récupérer la liste des étudiants en session de rattrapage (Groupé par étudiant)
  List<Map<String, dynamic>> get etudiantsEnSession {
    Map<int, Map<String, dynamic>> stats = {};

    for (var p in presences) {
      if (p.estAbsencePenalisante) {
        if (!stats.containsKey(p.etudiantId)) {
          stats[p.etudiantId] = {
            'id': p.etudiantId,
            'nom': p.nomEtudiant,
            'prenom': p.prenomEtudiant,
            'absences': 1,
          };
        } else {
          stats[p.etudiantId]!['absences']++;
        }
      }
    }

    // On ne garde que ceux qui ont >= 3 absences non justifiées
    return stats.values.where((e) => e['absences'] >= 3).toList();
  }

  // Simuler le marquage d'absence par l'enseignant
  void marquerAbsenceEnseignant(PresenceModel nouvellePresence) {
    presences.add(nouvellePresence);
    Get.snackbar(
      'Notification',
      'Une nouvelle absence a été enregistrée pour le cours du ${nouvellePresence.dateSeance}',
      snackPosition: SnackPosition.TOP,
    );
  }

  // Envoyer un justificatif au Chef de Département
  void envoyerJustificatif(int presenceId, String urlFichier) {
    final index = presences.indexWhere((p) => p.id == presenceId);
    if (index != -1) {
      final p = presences[index];
      presences[index] = PresenceModel(
        id: p.id,
        etudiantId: p.etudiantId,
        nomEtudiant: p.nomEtudiant,
        prenomEtudiant: p.prenomEtudiant,
        coursId: p.coursId,
        dateSeance: p.dateSeance,
        estPresent: p.estPresent,
        estJustifie: false, // Reste faux jusqu'à validation du Chef de Dépt
        justificatifUrl: urlFichier,
        statutJustification: 'EN_ATTENTE',
      );
      
      Get.snackbar(
        'Succès',
        'Votre justificatif a été envoyé au Chef de Département pour validation.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF00855A),
        colorText: Colors.white,
      );
    }
  }
}