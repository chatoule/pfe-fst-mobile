// lib/screens/chef_departement/tabs/pointages_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';

class PointagesTab extends StatelessWidget {
  const PointagesTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final pointages = shared.fichesPointage;

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
                    'En attente',
                    '${pointages.where((f) => f['valideChefDep'] == false && f['statut'] != 'REJETE').length}',
                    Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Validés',
                    '${pointages.where((f) => f['valideChefDep'] == true).length}',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Rejetés',
                    '${pointages.where((f) => f['statut'] == 'REJETE').length}',
                    Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: pointages.isEmpty
                ? const Center(
                child: Text('Aucun pointage disponible',
                    style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pointages.length,
              itemBuilder: (context, index) =>
                  _buildPointageCard(pointages[index], shared),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildPointageCard(
      Map<String, dynamic> p, SharedController shared) {
    final bool isPending = p['valideChefDep'] == false &&
        p['statut'] != 'REJETE';
    final bool isRejected = p['statut'] == 'REJETE';
    final bool isValidated = p['valideChefDep'] == true;
    final statut = p['statut'] ?? 'EN_ATTENTE';

    Color iconColor = isRejected
        ? Colors.red
        : isValidated
        ? Colors.green
        : Colors.orange;

    IconData iconData = isRejected
        ? Icons.cancel
        : isValidated
        ? Icons.check_circle
        : Icons.pending_actions;

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
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconData,
                      color: iconColor, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        p['matiere'] ?? 'Module inconnu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF003D29)),
                      ),
                      Text(
                        p['enseignantNom'] ?? 'Inconnu',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 12),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: iconColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: iconColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(statut,
                      style: TextStyle(
                          color: iconColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildInfo(Icons.calendar_today,
                      p['dateSeance'] ?? 'N/A'),
                  _buildInfo(Icons.access_time,
                      '${p['heureDebut'] ?? ''} - ${p['heureFin'] ?? ''}'),
                  _buildInfo(Icons.timer,
                      '${p['duree'] ?? 0} min'),
                ],
              ),
            ),
            const SizedBox(height: 12),
            if (isPending)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () =>
                          shared.validerParChefDep(p['id']),
                      icon: const Icon(Icons.check,
                          color: Colors.white, size: 16),
                      label: const Text('Valider',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00855A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () => shared.rejeterFiche(
                          p['id'], 'Chef Département'),
                      icon: const Icon(Icons.close,
                          color: Colors.white, size: 16),
                      label: const Text('Rejeter',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              )
            else
              Container(
                width: double.infinity,
                padding:
                const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: (isRejected ? Colors.red : Colors.green)
                      .withValues(alpha: 0.05),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  isRejected
                      ? 'Ce pointage a été rejeté'
                      : 'Ce pointage a été validé',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: isRejected ? Colors.red : Colors.green,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        Text(valeur,
            style: TextStyle(
                color: Colors.grey[600], fontSize: 12)),
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
