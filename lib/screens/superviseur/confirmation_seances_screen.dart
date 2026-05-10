// lib/screens/superviseur/confirmation_seances_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../controllers/shared_controller.dart';

class ConfirmationSeancesScreen extends StatefulWidget {
  const ConfirmationSeancesScreen({super.key});

  @override
  State<ConfirmationSeancesScreen> createState() =>
      _ConfirmationSeancesScreenState();
}

class _ConfirmationSeancesScreenState
    extends State<ConfirmationSeancesScreen> {
  final SignatureController _signatureController =
  SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool _showSignature = false;

  @override
  void dispose() {
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _signerFinSemestre() async {
    if (_signatureController.isEmpty) {
      Get.snackbar(
        'Erreur',
        'Veuillez signer avant de valider',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    final signatureBytes =
    await _signatureController.toPngBytes();
    if (signatureBytes != null) {
      SharedController.to.signerSuperviseur(signatureBytes);
    }

    Get.snackbar(
      'Succès !',
      'Signature enregistrée pour le semestre ${SharedController.to.semestre.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: const Color(0xFF00855A),
      colorText: Colors.white,
      icon: const Icon(Icons.check_circle, color: Colors.white),
      duration: const Duration(seconds: 3),
    );

    setState(() => _showSignature = false);
    _signatureController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Confirmation Séances',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final fiches = SharedController.to.fichesPointage;
        final enAttente = fiches
            .where((f) =>
        f['statut'] == 'EN_ATTENTE' ||
            f['statut'] == 'EN_COURS')
            .length;
        final confirmees = fiches
            .where((f) => f['confirmerSuperviseur'] == true)
            .length;
        final aSigne = SharedController
            .to.signatureSuperviseur.value !=
            null;

        return Column(
          children: [
            // Stats header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF00855A), Color(0xFF003D29)]),
              ),
              child: Row(
                children: [
                  _buildStatBadge('Total',
                      '${fiches.length}', Colors.white),
                  const SizedBox(width: 8),
                  _buildStatBadge('En attente',
                      '$enAttente', Colors.orange),
                  const SizedBox(width: 8),
                  _buildStatBadge('Confirmées',
                      '$confirmees', Colors.greenAccent),
                ],
              ),
            ),

            // Contenu
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Séances à confirmer',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003D29))),
                    const SizedBox(height: 12),

                    if (fiches.isEmpty)
                      const Center(
                        child: Padding(
                          padding: EdgeInsets.all(24),
                          child: Text(
                              'Aucune séance à confirmer',
                              style:
                              TextStyle(color: Colors.grey)),
                        ),
                      )
                    else
                      ...fiches.map((f) => _buildFicheCard(f)),

                    const SizedBox(height: 24),

                    // Zone signature fin de semestre
                    Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black
                                .withValues(alpha: 0.06),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          // Header section signature
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00855A)
                                  .withValues(alpha: 0.08),
                              borderRadius:
                              const BorderRadius.only(
                                topLeft: Radius.circular(16),
                                topRight: Radius.circular(16),
                              ),
                            ),
                            child: const Row(
                              children: [
                                Icon(Icons.draw_outlined,
                                    color: Color(0xFF00855A),
                                    size: 18),
                                SizedBox(width: 8),
                                Text('Signature fin de semestre',
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontWeight:
                                        FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                          ),

                          Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              children: [
                                // Info semestre
                                Container(
                                  padding:
                                  const EdgeInsets.all(12),
                                  decoration: BoxDecoration(
                                    color: const Color(
                                        0xFFF5F7FA),
                                    borderRadius:
                                    BorderRadius.circular(10),
                                  ),
                                  child: Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment
                                        .spaceBetween,
                                    children: [
                                      const Row(children: [
                                        Icon(Icons.school,
                                            color: Color(
                                                0xFF00855A),
                                            size: 16),
                                        SizedBox(width: 8),
                                        Text('Semestre :',
                                            style: TextStyle(
                                                color:
                                                Colors.grey)),
                                      ]),
                                      Obx(() => Text(
                                        SharedController
                                            .to.semestre.value,
                                        style: const TextStyle(
                                            fontWeight:
                                            FontWeight.bold,
                                            color: Color(
                                                0xFF003D29)),
                                      )),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 12),

                                // Statut signature
                                if (aSigne)
                                  Container(
                                    padding:
                                    const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: const Color(
                                          0xFF00855A)
                                          .withValues(alpha: 0.08),
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      border: Border.all(
                                          color: const Color(
                                              0xFF00855A)
                                              .withValues(
                                              alpha: 0.3)),
                                    ),
                                    child: const Row(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color:
                                            Color(0xFF00855A),
                                            size: 20),
                                        SizedBox(width: 8),
                                        Text(
                                            'Semestre signé avec succès !',
                                            style: TextStyle(
                                                color: Color(
                                                    0xFF00855A),
                                                fontWeight:
                                                FontWeight
                                                    .bold)),
                                      ],
                                    ),
                                  )
                                else ...[
                                  if (_showSignature) ...[
                                    Text('Signez ci-dessous :',
                                        style: TextStyle(
                                            color: Colors.grey[600],
                                            fontSize: 13)),
                                    const SizedBox(height: 8),
                                    Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color:
                                            Colors.grey[300]!),
                                        borderRadius:
                                        BorderRadius.circular(
                                            12),
                                      ),
                                      child: ClipRRect(
                                        borderRadius:
                                        BorderRadius.circular(
                                            12),
                                        child: Signature(
                                          controller:
                                          _signatureController,
                                          height: 150,
                                          backgroundColor:
                                          const Color(
                                              0xFFF5FAF7),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: TextButton.icon(
                                            onPressed: () =>
                                                _signatureController
                                                    .clear(),
                                            icon: const Icon(
                                                Icons.refresh,
                                                color: Colors.red,
                                                size: 16),
                                            label: const Text(
                                                'Effacer',
                                                style: TextStyle(
                                                    color:
                                                    Colors.red)),
                                          ),
                                        ),
                                        Expanded(
                                          child:
                                          ElevatedButton.icon(
                                            onPressed:
                                            _signerFinSemestre,
                                            icon: const Icon(
                                                Icons.check,
                                                color: Colors.white,
                                                size: 16),
                                            label: const Text(
                                                'Confirmer',
                                                style: TextStyle(
                                                    color:
                                                    Colors.white,
                                                    fontWeight:
                                                    FontWeight
                                                        .bold)),
                                            style: ElevatedButton
                                                .styleFrom(
                                              backgroundColor:
                                              const Color(
                                                  0xFF00855A),
                                              shape:
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                BorderRadius
                                                    .circular(10),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ] else
                                    SizedBox(
                                      width: double.infinity,
                                      child: ElevatedButton.icon(
                                        onPressed: () => setState(
                                                () => _showSignature =
                                            true),
                                        icon: const Icon(Icons.draw,
                                            color: Colors.white),
                                        label: const Text(
                                            'Signer le semestre',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontWeight:
                                                FontWeight.bold)),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                          const Color(0xFF00855A),
                                          padding:
                                          const EdgeInsets.symmetric(
                                              vertical: 14),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                12),
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildFicheCard(Map<String, dynamic> f) {
    final estConfirme = f['confirmerSuperviseur'] == true;
    final estRejete = f['statut'] == 'REJETE';
    final statut = f['statut'] ?? 'EN_ATTENTE';

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
            // Header fiche
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
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        f['matiere'] ?? 'Module inconnu',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                            color: Color(0xFF003D29)),
                      ),
                      Text(
                        f['enseignantNom'] ?? 'Inconnu',
                        style: const TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                _buildStatutBadge(statut),
              ],
            ),
            const SizedBox(height: 10),

            // Détails séance
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment:
                    MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                          child: _buildDetailInfo(
                              Icons.calendar_today,
                              f['dateSeance'] ?? 'N/A')),
                      Expanded(
                          child: _buildDetailInfo(
                              Icons.access_time,
                              '${f['heureDebut'] ?? ''} - ${f['heureFin'] ?? ''}')),
                      _buildDetailInfo(Icons.timer,
                          '${f['duree'] ?? 0} min'),
                    ],
                  ),
                  if (f['contenu'] != null &&
                      (f['contenu'] as String).isNotEmpty) ...[
                    const SizedBox(height: 8),
                    const Divider(height: 1),
                    const SizedBox(height: 8),
                    Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.notes,
                            size: 13, color: Colors.grey),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(f['contenu'],
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

            // Actions
            if (!estConfirme && !estRejete) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SharedController.to
                            .confirmerParSuperviseur(f['id']);
                        Get.snackbar(
                          'Succès',
                          'Séance confirmée !',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor:
                          const Color(0xFF00855A),
                          colorText: Colors.white,
                          icon: const Icon(Icons.check_circle,
                              color: Colors.white),
                        );
                      },
                      icon: const Icon(Icons.check,
                          color: Colors.white, size: 16),
                      label: const Text('Confirmer',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor:
                        const Color(0xFF00855A),
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
                      onPressed: () {
                        SharedController.to.rejeterFiche(
                            f['id'], 'SUPERVISEUR');
                        Get.snackbar(
                          'Info',
                          'Séance rejetée',
                          snackPosition: SnackPosition.BOTTOM,
                          backgroundColor: Colors.red,
                          colorText: Colors.white,
                          icon: const Icon(Icons.cancel,
                              color: Colors.white),
                        );
                      },
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
            ] else if (estConfirme)
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF00855A)
                      .withValues(alpha: 0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle,
                        color: Color(0xFF00855A), size: 16),
                    SizedBox(width: 6),
                    Text('Confirmé par le superviseur',
                        style: TextStyle(
                            color: Color(0xFF00855A),
                            fontWeight: FontWeight.bold,
                            fontSize: 12)),
                  ],
                ),
              ),
          ],
        ),
      ),
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
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE':
      case 'CONFIRME':
        couleur = const Color(0xFF00855A);
        break;
      case 'REJETE':
        couleur = Colors.red;
        break;
      default:
        couleur = Colors.orange;
    }
    return Container(
      padding:
      const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: couleur.withValues(alpha: 0.3)),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur,
              fontWeight: FontWeight.bold,
              fontSize: 10)),
    );
  }

  Widget _buildDetailInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        Flexible(
          child: Text(valeur,
              style: TextStyle(
                  color: Colors.grey[600], fontSize: 12),
              overflow: TextOverflow.ellipsis),
        ),
      ],
    );
  }
}
