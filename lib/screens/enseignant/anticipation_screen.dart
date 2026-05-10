import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shared_controller.dart';

class AnticipationsScreen extends StatelessWidget {
  const AnticipationsScreen({super.key});

  static final controller = SharedController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final anticipations = controller.anticipations;
      final planifiees = anticipations.where((a) => a['statut'] == 'PLANIFIE').length;
      final realisees = anticipations.where((a) => a['statut'] == 'ANTICIPE').length;

      return Column(
        children: [
          // En-tête simplifié avec dégradé
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                _buildStatBadge('Total', '${anticipations.length}', Colors.white),
                const SizedBox(width: 12),
                _buildStatBadge('Planifiées', '$planifiees', Colors.orangeAccent),
                const SizedBox(width: 12),
                _buildStatBadge('Réalisées', '$realisees', Colors.greenAccent),
              ],
            ),
          ),

          Expanded(
            child: anticipations.isEmpty 
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: anticipations.length,
                  itemBuilder: (context, index) {
                    final a = anticipations[index];
                    return _buildCleanCard(a);
                  },
                ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showAddAnticipationDialog(context),
                icon: const Icon(Icons.add, color: Colors.white),
                label: const Text('Déclarer une anticipation',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00855A),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.fast_forward_outlined, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Aucune anticipation déclarée',
              style: TextStyle(color: Colors.grey, fontSize: 16)),
        ],
      ),
    );
  }

  Widget _buildStatBadge(String label, String valeur, Color couleur) {
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
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
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

  void _showAddAnticipationDialog(BuildContext context) {
    final matiereController = TextEditingController();
    final dateController = TextEditingController();
    final heureController = TextEditingController();
    final salleController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Row(
          children: [
            Icon(Icons.fast_forward, color: Color(0xFF00855A)),
            SizedBox(width: 8),
            Text('Anticiper un cours'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: matiereController,
              decoration: const InputDecoration(labelText: 'Matière'),
            ),
            TextField(
              controller: dateController,
              decoration: const InputDecoration(labelText: 'Date prévue'),
            ),
            TextField(
              controller: heureController,
              decoration: const InputDecoration(labelText: 'Horaire'),
            ),
            TextField(
              controller: salleController,
              decoration: const InputDecoration(labelText: 'Salle'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              if (matiereController.text.isNotEmpty) {
                controller.ajouterAnticipation(
                  matiereController.text,
                  dateController.text.isEmpty ? 'A venir' : dateController.text,
                  heureController.text.isEmpty ? 'N/A' : heureController.text,
                  salleController.text.isEmpty ? 'N/A' : salleController.text,
                );
                Get.back();
                Get.snackbar('Succès', 'Anticipation enregistrée');
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00855A)),
            child: const Text('Enregistrer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
