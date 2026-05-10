

import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/presence_model.dart';
import '../services/module_service.dart';
import '../services/seance_service.dart';
import '../services/pointage_service.dart';
import '../services/presence_service.dart';
import 'auth_controller.dart';

class SharedController extends GetxController {
  static SharedController get to => Get.find();

  final ModuleService _moduleService = ModuleService();
  final SeanceService _seanceService = SeanceService();
  final PointageService _pointageService = PointageService();
  final PresenceService _presenceService = PresenceService();

  // ===== ÉTATS OBSERVABLES =====
  var departements = ['Tous les départements'].obs;
  var selectedDepartement = 'Tous les départements'.obs;
  var fichesPointage = <Map<String, dynamic>>[].obs;
  var presences = <PresenceModel>[].obs;
  var rattrapages = <Map<String, String>>[].obs;
  var anticipations = <Map<String, String>>[].obs;
  var supportsDeCours = <Map<String, dynamic>>[].obs;
  var coursDuJour = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  var etudiantsEnSession = <Map<String, dynamic>>[].obs;

  // ===== SIGNATURES =====
  var signatureSuperviseur = Rx<Uint8List?>(null);
  var signatureChefDep = Rx<Uint8List?>(null);
  var signatureDoyen = Rx<Uint8List?>(null);
  var nomChefDep = 'Ibrahim Seyni Hassimi'.obs;
  var nomSuperviseur = 'Mubarak'.obs;
  var nomDoyen = 'Dr. Ibrahim Oumarou Amadou'.obs;
  var semestre = 'Semestre 2 (2023-2024)'.obs;

  @override
  void onInit() {
    super.onInit();
    rafraichirDonnees();
  }

  // ===== RÉCUPÉRATION DÉPARTEMENT DE L'UTILISATEUR =====
  int get _departementId {
    // TODO: remplacer par user.departementId quand disponible dans UserModel
    return 1;
  }

