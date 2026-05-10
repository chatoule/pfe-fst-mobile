// lib/screens/chef_departement/tabs/liste_rouge_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import 'dart:typed_data';
import '../../../controllers/shared_controller.dart';
import '../../../services/export_service.dart';

class ListeRougeTab extends StatefulWidget {
  const ListeRougeTab({super.key});

  @override
  State<ListeRougeTab> createState() => _ListeRougeTabState();
}

class _ListeRougeTabState extends State<ListeRougeTab> {
  final SharedController _shared = Get.find<SharedController>();
  final SignatureController _signatureController =
  SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _exporterListeRouge() async {
    Uint8List? signatureData =
        _shared.signatureChefDep.value;

    if (signatureData == null &&
        _signatureController.isNotEmpty) {
      signatureData =
      await _signatureController.toPngBytes();
      if (signatureData != null) {
        _shared.signerChefDep(signatureData);
      }
    }

    if (signatureData != null) {
      ExportService.exporterListeRougePDF(
          _shared.etudiantsEnSession,
          signature: signatureData);
    } else {
      Get.snackbar(
        'Signature manquante',
        'Veuillez signer avant d\'exporter.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final etudiants = _shared.etudiantsEnSession;
      final hasSigned =
          _shared.signatureChefDep.value != null;

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

          if (etudiants.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_satisfied_alt,
                        size: 60, color: Colors.green[200]),
                    const SizedBox(height: 16),
                    const Text(
                        'Aucun étudiant en session de rattrapage',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else ...[
            // Bannière rouge
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red[900],
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded,
                      color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'LISTE ROUGE : Étudiants transférés en session de rattrapage',
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),

            // Liste étudiants
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: etudiants.length,
                itemBuilder: (context, index) {
                  final e = etudiants[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border:
                      Border.all(color: Colors.red[100]!),
                      boxShadow: [
                        BoxShadow(
                          color:
                          Colors.red.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                      const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[50],
                        child: Text(
                          '${(e['prenom'] as String? ?? 'X')[0]}${(e['nom'] as String? ?? 'X')[0]}',
                          style: TextStyle(
                              color: Colors.red[900],
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        '${e['prenom'] ?? ''} ${e['nom'] ?? ''}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.red[900]),
                      ),
                      subtitle: Text(
                          'ID: ${e['id']} • Matricule: FST-2024-${e['id']}'),
                      trailing: Column(
                        mainAxisAlignment:
                        MainAxisAlignment.center,
                        crossAxisAlignment:
                        CrossAxisAlignment.end,
                        children: [
                          Text('${e['absences']}',
                              style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18)),
                          const Text('absences NJ',
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // Zone signature
            Padding(
              padding: const EdgeInsets.symmetric(
                  horizontal: 16, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Signature du Chef de Département :',
                    style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29)),
                  ),
                  const SizedBox(height: 8),
                  if (hasSigned) ...[
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.green[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: Colors.green[200]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.check_circle,
                              color: Colors.green),
                          const SizedBox(width: 8),
                          const Expanded(
                            child: Text('Signé numériquement',
                                style: TextStyle(
                                    color: Colors.green,
                                    fontWeight:
                                    FontWeight.bold)),
                          ),
                          Image.memory(
                              _shared.signatureChefDep.value!,
                              height: 40,
                              width: 80,
                              fit: BoxFit.contain),
                          IconButton(
                            icon: const Icon(Icons.edit,
                                color: Colors.grey, size: 20),
                            onPressed: () => _shared
                                .signatureChefDep.value = null,
                          ),
                        ],
                      ),
                    ),
                  ] else ...[
                    Container(
                      decoration: BoxDecoration(
                        border: Border.all(
                            color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Signature(
                          controller: _signatureController,
                          height: 100,
                          backgroundColor: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      mainAxisAlignment:
                      MainAxisAlignment.center,
                      children: [
                        TextButton.icon(
                          onPressed: () =>
                              _signatureController.clear(),
                          icon: const Icon(Icons.clear,
                              size: 16),
                          label: const Text('Effacer'),
                        ),
                        const SizedBox(width: 12),
                        ElevatedButton(
                          onPressed: () async {
                            if (_signatureController
                                .isNotEmpty) {
                              final bytes =
                              await _signatureController
                                  .toPngBytes();
                              if (bytes != null) {
                                _shared.signerChefDep(bytes);
                              }
                            }
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                              const Color(0xFF00855A)),
                          child: const Text('Valider',
                              style: TextStyle(
                                  color: Colors.white)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Bouton export
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: (hasSigned ||
                      _signatureController.isNotEmpty)
                      ? _exporterListeRouge
                      : null,
                  icon: const Icon(Icons.picture_as_pdf,
                      color: Colors.white),
                  label: const Text(
                      'Générer la Liste Rouge Officielle',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (hasSigned ||
                        _signatureController.isNotEmpty)
                        ? const Color(0xFF00855A)
                        : Colors.grey,
                    shape: RoundedRectangleBorder(
                        borderRadius:
                        BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    });
  }
}
