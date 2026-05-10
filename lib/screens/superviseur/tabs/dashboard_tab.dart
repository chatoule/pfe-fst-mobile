// lib/screens/superviseur/tabs/dashboard_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/shared_controller.dart';

class DashboardTab extends StatelessWidget {
  const DashboardTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final shared = Get.find<SharedController>();

    return Obx(() {
      final fiches = shared.fichesPointage;
      final enAttente = fiches
          .where((f) =>
      f['confirmerSuperviseur'] == false &&
          f['statut'] != 'REJETE')
          .length;
      final validees =
          fiches.where((f) => f['statut'] == 'VALIDE').length;
      final user = auth.utilisateur.value;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header carte
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Bienvenue, ${user?.prenom ?? 'Superviseur'} !',
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 14),
                  ),
                  const Text('Superviseur FST',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard(
                          'Total', '${fiches.length}', Colors.white),
                      const SizedBox(width: 8),
                      _buildStatCard(
                          'À confirmer', '$enAttente', Colors.orange),
                      const SizedBox(width: 8),
                      _buildStatCard(
                          'Validées', '$validees', Colors.greenAccent),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Graphique
            _buildChartSection(fiches),

            const SizedBox(height: 24),

            // Derniers pointages
            const Text('Derniers Pointages',
                style: TextStyle(
                    fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),

            if (fiches.isEmpty)
              const Center(
                  child: Padding(
                    padding: EdgeInsets.all(24),
                    child: Text('Aucun pointage enregistré',
                        style: TextStyle(color: Colors.grey)),
                  ))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fiches.length > 5 ? 5 : fiches.length,
                itemBuilder: (context, index) {
                  final f =
                  fiches[fiches.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(
                        backgroundColor: Color(0xFF00855A),
                        child: Icon(Icons.person,
                            color: Colors.white),
                      ),
                      title: Text(
                        f['matiere'] ?? 'Module inconnu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                          f['enseignantNom'] ?? 'Inconnu'),
                      trailing:
                      _buildStatutBadge(f['statut'] ?? 'EN_ATTENTE'),
                    ),
                  );
                },
              ),

            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () {
                  // Navigation vers historique gérée par le parent
                  Get.snackbar(
                    'Info',
                    'Ouvrez "Historique" depuis le menu',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: const Color(0xFF00855A),
                    colorText: Colors.white,
                  );
                },
                style: OutlinedButton.styleFrom(
                  foregroundColor: const Color(0xFF00855A),
                  side: const BorderSide(
                      color: Color(0xFF00855A)),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text('Voir tout l\'historique'),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(
      String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value,
                  style: TextStyle(
                      color: color,
                      fontSize: 20,
                      fontWeight: FontWeight.bold)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChartSection(List<Map<String, dynamic>> fiches) {
    final validees =
        fiches.where((f) => f['statut'] == 'VALIDE').length;
    final rejetees =
        fiches.where((f) => f['statut'] == 'REJETE').length;
    final enAttente = fiches.length - validees - rejetees;

    // Si tout est à 0, afficher un graphique vide
    final total = validees + rejetees + enAttente;

    return Container(
      padding: const EdgeInsets.all(16),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Répartition des Séances',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 180,
            child: total == 0
                ? const Center(
                child: Text('Aucune donnée disponible',
                    style: TextStyle(color: Colors.grey)))
                : Row(
              children: [
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 2,
                      centerSpaceRadius: 40,
                      sections: [
                        if (validees > 0)
                          PieChartSectionData(
                            value: validees.toDouble(),
                            title: '',
                            color: const Color(0xFF00855A),
                            radius: 25,
                          ),
                        if (enAttente > 0)
                          PieChartSectionData(
                            value: enAttente.toDouble(),
                            title: '',
                            color: Colors.orange,
                            radius: 25,
                          ),
                        if (rejetees > 0)
                          PieChartSectionData(
                            value: rejetees.toDouble(),
                            title: '',
                            color: Colors.red,
                            radius: 25,
                          ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  mainAxisAlignment:
                  MainAxisAlignment.center,
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    _buildLegendItem('Validées',
                        const Color(0xFF00855A), validees),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                        'En attente', Colors.orange, enAttente),
                    const SizedBox(height: 8),
                    _buildLegendItem(
                        'Rejetées', Colors.red, rejetees),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(
      String label, Color color, int count) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text('$label ($count)',
            style: const TextStyle(
                fontSize: 12, fontWeight: FontWeight.w500)),
      ],
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE':
      case 'CONFIRME':
        couleur = const Color(0xFF00855A);
        break;
      case 'REJETE':
        couleur = Colors.red;
        break;
      default:
        couleur = Colors.orange;
    }
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border:
        Border.all(color: couleur.withValues(alpha: 0.3)),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur,
              fontWeight: FontWeight.bold,
              fontSize: 9)),
    );
  }
}
