// lib/screens/chef_departement/tabs/rattrapages_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';

class RattrapagesTab extends StatelessWidget {
  const RattrapagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final enAttente = shared.rattrapages
          .where((r) => r['statut'] == 'EN_ATTENTE')
          .toList();

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
                _buildStatBadge('En attente',
                    '${enAttente.length}', Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge('Total',
                    '${shared.rattrapages.length}', Colors.white),
              ],
            ),
          ),
          Expanded(
            child: enAttente.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.done_all,
                      size: 60, color: Colors.green),
                  SizedBox(height: 16),
                  Text(
                      'Tous les rattrapages ont été traités',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: enAttente.length,
              itemBuilder: (context, index) =>
                  _buildRattrapageCard(
                      enAttente[index], shared),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildRattrapageCard(
      Map<String, String> r, SharedController shared) {
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
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.replay,
                      color: Colors.orange, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        r['matiere'] ?? 'Inconnu',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29)),
                      ),
                      Text(
                        '${r['date']} • ${r['heure']}',
                        style: const TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        shared.validerRattrapage(r['id']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00855A),
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10)),
                    ),
                    child: const Text('Valider',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () =>
                        shared.rejeterRattrapage(r['id']!),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(
                          borderRadius:
                          BorderRadius.circular(10)),
                    ),
                    child: const Text('Rejeter',
                        style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
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
            Text(valeur,
                style: TextStyle(
                    color: couleur,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
