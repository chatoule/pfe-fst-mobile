// lib/screens/superviseur/tabs/liste_rouge_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/shared_controller.dart';
import '../../../services/export_service.dart';

class ListeRougeSupTab extends StatelessWidget {
  const ListeRougeSupTab({super.key});

  @override
  Widget build(BuildContext context) {
    final shared = Get.find<SharedController>();

    return Obx(() {
      final etudiants = shared.etudiantsEnSession;

      return Column(
        children: [
          // Header institutionnel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(
                  bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_uin.png',
                    width: 45, height: 45),
                const SizedBox(width: 12),
                const Column(
                  children: [
                    Text('UNIVERSITÉ ISLAMIQUE AU NIGER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF003D29))),
                    Text('FACULTÉ DES SCIENCES ET TECHNIQUES',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00855A))),
                  ],
                ),
              ],
            ),
          ),

          // Bannière rouge
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFFB71C1C), Color(0xFF7F0000)]),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SESSION DE RATTRAPAGE',
                        style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15)),
                    Text(
                      '${etudiants.length} étudiant(s) concerné(s)',
                      style: const TextStyle(
                          color: Colors.white70, fontSize: 12),
                    ),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: etudiants.isEmpty
                      ? null
                      : () async {
                    await ExportService.exporterListeRougePDF(
                      etudiants,
                      signature:
                      shared.signatureChefDep.value,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf,
                      size: 18),
                  label: const Text('Exporter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red[900],
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ],
            ),
          ),

          // Liste ou état vide
          Expanded(
            child: etudiants.isEmpty
                ? Center(
              child: Column(
                mainAxisAlignment:
                MainAxisAlignment.center,
                children: [
                  Icon(Icons.check_circle_outline,
                      size: 64,
                      color: Colors.green[200]),
                  const SizedBox(height: 16),
                  const Text(
                    'Aucun étudiant sur la liste rouge',
                    style: TextStyle(
                        color: Colors.grey, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Tous les étudiants ont un taux\nd\'absence acceptable.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        color: Colors.grey, fontSize: 13),
                  ),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: etudiants.length,
              itemBuilder: (context, index) =>
                  _buildEtudiantCard(etudiants[index]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildEtudiantCard(Map<String, dynamic> e) {
    final prenom = e['prenom'] as String? ?? '';
    final nom = e['nom'] as String? ?? '';
    final absences = e['absences'] as int? ?? 0;

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
        border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        leading: CircleAvatar(
          backgroundColor: Colors.red[50],
          child: Text(
            '${prenom.isNotEmpty ? prenom[0] : '?'}${nom.isNotEmpty ? nom[0] : '?'}',
            style: const TextStyle(
                color: Colors.red, fontWeight: FontWeight.bold),
          ),
        ),
        title: Text(
          '$prenom $nom',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF003D29)),
        ),
        subtitle: Text(
          'ID: ${e['id']} • $absences absences non justifiées',
          style: TextStyle(
              color: Colors.red[700],
              fontWeight: FontWeight.w500,
              fontSize: 12),
        ),
        trailing: const Icon(Icons.warning_amber_rounded,
            color: Colors.red),
      ),
    );
  }
}
