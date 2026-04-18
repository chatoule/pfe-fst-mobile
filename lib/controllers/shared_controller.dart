import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import '../models/presence_model.dart';

class SharedController extends GetxController {
  static SharedController get to => Get.find();

  // ===== DÉPARTEMENTS ET FILTRAGE =====
  var departements = ['Tous les départements', 'Télécommunications', 'Informatique'].obs;
  var selectedDepartement = 'Tous les départements'.obs;

  // ===== FICHES DE POINTAGE =====
  var fichesPointage = <Map<String, dynamic>>[].obs;

  // ===== PRESENCES PARTAGEES =====
  var presences = <PresenceModel>[].obs;

  // ===== RATTRAPAGES =====
  var rattrapages = <Map<String, String>>[
    {
      'matiere': 'Mathematiques',
      'date': '2024-03-20',
      'heure': '08h00 - 10h00',
      'salle': 'A101',
      'statut': 'EN_ATTENTE',
    },
    {
      'matiere': 'Physique',
      'date': '2024-03-22',
      'heure': '10h00 - 12h00',
      'salle': 'B202',
      'statut': 'VALIDE',
    },
    {
      'matiere': 'Chimie',
      'date': '2024-03-25',
      'heure': '14h00 - 16h00',
      'salle': 'C303',
      'statut': 'REJETE',
    },
  ].obs;

  // ===== SIGNATURES ET NOMS OFFICIELS =====
  var signatureSuperviseur = Rx<Uint8List?>(null);
  var signatureChefDep = Rx<Uint8List?>(null);
  var signatureDoyen = Rx<Uint8List?>(null);
  var nomChefDep = 'Ibrahim Seyni Hassimi'.obs;
  var nomSuperviseur = 'Mubarak'.obs;
  var nomDoyen = 'Dr. Ibrahim Oumarou Amadou'.obs;
  var semestre = 'Semestre 2025/2026'.obs;

