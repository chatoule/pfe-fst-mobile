import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/presence_controller.dart';
import '../controllers/auth_controller.dart';
import '../widgets/app_drawer.dart';

class PresenceScreen extends StatefulWidget {
  @override
  _PresenceScreenState createState() => _PresenceScreenState();
}

class _PresenceScreenState extends State<PresenceScreen> {
  final PresenceController _presenceController = Get.put(PresenceController());
  final AuthController _authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    _presenceController.chargerDonneesFictives();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Presences'),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      body: Obx(() {
        if (_presenceController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (_presenceController.presences.isEmpty) {
          return Center(
            child: Text(
              'Aucune presence disponible',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          );
        }
        return ListView.builder(
          padding: EdgeInsets.all(16),
          itemCount: _presenceController.presences.length,
          itemBuilder: (context, index) {
            final presence = _presenceController.presences[index];
            return Card(
              margin: EdgeInsets.only(bottom: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: Color(0xFF00855A),
                  child: Text(
                    presence.nomEtudiant[0],
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                title: Text('${presence.nomEtudiant} ${presence.prenomEtudiant}'),
                subtitle: Text(presence.dateSeance),
                trailing: Switch(
                  value: presence.estPresent,
                  activeColor: Color(0xFF00855A),
                  onChanged: (value) {
                    _presenceController.marquerPresenceLocale(
                        presence.etudiantId, value);
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