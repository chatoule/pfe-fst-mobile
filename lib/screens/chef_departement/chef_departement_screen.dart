import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'validation_seances_screen.dart';
import 'etat_vacation_screen.dart';

class ChefDepartementScreen extends StatefulWidget {
  @override
  _ChefDepartementScreenState createState() => _ChefDepartementScreenState();
}

class _ChefDepartementScreenState extends State<ChefDepartementScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> coursEnCours = [
    {
      'matiere': 'Informatique',
      'enseignant': 'Dr. Mahamane Moussa',
      'salle': 'C303',
      'heure': '08h00 - 10h00',
      'presents': 28,
      'total': 35,
      'statut': 'EN_COURS',
    },
    {
      'matiere': 'Mathematiques',
      'enseignant': 'Dr. Aichat Salami',
      'salle': 'A101',
      'heure': '10h00 - 12h00',
      'presents': 30,
      'total': 32,
      'statut': 'EN_COURS',
    },
    {
      'matiere': 'Physique',
      'enseignant': 'Dr. Ibrahim Abdou',
      'salle': 'B202',
      'heure': '14h00 - 16h00',
      'presents': 20,
      'total': 30,
      'statut': 'PLANIFIE',
    },
  ];

  final List<Map<String, dynamic>> pointagesEnAttente = [
    {
      'enseignant': 'Dr. Mahamane Moussa',
      'matiere': 'Informatique',
      'date': '2024-03-18',
      'heureDebut': '08h00',
      'heureFin': '10h00',
      'duree': 120,
      'statut': 'EN_ATTENTE',
    },
    {
      'enseignant': 'Dr. Aichat Salami',
      'matiere': 'Mathematiques',
      'date': '2024-03-18',
      'heureDebut': '10h00',
      'heureFin': '12h00',
      'duree': 115,
      'statut': 'EN_ATTENTE',
    },
    {
      'enseignant': 'Dr. Ibrahim Abdou',
      'matiere': 'Physique',
      'date': '2024-03-17',
      'heureDebut': '14h00',
      'heureFin': '16h00',
      'duree': 110,
      'statut': 'EN_ATTENTE',
    },
  ];

  final List<Map<String, dynamic>> statistiques = [
    {'matiere': 'Informatique', 'tauxPresence': 80, 'totalSeances': 10},
    {'matiere': 'Mathematiques', 'tauxPresence': 94, 'totalSeances': 8},
    {'matiere': 'Physique', 'tauxPresence': 67, 'totalSeances': 12},
    {'matiere': 'Chimie', 'tauxPresence': 88, 'totalSeances': 9},
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
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'C',
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
                  child: Text('CHEF DEPARTEMENT',
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
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Tableau de bord'),
                _buildDrawerItem(1, Icons.people_outline, 'Suivi Presences'),
                _buildDrawerItem(2, Icons.check_circle_outline, 'Valider Pointages'),
                _buildDrawerItem(3, Icons.bar_chart_outlined, 'Rapports'),
                _buildDrawerItem(4, Icons.verified_outlined, 'Valider Seances'),
                _buildDrawerItem(5, Icons.payments_outlined, 'Etat de Vacation'),
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
      case 0: return 'Tableau de bord';
      case 1: return 'Suivi Presences';
      case 2: return 'Valider Pointages';
      case 3: return 'Rapports';
      default: return 'Chef Departement';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildTableauBord();
      case 1: return _buildPresences();
      case 2: return _buildPointages();
      case 3: return _buildRapports();
      case 4: return ValidationSeancesScreen();
      case 5: return EtatVacationScreen();
      default: return _buildTableauBord();
    }
  }

  // ===================== TABLEAU DE BORD =====================
  Widget _buildTableauBord() {
    final totalCours = coursEnCours.length;
    final enCours = coursEnCours.where((c) => c['statut'] == 'EN_COURS').length;
    final planifies = coursEnCours.where((c) => c['statut'] == 'PLANIFIE').length;
    final pointagesAttente = pointagesEnAttente.length;

    return SingleChildScrollView(
      child: Column(
        children: [
          // Header gradient
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
                      child: Obx(() {
                        final user = _authController.utilisateur.value;
                        return Center(
                          child: Text(
                            user != null ? '${user.prenom[0]}${user.nom[0]}' : 'C',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        );
                      }),
                    ),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Bonjour,',
                            style: TextStyle(color: Colors.white70, fontSize: 13)),
                        Obx(() => Text(
                          '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        )),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 6),
                Text('Chef de Departement - FST UIN',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
                SizedBox(height: 20),
                Row(
                  children: [
                    _buildHeaderStat('Total', '$totalCours', Icons.list_alt),
                    SizedBox(width: 8),
                    _buildHeaderStat('En cours', '$enCours', Icons.play_circle_outline),
                    SizedBox(width: 8),
                    _buildHeaderStat('Planifies', '$planifies', Icons.schedule),
                    SizedBox(width: 8),
                    _buildHeaderStat('En attente', '$pointagesAttente', Icons.pending_outlined),
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
                // Actions rapides
                Text('Actions rapides',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                SizedBox(height: 12),
                Row(
                  children: [
                    _buildActionCard('Presences', Icons.people, Colors.blue, 1),
                    SizedBox(width: 12),
                    _buildActionCard('Pointages', Icons.check_circle, Colors.orange, 2),
                    SizedBox(width: 12),
                    _buildActionCard('Rapports', Icons.bar_chart, Colors.purple, 3),
                  ],
                ),

                SizedBox(height: 24),

                // Cours du jour
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Cours du jour',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003D29))),
                    TextButton(
                      onPressed: () => setState(() => _currentIndex = 1),
                      child: Text('Voir tout',
                          style: TextStyle(
                              color: Color(0xFF00855A), fontSize: 13)),
                    ),
                  ],
                ),
                SizedBox(height: 8),

                ...coursEnCours.map((cours) => _buildCoursCard(cours)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== PRESENCES =====================
  Widget _buildPresences() {
    return SingleChildScrollView(
      child: Column(
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
                _buildStatBadge('Total', '${coursEnCours.length}', Colors.white),
                SizedBox(width: 8),
                _buildStatBadge('EN_COURS',
                    '${coursEnCours.where((c) => c['statut'] == 'EN_COURS').length}',
                    Colors.orange),
                SizedBox(width: 8),
                _buildStatBadge('PLANIFIE',
                    '${coursEnCours.where((c) => c['statut'] == 'PLANIFIE').length}',
                    Colors.blueAccent),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: coursEnCours.map((cours) {
                final taux = (cours['presents'] / cours['total'] * 100).toInt();
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(cours['matiere'],
                                style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF003D29))),
                            _buildStatutBadge(cours['statut']),
                          ],
                        ),
                        SizedBox(height: 4),
                        Text(cours['enseignant'],
                            style: TextStyle(
                                color: Color(0xFF00855A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                        SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat('Presents', cours['presents'], Color(0xFF00855A)),
                            _buildMiniStat('Absents',
                                cours['total'] - cours['presents'], Colors.red),
                            _buildMiniStat('Total', cours['total'], Colors.blue),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('Taux de presence',
                                style: TextStyle(
                                    color: Colors.grey[600], fontSize: 12)),
                            Text('$taux%',
                                style: TextStyle(
                                    color: taux >= 75
                                        ? Color(0xFF00855A)
                                        : Colors.red,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14)),
                          ],
                        ),
                        SizedBox(height: 6),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: cours['presents'] / cours['total'],
                            backgroundColor: Colors.grey[200],
                            color: taux >= 75 ? Color(0xFF00855A) : Colors.red,
                            minHeight: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== POINTAGES =====================
  Widget _buildPointages() {
    return SingleChildScrollView(
      child: Column(
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
                _buildStatBadge('En attente',
                    '${pointagesEnAttente.length}', Colors.orange),
                SizedBox(width: 8),
                _buildStatBadge('Valides', '0', Colors.greenAccent),
                SizedBox(width: 8),
                _buildStatBadge('Rejetes', '0', Colors.redAccent),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: pointagesEnAttente.map((p) {
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
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 44,
                                  height: 44,
                                  decoration: BoxDecoration(
                                    color: Colors.orange.withOpacity(0.1),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Icon(Icons.pending_actions,
                                      color: Colors.orange, size: 22),
                                ),
                                SizedBox(width: 12),
                                Column(
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
                                            fontSize: 12)),
                                  ],
                                ),
                              ],
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color: Colors.orange.withOpacity(0.3)),
                              ),
                              child: Text('EN ATTENTE',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildDetailInfo(
                                  Icons.calendar_today, p['date']),
                              _buildDetailInfo(Icons.access_time,
                                  '${p['heureDebut']} - ${p['heureFin']}'),
                              _buildDetailInfo(
                                  Icons.timer, '${p['duree']} min'),
                            ],
                          ),
                        ),
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  Get.snackbar('Succes', 'Pointage valide',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Color(0xFF00855A),
                                      colorText: Colors.white,
                                      icon: Icon(Icons.check_circle,
                                          color: Colors.white));
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
                                  Get.snackbar('Info', 'Pointage rejete',
                                      snackPosition: SnackPosition.BOTTOM,
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                      icon: Icon(Icons.cancel,
                                          color: Colors.white));
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
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  // ===================== RAPPORTS =====================
  Widget _buildRapports() {
    return SingleChildScrollView(
      child: Column(
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
                _buildStatBadge('Modules', '${statistiques.length}', Colors.white),
                SizedBox(width: 8),
                _buildStatBadge('Taux moyen',
                    '${(statistiques.fold(0, (sum, s) => sum + (s['tauxPresence'] as int)) / statistiques.length).toInt()}%',
                    Colors.greenAccent),
                SizedBox(width: 8),
                _buildStatBadge('Critiques',
                    '${statistiques.where((s) => (s['tauxPresence'] as int) < 75).length}',
                    Colors.redAccent),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Statistiques par matiere',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                SizedBox(height: 12),

                ...statistiques.map((stat) {
                  final taux = stat['tauxPresence'] as int;
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: couleur.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(Icons.book,
                                        color: couleur, size: 20),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(stat['matiere'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF003D29))),
                                      Text('${stat['totalSeances']} seances',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 12)),
                                    ],
                                  ),
                                ],
                              ),
                              Text('$taux%',
                                  style: TextStyle(
                                      color: couleur,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 22)),
                            ],
                          ),
                          SizedBox(height: 10),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: taux / 100,
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

                SizedBox(height: 8),

                Text('Generer des rapports',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                SizedBox(height: 12),

                _buildRapportCard('Rapport de presences',
                    'Liste complete des presences', Icons.people, Colors.blue),
                _buildRapportCard('Rapport des pointages',
                    'Historique des pointages', Icons.check_circle, Color(0xFF00855A)),
                _buildRapportCard('Etat paiement vacataires',
                    'Calcul heures et paiements', Icons.payment, Colors.orange),

                SizedBox(height: 16),

                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => Get.snackbar('Export', 'Export Excel lance',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.green,
                              colorText: Colors.white),
                          icon: Icon(Icons.table_chart, color: Colors.white),
                          label: Text('Excel',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => Get.snackbar('Export', 'Export PDF lance',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white),
                          icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                          label: Text('PDF',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS COMMUNS =====================
  Widget _buildHeaderStat(String label, String valeur, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 18),
            SizedBox(height: 4),
            Text(valeur,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 9),
                textAlign: TextAlign.center),
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

  Widget _buildCoursCard(Map<String, dynamic> cours) {
    final taux = (cours['presents'] / cours['total'] * 100).toInt();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(cours['matiere'],
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                ),
                _buildStatutBadge(cours['statut']),
              ],
            ),
            SizedBox(height: 4),
            Text(cours['enseignant'],
                style: TextStyle(
                    color: Color(0xFF00855A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            SizedBox(height: 6),
            Row(children: [
              Icon(Icons.access_time, size: 13, color: Colors.grey),
              SizedBox(width: 4),
              Text(cours['heure'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              SizedBox(width: 12),
              Icon(Icons.location_on, size: 13, color: Colors.grey),
              SizedBox(width: 4),
              Text('Salle ${cours['salle']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ]),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${cours['presents']}/${cours['total']} presents',
                    style: TextStyle(
                        color: Color(0xFF00855A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text('$taux%',
                    style: TextStyle(
                        color: taux >= 75 ? Color(0xFF00855A) : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
            SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: cours['presents'] / cours['total'],
                backgroundColor: Colors.grey[200],
                color: taux >= 75 ? Color(0xFF00855A) : Colors.red,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'EN_COURS': couleur = Colors.orange; break;
      case 'TERMINE': couleur = Color(0xFF00855A); break;
      case 'ANNULE': couleur = Colors.red; break;
      default: couleur = Colors.blue;
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

  Widget _buildRapportCard(
      String titre, String description, IconData icon, Color couleur) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: couleur.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: couleur),
        ),
        title: Text(titre,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description,
            style: TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Icon(Icons.download, color: couleur),
        onTap: () => Get.snackbar('Rapport', '$titre genere',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: couleur,
            colorText: Colors.white),
      ),
    );
  }
}