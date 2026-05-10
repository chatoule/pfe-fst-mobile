// lib/screens/chef_departement/tabs/presences_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';

class PresencesTab extends StatelessWidget {
  const PresencesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final cours = shared.coursDuJour;

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)]),
            ),
            child: Row(
              children: [
                _buildStatBadge(
                    'Total', '${cours.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'En cours',
                    '${cours.where((c) => c['statut'] == 'EN_COURS').length}',
                    Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Planifiés',
                    '${cours.where((c) => c['statut'] == 'PLANIFIE').length}',
                    Colors.blueAccent),
              ],
            ),
          ),
          Expanded(
            child: cours.isEmpty
                ? const Center(
              child: Text('Aucun cours disponible',
                  style: TextStyle(color: Colors.grey)),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cours.length,
              itemBuilder: (context, index) =>
                  _buildCoursCard(cours[index]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCoursCard(Map<String, dynamic> c) {
    final presents = (c['nombrePresents'] as int?) ?? 0;
    final total = (c['nombreInscrits'] as int?) ?? 1;
    final taux =
    total > 0 ? ((presents / total) * 100).toInt() : 0;
    final matiere = c['matiere'] ?? 'Module inconnu';
    final enseignant = c['enseignantNom'] ?? 'Enseignant';
    final statut = c['statut'] ?? 'PLANIFIE';

    Color statutColor;
    switch (statut) {
      case 'EN_COURS': statutColor = Colors.orange; break;
      case 'TERMINE': statutColor = const Color(0xFF00855A); break;
      default: statutColor = Colors.blue;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(matiere,
                      style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: statutColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: statutColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(statut,
                      style: TextStyle(
                          color: statutColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(enseignant,
                style: const TextStyle(
                    color: Color(0xFF00855A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMiniStat(
                    'Présents', presents, const Color(0xFF00855A)),
                _buildMiniStat(
                    'Absents', total - presents, Colors.red),
                _buildMiniStat('Total', total, Colors.blue),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Taux de présence',
                    style: TextStyle(
                        color: Colors.grey[600], fontSize: 12)),
                Text('$taux%',
                    style: TextStyle(
                        color: taux >= 75
                            ? const Color(0xFF00855A)
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? presents / total : 0,
                backgroundColor: Colors.grey[200],
                color:
                taux >= 75 ? const Color(0xFF00855A) : Colors.red,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(
      String label, int valeur, Color couleur) {
    return Column(
      children: [
        Text('$valeur',
            style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: couleur)),
        Text(label,
            style:
            TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildStatBadge(
      String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(valeur,
                  style: TextStyle(
                      color: couleur,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