  // ===== APPELS API =====
  Future<void> rafraichirDonnees() async {
    isLoading.value = true;
    try {
      // 1. Modules et départements
      final modules = await _moduleService.getAllModules();
      Set<String> deps = {'Tous les départements'};
      for (var m in modules) {
        if (m['departementNom'] != null) {
          deps.add(m['departementNom']);
        }
      }
      departements.value = deps.toList();

      // 2. Séances d'aujourd'hui
      final seances = await _seanceService.getSeancesAujourdhui(_departementId);
      coursDuJour.value = List<Map<String, dynamic>>.from(seances);

      // 3. Pointages en attente
      final pointages = await _pointageService.getPointagesEnAttente();
      fichesPointage.value = List<Map<String, dynamic>>.from(pointages);

      // 4. ✅ CORRIGÉ : Charger les présences de l'étudiant connecté si rôle ETUDIANT
      final user = Get.find<AuthController>().utilisateur.value;
      if (user != null) {
        final mesPresences = await _presenceService.getPresencesEtudiant(user.id);
        presences.value = mesPresences
            .map((p) => PresenceModel.fromJson(p as Map<String, dynamic>))
            .toList();
        _actualiserListeRouge();
      }
    } catch (e) {
      print("Erreur rafraichirDonnees: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ===== FICHES POINTAGE =====
  // ⚠️ NOTE : soumettreFiche est local uniquement — le vrai pointage se fait
  // via PointageController.effectuerPointage() qui appelle l'API
  void soumettreFiche(Map<String, dynamic> fiche) {
    fichesPointage.add({
      'id': fichesPointage.length + 1,
      ...fiche,
      'statut': 'EN_ATTENTE',
      'confirmerSuperviseur': false,
      'valideChefDep': false,
      'dateSoumission': DateTime.now().toString(),
    });
  }

  Future<void> confirmerParSuperviseur(int ficheId) async {
    isLoading.value = true;
    try {
      final success = await _pointageService.updateStatut(ficheId, 'CONFIRME');
      if (success) {
        final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
        if (index != -1) {
          final fiche = Map<String, dynamic>.from(fichesPointage[index]);
          fiche['confirmerSuperviseur'] = true;
          fiche['statut'] = 'CONFIRME';
          fichesPointage[index] = fiche;
          fichesPointage.refresh();
        }
        Get.snackbar(
          'Succès',
          'Séance confirmée avec succès.',
          backgroundColor: const Color(0xFF00855A),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        // ✅ CORRIGÉ : snackbar si endpoint non disponible
        Get.snackbar(
          'Fonctionnalité en attente',
          'La confirmation sera disponible dès que le backend est prêt.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> validerParChefDep(int ficheId) async {
    isLoading.value = true;
    try {
      final success = await _pointageService.updateStatut(ficheId, 'VALIDE');
      if (success) {
        final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
        if (index != -1) {
          final fiche = Map<String, dynamic>.from(fichesPointage[index]);
          fiche['valideChefDep'] = true;
          fiche['statut'] = 'VALIDE';
          fichesPointage[index] = fiche;
          fichesPointage.refresh();
        }
        Get.snackbar(
          'Succès',
          'Pointage validé avec succès.',
          backgroundColor: const Color(0xFF00855A),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.verified, color: Colors.white),
        );
      } else {
        // ✅ CORRIGÉ : snackbar si PUT /pointages/{id}/statut manquant
        Get.snackbar(
          'Fonctionnalité en attente',
          'Validation disponible dès que PUT /pointages/{id}/statut est créé par Dayyanatou.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> rejeterFiche(int ficheId, String initiateur) async {
    isLoading.value = true;
    try {
      final success = await _pointageService.updateStatut(
        ficheId,
        'REJETE',
        motif: 'Rejeté par $initiateur',
      );
      if (success) {
        final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
        if (index != -1) {
          final fiche = Map<String, dynamic>.from(fichesPointage[index]);
          fiche['statut'] = 'REJETE';
          fiche['motifRejet'] = 'Rejeté par $initiateur';
          fichesPointage[index] = fiche;
          fichesPointage.refresh();
        }
        Get.snackbar(
          'Rejeté',
          'Pointage rejeté.',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      } else {
        // ✅ CORRIGÉ : snackbar si endpoint manquant
        Get.snackbar(
          'Fonctionnalité en attente',
          'Le rejet sera disponible dès que le backend est prêt.',
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          icon: const Icon(Icons.info_outline, color: Colors.white),
        );
      }
    } finally {
      isLoading.value = false;
    }
  }

  // ===== PRÉSENCES =====
  void marquerPresence(
      int etudiantId,
      int seanceId,
      bool estPresent,
      String dateSeance,
      String matiere,
      String nom,
      String prenom,
      ) {
    final index = presences.indexWhere(
            (p) => p.etudiantId == etudiantId && p.matiere == matiere);
    if (index != -1) {
      presences[index] = PresenceModel(
        id: presences[index].id,
        etudiantId: etudiantId,
        nomEtudiant: nom,
        prenomEtudiant: prenom,
        coursId: seanceId,
        dateSeance: dateSeance,
        matiere: matiere,
        estPresent: estPresent,
        justificatifUrl: presences[index].justificatifUrl,
        motifJustificatif: presences[index].motifJustificatif,
        typeJustificatif: presences[index].typeJustificatif,
        statutJustification: presences[index].statutJustification,
      );
    } else {
      presences.add(PresenceModel(
        id: presences.length + 1,
        etudiantId: etudiantId,
        nomEtudiant: nom,
        prenomEtudiant: prenom,
        coursId: seanceId,
        dateSeance: dateSeance,
        matiere: matiere,
        estPresent: estPresent,
      ));
    }
    presences.refresh();

    // Envoi à l'API en arrière-plan
    if (seanceId > 0) {
      _presenceService
          .marquerPresence(
        datePresence: dateSeance,
        estPresent: estPresent,
        etudiantId: etudiantId,
        seanceId: seanceId,
      )
          .then((success) {
        if (!success) {
          Get.snackbar(
            'Avertissement',
            'Présence enregistrée localement mais non synchronisée avec le serveur.',
            backgroundColor: Colors.orange,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      });
    }
    _actualiserListeRouge();
  }

  // ===== RATTRAPAGE =====
  Future<void> ajouterRattrapage(
      String matiere, String date, String heure, String salle) async {
    isLoading.value = true;
    try {
      final user = Get.find<AuthController>().utilisateur.value;
      if (user == null) return;

      final modules = await _moduleService.getAllModules();
      final module = modules.firstWhere(
            (m) => m['intitule'] == matiere,
        orElse: () => modules.isNotEmpty ? modules[0] : {'id': 1},
      );

      String heureDebut = heure;
      String heureFin = heure;
      if (heure.contains('-')) {
        heureDebut = heure.split('-').first.trim();
        heureFin = heure.split('-').last.trim();
      }

      final success = await _seanceService.creerSeance(
        dateSeance: date,
        heureDebut: heureDebut,
        heureFin: heureFin,
        typeSeance: 'RATTRAPAGE',
        enseignantId: user.id,
        moduleId: module['id'],
        salleId: 1,
      );

      if (success) {
        rattrapages.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'matiere': matiere,
          'date': date,
          'heure': heure,
          'salle': salle,
          'statut': 'EN_ATTENTE',
        });
        rattrapages.refresh();
      } else {
        Get.snackbar('Erreur', 'Impossible de créer le rattrapage sur le serveur.',
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Erreur ajouterRattrapage: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // ===== ANTICIPATION =====
  Future<void> ajouterAnticipation(
      String matiere, String date, String heure, String salle) async {
    isLoading.value = true;
    try {
      final user = Get.find<AuthController>().utilisateur.value;
      if (user == null) return;

      final modules = await _moduleService.getAllModules();
      final module = modules.firstWhere(
            (m) => m['intitule'] == matiere,
        orElse: () => modules.isNotEmpty ? modules[0] : {'id': 1},
      );

      String heureDebut = heure;
      String heureFin = heure;
      if (heure.contains('-')) {
        heureDebut = heure.split('-').first.trim();
        heureFin = heure.split('-').last.trim();
      }

      final success = await _seanceService.creerSeance(
        dateSeance: date,
        heureDebut: heureDebut,
        heureFin: heureFin,
        typeSeance: 'ANTICIPATION',
        enseignantId: user.id,
        moduleId: module['id'],
        salleId: 1,
      );

      if (success) {
        anticipations.add({
          'id': DateTime.now().millisecondsSinceEpoch.toString(),
          'matiere': matiere,
          'date': date,
          'heure': heure,
          'salle': salle,
          'statut': 'PLANIFIE',
        });
        anticipations.refresh();
      } else {
        Get.snackbar('Erreur', "Impossible de créer l'anticipation sur le serveur.",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    } catch (e) {
      print("Erreur ajouterAnticipation: $e");
    } finally {
      isLoading.value = false;
    }
  }

  void validerRattrapage(String id) {
    final index = rattrapages.indexWhere((r) => r['id'] == id);
    if (index != -1) {
      var r = Map<String, String>.from(rattrapages[index]);
      r['statut'] = 'VALIDE';
      rattrapages[index] = r;
      rattrapages.refresh();
    }
  }

  void rejeterRattrapage(String id) {
    final index = rattrapages.indexWhere((r) => r['id'] == id);
    if (index != -1) {
      var r = Map<String, String>.from(rattrapages[index]);
      r['statut'] = 'REJETE';
      rattrapages[index] = r;
      rattrapages.refresh();
    }
  }

  // ===== SUPPORTS =====
  void ajouterSupport(String titre, String matiere, String type, String taille,
      {String? path}) {
    supportsDeCours.add({
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'titre': titre,
      'matiere': matiere,
      'type': type.toUpperCase(),
      'date': DateTime.now().toString().split(' ')[0],
      'taille': taille,
      'path': path,
      'icon': type.toUpperCase() == 'PDF'
          ? Icons.picture_as_pdf
          : Icons.description,
      'couleur': type.toUpperCase() == 'PDF' ? Colors.red : Colors.blue,
    });
    supportsDeCours.refresh();
  }

  void telechargerSupport(String titre) {
    Get.snackbar(
      'Téléchargement',
      'Le fichier "$titre" est en cours de téléchargement...',
      backgroundColor: const Color(0xFF00855A),
      colorText: Colors.white,
      snackPosition: SnackPosition.BOTTOM,
      icon: const Icon(Icons.download, color: Colors.white),
    );
  }

  // ===== JUSTIFICATIFS =====
  void soumettreJustificatif(
      int presenceId, String type, String motif, String url) {
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
        matiere: p.matiere,
        estPresent: p.estPresent,
        justificatifUrl: url,
        typeJustificatif: type,
        motifJustificatif: motif,
        statutJustification: 'EN_ATTENTE',
      );
      presences.refresh();
      _actualiserListeRouge();
    }
  }

  List<PresenceModel> getJustificatifsEnAttente() {
    return presences
        .where((p) =>
    !p.estPresent &&
        p.statutJustification == 'EN_ATTENTE' &&
        p.motifJustificatif != null)
        .toList();
  }

  void traiterJustificatif(int presenceId, bool valider) {
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
        matiere: p.matiere,
        estPresent: p.estPresent,
        justificatifUrl: p.justificatifUrl,
        motifJustificatif: p.motifJustificatif,
        typeJustificatif: p.typeJustificatif,
        statutJustification: valider ? 'VALIDE' : 'REJETE',
      );
      presences.refresh();
      _actualiserListeRouge();

      // ✅ Snackbar de confirmation
      Get.snackbar(
        valider ? 'Justificatif validé' : 'Justificatif rejeté',
        valider
            ? 'Le justificatif a été accepté.'
            : 'Le justificatif a été refusé.',
        backgroundColor: valider ? const Color(0xFF00855A) : Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  void _actualiserListeRouge() {
    final Map<int, Map<String, dynamic>> mapAbsences = {};
    for (var p in presences) {
      if (!p.estPresent && p.statutJustification != 'VALIDE') {
        if (!mapAbsences.containsKey(p.etudiantId)) {
          mapAbsences[p.etudiantId] = {
            'id': p.etudiantId,
            'nom': p.nomEtudiant,
            'prenom': p.prenomEtudiant,
            'absences': 0,
          };
        }
        mapAbsences[p.etudiantId]!['absences']++;
      }
    }
    etudiantsEnSession.value = mapAbsences.values
        .where((e) => (e['absences'] as int) >= 3)
        .toList();
  }

  // ===== STATS =====
  double getTauxPresence(int etudiantId) {
    final mesPresences =
    presences.where((p) => p.etudiantId == etudiantId).toList();
    if (mesPresences.isEmpty) return 100.0;
    final presents = mesPresences
        .where((p) => p.estPresent || p.statutJustification == 'VALIDE')
        .length;
    return (presents / mesPresences.length) * 100;
  }

  List<PresenceModel> getPresencesEtudiant(int etudiantId) =>
      presences.where((p) => p.etudiantId == etudiantId).toList();

  List<PresenceModel> getAbsencesEtudiant(int etudiantId) =>
      presences.where((p) => p.etudiantId == etudiantId && !p.estPresent).toList();

  int getNombreAbsencesNonJustifiees(int etudiantId) => presences
      .where((p) =>
  p.etudiantId == etudiantId &&
      !p.estPresent &&
      p.statutJustification != 'VALIDE')
      .length;

  bool estEnSessionRattrapage(int etudiantId) =>
      getNombreAbsencesNonJustifiees(etudiantId) >= 3;

  List<Map<String, dynamic>> get filteredFiches {
    if (selectedDepartement.value == 'Tous les départements')
      return fichesPointage;
    return fichesPointage
        .where((f) => f['departement'] == selectedDepartement.value)
        .toList();
  }

  int get totalSeances => filteredFiches.length;
  int get seancesValidees =>
      filteredFiches.where((f) => f['statut'] == 'VALIDE').length;
  int get seancesEnAttente => filteredFiches
      .where((f) =>
  f['statut'] == 'EN_ATTENTE' ||
      f['statut'] == 'CONFIRME' ||
      f['statut'] == 'EN_COURS')
      .length;
  int get seancesRejetees =>
      filteredFiches.where((f) => f['statut'] == 'REJETE').length;

  // ✅ CORRIGÉ : statistiquesMatieres calculé depuis presences chargées via API
  List<Map<String, dynamic>> get statistiquesMatieres {
    final Map<String, Map<String, dynamic>> stats = {};
    for (var p in presences) {
      final key = p.matiere ?? 'Inconnu';
      if (!stats.containsKey(key)) {
        stats[key] = {
          'matiere': key,
          'totalInscrits': 0,
          'totalPresents': 0,
        };
      }
      stats[key]!['totalInscrits']++;
      if (p.estPresent) stats[key]!['totalPresents']++;
    }
    return stats.values.map((s) {
      final total = s['totalInscrits'] as int;
      final presents = s['totalPresents'] as int;
      return {
        'matiere': s['matiere'],
        'totalSeances': (total / 30).ceil(),
        'tauxPresence': total > 0 ? (presents / total * 100).toInt() : 0,
      };
    }).toList();
  }

  List<Map<String, dynamic>> getVacatairesData() {
    final validees =
    fichesPointage.where((f) => f['statut'] == 'VALIDE').toList();
    Map<String, Map<String, dynamic>> map = {};
    for (var f in validees) {
      final nomComplet = f['enseignantNom'] ?? 'Inconnu';
      if (!map.containsKey(nomComplet)) {
        final noms = nomComplet.split(' ');
        map[nomComplet] = {
          'enseignantNom': nomComplet,
          'nom': noms.length > 1 ? noms.sublist(1).join(' ') : noms[0],
          'prenom': noms.length > 1 ? noms[0] : '',
          'enseignantId': f['enseignantId'],
          'matiere': f['matiere'],
          'totalHeures': 0,
          'tauxHoraire': 5000,
          'seances': [],
          'salles': <String>{},
        };
      }
      int dureeMin = f['duree'] as int? ?? 0;
      int heures = dureeMin ~/ 60;
      if (heures == 0 && dureeMin > 0) heures = 1;
      map[nomComplet]!['totalHeures'] += heures;
      (map[nomComplet]!['seances'] as List).add({
        'duree': heures,
        'statut': 'VALIDE',
        'date': f['dateSeance'],
      });
      if (f['salle'] != null) {
        (map[nomComplet]!['salles'] as Set<String>).add(f['salle'] as String);
      }
    }
    return map.values.toList();
  }

  // ===== SIGNATURES =====
  void signerSuperviseur(Uint8List signature) =>
      signatureSuperviseur.value = signature;
  void signerChefDep(Uint8List signature) =>
      signatureChefDep.value = signature;
  void signerDoyen(Uint8List signature) => signatureDoyen.value = signature;
}
