import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AnticipationsScreen extends StatelessWidget {
  final List<Map<String, String>> anticipations = [
    {
      'matiere': 'Calcul Intégral et Equations Différentielles',
      'date': '2024-04-10',
      'heure': '08h00 - 10h00',
      'salle': 'Salle 02',
      'statut': 'PLANIFIE',
    },
    {
      'matiere': 'Structure de Données',
      'date': '2024-04-12',
      'heure': '10h30 - 12h30',
      'salle': 'Salle 201',
      'statut': 'ANTICIPE',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          // En-tête simplifié avec dégradé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20),
              ),
            ),
            child: Column(
              children: [
                const Text(
                  'Liste des Cours Anticipés',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  '${anticipations.length} séances prévues',
                  style: const TextStyle(color: Colors.white70, fontSize: 13),
                ),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: anticipations.length,
              itemBuilder: (context, index) {
                final a = anticipations[index];
                return _buildCleanCard(a);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCleanCard(Map<String, String> a) {
    bool isAnticipe = a['statut'] == 'ANTICIPE';
    Color themeColor = isAnticipe ? const Color(0xFF00855A) : Colors.orange;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Barre latérale colorée
              Container(width: 6, color: themeColor),
              
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Titre avec gestion d'overflow
                      Text(
                        a['matiere']!,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 15,
                          color: Color(0xFF003D29),
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 12),
                      
                      // Infos avec wrap pour éviter les débordements sur petits écrans
                      Wrap(
                        spacing: 12,
                        runSpacing: 8,
                        children: [
                          _buildSmallInfo(Icons.calendar_today, a['date']!),
                          _buildSmallInfo(Icons.access_time, a['heure']!),
                          _buildSmallInfo(Icons.location_on, a['salle']!),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              // Badge de statut
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: themeColor.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: themeColor.withValues(alpha: 0.2)),
                    ),
                    child: Text(
                      a['statut']!,
                      style: TextStyle(
                        color: themeColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 9,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSmallInfo(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 14, color: Colors.grey[600]),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(color: Colors.grey[600], fontSize: 12),
        ),
      ],
    );
  }
}
