import 'package:flutter/material.dart';

class HistoriqueScreen extends StatelessWidget {
  final List<Map<String, dynamic>> historique = [
    {
      'matiere': 'Mathematiques',
      'date': '2024-03-15',
      'heure': '08h00 - 10h00',
      'salle': 'A101',
      'type': 'COURS',
      'statut': 'TERMINE',
      'icon': Icons.book,
      'couleur': Colors.blue,
    },
    {
      'matiere': 'Physique',
      'date': '2024-03-14',
      'heure': '10h00 - 12h00',
      'salle': 'B202',
      'type': 'RATTRAPAGE',
      'statut': 'TERMINE',
      'icon': Icons.replay,
      'couleur': Colors.orange,
    },
    {
      'matiere': 'Informatique',
      'date': '2024-03-13',
      'heure': '14h00 - 16h00',
      'salle': 'C303',
      'type': 'ANTICIPATION',
      'statut': 'TERMINE',
      'icon': Icons.fast_forward,
      'couleur': Colors.purple,
    },
    {
      'matiere': 'Chimie',
      'date': '2024-03-12',
      'heure': '08h00 - 10h00',
      'salle': 'A101',
      'type': 'COURS',
      'statut': 'ANNULE',
      'icon': Icons.book,
      'couleur': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final termines = historique.where((h) => h['statut'] == 'TERMINE').length;
    final annules = historique.where((h) => h['statut'] == 'ANNULE').length;

    return Column(
      children: [
        // Header
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Total', '${historique.length}', Colors.white),
              SizedBox(width: 12),
              _buildStatBadge('Termines', '$termines', Colors.greenAccent),
              SizedBox(width: 12),
              _buildStatBadge('Annules', '$annules', Colors.redAccent),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: historique.length,
            itemBuilder: (context, index) {
              final h = historique[index];
              final isTermine = h['statut'] == 'TERMINE';

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
                          color: (h['couleur'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(h['icon'] as IconData,
                            color: h['couleur'] as Color, size: 22),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(h['matiere'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    color: Color(0xFF003D29))),
                            SizedBox(height: 4),
                            Row(children: [
                              Icon(Icons.calendar_today,
                                  size: 12, color: Colors.grey),
                              SizedBox(width: 3),
                              Text(h['date'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              SizedBox(width: 8),
                              Icon(Icons.access_time,
                                  size: 12, color: Colors.grey),
                              SizedBox(width: 3),
                              Text(h['heure'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                            ]),
                            SizedBox(height: 2),
                            Row(children: [
                              Icon(Icons.location_on,
                                  size: 12, color: Colors.grey),
                              SizedBox(width: 3),
                              Text('Salle ${h['salle']}',
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 12)),
                              SizedBox(width: 8),
                              Container(
                                padding: EdgeInsets.symmetric(
                                    horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: (h['couleur'] as Color).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: Text(h['type'],
                                    style: TextStyle(
                                        color: h['couleur'] as Color,
                                        fontSize: 9,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ]),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: isTermine
                              ? Color(0xFF00855A).withOpacity(0.1)
                              : Colors.red.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                              color: isTermine
                                  ? Color(0xFF00855A).withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3)),
                        ),
                        child: Text(h['statut'],
                            style: TextStyle(
                                color: isTermine
                                    ? Color(0xFF00855A)
                                    : Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 10)),
                      ),
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
}