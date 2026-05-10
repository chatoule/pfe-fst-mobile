// lib/screens/chef_departement/tabs/rapports_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';
import '../../../services/export_service.dart';

class RapportsTab extends StatelessWidget {
  const RapportsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final stats = shared.statistiquesMatieres;
      final totalModules = stats.length;
      final tauxMoyen = totalModules > 0
          ? (stats.fold(0,
              (sum, s) => sum + (s['tauxPresence'] as int)) /
          totalModules).toInt()
          : 0;
      final critiques = stats
          .where((s) => (s['tauxPresence'] as int) < 75)
          .length;

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
                    'Modules', '$totalModules', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Taux moyen', '$tauxMoyen%', Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Critiques', '$critiques', Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                const Text('Statistiques par matière',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                const SizedBox(height: 12),

                ...stats.map((stat) => _buildStatCard(stat)),

                const SizedBox(height: 16),
                const Text('Générer des rapports',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                const SizedBox(height: 12),

                _buildRapportCard('Rapport de présences',
                    'Liste complète des présences',
                    Icons.people, Colors.blue),
                _buildRapportCard('Rapport des pointages',
                    'Historique des pointages',
                    Icons.check_circle, const Color(0xFF00855A)),
                _buildRapportCard('État paiement vacataires',
                    'Calcul heures et paiements',
                    Icons.payment, Colors.orange),

                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            ExportService.exporterEtatVacationExcel(
                                shared.getVacatairesData()),
                        icon: const Icon(Icons.table_chart,
                            color: Colors.white),
                        label: const Text('Excel',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () =>
                            ExportService.exporterRapportPresencesPDF(
                                shared.statistiquesMatieres),
                        icon: const Icon(Icons.picture_as_pdf,
                            color: Colors.white),
                        label: const Text('PDF',
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold)),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                              BorderRadius.circular(12)),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      );
    });
  }

  Widget _buildStatCard(Map<String, dynamic> stat) {
    final taux = stat['tauxPresence'] as int;
    final couleur =
    taux >= 75 ? const Color(0xFF00855A) : Colors.red;

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
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: couleur.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child:
                  Icon(Icons.book, color: couleur, size: 20),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(stat['matiere'],
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF003D29))),
                      Text('${stat['totalSeances']} séances',
                          style: const TextStyle(
                              color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                Text('$taux%',
                    style: TextStyle(
                        color: couleur,
                        fontWeight: FontWeight.bold,
                        fontSize: 22)),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: taux / 100,
                backgroundColor: Colors.grey[200],
                color: couleur,
                minHeight: 8,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRapportCard(String titre, String description,
      IconData icon, Color couleur) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: couleur),
        ),
        title: Text(titre,
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description,
            style:
            const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Icon(Icons.download, color: couleur),
        onTap: () => Get.snackbar(
          'Rapport',
          '$titre généré',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: couleur,
          colorText: Colors.white,
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
