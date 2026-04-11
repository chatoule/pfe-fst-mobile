import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SupportsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> supports = [
    {
      'titre': 'Cours Chapitre 1 - Introduction',
      'matiere': 'Informatique',
      'type': 'PDF',
      'date': '2024-03-10',
      'taille': '2.4 MB',
      'icon': Icons.picture_as_pdf,
      'couleur': Colors.red,
    },
    {
      'titre': 'TD Exercices Chapitre 2',
      'matiere': 'Mathematiques',
      'type': 'WORD',
      'date': '2024-03-12',
      'taille': '1.1 MB',
      'icon': Icons.description,
      'couleur': Colors.blue,
    },
    {
      'titre': 'Presentation Chapitre 3',
      'matiere': 'Physique',
      'type': 'PPT',
      'date': '2024-03-14',
      'taille': '5.8 MB',
      'icon': Icons.slideshow,
      'couleur': Colors.orange,
    },
    {
      'titre': 'TP Laboratoire',
      'matiere': 'Chimie',
      'type': 'PDF',
      'date': '2024-03-15',
      'taille': '3.2 MB',
      'icon': Icons.picture_as_pdf,
      'couleur': Colors.red,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header stats
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Total', '${supports.length}', Colors.white),
              SizedBox(width: 12),
              _buildStatBadge('PDF', '${supports.where((s) => s['type'] == 'PDF').length}', Colors.redAccent),
              SizedBox(width: 12),
              _buildStatBadge('Autres', '${supports.where((s) => s['type'] != 'PDF').length}', Colors.blueAccent),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: supports.length,
            itemBuilder: (context, index) {
              final s = supports[index];
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
                          color: (s['couleur'] as Color).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(s['icon'] as IconData,
                            color: s['couleur'] as Color, size: 24),
                      ),
                      SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(s['titre'],
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 14,
                                    color: Color(0xFF003D29))),
                            SizedBox(height: 4),
                            Text(s['matiere'],
                                style: TextStyle(
                                    color: Color(0xFF00855A),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500)),
                            SizedBox(height: 2),
                            Row(children: [
                              Icon(Icons.calendar_today,
                                  size: 11, color: Colors.grey),
                              SizedBox(width: 3),
                              Text(s['date'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                              SizedBox(width: 8),
                              Icon(Icons.storage, size: 11, color: Colors.grey),
                              SizedBox(width: 3),
                              Text(s['taille'],
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 11)),
                            ]),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: (s['couleur'] as Color).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(s['type'],
                                style: TextStyle(
                                    color: s['couleur'] as Color,
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold)),
                          ),
                          SizedBox(height: 8),
                          IconButton(
                            icon: Icon(Icons.download,
                                color: Color(0xFF00855A), size: 20),
                            onPressed: () => Get.snackbar(
                              'Telechargement',
                              '${s['titre']} telecharge',
                              snackPosition: SnackPosition.BOTTOM,
                              backgroundColor: Color(0xFF00855A),
                              colorText: Colors.white,
                            ),
                            padding: EdgeInsets.zero,
                            constraints: BoxConstraints(),
                          ),
                        ],
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
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => Get.snackbar(
                'Upload',
                'Fonctionnalite disponible prochainement',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Color(0xFF00855A),
                colorText: Colors.white,
              ),
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text('Ajouter un support',
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