import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class DoyenScreen extends StatefulWidget {
  @override
  _DoyenScreenState createState() => _DoyenScreenState();
}

class _DoyenScreenState extends State<DoyenScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> etats = [
    {
      'titre': 'Etat de presence - Mars 2026',
      'departement': 'Informatique',
      'date': '01/04/2026',
      'statut': 'EN_ATTENTE',
      'nbEtudiants': 140,
      'tauxPresence': 85,
      'couleur': Colors.blue,
      'icon': Icons.people,
    },
    {
      'titre': 'Etat de pointage - Mars 2026',
      'departement': 'Mathematiques',
      'date': '01/04/2026',
      'statut': 'EN_ATTENTE',
      'nbEtudiants': 120,
      'tauxPresence': 78,
      'couleur': Colors.purple,
      'icon': Icons.check_circle,
    },
    {
      'titre': 'Etat paiement vacataires - Fev 2026',
      'departement': 'Physique',
      'date': '15/03/2026',
      'statut': 'VALIDE',
      'nbEtudiants': 95,
      'tauxPresence': 91,
      'couleur': Color(0xFF00855A),
      'icon': Icons.payment,
    },
    {
      'titre': 'Etat de presence - Fev 2026',
      'departement': 'Chimie',
      'date': '15/03/2026',
      'statut': 'REJETE',
      'nbEtudiants': 110,
      'tauxPresence': 62,
      'couleur': Colors.red,
      'icon': Icons.people,
    },
  ];

  final List<Map<String, dynamic>> statsDepar = [
    {'nom': 'Informatique', 'enseignants': 8, 'etudiants': 140, 'taux': 85, 'icon': Icons.computer, 'couleur': Colors.blue},
    {'nom': 'Mathematiques', 'enseignants': 6, 'etudiants': 120, 'taux': 78, 'icon': Icons.calculate, 'couleur': Colors.purple},
    {'nom': 'Physique', 'enseignants': 5, 'etudiants': 95, 'taux': 91, 'icon': Icons.science, 'couleur': Color(0xFF00855A)},
    {'nom': 'Chimie', 'enseignants': 4, 'etudiants': 110, 'taux': 62, 'icon': Icons.biotech, 'couleur': Colors.orange},
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
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'D',
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
                  child: Text('DOYEN',
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
                _buildDrawerItem(1, Icons.verified_outlined, 'Valider Etats'),
                _buildDrawerItem(2, Icons.bar_chart_outlined, 'Statistiques & Rapports'),
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
      case 1: return 'Valider Etats';
      case 2: return 'Statistiques & Rapports';
      default: return 'Doyen';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildTableauBord();
      case 1: return _buildEtats();
      case 2: return _buildStatistiques();
      default: return _buildTableauBord();
    }
  }

  // ===================== TABLEAU DE BORD =====================
  Widget _buildTableauBord() {
    final totalEnseignants = statsDepar.fold(0, (sum, d) => sum + (d['enseignants'] as int));
    final totalEtudiants = statsDepar.fold(0, (sum, d) => sum + (d['etudiants'] as int));
    final tauxMoyen = statsDepar.fold(0, (sum, d) => sum + (d['taux'] as int)) ~/ statsDepar.length;
    final etatsAttente = etats.where((e) => e['statut'] == 'EN_ATTENTE').length;

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
                            user != null ? '${user.prenom[0]}${user.nom[0]}' : 'D',
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
                SizedBox(height: 4),
                Text('Doyen - FST UIN',
                    style: TextStyle(color: Colors.white60, fontSize: 12)),
                SizedBox(height: 20),

                // Stats
                Row(
                  children: [
                    _buildHeaderStat('Enseignants', '$totalEnseignants', Icons.person),
                    SizedBox(width: 8),
                    _buildHeaderStat('Etudiants', '$totalEtudiants', Icons.school),
                    SizedBox(width: 8),
                    _buildHeaderStat('Taux moyen', '$tauxMoyen%', Icons.bar_chart),
                    SizedBox(width: 8),
                    _buildHeaderStat('En attente', '$etatsAttente', Icons.pending),
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
                    _buildActionCard('Valider Etats', Icons.verified, Colors.orange, 1),
                    SizedBox(width: 12),
                    _buildActionCard('Statistiques', Icons.bar_chart, Colors.purple, 2),
                    SizedBox(width: 12),
                    _buildActionCard('Rapports', Icons.picture_as_pdf, Colors.red, 2),
                  ],
                ),

                SizedBox(height: 24),

                // Vue par département
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Vue par departement',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003D29))),
                    Text('${statsDepar.length} dept.',
                        style: TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 13,
                            fontWeight: FontWeight.w500)),
                  ],
                ),
                SizedBox(height: 12),

                ...statsDepar.map((dep) => _buildDepCard(dep)).toList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ===================== ETATS =====================
  Widget _buildEtats() {
    final enAttente = etats.where((e) => e['statut'] == 'EN_ATTENTE').length;
    final valides = etats.where((e) => e['statut'] == 'VALIDE').length;
    final rejetes = etats.where((e) => e['statut'] == 'REJETE').length;

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
              _buildStatBadge('En attente', '$enAttente', Colors.orange),
              SizedBox(width: 8),
              _buildStatBadge('Valides', '$valides', Colors.greenAccent),
              SizedBox(width: 8),
              _buildStatBadge('Rejetes', '$rejetes', Colors.redAccent),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: etats.length,
            itemBuilder: (context, index) {
              final etat = etats[index];
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
                              color: (etat['couleur'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(etat['icon'] as IconData,
                                color: etat['couleur'] as Color, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(etat['titre'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 13,
                                        color: Color(0xFF003D29))),
                                SizedBox(height: 2),
                                Text(etat['departement'],
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          _buildEtatBadge(etat['statut']),
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
                            _buildDetailInfo(Icons.calendar_today, etat['date']),
                            _buildDetailInfo(Icons.people, '${etat['nbEtudiants']} etudiants'),
                            _buildDetailInfo(Icons.bar_chart, '${etat['tauxPresence']}%'),
                          ],
                        ),
                      ),
                      if (etat['statut'] == 'EN_ATTENTE') ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => etat['statut'] = 'VALIDE');
                                  Get.snackbar('Succes', 'Etat valide !',
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
                                  setState(() => etat['statut'] = 'REJETE');
                                  Get.snackbar('Info', 'Etat rejete',
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

  // ===================== STATISTIQUES =====================
  Widget _buildStatistiques() {
    final tauxMoyen = statsDepar.fold(0, (sum, d) => sum + (d['taux'] as int)) ~/ statsDepar.length;
    final critiques = statsDepar.where((s) => (s['taux'] as int) < 75).length;

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
                _buildStatBadge('Departements', '${statsDepar.length}', Colors.white),
                SizedBox(width: 8),
                _buildStatBadge('Taux moyen', '$tauxMoyen%', Colors.greenAccent),
                SizedBox(width: 8),
                _buildStatBadge('Critiques', '$critiques', Colors.redAccent),
              ],
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Stats globales
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Color(0xFF00855A), Color(0xFF003D29)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Text('Statistiques globales - FST UIN',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                              fontWeight: FontWeight.w500)),
                      SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _buildGlobalStat('Departements', '4'),
                          _buildGlobalStat('Enseignants', '23'),
                          _buildGlobalStat('Etudiants', '465'),
                          _buildGlobalStat('Modules', '18'),
                        ],
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 24),

                Text('Taux de presence par departement',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                SizedBox(height: 12),

                ...statsDepar.map((dep) {
                  final taux = dep['taux'] as int;
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
                                      color: (dep['couleur'] as Color).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Icon(dep['icon'] as IconData,
                                        color: dep['couleur'] as Color, size: 20),
                                  ),
                                  SizedBox(width: 12),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(dep['nom'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: Color(0xFF003D29))),
                                      Text('${dep['enseignants']} ens. • ${dep['etudiants']} etu.',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 11)),
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

                _buildRapportCard('Rapport global FST',
                    'Synthese de toutes les presences',
                    Icons.summarize, Color(0xFF00855A)),
                _buildRapportCard('Rapport par departement',
                    'Detail par departement',
                    Icons.business, Colors.blue),
                _buildRapportCard('Rapport financier vacataires',
                    'Etat de paiement des vacataires',
                    Icons.payment, Colors.orange),

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
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 6),
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
                    fontSize: 14,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 9),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(String label, IconData icon, Color couleur, int index) {
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
                      color: Color(0xFF003D29)),
                  textAlign: TextAlign.center),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDepCard(Map<String, dynamic> dep) {
    final taux = dep['taux'] as int;
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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (dep['couleur'] as Color).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(dep['icon'] as IconData,
                      color: dep['couleur'] as Color, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(dep['nom'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF003D29))),
                      Text('${dep['enseignants']} enseignants • ${dep['etudiants']} etudiants',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text('$taux%',
                    style: TextStyle(
                        color: couleur,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
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

  Widget _buildDetailInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        SizedBox(width: 4),
        Text(valeur, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRapportCard(String titre, String description, IconData icon, Color couleur) {
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

  Widget _buildEtatBadge(String statut) {
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