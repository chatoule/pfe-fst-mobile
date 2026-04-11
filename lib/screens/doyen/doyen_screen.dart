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

  // Données mock
  final List<Map<String, dynamic>> etats = [
    {
      'titre': 'Etat de presence - Mars 2026',
      'departement': 'Informatique',
      'date': '01/04/2026',
      'statut': 'EN_ATTENTE',
      'nbEtudiants': 140,
      'tauxPresence': 85,
    },
    {
      'titre': 'Etat de pointage - Mars 2026',
      'departement': 'Mathematiques',
      'date': '01/04/2026',
      'statut': 'EN_ATTENTE',
      'nbEtudiants': 120,
      'tauxPresence': 78,
    },
    {
      'titre': 'Etat paiement vacataires - Fev 2026',
      'departement': 'Physique',
      'date': '15/03/2026',
      'statut': 'VALIDE',
      'nbEtudiants': 95,
      'tauxPresence': 91,
    },
    {
      'titre': 'Etat de presence - Fev 2026',
      'departement': 'Chimie',
      'date': '15/03/2026',
      'statut': 'REJETE',
      'nbEtudiants': 110,
      'tauxPresence': 62,
    },
  ];

  final List<Map<String, dynamic>> statsDepar = [
    {'nom': 'Informatique', 'enseignants': 8, 'etudiants': 140, 'taux': 85},
    {'nom': 'Mathematiques', 'enseignants': 6, 'etudiants': 120, 'taux': 78},
    {'nom': 'Physique', 'enseignants': 5, 'etudiants': 95, 'taux': 91},
    {'nom': 'Chimie', 'enseignants': 4, 'etudiants': 110, 'taux': 62},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitre()),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
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
          // En-tête
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00855A), Color(0xFF005C3E)],
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

          // Menu items
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 8),
                _buildDrawerItem(0, Icons.dashboard, 'Tableau de bord'),
                _buildDrawerItem(1, Icons.verified, 'Valider Etats'),
                _buildDrawerItem(2, Icons.bar_chart, 'Statistiques & Rapports'),
              ],
            ),
          ),

          // Footer
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
            color: isActive ? Color(0xFF00855A) : Colors.grey[700], size: 22),
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
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Carte de bienvenue
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00855A), Color(0xFF005C3E)],
              ),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Bienvenue,',
                    style: TextStyle(color: Colors.white70, fontSize: 14)),
                Obx(() => Text(
                  '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 4),
                Text('Doyen - FST UIN',
                    style: TextStyle(color: Colors.white60, fontSize: 13)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildHeaderStat('Enseignants', '$totalEnseignants'),
                    _buildHeaderStat('Etudiants', '$totalEtudiants'),
                    _buildHeaderStat('Taux moyen', '$tauxMoyen%'),
                    _buildHeaderStat('En attente', '$etatsAttente'),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          Text('Vue par departement',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: statsDepar.length,
            itemBuilder: (context, index) {
              final dep = statsDepar[index];
              final taux = dep['taux'] as int;
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(dep['nom'],
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 16)),
                          Text('$taux%',
                              style: TextStyle(
                                  color: taux >= 75
                                      ? Color(0xFF00855A)
                                      : Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16)),
                        ],
                      ),
                      SizedBox(height: 6),
                      Row(children: [
                        Icon(Icons.people, size: 14, color: Colors.grey),
                        SizedBox(width: 4),
                        Text('${dep['enseignants']} enseignants • ${dep['etudiants']} etudiants',
                            style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                      SizedBox(height: 8),
                      LinearProgressIndicator(
                        value: taux / 100,
                        backgroundColor: Colors.grey[200],
                        color: taux >= 75 ? Color(0xFF00855A) : Colors.red,
                        minHeight: 6,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // ===================== ETATS =====================
  Widget _buildEtats() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: etats.length,
      itemBuilder: (context, index) {
        final etat = etats[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          elevation: 2,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(etat['titre'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 14)),
                    ),
                    _buildEtatBadge(etat['statut']),
                  ],
                ),
                SizedBox(height: 8),
                Row(children: [
                  Icon(Icons.business, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(etat['departement'],
                      style: TextStyle(color: Colors.grey)),
                  SizedBox(width: 12),
                  Icon(Icons.calendar_today, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text(etat['date'],
                      style: TextStyle(color: Colors.grey)),
                ]),
                SizedBox(height: 6),
                Row(children: [
                  Icon(Icons.people, size: 14, color: Colors.grey),
                  SizedBox(width: 4),
                  Text('${etat['nbEtudiants']} etudiants • Taux: ${etat['tauxPresence']}%',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ]),
                if (etat['statut'] == 'EN_ATTENTE') ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => etat['statut'] = 'VALIDE');
                            Get.snackbar(
                              'Succes',
                              'Etat valide avec succes',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Color(0xFF00855A),
                              colorText: Colors.white,
                            );
                          },
                          icon: Icon(Icons.check, color: Colors.white, size: 16),
                          label: Text('Valider',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00855A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            setState(() => etat['statut'] = 'REJETE');
                            Get.snackbar(
                              'Info',
                              'Etat rejete',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          },
                          icon: Icon(Icons.close, color: Colors.white, size: 16),
                          label: Text('Rejeter',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
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
    );
  }

  // ===================== STATISTIQUES =====================
  Widget _buildStatistiques() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Stats globales
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF00855A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Statistiques globales - FST UIN',
                    style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                        fontWeight: FontWeight.bold)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Departements', '4'),
                    _buildStatItem('Enseignants', '23'),
                    _buildStatItem('Etudiants', '465'),
                    _buildStatItem('Modules', '18'),
                  ],
                ),
              ],
            ),
          ),

          SizedBox(height: 24),

          Text('Taux de presence par departement',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          ...statsDepar.map((dep) {
            final taux = dep['taux'] as int;
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(dep['nom'],
                          style: TextStyle(fontWeight: FontWeight.w500)),
                      Text('$taux%',
                          style: TextStyle(
                              color: taux >= 75
                                  ? Color(0xFF00855A)
                                  : Colors.red,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                  SizedBox(height: 6),
                  LinearProgressIndicator(
                    value: taux / 100,
                    backgroundColor: Colors.grey[200],
                    color: taux >= 75 ? Color(0xFF00855A) : Colors.red,
                    minHeight: 8,
                  ),
                ],
              ),
            );
          }).toList(),

          SizedBox(height: 24),

          Text('Generer des rapports',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          _buildRapportCard('Rapport global FST',
              'Synthese de toutes les presences', Icons.summarize, Color(0xFF00855A)),
          _buildRapportCard('Rapport par departement',
              'Detail par departement', Icons.business, Colors.blue),
          _buildRapportCard('Rapport financier vacataires',
              'Etat de paiement des vacataires', Icons.payment, Colors.orange),

          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.snackbar('Export', 'Export Excel lance',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.green,
                      colorText: Colors.white),
                  icon: Icon(Icons.table_chart, color: Colors.white),
                  label: Text('Excel', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => Get.snackbar('Export', 'Export PDF lance',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.red,
                      colorText: Colors.white),
                  icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: Text('PDF', style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS COMMUNS =====================
  Widget _buildHeaderStat(String label, String valeur) {
    return Column(
      children: [
        Text(valeur,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildStatItem(String label, String valeur) {
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

  Widget _buildRapportCard(
      String titre, String description, IconData icon, Color couleur) {
    return Card(
      margin: EdgeInsets.only(bottom: 10),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        title: Text(titre, style: TextStyle(fontWeight: FontWeight.bold)),
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
        border: Border.all(color: couleur),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}