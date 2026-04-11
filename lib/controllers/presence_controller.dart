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
      PresenceModel(
        id: 1, etudiantId: 1,
        nomEtudiant: 'Amadou', prenomEtudiant: 'Sow',
        coursId: 1, dateSeance: '2024-03-15', estPresent: true,
      ),
      PresenceModel(
        id: 2, etudiantId: 2,
        nomEtudiant: 'Aichat', prenomEtudiant: 'Salami',
        coursId: 1, dateSeance: '2024-03-15', estPresent: false,
      ),
      PresenceModel(
        id: 3, etudiantId: 3,
        nomEtudiant: 'Dayyanatou', prenomEtudiant: 'Magagi',
        coursId: 1, dateSeance: '2024-03-15', estPresent: true,
      ),
    ];
  }

  Future<void> chargerPresences(int coursId) async {
    chargerDonneesFictives();
  }

  void marquerPresenceLocale(int etudiantId, bool estPresent) {
    final index = presences.indexWhere((p) => p.etudiantId == etudiantId);
    if (index != -1) {
      presences[index] = PresenceModel(
        id: presences[index].id,
        etudiantId: presences[index].etudiantId,
        nomEtudiant: presences[index].nomEtudiant,
        prenomEtudiant: presences[index].prenomEtudiant,
        coursId: presences[index].coursId,
        dateSeance: presences[index].dateSeance,
        estPresent: estPresent,
      );
      Get.snackbar('Succes', 'Presence mise a jour',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}