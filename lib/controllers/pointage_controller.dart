// lib/controllers/pointage_controller.dart

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import '../services/pointage_service.dart';
import '../services/seance_service.dart';
import 'auth_controller.dart';
import 'shared_controller.dart';

class PointageController extends GetxController {
  final PointageService _pointageService = PointageService();
  final SeanceService _seanceService = SeanceService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var seancesList = <dynamic>[].obs;
  var totalHeuresMois = 0.0.obs;
  var seancesPointees = 0.obs;

  @override
  void onInit() {
    super.onInit();
    chargerDonnees();
  }

  Future<void> chargerDonnees() async {
    final user = AuthController.to.utilisateur.value;
    if (user != null) {
      await chargerSeancesEnseignant(user.id);
    }
  }

  Future<void> chargerSeancesEnseignant(int enseignantId) async {
    isLoading.value = true;
    errorMessage.value = '';
    try {
      final res = await _seanceService.getSeancesEnseignant(enseignantId);
      seancesList.assignAll(res);
      calculerStatistiques();
    } catch (e) {
      errorMessage.value = 'Erreur lors du chargement des séances: $e';
    } finally {
      isLoading.value = false; // ✅ CORRIGÉ : une seule assignation, pas deux
    }
  }

  void calculerStatistiques() {
    seancesPointees.value = seancesList
        .where((s) =>
    s['statutPointage'] == 'TERMINE' ||
        s['statutPointage'] == 'VALIDE')
        .length;
    totalHeuresMois.value = seancesPointees.value * 2.0;
  }

  Future<void> effectuerPointage({
    required int seanceId,
    required String heureDebut,
    required String heureFin,
    String? contenu,
  }) async {
    final user = AuthController.to.utilisateur.value;
    if (user == null) return;

    isLoading.value = true;
    try {
      final success = await _pointageService.creerPointage(
        date: DateTime.now().toString().split(' ')[0],
        seanceId: seanceId,
        enseignantId: user.id,
        heureDebut: heureDebut, // ✅ la conversion se fait dans PointageService
        heureFin: heureFin,
        contenu: contenu,
      );

      if (success) {
        Get.snackbar(
          'Succès',
          'Pointage effectué avec succès',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: const Color(0xFF00855A),
          colorText: Colors.white,
        );
        await chargerDonnees();
        SharedController.to.rafraichirDonnees();
      } else {
        Get.snackbar(
          'Erreur',
          'Échec du pointage. Vérifiez la connexion au serveur.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Une erreur est survenue: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
