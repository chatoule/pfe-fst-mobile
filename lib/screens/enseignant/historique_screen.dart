import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shared_controller.dart';
import '../../controllers/auth_controller.dart';

class HistoriqueScreen extends StatelessWidget {
  final SharedController _sharedController = Get.find<SharedController>();
  final AuthController _authController = Get.find<AuthController>();

  HistoriqueScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final user = _authController.utilisateur.value;
      // Filtrer les fiches de l'enseignant connecté
      final fiches = _sharedController.fichesPointage
          .where((f) => f['enseignantId'] == user?.id || f['enseignantNom'] == '${user?.prenom} ${user?.nom}')
          .toList();
      
      // Trier par date (plus récent en haut)
      fiches.sort((a, b) => b['dateSeance'].compareTo(a['dateSeance']));

      final termines = fiches.where((f) => f['statut'] == 'VALIDE').length;
      final enAttente = fiches.where((f) => f['statut'] != 'VALIDE' && f['statut'] != 'REJETE').length;
      final rejetees = fiches.where((f) => f['statut'] == 'REJETE').length;

      return Column(
        children: [
          // Header Stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                _buildStatBadge('Total', '${fiches.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge('Validés', '$termines', Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge('En cours', '$enAttente', Colors.orangeAccent),
                const SizedBox(width: 8),
                _buildStatBadge('Rejetés', '$rejetees', Colors.redAccent),
              ],
            ),
          ),

          Expanded(
            child: fiches.isEmpty
                ? _buildEmptyState()
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: fiches.length,
                    itemBuilder: (context, index) {
                      final f = fiches[index];
                      return _buildHistoriqueCard(context, f);
                    },
                  ),
          ),
        ],
      );
    });
  }

  Widget _buildHistoriqueCard(BuildContext context, Map<String, dynamic> f) {
    final statut = f['statut'] ?? 'EN_COURS';
    Color statutColor;
    IconData statutIcon;

    switch (statut) {
      case 'VALIDE':
        statutColor = const Color(0xFF00855A);
        statutIcon = Icons.verified;
        break;
      case 'CONFIRME':
        statutColor = Colors.blue;
        statutIcon = Icons.rule;
        break;
      case 'REJETE':
        statutColor = Colors.red;
        statutIcon = Icons.cancel;
        break;
      default:
        statutColor = Colors.orange;
        statutIcon = Icons.pending_actions;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: () => _showDetailsDialog(context, f),
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: statutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(statutIcon, color: statutColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(f['matiere'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF003D29))),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 12,
                      runSpacing: 4,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text(f['dateSeance'],
                                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.access_time, size: 12, color: Colors.grey),
                            const SizedBox(width: 4),
                            Text('${f['heureDebut']} - ${f['heureFin']}',
                                style: const TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statutColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: statutColor.withOpacity(0.3)),
                ),
                child: Text(statut,
                    style: TextStyle(
                        color: statutColor,
                        fontWeight: FontWeight.bold,
                        fontSize: 10)),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> f) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.info_outline, color: Color(0xFF00855A)),
            const SizedBox(width: 10),
            const Text('Détails du pointage', style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailRow('Matière', f['matiere']),
              _buildDetailRow('Date', f['dateSeance']),
              _buildDetailRow('Horaire', '${f['heureDebut']} - ${f['heureFin']}'),
              _buildDetailRow('Salle', f['salle'] ?? 'N/A'),
              _buildDetailRow('Durée', '${f['duree']} min'),
              const Divider(),
              const Text('Contenu du cours :', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 4),
              Text(f['contenu'] ?? 'Aucun contenu renseigné', 
                  style: const TextStyle(fontSize: 13, color: Colors.black87)),
              const SizedBox(height: 12),
              const Text('Circuit de validation :', 
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
              const SizedBox(height: 8),
              _buildValidationStep('Saisie Enseignant', true),
              _buildValidationStep('Confirmation Superviseur', f['confirmerSuperviseur'] ?? false),
              _buildValidationStep('Validation Chef Dept.', f['valideChefDep'] ?? false),
              if (f['statut'] == 'REJETE') ...[
                const SizedBox(height: 8),
                Text('Motif du rejet : ${f['motifRejet'] ?? "Non spécifié"}',
                    style: const TextStyle(color: Colors.red, fontSize: 12, fontWeight: FontWeight.bold)),
              ]
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer', style: TextStyle(color: Color(0xFF00855A))),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: Colors.grey)),
          Text(value, style: const TextStyle(fontSize: 12, color: Color(0xFF003D29))),
        ],
      ),
    );
  }

  Widget _buildValidationStep(String label, bool isDone) {
    return Row(
      children: [
        Icon(isDone ? Icons.check_circle : Icons.radio_button_unchecked,
            color: isDone ? Colors.green : Colors.grey, size: 16),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(
            fontSize: 12, 
            color: isDone ? Colors.black87 : Colors.grey,
            decoration: isDone ? null : TextDecoration.none)),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.history, size: 64, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text('Aucun historique disponible',
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
          color: Colors.white.withOpacity(0.15),
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
                style: const TextStyle(color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}