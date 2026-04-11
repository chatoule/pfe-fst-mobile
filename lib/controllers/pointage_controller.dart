import 'package:get/get.dart';
import '../models/cours_model.dart';
import '../services/pointage_service.dart';

class PointageController extends GetxController {
  final PointageService _pointageService = PointageService();

  var isLoading = false.obs;
  var errorMessage = ''.obs;
  var coursList = <CoursModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    chargerDonneesFictives();
  }

  void chargerDonneesFictives() {
    coursList.value = [
      CoursModel(
        id: 1, matiere: 'Mathematiques',
        enseignantNom: 'Moussa', enseignantPrenom: 'Ali',
        dateSeance: '2024-03-15', heureDebut: '08h00',
        heureFin: '10h00', salle: 'A101', statut: 'PLANIFIE',
      ),
      CoursModel(
        id: 2, matiere: 'Physique',
        enseignantNom: 'Diallo', enseignantPrenom: 'Ibrahim',
        dateSeance: '2024-03-16', heureDebut: '10h00',
        heureFin: '12h00', salle: 'B202', statut: 'TERMINE',
      ),
      CoursModel(
        id: 3, matiere: 'Chimie',
        enseignantNom: 'Maiga', enseignantPrenom: 'Fatima',
        dateSeance: '2024-03-17', heureDebut: '14h00',
        heureFin: '16h00', salle: 'C303', statut: 'PLANIFIE',
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
      coursList[index] = CoursModel(
        id: coursList[index].id,
        matiere: coursList[index].matiere,
        enseignantNom: coursList[index].enseignantNom,
        enseignantPrenom: coursList[index].enseignantPrenom,
        dateSeance: coursList[index].dateSeance,
        heureDebut: coursList[index].heureDebut,
        heureFin: coursList[index].heureFin,
        salle: coursList[index].salle,
        statut: 'TERMINE',
      );
      Get.snackbar('Succes', 'Cours pointe avec succes',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}