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

  // Données mock
  final List<Map<String, dynamic>> etudiants = [
    {'matricule': 'ETU001', 'nom': 'Moussa', 'prenom': 'Diallo', 'niveau': 'L3', 'statut': 'ACTIF'},
    {'matricule': 'ETU002', 'nom': 'Salami', 'prenom': 'Aichat', 'niveau': 'M1', 'statut': 'ACTIF'},
    {'matricule': 'ETU003', 'nom': 'Mahamane', 'prenom': 'Ibrahim', 'niveau': 'L2', 'statut': 'INACTIF'},
    {'matricule': 'ETU004', 'nom': 'Abdou', 'prenom': 'Fatouma', 'niveau': 'L3', 'statut': 'ACTIF'},
  ];

  final List<Map<String, dynamic>> enseignants = [
    {'matricule': 'ENS001', 'nom': 'Mahamane', 'prenom': 'Moussa', 'grade': 'Professeur', 'statut': 'ACTIF'},
    {'matricule': 'ENS002', 'nom': 'Salami', 'prenom': 'Aichat', 'grade': 'Maitre de conference', 'statut': 'ACTIF'},
    {'matricule': 'ENS003', 'nom': 'Abdou', 'prenom': 'Ibrahim', 'grade': 'Vacataire', 'statut': 'ACTIF'},
  ];

  final List<Map<String, dynamic>> modules = [
    {'code': 'INF301', 'intitule': 'Algorithmique', 'semestre': 'S1', 'coefficient': '3', 'volumeHoraire': '45'},
    {'code': 'MAT201', 'intitule': 'Analyse', 'semestre': 'S2', 'coefficient': '4', 'volumeHoraire': '60'},
    {'code': 'PHY101', 'intitule': 'Mecanique', 'semestre': 'S1', 'coefficient': '2', 'volumeHoraire': '30'},
    {'code': 'CHI201', 'intitule': 'Chimie Organique', 'semestre': 'S2', 'coefficient': '3', 'volumeHoraire': '45'},
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
      appBar: AppBar(
        title: Text(_getTitre()),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      body: _getScreen(),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Color(0xFF00855A),
        unselectedItemColor: Colors.grey,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Utilisateurs',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.book),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment),
            label: 'Justifications',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Rapports',
          ),
        ],
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
      case 0: return _buildUtilisateursTab();
      case 1: return _buildModulesTab();
      case 2: return _buildJustificationsTab();
      case 3: return _buildRapportsTab();
      default: return _buildUtilisateursTab();
    }
  }

  // ===================== UTILISATEURS =====================
  Widget _buildUtilisateursTab() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          Container(
            color: Color(0xFF00855A).withOpacity(0.1),
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
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF00855A).withOpacity(0.1),
                    child: Text(
                      e['nom'][0],
                      style: TextStyle(
                          color: Color(0xFF00855A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('${e['prenom']} ${e['nom']}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${e['matricule']} • ${e['niveau']}'),
                  trailing: _buildBadge(e['statut']),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showAjouterEtudiant(),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Ajouter un etudiant',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
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
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF00855A).withOpacity(0.1),
                    child: Text(
                      e['nom'][0],
                      style: TextStyle(
                          color: Color(0xFF00855A),
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  title: Text('${e['prenom']} ${e['nom']}',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text('${e['matricule']} • ${e['grade']}'),
                  trailing: _buildBadge(e['statut']),
                ),
              );
            },
          ),
        ),
        Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showAjouterEnseignant(),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Ajouter un enseignant',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===================== MODULES =====================
  Widget _buildModulesTab() {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: modules.length,
            itemBuilder: (context, index) {
              final m = modules[index];
              return Card(
                margin: EdgeInsets.only(bottom: 10),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: EdgeInsets.all(14),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: Color(0xFF00855A).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Center(
                          child: Text(m['code'].substring(0, 3),
                              style: TextStyle(
                                  color: Color(0xFF00855A),
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
                                    fontWeight: FontWeight.bold, fontSize: 15)),
                            SizedBox(height: 4),
                            Text(
                                '${m['code']} • ${m['semestre']} • Coef: ${m['coefficient']}',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                            Text('Volume horaire: ${m['volumeHoraire']}h',
                                style: TextStyle(
                                    color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ),
                      IconButton(
                        icon: Icon(Icons.edit, color: Color(0xFF00855A)),
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
          child: SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () => _showAjouterModule(),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Ajouter un module',
                  style: TextStyle(color: Colors.white)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ===================== JUSTIFICATIONS =====================
  Widget _buildJustificationsTab() {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: justifications.length,
      itemBuilder: (context, index) {
        final j = justifications[index];
        return Card(
          margin: EdgeInsets.only(bottom: 12),
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
                    Text(j['etudiant'],
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 15)),
                    _buildJustifBadge(j['statut']),
                  ],
                ),
                SizedBox(height: 6),
                Text('Matiere: ${j['matiere']}',
                    style: TextStyle(color: Colors.grey)),
                Text('Type: ${j['type']}',
                    style: TextStyle(color: Colors.grey)),
                Text('Date: ${j['date']}',
                    style: TextStyle(color: Colors.grey)),
                if (j['statut'] == 'EN_ATTENTE') ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar('Succes', 'Justificatif valide',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Color(0xFF00855A),
                                colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF00855A),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Valider',
                              style: TextStyle(color: Colors.white)),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar('Info', 'Justificatif rejete',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.red,
                                colorText: Colors.white);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                          ),
                          child: Text('Rejeter',
                              style: TextStyle(color: Colors.white)),
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

  // ===================== RAPPORTS =====================
  Widget _buildRapportsTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Generer des rapports',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          _buildRapportCard(
            'Rapport de presences',
            'Liste complete des presences et absences',
            Icons.people,
            Colors.blue,
          ),
          _buildRapportCard(
            'Rapport des pointages',
            'Historique des pointages des enseignants',
            Icons.check_circle,
            Color(0xFF00855A),
          ),
          _buildRapportCard(
            'Etat de paiement vacataires',
            'Calcul des heures et paiements',
            Icons.payment,
            Colors.orange,
          ),
          _buildRapportCard(
            'Rapport des justificatifs',
            'Liste des justificatifs soumis',
            Icons.assignment,
            Colors.purple,
          ),

          SizedBox(height: 24),

          Text('Exporter les donnees',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _buildExportButton(
                    'Excel', Icons.table_chart, Colors.green),
              ),
              SizedBox(width: 12),
              Expanded(
                child: _buildExportButton(
                    'PDF', Icons.picture_as_pdf, Colors.red),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRapportCard(
      String titre, String description, IconData icon, Color couleur) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
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
        onTap: () {
          Get.snackbar(
            'Export',
            '$titre genere avec succes',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: couleur,
            colorText: Colors.white,
          );
        },
      ),
    );
  }

  Widget _buildExportButton(String label, IconData icon, Color couleur) {
    return ElevatedButton.icon(
      onPressed: () {
        Get.snackbar('Export', 'Export $label lance',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: couleur,
            colorText: Colors.white);
      },
      icon: Icon(icon, color: Colors.white),
      label: Text(label, style: TextStyle(color: Colors.white)),
      style: ElevatedButton.styleFrom(
        backgroundColor: couleur,
        padding: EdgeInsets.symmetric(vertical: 14),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ===================== DIALOGS =====================
  void _showAjouterEtudiant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un etudiant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Nom'),
            SizedBox(height: 10),
            _buildTextField('Prenom'),
            SizedBox(height: 10),
            _buildTextField('Matricule'),
            SizedBox(height: 10),
            _buildTextField('Niveau (L1, L2, M1...)'),
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
              Get.snackbar('Succes', 'Etudiant ajoute avec succes',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A)),
            child: Text('Ajouter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAjouterEnseignant() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un enseignant'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Nom'),
            SizedBox(height: 10),
            _buildTextField('Prenom'),
            SizedBox(height: 10),
            _buildTextField('Matricule'),
            SizedBox(height: 10),
            _buildTextField('Grade'),
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
              Get.snackbar('Succes', 'Enseignant ajoute avec succes',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A)),
            child: Text('Ajouter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showAjouterModule() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Ajouter un module'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildTextField('Code'),
            SizedBox(height: 10),
            _buildTextField('Intitule'),
            SizedBox(height: 10),
            _buildTextField('Semestre'),
            SizedBox(height: 10),
            _buildTextField('Coefficient'),
            SizedBox(height: 10),
            _buildTextField('Volume horaire'),
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
              Get.snackbar('Succes', 'Module ajoute avec succes',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A)),
            child: Text('Ajouter', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  // ===================== WIDGETS COMMUNS =====================
  Widget _buildTextField(String label) {
    return TextField(
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: Color(0xFF00855A)),
        ),
      ),
    );
  }

  Widget _buildBadge(String statut) {
    Color couleur = statut == 'ACTIF' ? Color(0xFF00855A) : Colors.grey;
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
        border: Border.all(color: couleur),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur, fontWeight: FontWeight.bold, fontSize: 11)),
    );
  }
}