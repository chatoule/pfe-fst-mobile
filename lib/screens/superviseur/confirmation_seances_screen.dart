import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../controllers/shared_controller.dart';

class ConfirmationSeancesScreen extends StatefulWidget {
  @override
  _ConfirmationSeancesScreenState createState() =>
      _ConfirmationSeancesScreenState();
}

class _ConfirmationSeancesScreenState
    extends State<ConfirmationSeancesScreen> {

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

  void _signerFinSemestre() async {
    if (_signatureController.isEmpty) {
      Get.snackbar('Erreur', 'Veuillez signer avant de valider',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
      return;
    }

    final signatureBytes = await _signatureController.toPngBytes();
    SharedController.to.signerSuperviseur('signature_superviseur_${DateTime.now()}');

    Get.snackbar(
      'Succes !',
      'Signature enregistree pour le semestre ${SharedController.to.semestre.value}',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF00855A),
      colorText: Colors.white,
      icon: Icon(Icons.check_circle, color: Colors.white),
      duration: Duration(seconds: 3),
    );

    setState(() => _showSignature = false);
    _signatureController.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Confirmation Seances',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final fiches = SharedController.to.fichesPointage;
        final enAttente = fiches.where((f) => f['statut'] == 'EN_ATTENTE').length;
        final confirmees = fiches.where((f) => f['confirmerSuperviseur'] == true).length;
        final aSigne = SharedController.to.signatureSuperviseur.value.isNotEmpty;

        return Column(
        children: [
        // Header stats
        Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
        gradient: LinearGradient(
        colors: [Color(0xFF00855A), Color(0xFF003D29)],
        ),
        ),
        child: Row(
        children: [
        _buildStatBadge('Total', '${fiches.length}', Colors.white),
        SizedBox(width: 8),
        _buildStatBadge('En attente', '$enAttente', Colors.orange),
        SizedBox(width: 8),
        _buildStatBadge('Confirmees', '$confirmees', Colors.greenAccent),
        ],
        ),
        ),

        Expanded(
        child: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        // Liste des séances
        Text('Seances a confirmer',
        style: TextStyle(
        fontSize: 16,
        fontWeight: FontWeight.bold,
        color: Color(0xFF003D29))),
        SizedBox(height: 12),

        ...fiches.map((f) => _buildFicheCard(f)).toList(),

        SizedBox(height: 24),

        // Signature fin de semestre
        Container(
        width: double.infinity,
        decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
        BoxShadow(
        color: Colors.black.withOpacity(0.06),
        blurRadius: 10,
        offset: Offset(0, 4),
        ),
        ],
        ),
        child: Column(
        children: [
        Container(
        padding: EdgeInsets.symmetric(
        horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
        color: Color(0xFF00855A).withOpacity(0.08),
        borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
        ),
        ),
        child: Row(
        children: [
        Icon(Icons.draw_outlined,
        color: Color(0xFF00855A), size: 18),
        SizedBox(width: 8),
        Text('Signature fin de semestre',
        style: TextStyle(
        color: Color(0xFF00855A),
        fontWeight: FontWeight.bold,
        fontSize: 14)),
        ],
        ),
        ),
        Padding(
        padding: EdgeInsets.all(16),
        child: Column(
        children: [
        // Semestre info
        Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: Color(0xFFF5F7FA),
        borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Row(children: [
        Icon(Icons.school,
        color: Color(0xFF00855A), size: 16),
        SizedBox(width: 8),
        Text('Semestre :',
        style: TextStyle(color: Colors.grey)),
        ]),
        Text(
        SharedController.to.semestre.value,
        style: TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF003D29)),
        ),
        ],
        ),
        ),
        SizedBox(height: 12),

        // Statut signature
        if (aSigne)
        Container(
        padding: EdgeInsets.all(12),
        decoration: BoxDecoration(
        color: Color(0xFF00855A).withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
        color: Color(0xFF00855A).withOpacity(0.3)),
        ),
        child: Row(
        children: [
        Icon(Icons.check_circle,
        color: Color(0xFF00855A), size: 20),
        SizedBox(width: 8),
        Text('Semestre signe avec succes !',
        style: TextStyle(
        color: Color(0xFF00855A),
        fontWeight: FontWeight.bold)),
        ],
        ),
        )
        else ...[
        if (_showSignature) ...[
        Text('Signez ci-dessous :',
        style: TextStyle(
        color: Colors.grey[600],
        fontSize: 13)),
        SizedBox(height: 8),
        Container(
        decoration: BoxDecoration(
        border: Border.all(
        color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(12),
        ),
        child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Signature(
        controller: _signatureController,
        height: 150,
        backgroundColor: Color(0xFFF5FAF7),
        ),
        ),
        ),
        SizedBox(height: 8),
        Row(
        children: [
        Expanded(
        child: TextButton.icon(
        onPressed: () =>
        _signatureController.clear(),
        icon: Icon(Icons.refresh,
        color: Colors.red, size: 16),
        label: Text('Effacer',
        style: TextStyle(
        color: Colors.red)),
        ),
        ),
        Expanded(
        child: ElevatedButton.icon(
        onPressed: _signerFinSemestre,
        icon: Icon(Icons.check,
        color: Colors.white, size: 16),
        label: Text('Confirmer',
        style: TextStyle(
        color: Colors.white,
        fontWeight:
        FontWeight.bold)),
        style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00855A),
        shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(10)),
        ),
        ),
        ),
        ],
        ),
        ] else
        SizedBox(
        width: double.infinity,
        child: ElevatedButton.icon(
        onPressed: () =>
        setState(() => _showSignature = true),
        icon: Icon(Icons.draw, color: Colors.white),
        label: Text(
        'Signer le semestre',
        style: TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold),
        ),
        style: ElevatedButton.styleFrom(
        backgroundColor: Color(0xFF00855A),
        padding: EdgeInsets.symmetric(
        vertical: 14),
        shape: RoundedRectangleBorder(
        borderRadius:
        BorderRadius.circular(12)),
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

        SizedBox(height: 24),
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

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Colors.blue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(Icons.person, color: Colors.blue, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(f['matiere'],
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF003D29))),
                      Text(f['enseignantNom'],
                          style: TextStyle(
                              color: Color(0xFF00855A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                _buildStatutBadge(f['statut']),
              ],
            ),
            SizedBox(height: 10),
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Color(0xFFF5F7FA),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildDetailInfo(Icons.calendar_today, f['dateSeance']),
                      _buildDetailInfo(Icons.access_time,
                          '${f['heureDebut']} - ${f['heureFin']}'),
                      _buildDetailInfo(Icons.timer, '${f['duree']} min'),
                    ],
                  ),
                  if (f['contenu'] != null && f['contenu'].isNotEmpty) ...[
                    SizedBox(height: 8),
                    Divider(height: 1),
                    SizedBox(height: 8),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Icon(Icons.notes, size: 13, color: Colors.grey),
                        SizedBox(width: 4),
                        Expanded(
                          child: Text(f['contenu'],
                              style: TextStyle(
                                  color: Colors.grey[600], fontSize: 12)),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),

            if (!estConfirme && !estRejete) ...[
              SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SharedController.to.confirmerParSuperviseur(f['id']);
                        Get.snackbar('Succes', 'Seance confirmee !',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Color(0xFF00855A),
                            colorText: Colors.white,
                            icon: Icon(Icons.check_circle, color: Colors.white));
                      },
                      icon: Icon(Icons.check, color: Colors.white, size: 16),
                      label: Text('Confirmer',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF00855A),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  Expanded(
                    child: ElevatedButton.icon(
                      onPressed: () {
                        SharedController.to.rejeterFiche(f['id'], 'SUPERVISEUR');
                        Get.snackbar('Info', 'Seance rejetee',
                            snackPosition: SnackPosition.BOTTOM,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            icon: Icon(Icons.cancel, color: Colors.white));
                      },
                      icon: Icon(Icons.close, color: Colors.white, size: 16),
                      label: Text('Rejeter',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                      ),
                    ),
                  ),
                ],
              ),
            ] else if (estConfirme)
              Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Color(0xFF00855A).withOpacity(0.08),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: Color(0xFF00855A), size: 16),
                    SizedBox(width: 6),
                    Text('Confirme par le superviseur',
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

  Widget _buildStatBadge(String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(valeur,
                style: TextStyle(
                    color: couleur, fontSize: 18, fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 10),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE': couleur = Color(0xFF00855A); break;
      case 'CONFIRME': couleur = Colors.blue; break;
      case 'REJETE': couleur = Colors.red; break;
      default: couleur = Colors.orange;
    }
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: couleur.withOpacity(0.3)),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  Widget _buildDetailInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        SizedBox(width: 4),
        Text(valeur, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }
}