// lib/screens/chef_departement/tabs/justificatifs_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:io';
import '../../../controllers/shared_controller.dart';
import '../../../models/presence_model.dart';

class JustificatifsTab extends StatelessWidget {
  const JustificatifsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final justificatifs = shared.getJustificatifsEnAttente();

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
                    '${justificatifs.length}', Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Validés',
                    '${shared.presences.where((p) => p.statutJustification == 'VALIDE').length}',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Rejetés',
                    '${shared.presences.where((p) => p.statutJustification == 'REJETE').length}',
                    Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: justificatifs.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox,
                      size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun justificatif en attente',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: justificatifs.length,
              itemBuilder: (context, index) =>
                  _buildJustificatifCard(
                      context, justificatifs[index], shared),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildJustificatifCard(BuildContext context,
      PresenceModel j, SharedController shared) {
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
            // Étudiant info
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.blue.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person,
                      color: Colors.blue, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${j.prenomEtudiant} ${j.nomEtudiant}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29)),
                      ),
                      Text(
                        '${j.matiere ?? ''} • ${j.typeJustificatif ?? ''}',
                        style: const TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.orange.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color:
                        Colors.orange.withValues(alpha: 0.3)),
                  ),
                  child: const Text('EN ATTENTE',
                      style: TextStyle(
                          color: Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ],
            ),
            const SizedBox(height: 8),

            // Détails
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(j.dateSeance,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ]),
                  if (j.motifJustificatif != null) ...[
                    const SizedBox(height: 4),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(j.motifJustificatif!,
                              style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 12),

            // Pièce jointe
            if (j.justificatifUrl != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: InkWell(
                  onTap: () =>
                      _voirPieceJointe(context, j),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.blue.withValues(alpha: 0.05),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                          color:
                          Colors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          j.justificatifUrl!
                              .toLowerCase()
                              .endsWith('.pdf')
                              ? Icons.picture_as_pdf
                              : Icons.image,
                          size: 16,
                          color: Colors.blue,
                        ),
                        const SizedBox(width: 8),
                        const Text('Voir la pièce jointe',
                            style: TextStyle(
                                color: Colors.blue,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                      ],
                    ),
                  ),
                ),
              ),

            // Boutons valider/rejeter
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () =>
                        shared.traiterJustificatif(j.id, true),
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
                    onPressed: () =>
                        shared.traiterJustificatif(j.id, false),
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
            ),
          ],
        ),
      ),
    );
  }

  void _voirPieceJointe(BuildContext context, PresenceModel j) {
    if (j.justificatifUrl == null) return;
    final path = j.justificatifUrl!.toLowerCase();
    if (path.endsWith('.jpg') ||
        path.endsWith('.jpeg') ||
        path.endsWith('.png')) {
      showDialog(
        context: context,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: IconButton(
                  icon: const Icon(Icons.close,
                      color: Colors.white),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(File(j.justificatifUrl!),
                    fit: BoxFit.contain),
              ),
            ],
          ),
        ),
      );
    } else {
      Get.snackbar('Fichier PDF',
          'Chemin : ${j.justificatifUrl}',
          backgroundColor: Colors.blue,
          colorText: Colors.white);
    }
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
