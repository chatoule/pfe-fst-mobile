// lib/screens/chef_departement/tabs/tableau_bord_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/auth_controller.dart';
import '../../../controllers/shared_controller.dart';
import '../../../utils/helpers.dart';

class TableauBordTab extends StatelessWidget {
  const TableauBordTab({super.key});

  @override
  Widget build(BuildContext context) {
    final auth = Get.find<AuthController>();
    final shared = Get.find<SharedController>();

    return Obx(() {
      final totalCours = shared.coursDuJour.length;
      final pointagesAttente = shared.fichesPointage
          .where((f) => f['valideChefDep'] == false)
          .length;
      final user = auth.utilisateur.value;

      return SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(
                              color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user != null
                                ? '${user.prenom[0]}${user.nom[0]}'
                                : 'C',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [
                          const Text('Bonjour,',
                              style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 13)),
                          Text(
                            '${user?.prenom ?? ""} ${user?.nom ?? ""}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Chef de Département - FST UIN',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildHeaderStat('Total cours',
                          '$totalCours', Icons.list_alt),
                      const SizedBox(width: 6),
                      _buildHeaderStat('En attente',
                          '$pointagesAttente',
                          Icons.pending_outlined),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actions rapides',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionCard(context, 'Présences',
                          Icons.people, Colors.blue, 1),
                      const SizedBox(width: 12),
                      _buildActionCard(context, 'Pointages',
                          Icons.check_circle, Colors.orange, 2),
                      const SizedBox(width: 12),
                      _buildActionCard(context, 'Rapports',
                          Icons.bar_chart, Colors.purple, 3),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text('Cours du jour',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 8),
                  if (shared.coursDuJour.isEmpty)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: Text('Aucun cours aujourd\'hui',
                            style:
                            TextStyle(color: Colors.grey)),
                      ),
                    )
                  else
                    ...shared.coursDuJour
                        .map((cours) => _buildCoursCard(cours)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildHeaderStat(
      String label, String valeur, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
            vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
              color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(valeur,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 8),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(BuildContext context, String label,
      IconData icon, Color couleur, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          // Navigation via le drawer parent
          // On utilise le Scaffold pour ouvrir le drawer
          // et sélectionner l'onglet
          Get.snackbar(
            '',
            '',
            duration: Duration.zero,
          );
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: couleur.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: couleur, size: 22),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003D29))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursCard(Map<String, dynamic> cours) {
    final presents = (cours['nombrePresents'] as int?) ?? 0;
    final total =
        (cours['nombreInscrits'] as int?) ?? 1;
    final taux =
    total > 0 ? ((presents / total) * 100).toInt() : 0;
    final matiere =
        cours['matiere'] ?? cours['moduleNom'] ?? 'Module';
    final enseignant = cours['enseignantNom'] ?? 'Enseignant';
    final heureDebut = cours['heureDebut'] ?? '';
    final heureFin = cours['heureFin'] ?? '';
    final salle = cours['salleNom'] ?? cours['salle'] ?? 'N/A';
    final statut = cours['statut'] ?? 'PLANIFIE';

    Color statutColor;
    switch (statut) {
      case 'EN_COURS': statutColor = Colors.orange; break;
      case 'TERMINE': statutColor = const Color(0xFF00855A); break;
      case 'ANNULE': statutColor = Colors.red; break;
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
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.access_time,
                  size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Text('$heureDebut - $heureFin',
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 12),
              const Icon(Icons.location_on,
                  size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Text(salle,
                  style: TextStyle(
                      color: Colors.grey[600], fontSize: 12)),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('$presents/$total présents',
                    style: const TextStyle(
                        color: Color(0xFF00855A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text('$taux%',
                    style: TextStyle(
                        color: taux >= 75
                            ? const Color(0xFF00855A)
                            : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: total > 0 ? presents / total : 0,
                backgroundColor: Colors.grey[200],
                color: taux >= 75
                    ? const Color(0xFF00855A)
                    : Colors.red,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
