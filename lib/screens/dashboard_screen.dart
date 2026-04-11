import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/pointage_controller.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController _authController = Get.put(AuthController());
  final PointageController _pointageController = Get.put(PointageController());

  @override
  Widget build(BuildContext context) {
    _pointageController.chargerTousCours();

    return Scaffold(
      appBar: AppBar(
        title: Text('Tableau de bord'),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(() {
              final user = _authController.utilisateur.value;
              return Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFF00855A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Bienvenue,',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      user != null ? '${user.prenom} ${user.nom}' : 'Utilisateur',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      user?.role ?? '',
                      style: TextStyle(color: Colors.white60, fontSize: 13),
                    ),
                  ],
                ),
              );
            }),
            SizedBox(height: 24),
            Text(
              'Vue d\'ensemble',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Obx(() {
              final cours = _pointageController.coursList;
              final total = cours.length;
              final termines = cours.where((c) => c.statut == 'TERMINE').length;
              final planifies = cours.where((c) => c.statut == 'PLANIFIE').length;
              final annules = cours.where((c) => c.statut == 'ANNULE').length;
              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard('Total cours', total, Colors.blue),
                  _buildStatCard('Termines', termines, Color(0xFF00855A)),
                  _buildStatCard('Planifies', planifies, Colors.orange),
                  _buildStatCard('Annules', annules, Colors.red),
                ],
              );
            }),
            SizedBox(height: 24),
            Text(
              'Cours recents',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Obx(() {
              if (_pointageController.isLoading.value) {
                return Center(child: CircularProgressIndicator());
              }
              if (_pointageController.coursList.isEmpty) {
                return Center(
                  child: Text(
                    'Aucun cours disponible',
                    style: TextStyle(color: Colors.grey),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: _pointageController.coursList.length,
                itemBuilder: (context, index) {
                  final cours = _pointageController.coursList[index];
                  return Card(
                    margin: EdgeInsets.only(bottom: 10),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF00855A),
                        child: Icon(Icons.book, color: Colors.white),
                      ),
                      title: Text(cours.matiere),
                      subtitle: Text('${cours.enseignantNom} - ${cours.dateSeance}'),
                      trailing: Container(
                        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: cours.statut == 'TERMINE'
                              ? Colors.green[50]
                              : Colors.orange[50],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: cours.statut == 'TERMINE'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                        child: Text(
                          cours.statut,
                          style: TextStyle(
                            fontSize: 11,
                            color: cours.statut == 'TERMINE'
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String titre, int valeur, Color couleur) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withOpacity(0.3)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            valeur.toString(),
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: couleur,
            ),
          ),
          SizedBox(height: 4),
          Text(
            titre,
            style: TextStyle(fontSize: 13, color: couleur),
          ),
        ],
      ),
    );
  }
}