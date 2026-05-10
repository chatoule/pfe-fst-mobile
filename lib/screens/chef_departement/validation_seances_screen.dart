// lib/screens/chef_departement/validation_seances_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../controllers/shared_controller.dart';

class ValidationSeancesScreen extends StatefulWidget {
  const ValidationSeancesScreen({super.key});

  @override
  State<ValidationSeancesScreen> createState() =>
      _ValidationSeancesScreenState();
}

class _ValidationSeancesScreenState
    extends State<ValidationSeancesScreen> {
  final SignatureController _signatureController = SignatureController(
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

    final signature = await _signatureController.toPngBytes();
    if (signature != null) {
      SharedController.to.signerChefDep(signature);
      Get.snackbar(
        'Succès !',
        'Signature enregistrée pour le semestre ${SharedController.to.semestre.value}',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: const Color(0xFF00855A),
        colorText: Colors.white,
        icon: const Icon(Icons.check_circle, color: Colors.white),
        duration: const Duration(seconds: 3),
      );
    }

    setState(() => _showSignature = false);
    _signatureController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Validation Séances',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final fiches = SharedController.to.fichesPointage;
        final confirmesSuperviseur = fiches
            .where((f) => f['confirmerSuperviseur'] == true)
            .toList();
        final valides = fiches
            .where((f) => f['valideChefDep'] == true)
            .length;
        final aSigne =
            SharedController.to.signatureChefDep.value != null;

        return Column(
          children: [
            // En-tête institutionnel
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                    bottom:
                    BorderSide(color: Color(0xFFEEEEEE))),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/images/logo_uin.png',
                      width: 45, height: 45),
                  const SizedBox(width: 12),
                  const Column(
                    children: [
                      Text(
                        'UNIVERSITÉ ISLAMIQUE AU NIGER',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                            color: Color(0xFF003D29)),
                      ),
                      Text(
                        'FACULTÉ DES SCIENCES ET TECHNIQUES',
                        style: TextStyle(
                            fontSize: 11,
                            color: Color(0xFF00855A)),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Stats header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                    colors: [Color(0xFF00855A), Color(0xFF003D29)]),
              ),
              child: Row(
                children: [
                  _buildStatBadge('Confirmées',
                      '${confirmesSuperviseur.length}',
                      Colors.white),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                      'À valider',
                      '${confirmesSuperviseur.where((f) => f['valideChefDep'] == false).length}',
                      Colors.orange),
                  const SizedBox(width: 8),
                  _buildStatBadge(
                      'Validées', '$valides', Colors.greenAccent),
                ],
              ),
            ),

            // Contenu principal
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Séances confirmées par le Superviseur',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29)),
                    ),
                    const SizedBox(height: 12),

                    // Liste des fiches
                    if (confirmesSuperviseur.isEmpty)
                      Container(
                        padding: const EdgeInsets.all(24),
                        child: Center(
                          child: Column(
                            children: [
                              Icon(Icons.inbox,
                                  size: 50,
                                  color: Colors.grey[300]),
                              const SizedBox(height: 12),
                              const Text(
                                'Aucune séance confirmée par le superviseur',
                                style: TextStyle(
                                    color: Colors.grey),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ...confirmesSuperviseur
                          .map((f) => _buildFicheCard(f)),

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
                          // Header section
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: const Color(0xFF00855A)
                                  .withValues(alpha: 0.08),
                              borderRadius: const BorderRadius.only(
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
                                Text(
                                  'Signature fin de semestre',
                                  style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14),
                                ),
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
                                    color:
                                    const Color(0xFFF5F7FA),
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
                                            color:
                                            Color(0xFF00855A),
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
                                      color: const Color(0xFF00855A)
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
                                              color:
                                              Color(0xFF00855A),
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
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
                                                'Valider',
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
                                                    .circular(
                                                    10),
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
                                                () =>
                                            _showSignature =
                                            true),
                                        icon: const Icon(Icons.draw,
                                            color: Colors.white),
                                        label: const Text(
                                          'Signer le semestre',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight:
                                              FontWeight.bold),
                                        ),
                                        style: ElevatedButton
                                            .styleFrom(
                                          backgroundColor:
                                          const Color(
                                              0xFF00855A),
                                          padding:
                                          const EdgeInsets
                                              .symmetric(
                                              vertical: 14),
                                          shape:
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius
                                                .circular(12),
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
    final estValide = f['valideChefDep'] == true;

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
                    color:
                    Colors.purple.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(Icons.person,
                      color: Colors.purple, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: [
                      Text(
                        // ✅ null-safe
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
                _buildStatutBadge(
                    f['statut'] ?? 'EN_ATTENTE'),
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
                      _buildDetailInfo(Icons.calendar_today,
                          f['dateSeance'] ?? 'N/A'),
                      _buildDetailInfo(
                          Icons.access_time,
                          '${f['heureDebut'] ?? ''} - ${f['heureFin'] ?? ''}'),
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
                          child: Text(
                            f['contenu'],
                            style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            // Badge superviseur
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(
                  horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.blue, size: 14),
                  SizedBox(width: 6),
                  Text(
                    'Confirmé par le Superviseur',
                    style: TextStyle(
                        color: Colors.blue,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            ),

            // Boutons validation
            if (!estValide) ...[
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SharedController.to
                            .validerParChefDep(f['id']);
                        Get.snackbar(
                          'Succès',
                          'Séance validée !',
                          snackPosition:
                          SnackPosition.BOTTOM,
                          backgroundColor:
                          const Color(0xFF00855A),
                          colorText: Colors.white,
                          icon: const Icon(
                              Icons.check_circle,
                              color: Colors.white),
                        );
                      },
                      icon: const Icon(Icons.verified,
                          color: Colors.white, size: 16),
                      label: const Text('Valider',
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
                        SharedController.to
                            .rejeterFiche(f['id'], 'CHEF_DEP');
                        Get.snackbar(
                          'Info',
                          'Séance rejetée',
                          snackPosition:
                          SnackPosition.BOTTOM,
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
            ] else
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
                    Icon(Icons.verified,
                        color: Color(0xFF00855A), size: 16),
                    SizedBox(width: 6),
                    Text(
                      'Validé par le Chef de Département',
                      style: TextStyle(
                          color: Color(0xFF00855A),
                          fontWeight: FontWeight.bold,
                          fontSize: 12),
                    ),
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
            Text(valeur,
                style: TextStyle(
                    color: couleur,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE': couleur = const Color(0xFF00855A); break;
      case 'CONFIRME': couleur = Colors.blue; break;
      case 'REJETE': couleur = Colors.red; break;
      default: couleur = Colors.orange;
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
        Text(valeur,
            style: TextStyle(
                color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}
