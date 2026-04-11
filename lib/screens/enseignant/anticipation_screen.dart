import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnticipationsScreen extends StatelessWidget {
  final List<Map<String, String>> anticipations = [
    {
      'matiere': 'Informatique',
      'date': '2024-03-18',
      'heure': '14h00 - 16h00',
      'salle': 'C303',
      'statut': 'EN_ATTENTE',
    },
    {
      'matiere': 'Mathematiques',
      'date': '2024-03-19',
      'heure': '08h00 - 10h00',
      'salle': 'A101',
      'statut': 'VALIDE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final enAttente = anticipations.where((a) => a['statut'] == 'EN_ATTENTE').length;
    final valides = anticipations.where((a) => a['statut'] == 'VALIDE').length;

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
              _buildStatBadge('Total', '${anticipations.length}', Colors.white),
              SizedBox(width: 12),
              _buildStatBadge('En attente', '$enAttente', Colors.orange),
              SizedBox(width: 12),
              _buildStatBadge('Valides', '$valides', Colors.greenAccent),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: anticipations.length,
            itemBuilder: (context, index) {
              final a = anticipations[index];
              return _buildCard(a);
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _showDemandeAnticipation(context),
              icon: Icon(Icons.add, color: Colors.white),
              label: Text('Demander une anticipation',
                  style: TextStyle(color: Colors.white, fontSize: 15,
                      fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                elevation: 2,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCard(Map<String, String> a) {
    Color couleur;
    IconData icon;
    switch (a['statut']) {
      case 'VALIDE':
        couleur = Color(0xFF00855A);
        icon = Icons.check_circle;
        break;
      case 'REJETE':
        couleur = Colors.red;
        icon = Icons.cancel;
        break;
      default:
        couleur = Colors.orange;
        icon = Icons.schedule;
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
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: couleur.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: couleur, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(a['matiere']!,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 4),
                  Row(children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(a['date']!,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                    SizedBox(width: 10),
                    Icon(Icons.access_time, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(a['heure']!,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                  SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.location_on, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text('Salle ${a['salle']!}',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: couleur.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: couleur.withOpacity(0.3)),
              ),
              child: Text(a['statut']!,
                  style: TextStyle(
                      color: couleur,
                      fontWeight: FontWeight.bold,
                      fontSize: 10)),
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showDemandeAnticipation(BuildContext context) {
    final matiereController = TextEditingController();
    final dateController = TextEditingController();
    final motifController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.fast_forward, color: Color(0xFF00855A)),
            SizedBox(width: 8),
            Text('Demander une anticipation'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogField('Matiere', Icons.book, matiereController),
            SizedBox(height: 12),
            _buildDialogField('Date souhaitee', Icons.calendar_today, dateController),
            SizedBox(height: 12),
            _buildDialogField('Motif', Icons.note, motifController, maxLines: 3),
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
              Get.snackbar('Succes', 'Demande envoyee avec succes',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white,
                  icon: Icon(Icons.check_circle, color: Colors.white));
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Envoyer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, IconData icon,
      TextEditingController controller, {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF00855A), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00855A)),
        ),
      ),
    );
  }
}