  // ===== COURS DU JOUR (Basé sur l'emploi du temps TELECOM fourni) =====
  var coursDuJour = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    _initDonneesReelles();
  }

  void _initDonneesReelles() {
    _initPresencesFictives();
    // ===== INJECTION DES COURS FST (INFO PRIORITÉ) =====
    coursDuJour.value = [
      {
        'matiere': 'Algorithmique Avancée',
        'enseignant': 'Dr. Moussa Ibrahim',
        'salle': 'Labo Info 1',
        'heure': '08h00 - 10h00',
        'niveau': 'L2 INFO',
        'statut': 'EN_COURS',
        'total': 60,
        'presents': 58,
        'departement': 'Informatique',
      },
      {
        'matiere': 'Base de Données',
        'enseignant': 'Mme. Fatouma Zakari',
        'salle': 'Salle 05',
        'heure': '10h00 - 12h00',
        'niveau': 'L1 INFO',
        'statut': 'PLANIFIE',
        'total': 75,
        'presents': 0,
        'departement': 'Informatique',
      },
      {
        'matiere': 'Systèmes d\'Exploitation',
        'enseignant': 'Ibrahim Seyni Hassimi',
        'salle': 'Salle 03',
        'heure': '14h00 - 17h00',
        'niveau': 'L2 INFO',
        'statut': 'PLANIFIE',
        'total': 55,
        'presents': 0,
        'departement': 'Informatique',
      },
    ];

    // ===== FICHES POINTAGE INITIALES (Historique pour démonstration) =====
    fichesPointage.value = [
      {
        'id': 1,
        'enseignantId': 201,
        'enseignantNom': 'Adamou Issaka Kodo',
        'matiere': 'RF, Antennes et Hyperfréquences',
        'salle': 'Salle 01',
        'dateSeance': '2024-04-01',
        'heureDebut': '08h00',
        'heureFin': '11h30',
        'duree': 210,
        'contenu': 'Étude des diagrammes de rayonnement',
        'statut': 'VALIDE',
        'confirmerSuperviseur': true,
        'valideChefDep': true,
        'departement': 'Télécommunications',
      },
      {
        'id': 2,
        'enseignantId': 202,
        'enseignantNom': 'Hassane Kabirou',
        'matiere': 'Architecture des Ordinateurs',
        'salle': 'Salle 02',
        'dateSeance': '2024-04-02',
        'heureDebut': '09h00',
        'heureFin': '11h00',
        'duree': 120,
        'contenu': 'Registres et Unité Arithmétique et Logique',
        'statut': 'VALIDE',
        'confirmerSuperviseur': true,
        'valideChefDep': true,
        'departement': 'Informatique',
      },
      {
        'id': 3,
        'enseignantId': 201,
        'enseignantNom': 'Adamou Issaka Kodo',
        'matiere': 'Nouveau Module',
        'salle': 'Salle 03',
        'dateSeance': '2024-04-03',
        'heureDebut': '08h00',
        'heureFin': '10h00',
        'duree': 120,
        'contenu': 'Introduction générale',
        'statut': 'EN_COURS',
        'confirmerSuperviseur': false,
        'valideChefDep': false,
        'departement': 'Télécommunications',
      }
    ];
  }

  void _initPresencesFictives() {
    final matieres = ['RF, Antennes et Hyperfréquences', 'Réseaux satellites, RADAR et GPS', 'Traitement Numérique du Signal', 'Electronique Analog. & Num.'];
    final noms = ['Moussa', 'Abdoulaye', 'Fatimata', 'Ibrahim', 'Zainab'];
    final prenoms = ['Adamou', 'Oumarou', 'Sani', 'Ali', 'Issoufou'];

    for (int i = 0; i < 50; i++) {
      final etudiantId = 100 + (i % 5);
      final matiere = matieres[i % matieres.length];
      final estPresent = (i % 7) != 0; // Quelques absences
      
      presences.add(PresenceModel(
        id: i + 1,
        etudiantId: etudiantId,
        nomEtudiant: noms[i % 5],
        prenomEtudiant: prenoms[i % 5],
        coursId: (i % 4) + 1,
        dateSeance: '2024-04-01',
        matiere: matiere,
        estPresent: estPresent,
        statutJustification: !estPresent && (i % 3 == 0) ? 'EN_ATTENTE' : null,
        motifJustificatif: !estPresent && (i % 3 == 0) ? 'Raison médicale' : null,
        typeJustificatif: 'Certificat médical',
      ));
    }
    _actualiserListeRouge();
  }

  // ===== METHODES FICHES POINTAGE =====
  void soumettreFiche(Map<String, dynamic> fiche) {
    fichesPointage.add({
      'id': fichesPointage.length + 1,
      ...fiche,
      'departement': 'Télécommunications', // Par défaut pour la démo
      'statut': 'EN_COURS',
      'confirmerSuperviseur': false,
      'valideChefDep': false,
      'dateSoumission': DateTime.now().toString(),
    });
  }

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

  // ===== METHODES PRESENCES =====
  void marquerPresence(int etudiantId, int coursId, bool estPresent, String dateSeance, String matiere, String nom, String prenom) {
    final index = presences.indexWhere((p) => p.etudiantId == etudiantId && p.matiere == matiere);
    if (index != -1) {
      presences[index] = PresenceModel(
        id: presences[index].id,
        etudiantId: etudiantId,
        nomEtudiant: nom,
        prenomEtudiant: prenom,
        coursId: coursId,
        dateSeance: dateSeance,
        matiere: matiere,
        estPresent: estPresent,
      );
    } else {
      presences.add(PresenceModel(
        id: presences.length + 1,
        etudiantId: etudiantId,
        nomEtudiant: nom,
        prenomEtudiant: prenom,
        coursId: coursId,
        dateSeance: dateSeance,
        matiere: matiere,
        estPresent: estPresent,
      ));
    }
    presences.refresh();
  }

  // ===== GESTION DES ABSENCES ET JUSTIFICATIFS =====
  var etudiantsEnSession = <Map<String, dynamic>>[].obs;

  double getTauxPresence(int etudiantId) {
    final mesPresences = presences.where((p) => p.etudiantId == etudiantId).toList();
    if (mesPresences.isEmpty) return 100.0;
    final presents = mesPresences.where((p) => p.estPresent || p.statutJustification == 'VALIDE').length;
    return (presents / mesPresences.length) * 100;
  }

  List<PresenceModel> getPresencesEtudiant(int etudiantId) {
    return presences.where((p) => p.etudiantId == etudiantId).toList();
  }

  List<PresenceModel> getAbsencesEtudiant(int etudiantId) {
    return presences.where((p) => p.etudiantId == etudiantId && !p.estPresent).toList();
  }

  int getNombreAbsencesNonJustifiees(int etudiantId) {
    return presences.where((p) => p.etudiantId == etudiantId && !p.estPresent && p.statutJustification != 'VALIDE').length;
  }

  bool estEnSessionRattrapage(int etudiantId) {
    return getNombreAbsencesNonJustifiees(etudiantId) >= 3;
  }

  void soumettreJustificatif(int presenceId, String type, String motif, String url) {
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

  void ajouterRattrapage(String matiere, String date, String heure, String salle) {
    rattrapages.add({
      'matiere': matiere,
      'date': date,
      'heure': heure,
      'salle': salle,
      'statut': 'EN_ATTENTE',
    });
    rattrapages.refresh();
  }

  void rejeterFiche(int ficheId, String initiateur) {
    final index = fichesPointage.indexWhere((f) => f['id'] == ficheId);
    if (index != -1) {
      final fiche = Map<String, dynamic>.from(fichesPointage[index]);
      fiche['statut'] = 'REJETE';
      fiche['motifRejet'] = 'Rejeté par $initiateur';
      fichesPointage[index] = fiche;
      fichesPointage.refresh();
    }
  }

  List<PresenceModel> getJustificatifsEnAttente() {
    return presences.where((p) => p.estPresent == false && p.statutJustification == 'EN_ATTENTE' && p.motifJustificatif != null).toList();
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
        motifJustificatif: p.motifJustificatif,
        typeJustificatif: p.typeJustificatif,
        statutJustification: valider ? 'VALIDE' : 'REJETE',
      );
      presences.refresh();
      _actualiserListeRouge();
    }
  }

  void _actualiserListeRouge() {
    // Logique simplifiée : Compte les absences non justifiées par étudiant
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

  void signerSuperviseur(Uint8List signature) {
    signatureSuperviseur.value = signature;
  }

  void signerChefDep(Uint8List signature) {
    signatureChefDep.value = signature;
  }

  void signerDoyen(Uint8List signature) {
    signatureDoyen.value = signature;
  }

  List<Map<String, dynamic>> getVacatairesData() {
    final validees = fichesPointage
        .where((f) => f['statut'] == 'VALIDE')
        .toList();

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

  // STATISTIQUES MATIERES
  List<Map<String, dynamic>> get statistiquesMatieres {
    final Map<String, Map<String, dynamic>> stats = {};
    
    for (var p in presences) {
      final key = p.matiere ?? 'Inconnu';
      if (!stats.containsKey(key)) {
        stats[key] = {
          'matiere': key,
          'totalSeances': 0,
          'totalPresents': 0,
          'totalInscrits': 0,
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
        'totalSeances': (total / 30).ceil(), // Approximation
        'tauxPresence': total > 0 ? (presents / total * 100).toInt() : 0,
      };
    }).toList();
  }

  // STATS RAPIDES
  List<Map<String, dynamic>> get filteredFiches {
    if (selectedDepartement.value == 'Tous les départements') return fichesPointage;
    return fichesPointage.where((f) => f['departement'] == selectedDepartement.value).toList();
  }

  int get totalSeances => filteredFiches.length;
  int get seancesValidees => filteredFiches.where((f) => f['statut'] == 'VALIDE').length;
  int get seancesEnAttente => filteredFiches.where((f) => f['statut'] == 'EN_ATTENTE' || f['statut'] == 'CONFIRME' || f['statut'] == 'EN_ATTENTE_SUPERVISEUR' || f['statut'] == 'EN_COURS').length;
}
