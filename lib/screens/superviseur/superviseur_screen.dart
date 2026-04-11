import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

class SuperviseurScreen extends StatefulWidget {
  @override
  _SuperviseurScreenState createState() => _SuperviseurScreenState();
}

class _SuperviseurScreenState extends State<SuperviseurScreen> {
  final AuthController _authController = Get.put(AuthController());
  int _currentIndex = 0;

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
            icon: Icon(Icons.check_circle),
            label: 'Pointages',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Presences',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Historique',
          ),
        ],
      ),
    );
  }

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Valider Pointages';
      case 1: return 'Suivre Presences';
      case 2: return 'Statistiques';
      case 3: return 'Historique';
      default: return 'Superviseur';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildPointagesTab();
      case 1: return _buildPresencesTab();
      case 2: return _buildStatistiquesTab();
      case 3: return _buildHistoriqueTab();
      default: return _buildPointagesTab();
    }
  }

  Widget _buildPointagesTab() {
    final pointages = [
      {'enseignant': 'Moussa Ali', 'matiere': 'Mathematiques',
        'date': '2024-03-15', 'heure': '08h00-10h00', 'statut': 'EN_ATTENTE'},
      {'enseignant': 'Diallo Ibrahim', 'matiere': 'Physique',
        'date': '2024-03-15', 'heure': '10h00-12h00', 'statut': 'EN_ATTENTE'},
      {'enseignant': 'Maiga Fatima', 'matiere': 'Chimie',
        'date': '2024-03-14', 'heure': '14h00-16h00', 'statut': 'VALIDE'},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: pointages.length,
      itemBuilder: (context, index) {
        final p = pointages[index];
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
                    Text(p['matiere']!,
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold)),
                    _buildBadge(p['statut']!),
                  ],
                ),
                SizedBox(height: 8),
                Text('Enseignant: ${p['enseignant']}',
                    style: TextStyle(color: Colors.grey)),
                Text('${p['date']} • ${p['heure']}',
                    style: TextStyle(color: Colors.grey)),
                if (p['statut'] == 'EN_ATTENTE') ...[
                  SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () {
                            Get.snackbar('Succes', 'Pointage valide',
                                snackPosition: SnackPosition.BOTTOM,
                                backgroundColor: Colors.green,
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
                            Get.snackbar('Info', 'Pointage rejete',
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

  Widget _buildPresencesTab() {
    final presences = [
      {'module': 'Mathematiques', 'total': '35', 'presents': '30', 'absents': '5'},
      {'module': 'Physique', 'total': '35', 'presents': '28', 'absents': '7'},
      {'module': 'Informatique', 'total': '35', 'presents': '33', 'absents': '2'},
      {'module': 'Chimie', 'total': '35', 'presents': '25', 'absents': '10'},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: presences.length,
      itemBuilder: (context, index) {
        final p = presences[index];
        final taux = (int.parse(p['presents']!) / int.parse(p['total']!) * 100).toInt();
        return Card(
          margin: EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(p['module']!,
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Presents: ${p['presents']}/${p['total']}',
                        style: TextStyle(color: Colors.grey)),
                    Text('$taux%',
                        style: TextStyle(
                            color: taux >= 75 ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold)),
                  ],
                ),
                SizedBox(height: 8),
                LinearProgressIndicator(
                  value: taux / 100,
                  backgroundColor: Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation(
                      taux >= 75 ? Color(0xFF00855A) : Colors.red),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatistiquesTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16),
      child: Column(
        children: [
          // Carte stats globales
          Container(
            width: double.infinity,
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Color(0xFF00855A),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text('Vue globale',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 14)),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildStatItem('Total cours', '48', Colors.white),
                    _buildStatItem('Enseignants', '12', Colors.white),
                    _buildStatItem('Etudiants', '140', Colors.white),
                  ],
                ),
              ],
            ),
          ),
          SizedBox(height: 16),

          // Stats par module
          Text('Taux de presence par module',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold)),
          SizedBox(height: 12),

          _buildStatBar('Mathematiques', 0.86, Colors.green),
          _buildStatBar('Physique', 0.80, Colors.green),
          _buildStatBar('Informatique', 0.94, Colors.green),
          _buildStatBar('Chimie', 0.71, Colors.red),
        ],
      ),
    );
  }

  Widget _buildStatItem(String label, String valeur, Color couleur) {
    return Column(
      children: [
        Text(valeur,
            style: TextStyle(
                color: couleur,
                fontSize: 28,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: couleur.withOpacity(0.8), fontSize: 12)),
      ],
    );
  }

  Widget _buildStatBar(String module, double valeur, Color couleur) {
    return Padding(
      padding: EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(module),
              Text('${(valeur * 100).toInt()}%',
                  style: TextStyle(
                      color: couleur, fontWeight: FontWeight.bold)),
            ],
          ),
          SizedBox(height: 4),
          LinearProgressIndicator(
            value: valeur,
            backgroundColor: Colors.grey[200],
            valueColor: AlwaysStoppedAnimation(couleur),
            minHeight: 8,
          ),
        ],
      ),
    );
  }

  Widget _buildHistoriqueTab() {
    final historique = [
      {'action': 'Pointage valide', 'detail': 'Mathematiques - Moussa Ali',
        'date': '2024-03-15 09:30', 'type': 'VALIDATION'},
      {'action': 'Pointage rejete', 'detail': 'Chimie - Maiga Fatima',
        'date': '2024-03-14 14:00', 'type': 'REJET'},
      {'action': 'Presence consultee', 'detail': 'Module Physique',
        'date': '2024-03-14 10:00', 'type': 'CONSULTATION'},
    ];

    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: historique.length,
      itemBuilder: (context, index) {
        final h = historique[index];
        Color couleur = h['type'] == 'VALIDATION'
            ? Colors.green
            : h['type'] == 'REJET'
            ? Colors.red
            : Color(0xFF00855A);
        return Card(
          margin: EdgeInsets.only(bottom: 10),
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12)),
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: couleur.withOpacity(0.1),
              child: Icon(
                h['type'] == 'VALIDATION'
                    ? Icons.check_circle
                    : h['type'] == 'REJET'
                    ? Icons.cancel
                    : Icons.visibility,
                color: couleur,
              ),
            ),
            title: Text(h['action']!,
                style: TextStyle(fontWeight: FontWeight.bold)),
            subtitle: Text('${h['detail']}\n${h['date']}'),
            isThreeLine: true,
          ),
        );
      },
    );
  }

  Widget _buildBadge(String statut) {
    Color couleur = statut == 'VALIDE' ? Colors.green : Colors.orange;
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