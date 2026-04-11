import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SuperviseurScreen extends StatefulWidget {
  @override
  _SuperviseurScreenState createState() => _SuperviseurScreenState();
}

class _SuperviseurScreenState extends State<SuperviseurScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> pointages = [
    {
      'enseignant': 'Moussa Ali',
      'matiere': 'Mathematiques',
      'date': '2024-03-15',
      'heure': '08h00 - 10h00',
      'duree': 120,
      'statut': 'EN_ATTENTE',
      'couleur': Colors.blue,
    },
    {
      'enseignant': 'Diallo Ibrahim',
      'matiere': 'Physique',
      'date': '2024-03-15',
      'heure': '10h00 - 12h00',
      'duree': 118,
      'statut': 'EN_ATTENTE',
      'couleur': Colors.purple,
    },
    {
      'enseignant': 'Maiga Fatima',
      'matiere': 'Chimie',
      'date': '2024-03-14',
      'heure': '14h00 - 16h00',
      'duree': 115,
      'statut': 'VALIDE',
      'couleur': Color(0xFF00855A),
    },
  ];

  final List<Map<String, dynamic>> presences = [
    {'module': 'Mathematiques', 'total': 35, 'presents': 30, 'couleur': Colors.blue},
    {'module': 'Physique', 'total': 35, 'presents': 28, 'couleur': Colors.purple},
    {'module': 'Informatique', 'total': 35, 'presents': 33, 'couleur': Color(0xFF00855A)},
    {'module': 'Chimie', 'total': 35, 'presents': 25, 'couleur': Colors.orange},
  ];

  final List<Map<String, dynamic>> historique = [
    {
      'action': 'Pointage valide',
      'detail': 'Mathematiques - Moussa Ali',
      'date': '2024-03-15 09:30',
      'type': 'VALIDATION',
    },
    {
      'action': 'Pointage rejete',
      'detail': 'Chimie - Maiga Fatima',
      'date': '2024-03-14 14:00',
      'type': 'REJET',
    },
    {
      'action': 'Presence consultee',
      'detail': 'Module Physique',
      'date': '2024-03-14 10:00',
      'type': 'CONSULTATION',
    },
    {
      'action': 'Pointage valide',
      'detail': 'Informatique - Sani Ousseini',
      'date': '2024-03-13 08:00',
      'type': 'VALIDATION',
    },
  ];

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
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'S',
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
                  child: Text('SUPERVISEUR',
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
                _buildDrawerItem(0, Icons.check_circle_outline, 'Valider Pointages'),
                _buildDrawerItem(1, Icons.people_outline, 'Suivi Presences'),
                _buildDrawerItem(2, Icons.bar_chart_outlined, 'Statistiques'),
                _buildDrawerItem(3, Icons.history_outlined, 'Historique'),
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
      case 0: return 'Valider Pointages';
      case 1: return 'Suivi Presences';
      case 2: return 'Statistiques';
      case 3: return 'Historique';
      default: return 'Superviseur';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildPointages();
      case 1: return _buildPresences();
      case 2: return _buildStatistiques();
      case 3: return _buildHistorique();
      default: return _buildPointages();
    }
  }

  // ===================== POINTAGES =====================
  Widget _buildPointages() {
    final enAttente = pointages.where((p) => p['statut'] == 'EN_ATTENTE').length;
    final valides = pointages.where((p) => p['statut'] == 'VALIDE').length;

    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Total', '${pointages.length}', Colors.white),
              SizedBox(width: 8),
              _buildStatBadge('En attente', '$enAttente', Colors.orange),
              SizedBox(width: 8),
              _buildStatBadge('Valides', '$valides', Colors.greenAccent),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: pointages.length,
            itemBuilder: (context, index) {
              final p = pointages[index];
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
                              color: (p['couleur'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.person,
                                color: p['couleur'] as Color, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(p['matiere'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF003D29))),
                                Text(p['enseignant'],
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          _buildBadge(p['statut']),
                        ],
                      ),
                      SizedBox(height: 10),
                      Container(
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: Color(0xFFF5F7FA),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildDetailInfo(Icons.calendar_today, p['date']),
                            _buildDetailInfo(Icons.access_time, p['heure']),
                            _buildDetailInfo(Icons.timer, '${p['duree']} min'),
                          ],
                        ),
                      ),
                      if (p['statut'] == 'EN_ATTENTE') ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => p['statut'] = 'VALIDE');
                                  Get.snackbar('Succes', 'Pointage valide !',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Color(0xFF00855A),
                                      colorText: Colors.white,
                                      icon: Icon(Icons.check_circle, color: Colors.white));
                                },
                                icon: Icon(Icons.check, color: Colors.white, size: 16),
                                label: Text('Valider',
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Color(0xFF00855A),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => p['statut'] = 'REJETE');
                                  Get.snackbar('Info', 'Pointage rejete',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      icon: Icon(Icons.cancel, color: Colors.white));
                                },
                                icon: Icon(Icons.close, color: Colors.white, size: 16),
                                label: Text('Rejeter',
                                    style: TextStyle(color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===================== PRESENCES =====================
  Widget _buildPresences() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Modules', '${presences.length}', Colors.white),
              SizedBox(width: 8),
              _buildStatBadge('Taux moyen',
                  '${presences.fold(0, (sum, p) => sum + ((p['presents'] as int) * 100 ~/ (p['total'] as int))) ~/ presences.length}%',
                  Colors.greenAccent),
              SizedBox(width: 8),
              _buildStatBadge('Critiques',
                  '${presences.where((p) => (p['presents'] as int) * 100 ~/ (p['total'] as int) < 75).length}',
                  Colors.redAccent),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: presences.length,
            itemBuilder: (context, index) {
              final p = presences[index];
              final taux = (p['presents'] as int) * 100 ~/ (p['total'] as int);
              final couleur = taux >= 75 ? Color(0xFF00855A) : Colors.red;
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
                              color: (p['couleur'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.book,
                                color: p['couleur'] as Color, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(p['module'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF003D29))),
                          ),
                          Text('$taux%',
                              style: TextStyle(
                                  color: couleur,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                        ],
                      ),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildMiniStat('Presents', p['presents'], Color(0xFF00855A)),
                          _buildMiniStat('Absents',
                              (p['total'] as int) - (p['presents'] as int), Colors.red),
                          _buildMiniStat('Total', p['total'], Colors.blue),
                        ],
                      ),
                      SizedBox(height: 10),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: (p['presents'] as int) / (p['total'] as int),
                          backgroundColor: Colors.grey[200],
                          color: couleur,
                          minHeight: 8,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===================== STATISTIQUES =====================
  Widget _buildStatistiques() {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Column(
              children: [
                Text('Vue globale - FST UIN',
                    style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildGlobalStat('Total cours', '48'),
                    _buildGlobalStat('Enseignants', '12'),
                    _buildGlobalStat('Etudiants', '140'),
                    _buildGlobalStat('Modules', '4'),
                  ],
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Taux de presence par module',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                SizedBox(height: 12),
                ...presences.map((p) {
                  final taux = (p['presents'] as int) * 100 ~/ (p['total'] as int);
                  final couleur = taux >= 75 ? Color(0xFF00855A) : Colors.red;
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
                      padding: EdgeInsets.all(14),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: (p['couleur'] as Color).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.book,
                                        color: p['couleur'] as Color, size: 20),
                                  ),
                                  SizedBox(width: 12),
                                  Text(p['module'],
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 15,
                                          color: Color(0xFF003D29))),
                                ],
                              ),
                              Text('$taux%',
                                  style: TextStyle(
                                      color: couleur,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20)),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: (p['presents'] as int) / (p['total'] as int),
                              backgroundColor: Colors.grey[200],
                              color: couleur,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== HISTORIQUE =====================
  Widget _buildHistorique() {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Total', '${historique.length}', Colors.white),
              SizedBox(width: 8),
              _buildStatBadge('Validations',
                  '${historique.where((h) => h['type'] == 'VALIDATION').length}',
                  Colors.greenAccent),
              SizedBox(width: 8),
              _buildStatBadge('Rejets',
                  '${historique.where((h) => h['type'] == 'REJET').length}',
                  Colors.redAccent),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: historique.length,
            itemBuilder: (context, index) {
              final h = historique[index];
              Color couleur;
              IconData icon;
              switch (h['type']) {
                case 'VALIDATION':
                  couleur = Color(0xFF00855A);
                  icon = Icons.check_circle;
                  break;
                case 'REJET':
                  couleur = Colors.red;
                  icon = Icons.cancel;
                  break;
                default:
                  couleur = Colors.blue;
                  icon = Icons.visibility;
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
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: couleur.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: couleur, size: 22),
                  ),
                  title: Text(h['action'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF003D29))),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 2),
                      Text(h['detail'],
                          style: TextStyle(
                              color: Color(0xFF00855A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 2),
                      Row(
                        children: [
                          Icon(Icons.access_time, size: 11, color: Colors.grey),
                          SizedBox(width: 3),
                          Text(h['date'],
                              style: TextStyle(color: Colors.grey, fontSize: 11)),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  // ===================== WIDGETS COMMUNS =====================
  Widget _buildStatBadge(String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(valeur,
                style: TextStyle(
                    color: couleur,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalStat(String label, String valeur) {
    return Column(
      children: [
        Text(valeur,
            style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildMiniStat(String label, int valeur, Color couleur) {
    return Column(
      children: [
        Text('$valeur',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: couleur)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDetailInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        SizedBox(width: 4),
        Text(valeur, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE': couleur = Color(0xFF00855A); break;
      case 'REJETE': couleur = Colors.red; break;
      default: couleur = Colors.orange;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: couleur.withOpacity(0.3)),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }
}