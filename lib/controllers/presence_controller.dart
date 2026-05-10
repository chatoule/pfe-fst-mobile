
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../models/presence_model.dart';
import '../services/presence_service.dart';
import '../services/justificatif_service.dart';
import 'auth_controller.dart';

class PresenceController extends GetxController {
  final PresenceService _presenceService = PresenceService();
  final JustificatifService _justificatifService = JustificatifService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var presences = <PresenceModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    chargerPresences();
  }

  // ===== CHARGER LES PRÉSENCES DEPUIS L'API =====
  Future<void> chargerPresences() async {
    final user = AuthController.to.utilisateur.value;
    if (user == null) return;

    isLoading.value = true;
    errorMessage.value = '';

    try {
      final data = await _presenceService.getPresencesEtudiant(user.id);
      presences.assignAll(
        data.map((p) => PresenceModel.fromJson(p)).toList(),
      );
    } catch (e) {
      errorMessage.value = 'Erreur chargement présences : $e';
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ENVOYER UN JUSTIFICATIF VIA L'API =====
  Future<void> envoyerJustificatif({
    required int presenceId,
    required int etudiantId,
    required int seanceId,
    required String motif,
    String? fichierUrl,
  }) async {
    isLoading.value = true;
    try {
      final success = await _justificatifService.soumettreJustificatif(
        etudiantId: etudiantId,
        seanceId: seanceId,
        motif: motif,
        fichierUrl: fichierUrl,
      );

      if (success) {
        // Mettre à jour le statut local en attendant refresh API
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
            estJustifie: false,
            justificatifUrl: fichierUrl,
            statutJustification: 'EN_ATTENTE',
          );
          presences.refresh();
        }

        Get.snackbar(
          'Justificatif envoyé',
          'Votre justificatif a été soumis avec succès.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00855A),
          colorText: Colors.white,
          icon: const Icon(Icons.check_circle, color: Colors.white),
          duration: const Duration(seconds: 3),
        );

        // Recharger depuis l'API pour avoir les données à jour
        await chargerPresences();
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible d\'envoyer le justificatif. Vérifiez la connexion.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue : $e',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    } finally {
      isLoading.value = false;
    }
  }

  // ===== TRAITER UN JUSTIFICATIF (Chef de Département) =====
  // Cette action est côté chef — appel API PUT /justificatifs/{id}/statut
  Future<void> traiterJustificatif(int presenceId, bool estValide) async {
    final index = presences.indexWhere((p) => p.id == presenceId);
    if (index == -1) return;

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
    presences.refresh();

    Get.snackbar(
      estValide ? 'Justificatif validé' : 'Justificatif rejeté',
      'L\'absence de ${p.prenomEtudiant} a été mise à jour.',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: estValide ? Colors.green : Colors.red,
      colorText: Colors.white,
    );
  }

  // ===== CALCULER LES STATISTIQUES =====
  int get nombreAbsencesNonJustifiees =>
      presences.where((p) => p.estAbsencePenalisante).length;

  bool get estEnSessionRattrapage => nombreAbsencesNonJustifiees >= 3;

  double get tauxPresence {
    if (presences.isEmpty) return 0.0;
    final presents = presences.where((p) => p.estPresent).length;
    return (presents / presences.length) * 100;
  }

  List<Map<String, dynamic>> get etudiantsEnSession {
    final Map<int, Map<String, dynamic>> stats = {};
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
    return stats.values.where((e) => e['absences'] >= 3).toList();
  }
}
