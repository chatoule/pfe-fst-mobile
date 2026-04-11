import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SecretaireScreen extends StatefulWidget {
  @override
  _SecretaireScreenState createState() => _SecretaireScreenState();
}

class _SecretaireScreenState extends State<SecretaireScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> etudiants = [
    {'matricule': 'ETU001', 'nom': 'Moussa', 'prenom': 'Diallo', 'niveau': 'L3', 'statut': 'ACTIF', 'couleur': Colors.blue},
    {'matricule': 'ETU002', 'nom': 'Salami', 'prenom': 'Aichat', 'niveau': 'M1', 'statut': 'ACTIF', 'couleur': Color(0xFF00855A)},
    {'matricule': 'ETU003', 'nom': 'Mahamane', 'prenom': 'Ibrahim', 'niveau': 'L2', 'statut': 'INACTIF', 'couleur': Colors.grey},
    {'matricule': 'ETU004', 'nom': 'Abdou', 'prenom': 'Fatouma', 'niveau': 'L3', 'statut': 'ACTIF', 'couleur': Colors.purple},
  ];

  final List<Map<String, dynamic>> enseignants = [
    {'matricule': 'ENS001', 'nom': 'Mahamane', 'prenom': 'Moussa', 'grade': 'Professeur', 'statut': 'ACTIF', 'couleur': Colors.blue},
    {'matricule': 'ENS002', 'nom': 'Salami', 'prenom': 'Aichat', 'grade': 'Maitre de conference', 'statut': 'ACTIF', 'couleur': Color(0xFF00855A)},
    {'matricule': 'ENS003', 'nom': 'Abdou', 'prenom': 'Ibrahim', 'grade': 'Vacataire', 'statut': 'ACTIF', 'couleur': Colors.orange},
  ];

  final List<Map<String, dynamic>> modules = [
    {'code': 'INF301', 'intitule': 'Algorithmique', 'semestre': 'S1', 'coefficient': '3', 'volumeHoraire': '45', 'couleur': Colors.blue},
    {'code': 'MAT201', 'intitule': 'Analyse', 'semestre': 'S2', 'coefficient': '4', 'volumeHoraire': '60', 'couleur': Colors.purple},
    {'code': 'PHY101', 'intitule': 'Mecanique', 'semestre': 'S1', 'coefficient': '2', 'volumeHoraire': '30', 'couleur': Color(0xFF00855A)},
    {'code': 'CHI201', 'intitule': 'Chimie Organique', 'semestre': 'S2', 'coefficient': '3', 'volumeHoraire': '45', 'couleur': Colors.orange},
  ];

  final List<Map<String, dynamic>> justifications = [
    {'etudiant': 'Moussa Diallo', 'matiere': 'Informatique', 'date': '2024-03-15', 'type': 'Certificat medical', 'statut': 'EN_ATTENTE'},
    {'etudiant': 'Aichat Salami', 'matiere': 'Mathematiques', 'date': '2024-03-14', 'type': 'Convocation officielle', 'statut': 'VALIDE'},
    {'etudiant': 'Ibrahim Mahamane', 'matiere': 'Physique', 'date': '2024-03-13', 'type': 'Deces famille', 'statut': 'EN_ATTENTE'},
    {'etudiant': 'Fatouma Abdou', 'matiere': 'Chimie', 'date': '2024-03-12', 'type': 'Autre', 'statut': 'REJETE'},
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
                  child: Text('SECRETAIRE',
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
                _buildDrawerItem(0, Icons.people_outline, 'Utilisateurs'),
                _buildDrawerItem(1, Icons.book_outlined, 'Modules'),
                _buildDrawerItem(2, Icons.assignment_outlined, 'Justifications'),
                _buildDrawerItem(3, Icons.bar_chart_outlined, 'Rapports'),
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
      case 0: return 'Gestion Utilisateurs';
      case 1: return 'Gestion Modules';
      case 2: return 'Gestion Justifications';
      case 3: return 'Rapports & Exports';
      default: return 'Secretaire';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildUtilisateurs();
      case 1: return _buildModules();
      case 2: return _buildJustifications();
      case 3: return _buildRapports();
      default: return _buildUtilisateurs();
    }
  }

  // ===================== UTILISATEURS =====================
  Widget _buildUtilisateurs() {
    return DefaultTabController(
      length: 2,
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
                _buildStatBadge('Etudiants', '${etudiants.length}', Colors.white),
                SizedBox(width: 8),
                _buildStatBadge('Enseignants', '${enseignants.length}', Colors.greenAccent),
                SizedBox(width: 8),
                _buildStatBadge('Total', '${etudiants.length + enseignants.length}', Colors.blueAccent),
              ],
            ),
          ),
          Container(
            color: Colors.white,
            child: TabBar(
              labelColor: Color(0xFF00855A),
              unselectedLabelColor: Colors.grey,
              indicatorColor: Color(0xFF00855A),
              tabs: [
                Tab(text: 'Etudiants (${etudiants.length})'),
                Tab(text: 'Enseignants (${enseignants.length})'),
              ],
            ),
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildListeEtudiants(),
                _buildListeEnseignants(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildListeEtudiants() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: etudiants.length,
            itemBuilder: (context, index) {
              final e = etudiants[index];
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (e['couleur'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e['prenom'][0]}${e['nom'][0]}',
                        style: TextStyle(
                            color: e['couleur'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text('${e['prenom']} ${e['nom']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  subtitle: Text('${e['matricule']} • ${e['niveau']}',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: _buildBadge(e['statut']),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: _buildAddButton('Ajouter un etudiant', () => _showAjouterDialog('Etudiant')),
        ),
      ],
    );
  }

  Widget _buildListeEnseignants() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: enseignants.length,
            itemBuilder: (context, index) {
              final e = enseignants[index];
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
                  contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  leading: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: (e['couleur'] as Color).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${e['prenom'][0]}${e['nom'][0]}',
                        style: TextStyle(
                            color: e['couleur'] as Color,
                            fontWeight: FontWeight.bold,
                            fontSize: 16),
                      ),
                    ),
                  ),
                  title: Text('${e['prenom']} ${e['nom']}',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  subtitle: Text('${e['matricule']} • ${e['grade']}',
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                  trailing: _buildBadge(e['statut']),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: _buildAddButton('Ajouter un enseignant', () => _showAjouterDialog('Enseignant')),
        ),
      ],
    );
  }

  // ===================== MODULES =====================
  Widget _buildModules() {
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
              _buildStatBadge('Total', '${modules.length}', Colors.white),
              SizedBox(width: 8),
              _buildStatBadge('Semestre 1', '${modules.where((m) => m['semestre'] == 'S1').length}', Colors.greenAccent),
              SizedBox(width: 8),
              _buildStatBadge('Semestre 2', '${modules.where((m) => m['semestre'] == 'S2').length}', Colors.blueAccent),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final m = modules[index];
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
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: (m['couleur'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Center(
                          child: Text(m['code'].substring(0, 3),
                              style: TextStyle(
                                  color: m['couleur'] as Color,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12)),
                        ),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(m['intitule'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF003D29))),
                            SizedBox(height: 4),
                            Row(children: [
                              _buildTag(m['semestre'], m['couleur'] as Color),
                              SizedBox(width: 6),
                              _buildTag('Coef: ${m['coefficient']}', Colors.grey),
                              SizedBox(width: 6),
                              _buildTag('${m['volumeHoraire']}h', Colors.orange),
                            ]),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: Color(0xFF00855A), size: 20),
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: _buildAddButton('Ajouter un module', () => _showAjouterDialog('Module')),
        ),
      ],
    );
  }

  // ===================== JUSTIFICATIONS =====================
  Widget _buildJustifications() {
    final enAttente = justifications.where((j) => j['statut'] == 'EN_ATTENTE').length;
    final valides = justifications.where((j) => j['statut'] == 'VALIDE').length;

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
              _buildStatBadge('Total', '${justifications.length}', Colors.white),
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
            itemCount: justifications.length,
            itemBuilder: (context, index) {
              final j = justifications[index];
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
                              color: Colors.blue.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.person, color: Colors.blue, size: 22),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(j['etudiant'],
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF003D29))),
                                Text('${j['matiere']} • ${j['type']}',
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500)),
                              ],
                            ),
                          ),
                          _buildJustifBadge(j['statut']),
                        ],
                      ),
                      SizedBox(height: 8),
                      Row(children: [
                        Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(j['date'], style: TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                      if (j['statut'] == 'EN_ATTENTE') ...[
                        SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  setState(() => j['statut'] = 'VALIDE');
                                  Get.snackbar('Succes', 'Justificatif valide !',
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
                                  setState(() => j['statut'] = 'REJETE');
                                  Get.snackbar('Info', 'Justificatif rejete',
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

  // ===================== RAPPORTS =====================
  Widget _buildRapports() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generer des rapports',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003D29))),
          SizedBox(height: 12),

          _buildRapportCard('Rapport de presences',
              'Liste complete des presences et absences',
              Icons.people, Colors.blue),
          _buildRapportCard('Rapport des pointages',
              'Historique des pointages des enseignants',
              Icons.check_circle, Color(0xFF00855A)),
          _buildRapportCard('Etat de paiement vacataires',
              'Calcul des heures et paiements',
              Icons.payment, Colors.orange),
          _buildRapportCard('Rapport des justificatifs',
              'Liste des justificatifs soumis',
              Icons.assignment, Colors.purple),

          SizedBox(height: 24),

          Text('Exporter les donnees',
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF003D29))),
          SizedBox(height: 12),

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
                    color: couleur, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildTag(String label, Color couleur) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(label,
          style: TextStyle(
              color: couleur, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBadge(String statut) {
    Color couleur = statut == 'ACTIF' ? Color(0xFF00855A) : Colors.grey;
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

  Widget _buildJustifBadge(String statut) {
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

  Widget _buildAddButton(String label, VoidCallback onPressed) {
    return Container(
      width: double.infinity,
      height: 50,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF00A86B), Color(0xFF00855A)],
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Color(0xFF00855A).withOpacity(0.3),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(label,
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.transparent,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
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

  void _showAjouterDialog(String type) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.add_circle, color: Color(0xFF00855A)),
            SizedBox(width: 8),
            Text('Ajouter un $type'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('Nom', Icons.person),
            SizedBox(height: 10),
            _buildDialogField('Prenom', Icons.person_outline),
            SizedBox(height: 10),
            _buildDialogField('Matricule', Icons.badge),
            SizedBox(height: 10),
            _buildDialogField(
                type == 'Etudiant' ? 'Niveau' : type == 'Enseignant' ? 'Grade' : 'Code',
                Icons.info_outline),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              Get.snackbar('Succes', '$type ajoute avec succes !',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white,
                  icon: Icon(Icons.check_circle, color: Colors.white));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Ajouter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, IconData icon) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF00855A), size: 20),
        filled: true,
        fillColor: Color(0xFFF5FAF7),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00855A)),
        ),
      ),
    );
  }
}