import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/presence_controller.dart';
import '../controllers/auth_controller.dart';
import '../models/presence_model.dart';

class PresenceScreen extends StatefulWidget {
  const PresenceScreen({Key? key}) : super(key: key);

  @override
  State<PresenceScreen> createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  final PresenceController _presenceController = Get.find<PresenceController>();
  final AuthController _authController = Get.find<AuthController>();

  @override
  void initState() {
    super.initState();
    // On charge les données si la liste est vide
    if (_presenceController.presences.isEmpty) {
      _presenceController.chargerDonneesFictives();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Présences'),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      body: Obx(() {
        if (_presenceController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        
        final presences = _presenceController.presences;
        
        if (presences.isEmpty) {
          return const Center(
            child: Text(
              'Aucune présence disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        
        return ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: presences.length,
          itemBuilder: (context, index) {
            final presence = presences[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF00855A),
                  child: Text(
                    presence.nomEtudiant.isNotEmpty ? presence.nomEtudiant[0] : 'E',
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${presence.prenomEtudiant} ${presence.nomEtudiant}'),
                subtitle: Text('Séance du ${presence.dateSeance}'),
                trailing: Switch(
                  value: presence.estPresent,
                  activeTrackColor: const Color(0xFF00855A).withOpacity(0.5),
                  activeColor: const Color(0xFF00855A),
                  onChanged: (value) {
                    // Mise à jour locale pour l'exemple
                    final nouvellePresence = PresenceModel(
                      id: presence.id,
                      etudiantId: presence.etudiantId,
                      nomEtudiant: presence.nomEtudiant,
                      prenomEtudiant: presence.prenomEtudiant,
                      coursId: presence.coursId,
                      dateSeance: presence.dateSeance,
                      estPresent: value,
                      estJustifie: presence.estJustifie,
                      justificatifUrl: presence.justificatifUrl,
                      statutJustification: presence.statutJustification,
                    );
                    
                    // On remplace l'ancienne présence par la nouvelle dans la liste observable
                    _presenceController.presences[index] = nouvellePresence;
                    
                    if (!value) {
                       Get.snackbar(
                        'Absence enregistrée',
                        'L\'étudiant ${presence.prenomEtudiant} a été marqué absent.',
                        snackPosition: SnackPosition.BOTTOM,
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                      );
                    }
                  },
                ),
              ),
            );
          },
        );
      }),
    );
  }
}