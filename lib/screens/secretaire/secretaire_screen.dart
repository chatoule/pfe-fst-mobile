import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SecretaireScreen extends StatefulWidget {
  const SecretaireScreen({super.key});

  @override
  State<SecretaireScreen> createState() => _SecretaireScreenState();
}

class _SecretaireScreenState extends State<SecretaireScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  final List<Map<String, dynamic>> etudiants = [
    {'matricule': 'ETU001', 'nom': 'Moussa', 'prenom': 'Diallo', 'niveau': 'L3', 'statut': 'ACTIF', 'couleur': Colors.blue},
    {'matricule': 'ETU002', 'nom': 'Salami', 'prenom': 'Aichat', 'niveau': 'M1', 'statut': 'ACTIF', 'couleur': const Color(0xFF00855A)},
  ];

  final List<Map<String, dynamic>> modules = [
    {'code': 'INF301', 'intitule': 'Algorithmique', 'semestre': 'S1', 'coefficient': '3', 'volumeHoraire': '45', 'couleur': Colors.blue},
    {'code': 'MAT201', 'intitule': 'Analyse', 'semestre': 'S2', 'coefficient': '4', 'volumeHoraire': '60', 'couleur': Colors.purple},
  ];

  final List<Map<String, dynamic>> justifications = [
    {'etudiant': 'Moussa Diallo', 'matiere': 'Info', 'date': '2024-03-15', 'type': 'Certificat', 'statut': 'EN_ATTENTE'},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_getTitre(), style: const TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          )
        ],
      ),
      drawer: _buildDrawer(),
      body: _getScreen(),
      floatingActionButton: _currentIndex < 2 ? FloatingActionButton(
        onPressed: () {},
        backgroundColor: const Color(0xFF00855A),
        child: const Icon(Icons.add, color: Colors.white),
      ) : null,
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 40),
              decoration: const BoxDecoration(color: Color(0xFF00855A)),
              child: const Column(
                children: [
                  CircleAvatar(radius: 40, backgroundColor: Colors.white24, child: Icon(Icons.person, size: 40, color: Colors.white)),
                  SizedBox(height: 10),
                  Text("SECRETAIRE", style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
            _buildDrawerItem(0, Icons.people, "Gestion Etudiants"),
            _buildDrawerItem(1, Icons.book, "Gestion Modules"),
            _buildDrawerItem(2, Icons.description, "Justifications d'Absence"),
            const Spacer(),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text("FST - UIN v1.0", style: TextStyle(color: Colors.grey, fontSize: 12)),
            )
          ]
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final isSelected = _currentIndex == index;
    return ListTile(
      leading: Icon(icon, color: isSelected ? const Color(0xFF00855A) : Colors.grey),
      title: Text(label, style: TextStyle(color: isSelected ? const Color(0xFF00855A) : Colors.black, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
      onTap: () {
        setState(() => _currentIndex = index);
        Navigator.pop(context);
      },
    );
  }

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Etudiants';
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

  Widget _buildUtilisateurs() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: etudiants.length,
      itemBuilder: (context, index) {
        final e = etudiants[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(backgroundColor: e['couleur'].withValues(alpha: 0.1), child: Text(e['prenom'][0])),
            title: Text('${e['prenom']} ${e['nom']}', style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Matricule: ${e['matricule']} • Niveau: ${e['niveau']}'),
            trailing: const Icon(Icons.edit, size: 20),
          ),
        );
      },
    );
  }

  Widget _buildModules() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final m = modules[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: m['couleur'].withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
              child: Icon(Icons.book, color: m['couleur']),
            ),
            title: Text(m['intitule'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Code: ${m['code']} • Coeff: ${m['coefficient']} • VH: ${m['volumeHoraire']}h'),
            trailing: const Icon(Icons.more_vert),
          ),
        );
      },
    );
  }

  Widget _buildJustifications() {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: justifications.length,
      itemBuilder: (context, index) {
        final j = justifications[index];
        return Card(
          elevation: 2,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            title: Text(j['etudiant'], style: const TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('Motif: ${j['type']} • Date: ${j['date']}'),
            trailing: Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(color: Colors.orange.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(20)),
              child: const Text('En attente', style: TextStyle(color: Colors.orange, fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ),
        );
      },
    );
  }
}
