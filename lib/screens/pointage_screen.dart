import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/pointage_controller.dart';
import '../controllers/auth_controller.dart';
import 'enseignant/rattrapage_screen.dart';
import 'enseignant/anticipation_screen.dart';
import 'enseignant/support_screen.dart';
import 'enseignant/historique_screen.dart';
import 'enseignant/presence_screen.dart';
import 'enseignant/fiche_pointage_screen.dart';

class PointageScreen extends StatefulWidget {
  @override
  _PointageScreenState createState() => _PointageScreenState();
}

class _PointageScreenState extends State<PointageScreen> {
  final PointageController _pointageController = Get.put(PointageController());
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    final user = _authController.utilisateur.value;
    if (user != null) {
      _pointageController.chargerCours(user.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_getTitre(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A86B), Color(0xFF003D29)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final user = _authController.utilisateur.value;
                    return Center(
                      child: Text(
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'U',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12),
                Obx(() => Text(
                  '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('ENSEIGNANT',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                SizedBox(height: 4),
                Obx(() => Text(
                  _authController.utilisateur.value?.email ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 8),
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Dashboard'),
                _buildDrawerItem(1, Icons.people_outline, 'Presences'),
                _buildDrawerItem(2, Icons.replay_outlined, 'Rattrapages'),
                _buildDrawerItem(3, Icons.fast_forward_outlined, 'Anticipations'),
                _buildDrawerItem(4, Icons.folder_outlined, 'Supports'),
                _buildDrawerItem(5, Icons.history_outlined, 'Historique'),
              ],
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Se deconnecter',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            onTap: () => _authController.logout(),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('FST - UIN v1.0',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF00855A).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? Color(0xFF00855A) : Colors.grey[600], size: 22),
        title: Text(label,
            style: TextStyle(
                color: isActive ? Color(0xFF00855A) : Colors.grey[800],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14)),
        onTap: () {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Dashboard';
      case 1: return 'Presences';
      case 2: return 'Rattrapages';
      case 3: return 'Anticipations';
      case 4: return 'Supports';
      case 5: return 'Historique';
      default: return 'Enseignant';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildDashboard();
      case 1: return PresencesScreen();
      case 2: return RattrapagesScreen();
      case 3: return AnticipationsScreen();
      case 4: return SupportsScreen();
      case 5: return HistoriqueScreen();
      default: return _buildDashboard();
    }
  }

  // ===================== DASHBOARD =====================
  Widget _buildDashboard() {
    return Obx(() {
      final user = _authController.utilisateur.value;
      final cours = _pointageController.coursList;
      final planifies = cours.where((c) => c.statut == 'PLANIFIE').length;
      final termines = cours.where((c) => c.statut == 'TERMINE').length;
      final enCours = cours.where((c) => c.statut == 'EN_COURS').length;

      return SingleChildScrollView(
        child: Column(
          children: [
            // ===== HEADER GRADIENT =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user != null
                                ? '${user.prenom[0]}${user.nom[0]}'
                                : 'U',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour,',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text(
                            '${user?.prenom ?? ""} ${user?.nom ?? ""}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 20),
                  // Stats rapides
                  Row(
                    children: [
                      _buildHeaderStat('Planifies', '$planifies', Icons.schedule),
                      SizedBox(width: 12),
                      _buildHeaderStat('En cours', '$enCours', Icons.play_circle_outline),
                      SizedBox(width: 12),
                      _buildHeaderStat('Termines', '$termines', Icons.check_circle_outline),
                    ],
                  ),
                ],
              ),
            ),

            // ===== CONTENU =====
            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Actions rapides
                  Text('Actions rapides',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionCard(
                          'Presences', Icons.people, Colors.blue, 1),
                      SizedBox(width: 12),
                      _buildActionCard(
                          'Rattrapages', Icons.replay, Colors.orange, 2),
                      SizedBox(width: 12),
                      _buildActionCard(
                          'Supports', Icons.folder, Colors.purple, 4),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Cours du jour
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Mes Cours',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      Text('${cours.length} cours',
                          style: TextStyle(
                              color: Color(0xFF00855A),
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 12),

                  if (_pointageController.isLoading.value)
                    Center(child: CircularProgressIndicator(
                        color: Color(0xFF00855A)))
                  else if (cours.isEmpty)
                    _buildEmptyState(
                        'Aucun cours disponible', Icons.book_outlined)
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: cours.length,
                      itemBuilder: (context, index) {
                        final c = cours[index];
                        return _buildCoursCard(c);
                      },
                    ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderStat(String label, String valeur, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(valeur,
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                Text(label,
                    style: TextStyle(color: Colors.white70, fontSize: 10)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String label, IconData icon, Color couleur, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: couleur.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: couleur, size: 22),
              ),
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003D29))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursCard(dynamic cours) {
    Color statutColor;
    IconData statutIcon;
    switch (cours.statut) {
      case 'TERMINE':
        statutColor = Colors.green;
        statutIcon = Icons.check_circle;
        break;
      case 'EN_COURS':
        statutColor = Colors.orange;
        statutIcon = Icons.play_circle;
        break;
      case 'ANNULE':
        statutColor = Colors.red;
        statutIcon = Icons.cancel;
        break;
      default:
        statutColor = Color(0xFF00855A);
        statutIcon = Icons.schedule;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statutColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statutIcon, color: statutColor, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(cours.matiere,
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.access_time,
                            size: 13, color: Colors.grey),
                        SizedBox(width: 3),
                        Text('${cours.heureDebut} - ${cours.heureFin}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                        SizedBox(width: 10),
                        Icon(Icons.location_on,
                            size: 13, color: Colors.grey),
                        SizedBox(width: 3),
                        Text('Salle ${cours.salle}',
                            style: TextStyle(
                                color: Colors.grey[600], fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statutColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: statutColor.withOpacity(0.3)),
                  ),
                  child: Text(cours.statut,
                      style: TextStyle(
                          color: statutColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ],
            ),
            if (cours.statut == 'PLANIFIE') ...[
              SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() => FichePointageScreen(
                    cours: {
                      'matiere': cours.matiere,
                      'heureDebut': cours.heureDebut,
                      'heureFin': cours.heureFin,
                      'salle': cours.salle,
                      'dateSeance': cours.dateSeance,
                      'niveau': 'L3',
                      'semestre': 'S1',
                    },
                  )),
                  icon: Icon(Icons.touch_app, color: Colors.white, size: 18),
                  label: Text('Pointer ce cours',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF00855A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    padding: EdgeInsets.symmetric(vertical: 12),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: EdgeInsets.all(40),
      child: Column(
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(message,
              style: TextStyle(fontSize: 15, color: Colors.grey[500])),
        ],
      ),
    );
  }
}