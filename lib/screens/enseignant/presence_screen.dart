import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PresencesScreen extends StatefulWidget {
  @override
  _PresencesScreenState createState() => _PresencesScreenState();
}

class _PresencesScreenState extends State<PresencesScreen> {
  final List<Map<String, String>> cours = [
    {'id': '1', 'matiere': 'Informatique', 'heure': '08h00 - 10h00', 'salle': 'C303'},
    {'id': '2', 'matiere': 'Mathematiques', 'heure': '10h00 - 12h00', 'salle': 'A101'},
  ];

  final Map<String, List<Map<String, dynamic>>> etudiantsParCours = {
    '1': [
      {'matricule': 'ETU001', 'nom': 'Moussa Diallo', 'present': true},
      {'matricule': 'ETU002', 'nom': 'Aichat Salami', 'present': true},
      {'matricule': 'ETU003', 'nom': 'Ibrahim Mahamane', 'present': false},
      {'matricule': 'ETU004', 'nom': 'Fatouma Abdou', 'present': true},
      {'matricule': 'ETU005', 'nom': 'Sani Ousseini', 'present': false},
    ],
    '2': [
      {'matricule': 'ETU001', 'nom': 'Moussa Diallo', 'present': true},
      {'matricule': 'ETU006', 'nom': 'Zeinabou Hamidou', 'present': true},
      {'matricule': 'ETU007', 'nom': 'Adamou Issoufou', 'present': false},
    ],
  };

  String? _coursSelectionne;
  List<Map<String, dynamic>> _etudiants = [];
  bool _valide = false;

  void _selectionnerCours(String coursId) {
    setState(() {
      _coursSelectionne = coursId;
      _etudiants = List<Map<String, dynamic>>.from(
        etudiantsParCours[coursId]!.map((e) => Map<String, dynamic>.from(e)),
      );
      _valide = false;
    });
  }

  void _togglePresence(int index) {
    if (_valide) return;
    setState(() {
      _etudiants[index]['present'] = !_etudiants[index]['present'];
    });
  }

  void _validerPresences() {
    setState(() => _valide = true);
    final absents = _etudiants.where((e) => !e['present']).length;
    Get.snackbar(
      'Presences validees',
      '$absents absent(s) enregistre(s)',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          color: Color(0xFFE8F5F0),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Selectionner un cours',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: Color(0xFF00855A),
                ),
              ),
              SizedBox(height: 8),
              SizedBox(
                height: 40,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cours.length,
                  itemBuilder: (context, index) {
                    final c = cours[index];
                    final isSelected = _coursSelectionne == c['id'];
                    return GestureDetector(
                      onTap: () => _selectionnerCours(c['id']!),
                      child: Container(
                        margin: EdgeInsets.only(right: 8),
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isSelected ? Color(0xFF00855A) : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(color: Color(0xFF00855A)),
                        ),
                        child: Text(
                          c['matiere']!,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Color(0xFF00855A),
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),

        Expanded(
          child: _coursSelectionne == null
              ? _buildAucunCours()
              : _buildListeEtudiants(),
        ),

        if (_coursSelectionne != null && !_valide)
          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: _validerPresences,
                icon: Icon(Icons.check, color: Colors.white),
                label: Text('Valider les presences',
                    style: TextStyle(color: Colors.white, fontSize: 16)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),

        if (_valide)
          Padding(
            padding: EdgeInsets.all(16),
            child: Container(
              width: double.infinity,
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.green),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle, color: Colors.green),
                  SizedBox(width: 8),
                  Text('Presences validees',
                      style: TextStyle(
                          color: Colors.green, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildAucunCours() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('Selectionnez un cours\npour gerer les presences',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildListeEtudiants() {
    final presents = _etudiants.where((e) => e['present']).length;
    final absents = _etudiants.length - presents;

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Row(
            children: [
              _buildStat('Presents', presents, Colors.green),
              SizedBox(width: 12),
              _buildStat('Absents', absents, Colors.red),
              SizedBox(width: 12),
              _buildStat('Total', _etudiants.length, Color(0xFF00855A)),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16),
            itemCount: _etudiants.length,
            itemBuilder: (context, index) {
              final etudiant = _etudiants[index];
              final isPresent = etudiant['present'] as bool;
              return Card(
                margin: EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor:
                    isPresent ? Colors.green[100] : Colors.red[100],
                    child: Icon(
                      isPresent ? Icons.check : Icons.close,
                      color: isPresent ? Colors.green : Colors.red,
                    ),
                  ),
                  title: Text(etudiant['nom'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(etudiant['matricule'],
                      style: TextStyle(color: Colors.grey)),
                  trailing: _valide
                      ? Icon(Icons.lock, color: Colors.grey, size: 18)
                      : Switch(
                    value: isPresent,
                    onChanged: (_) => _togglePresence(index),
                    activeColor: Colors.green,
                    inactiveThumbColor: Colors.red,
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildStat(String label, int valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: couleur.withOpacity(0.1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: couleur.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Text('$valeur',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: couleur)),
            Text(label, style: TextStyle(fontSize: 12, color: couleur)),
          ],
        ),
      ),
    );
  }
}