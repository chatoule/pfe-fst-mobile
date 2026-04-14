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

  // ===================== DONNÉES =====================

  final List<Map<String, dynamic>> etudiants = [
    {'matricule': 'ETU001', 'nom': 'Moussa', 'prenom': 'Diallo', 'niveau': 'L3', 'statut': 'ACTIF', 'couleur': Colors.blue},
    {'matricule': 'ETU002', 'nom': 'Salami', 'prenom': 'Aichat', 'niveau': 'M1', 'statut': 'ACTIF', 'couleur': Color(0xFF00855A)},
  ];

  final List<Map<String, dynamic>> enseignants = [
    {'matricule': 'ENS001', 'nom': 'Mahamane', 'prenom': 'Moussa', 'grade': 'Professeur', 'statut': 'ACTIF', 'couleur': Colors.blue},
    {'matricule': 'ENS002', 'nom': 'Salami', 'prenom': 'Aichat', 'grade': 'Maitre', 'statut': 'ACTIF', 'couleur': Color(0xFF00855A)},
  ];

  final List<Map<String, dynamic>> modules = [
    {'code': 'INF301', 'intitule': 'Algorithmique', 'semestre': 'S1', 'coefficient': '3', 'volumeHoraire': '45', 'couleur': Colors.blue},
    {'code': 'MAT201', 'intitule': 'Analyse', 'semestre': 'S2', 'coefficient': '4', 'volumeHoraire': '60', 'couleur': Colors.purple},
  ];

  final List<Map<String, dynamic>> justifications = [
    {'etudiant': 'Moussa Diallo', 'matiere': 'Info', 'date': '2024-03-15', 'type': 'Certificat', 'statut': 'EN_ATTENTE'},
  ];

  // ===================== UI =====================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getTitre()),
        backgroundColor: Color(0xFF00855A),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: _getScreen(),
    );
  }

  // ===================== DRAWER =====================

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Color(0xFF00855A)),
              child: Center(
                child: Text("SECRETAIRE",
                    style: TextStyle(color: Colors.white, fontSize: 18)),
              ),
            ),
            _buildDrawerItem(0, "Utilisateurs"),
            _buildDrawerItem(1, "Modules"),
            _buildDrawerItem(2, "Justifications"),
          ]
      ),
    );
  }

  Widget _buildDrawerItem(int index, String label) {
    return ListTile(
      title: Text(label),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }

  // ===================== NAVIGATION =====================

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Utilisateurs';
      case 1: return 'Modules';
      case 2: return 'Justifications';
      default: return '';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildUtilisateurs();
      case 1: return _buildModules();
      case 2: return _buildJustifications();
      default: return Container();
    }
  }

  // ===================== UTILISATEURS =====================

  Widget _buildUtilisateurs() {
    return ListView(
      children: [
        ...etudiants.map((e) => ListTile(
          title: Text('${e['prenom']} ${e['nom']}'),
          subtitle: Text(e['niveau']),
        ))
      ],
    );
  }

  // ===================== MODULES =====================

  Widget _buildModules() {
    return ListView.builder(
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final m = modules[index];
        return ListTile(
          title: Text(m['intitule']),
          subtitle: Text('${m['code']} - ${m['semestre']}'),
        );
      },
    );
  }

  // ===================== JUSTIFICATIONS =====================

  Widget _buildJustifications() {
    return ListView.builder(
      itemCount: justifications.length,
      itemBuilder: (context, index) {
        final j = justifications[index];
        return ListTile(
          title: Text(j['etudiant']),
          subtitle: Text(j['type']),
        );
      },
    );
  }
}