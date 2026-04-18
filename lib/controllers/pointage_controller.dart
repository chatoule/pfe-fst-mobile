import 'package:get/get.dart';
import '../models/cours_model.dart';
import '../services/pointage_service.dart';

class PointageController extends GetxController {
  final PointageService _pointageService = PointageService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var coursList = <CoursModel>[].obs;

  var totalHeuresMois = 0.0.obs;
  var seancesValidees = 0.obs;

  @override
  void onInit() {
    super.onInit();
    chargerDonneesFictives();
    calculerStatistiques();
  }

  void calculerStatistiques() {
    // Simulation du calcul des heures (2h par séance terminée)
    totalHeuresMois.value = coursList.where((c) => c.statut == 'TERMINE').length * 2.0;
    seancesValidees.value = coursList.where((c) => c.statut == 'TERMINE').length;
  }

  void chargerDonneesFictives() {
    final today = DateTime.now();
    final tomorrow = today.add(const Duration(days: 1));
    
    String formatDate(DateTime d) => d.toString().split(' ')[0];

    coursList.value = [
      CoursModel(
        id: 1, matiere: 'Algorithmique et Structure de Données',
        enseignantNom: 'Moussa', enseignantPrenom: 'Ali',
        dateSeance: formatDate(today), heureDebut: '08h00',
        heureFin: '10h00', salle: 'Amphi A', statut: 'PLANIFIE',
      ),
      CoursModel(
        id: 2, matiere: 'Base de Données Relationnelles',
        enseignantNom: 'Moussa', enseignantPrenom: 'Ali',
        dateSeance: formatDate(today), heureDebut: '10h00',
        heureFin: '12h00', salle: 'Salle B1', statut: 'TERMINE',
      ),
      CoursModel(
        id: 3, matiere: 'Développement Mobile Flutter',
        enseignantNom: 'Moussa', enseignantPrenom: 'Ali',
        dateSeance: formatDate(tomorrow), heureDebut: '14h00',
        heureFin: '16h00', salle: 'Labo Info', statut: 'PLANIFIE',
      ),
    ];
  }

  Future<void> chargerCours(int enseignantId) async {
    chargerDonneesFictives();
  }

  Future<void> chargerTousCours() async {
    chargerDonneesFictives();
  }

  Future<void> pointerCours(int coursId) async {
    final index = coursList.indexWhere((c) => c.id == coursId);
    if (index != -1) {
      final c = coursList[index];
      coursList[index] = CoursModel(
        id: c.id,
        matiere: c.matiere,
        enseignantNom: c.enseignantNom,
        enseignantPrenom: c.enseignantPrenom,
        dateSeance: c.dateSeance,
        heureDebut: c.heureDebut,
        heureFin: c.heureFin,
        salle: c.salle,
        statut: 'TERMINE',
      );
      calculerStatistiques();
      coursList.refresh();
      // Le snackbar est maintenant géré dans FichePointageScreen pour éviter les doublons ou conflits de timing
    }
  }
}