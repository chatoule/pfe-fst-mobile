
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/presence_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../services/presence_service.dart';

class PresencesScreen extends StatefulWidget {
  final bool showAppBar;
  const PresencesScreen({super.key, this.showAppBar = true});

  @override
  State<PresencesScreen> createState() => _PresencesScreenState();
}

class _PresencesScreenState extends State<PresencesScreen> {
  final PresenceController _presenceController = Get.find<PresenceController>();
  final PresenceService _presenceService = PresenceService();

  @override
  void initState() {
    super.initState();
    // ✅ Charger depuis l'API au lieu des données fictives
    _presenceController.chargerPresences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: widget.showAppBar
          ? AppBar(
        title: const Text('Mes Présences',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _presenceController.chargerPresences(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Get.find<AuthController>().logout(),
          ),
        ],
      )
          : null,
      body: Obx(() {
        // ===== CHARGEMENT =====
        if (_presenceController.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(color: Color(0xFF00855A)),
          );
        }

        // ===== ERREUR =====
        if (_presenceController.errorMessage.value.isNotEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.wifi_off, size: 60, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  _presenceController.errorMessage.value,
                  style: const TextStyle(color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _presenceController.chargerPresences(),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Réessayer',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00855A),
                  ),
                ),
              ],
            ),
          );
        }

        final presences = _presenceController.presences;

        // ===== VIDE =====
        if (presences.isEmpty) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.event_available_outlined,
                    size: 60, color: Colors.grey[300]),
                const SizedBox(height: 16),
                const Text('Aucune présence disponible',
                    style: TextStyle(fontSize: 15, color: Colors.grey)),
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: () => _presenceController.chargerPresences(),
                  icon: const Icon(Icons.refresh, color: Colors.white),
                  label: const Text('Actualiser',
                      style: TextStyle(color: Colors.white)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00855A),
                  ),
                ),
              ],
            ),
          );
        }

        // ===== CONTENU =====
        return RefreshIndicator(
          color: const Color(0xFF00855A),
          onRefresh: () => _presenceController.chargerPresences(),
          child: Column(
            children: [
              // Stats rapides en haut
              _buildStatsHeader(),

              // Liste des présences
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: presences.length,
                  itemBuilder: (context, index) {
                    final presence = presences[index];
                    return _buildPresenceCard(presence, index);
                  },
                ),
              ),
            ],
          ),
        );
      }),
    );
  }

  // ===== HEADER STATS =====
  Widget _buildStatsHeader() {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(16),
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
      child: Obx(() {
        final total = _presenceController.presences.length;
        final presents =
            _presenceController.presences.where((p) => p.estPresent).length;
        final absents = total - presents;
        final taux = _presenceController.tauxPresence;

        return Row(
          children: [
            _buildStat('Total', '$total', Colors.blue),
            _buildStat('Présent', '$presents', const Color(0xFF00855A)),
            _buildStat('Absent', '$absents', Colors.red),
            _buildStat('Taux', '${taux.toStringAsFixed(0)}%',
                taux >= 75 ? const Color(0xFF00855A) : Colors.orange),
          ],
        );
      }),
    );
  }

  Widget _buildStat(String label, String valeur, Color couleur) {
    return Expanded(
      child: Column(
        children: [
          Text(valeur,
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: couleur)),
          const SizedBox(height: 4),
          Text(label,
              style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  // ===== CARTE PRÉSENCE =====
  Widget _buildPresenceCard(dynamic presence, int index) {
    Color statusColor;
    IconData statusIcon;
    String statusLabel;

    if (presence.estPresent) {
      statusColor = const Color(0xFF00855A);
      statusIcon = Icons.check_circle;
      statusLabel = 'Présent';
    } else if (presence.estJustifie) {
      statusColor = Colors.blue;
      statusIcon = Icons.verified_outlined;
      statusLabel = 'Justifié';
    } else if (presence.statutJustification == 'EN_ATTENTE') {
      statusColor = Colors.orange;
      statusIcon = Icons.hourglass_empty;
      statusLabel = 'En attente';
    } else {
      statusColor = Colors.red;
      statusIcon = Icons.cancel_outlined;
      statusLabel = 'Absent';
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          children: [
            Row(
              children: [
                // Icône statut
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(statusIcon, color: statusColor, size: 22),
                ),
                const SizedBox(width: 12),

                // Infos séance
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Séance du ${presence.dateSeance}',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF003D29),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Module #${presence.coursId}',
                        style: TextStyle(
                            fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),

                // Badge statut
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: statusColor.withValues(alpha: 0.3)),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontWeight: FontWeight.bold,
                      fontSize: 11,
                    ),
                  ),
                ),
              ],
            ),

            // ===== BOUTON JUSTIFIER (si absent non justifié) =====
            if (!presence.estPresent &&
                !presence.estJustifie &&
                presence.statutJustification != 'EN_ATTENTE') ...[
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: OutlinedButton.icon(
                  onPressed: () => _ouvrirFormJustificatif(presence),
                  icon: const Icon(Icons.upload_file_outlined,
                      size: 18, color: Color(0xFF00855A)),
                  label: const Text(
                    'Soumettre un justificatif',
                    style: TextStyle(
                        color: Color(0xFF00855A),
                        fontWeight: FontWeight.bold),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFF00855A)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],

            // ===== STATUT JUSTIFICATIF EN ATTENTE =====
            if (presence.statutJustification == 'EN_ATTENTE') ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.orange[50],
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                      color: Colors.orange.withValues(alpha: 0.3)),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.hourglass_empty,
                        size: 14, color: Colors.orange),
                    SizedBox(width: 6),
                    Text(
                      'Justificatif en attente de validation',
                      style:
                      TextStyle(fontSize: 12, color: Colors.orange),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  // ===== FORMULAIRE JUSTIFICATIF =====
  void _ouvrirFormJustificatif(dynamic presence) {
    final motifController = TextEditingController();

    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24),
            topRight: Radius.circular(24),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Soumettre un justificatif',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D29))),
            const SizedBox(height: 6),
            Text(
              'Séance du ${presence.dateSeance}',
              style: const TextStyle(color: Colors.grey, fontSize: 13),
            ),
            const SizedBox(height: 20),
            TextField(
              controller: motifController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: 'Motif de l\'absence *',
                hintText: 'Décrivez la raison de votre absence...',
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                  const BorderSide(color: Color(0xFF00855A)),
                ),
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () async {
                  if (motifController.text.trim().isEmpty) {
                    Get.snackbar('Champ manquant',
                        'Veuillez saisir le motif de l\'absence.',
                        backgroundColor: Colors.orange,
                        colorText: Colors.white,
                        snackPosition: SnackPosition.BOTTOM);
                    return;
                  }
                  Get.back();
                  // ✅ Appel API réel
                  await _presenceController.envoyerJustificatif(
                    presenceId: presence.id,
                    etudiantId: presence.etudiantId,
                    seanceId: presence.coursId,
                    motif: motifController.text.trim(),
                  );
                },
                icon: const Icon(Icons.send, color: Colors.white),
                label: const Text('Envoyer',
                    style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF00855A),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }
}