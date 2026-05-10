// lib/screens/superviseur/tabs/presences_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';

class PresencesSupTab extends StatelessWidget {
  const PresencesSupTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final allCours = shared.coursDuJour;
      final selectedDept = shared.selectedDepartement.value;
      final cours = selectedDept == 'Tous les départements'
          ? allCours
          : allCours
          .where((c) => c['departement'] == selectedDept)
          .toList();

      // Calculs sécurisés
      int totalPresents = 0;
      int totalInscrits = 0;
      for (var c in cours) {
        totalPresents += (c['nombrePresents'] as int?) ?? 0;
        totalInscrits += (c['nombreInscrits'] as int?) ?? 1;
      }
      final tauxMoyen = totalInscrits > 0
          ? (totalPresents * 100 ~/ totalInscrits)
          : 0;
      final critiques = cours
          .where((c) {
        final p = (c['nombrePresents'] as int?) ?? 0;
        final t = (c['nombreInscrits'] as int?) ?? 1;
        return (p * 100 ~/ t) < 75;
      })
          .length;

      return Column(
        children: [
          // Filtre département
          _buildDeptFilter(shared),

          // Stats header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)]),
            ),
            child: Row(
              children: [
                _buildStatBadge(
                    'Modules', '${cours.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Taux moyen', '$tauxMoyen%', Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Critiques', '$critiques', Colors.redAccent),
              ],
            ),
          ),

          // Liste
          Expanded(
            child: cours.isEmpty
                ? const Center(
                child: Text('Aucun cours disponible',
                    style: TextStyle(color: Colors.grey)))
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
                  value:
                  shared.selectedDepartement.value,
                  isExpanded: true,
                  icon: const Icon(Icons.filter_list,
                      size: 20),
                  items: shared.departements
                      .map((String value) =>
                      DropdownMenuItem<String>(
                        value: value,
                        child: Text(value,
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

  Widget _buildCoursCard(Map<String, dynamic> c) {
    final presents = (c['nombrePresents'] as int?) ?? 0;
    final total = (c['nombreInscrits'] as int?) ?? 1;
    final taux = presents * 100 ~/ total;
    final couleur =
    taux >= 75 ? const Color(0xFF00855A) : Colors.red;
    final matiere = c['matiere'] ?? 'Module inconnu';

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
                    color: couleur.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.book,
                      color: couleur, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(matiere,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF003D29)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis),
                ),
                Text('$taux%',
                    style: TextStyle(
                        color: couleur,
                        fontWeight: FontWeight.bold,
                        fontSize: 18)),
              ],
            ),
            const SizedBox(height: 10),
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
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? presents / total : 0,
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

  Widget _buildMiniStat(
      String label, int valeur, Color couleur) {
    return Column(
      children: [
        Text('$valeur',
            style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: couleur)),
        Text(label,
            style: TextStyle(
                fontSize: 11, color: Colors.grey[600])),
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
