// lib/screens/superviseur/tabs/statistiques_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';

class StatistiquesTab extends StatelessWidget {
  const StatistiquesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final stats = shared.statistiquesMatieres;

      return Column(
        children: [
          // Filtre département
          _buildDeptFilter(shared),

          // Header global
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)]),
            ),
            child: Column(
              children: [
                const Text('Vue globale - FST UIN',
                    style: TextStyle(
                        color: Colors.white70, fontSize: 13)),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment:
                  MainAxisAlignment.spaceAround,
                  children: [
                    _buildGlobalStat(
                        'Séances', '${shared.totalSeances}'),
                    _buildGlobalStat(
                        'Validées', '${shared.seancesValidees}'),
                    _buildGlobalStat(
                        'Attente', '${shared.seancesEnAttente}'),
                    _buildGlobalStat('Rejetées',
                        '${shared.seancesRejetees}'),
                  ],
                ),
              ],
            ),
          ),

          // Liste stats par module
          Expanded(
            child: stats.isEmpty
                ? const Center(
                child: Text(
                    'Aucune statistique disponible',
                    style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: stats.length,
              itemBuilder: (context, index) =>
                  _buildStatCard(context, stats[index]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDeptFilter(SharedController shared) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Text('Département:',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Container(
              padding:
              const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: shared.selectedDepartement.value,
                  isExpanded: true,
                  icon: const Icon(Icons.filter_list,
                      size: 20),
                  items: shared.departements
                      .map((val) => DropdownMenuItem<String>(
                    value: val,
                    child: Text(val,
                        style: const TextStyle(
                            fontSize: 13)),
                  ))
                      .toList(),
                  onChanged: (val) => shared
                      .selectedDepartement.value = val!,
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, Map<String, dynamic> s) {
    final taux = s['tauxPresence'] as int;
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
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: couleur.withValues(alpha: 0.1),
                        borderRadius:
                        BorderRadius.circular(10),
                      ),
                      child: Icon(Icons.book,
                          color: couleur, size: 20),
                    ),
                    const SizedBox(width: 12),
                    SizedBox(
                      width:
                      MediaQuery.of(context).size.width * 0.45,
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          Text(s['matiere'],
                              style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Color(0xFF003D29)),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis),
                          Text(
                              '${s['totalSeances']} séances',
                              style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                Text('$taux%',
                    style: TextStyle(
                        color: couleur,
                        fontWeight: FontWeight.bold,
                        fontSize: 20)),
              ],
            ),
            const SizedBox(height: 8),
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

  Widget _buildGlobalStat(String label, String valeur) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(valeur,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.bold)),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 11)),
          ),
        ],
      ),
    );
  }
}
