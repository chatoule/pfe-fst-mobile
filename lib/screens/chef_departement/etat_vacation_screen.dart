import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:signature/signature.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../controllers/shared_controller.dart';
import '../../services/export_service.dart';

class EtatVacationScreen extends StatefulWidget {
  const EtatVacationScreen({super.key});

  @override
  State<EtatVacationScreen> createState() => _EtatVacationScreenState();
}

class _EtatVacationScreenState extends State<EtatVacationScreen> {
  final SharedController _sharedController = SharedController.to;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );
  bool _hasSigned = false;

  List<Map<String, dynamic>> _getVacatairesData() {
    return _sharedController.getVacatairesData();
  }

  int _totalHeures(Map<String, dynamic> vacataire) {
    final seances = vacataire['seances'];
    if (seances is! List) return 0;
    return seances.fold(0, (sum, s) => sum + ((s['duree'] as int?) ?? 0));
  }

  int _montantTotal(Map<String, dynamic> vacataire) {
    return _totalHeures(vacataire) * ((vacataire['tauxHoraire'] as int?) ?? 0);
  }

  Future<void> _genererPDF() async {
    final signatureImg = await _signatureController.toPngBytes();
    final currentVacataires = _getVacatairesData();
    
    // Conversion au format attendu par ExportService
    final formattedVacations = currentVacataires.map((v) => {
      'enseignantNom': '${v['prenom']} ${v['nom']}',
      'matiere': v['matiere'],
      'totalHeures': v['totalHeures'],
      'tauxHoraire': v['tauxHoraire'],
    }).toList();

    await ExportService.exporterEtatVacationPDF(
      formattedVacations,
      signatureChef: signatureImg,
    );
  }

  pw.Widget _buildPDFCell(String text, {bool bold = false}) {
    return pw.Padding(padding: const pw.EdgeInsets.all(6), child: pw.Text(text, style: pw.TextStyle(fontSize: 9, fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal)));
  }

  String _formaterMontant(int montant) {
    return NumberFormat('#,###', 'fr_FR').format(montant).replaceAll(',', ' ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Etat de Vacation', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Obx(() {
        final currentVacataires = _getVacatairesData();
        final totalMontant = currentVacataires.fold(0, (sum, v) => sum + _montantTotal(v));

        return Column(
          children: [
            _buildHeader(currentVacataires.length, totalMontant),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  ...currentVacataires.map((v) => _buildVacataireCard(v)),
                  const SizedBox(height: 20),
                  _buildSignatureZone(),
                  const SizedBox(height: 20),
                  _buildActionButtons(currentVacataires.isNotEmpty),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  Widget _buildHeader(int count, int total) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(colors: [Color(0xFF00855A), Color(0xFF003D29)]),
        borderRadius: BorderRadius.only(bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('assets/images/logo_uin.png', width: 40, height: 40),
              const SizedBox(width: 10),
              const Flexible(
                child: Text('UNIVERSITE ISLAMIQUE AU NIGER', 
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12),
                  overflow: TextOverflow.ellipsis),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildHeaderStat('Vacataires', '$count'),
              _buildHeaderStat('Total Global', '${_formaterMontant(total)} F'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String value) {
    return Column(
      children: [
        Text(value, style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildVacataireCard(Map<String, dynamic> v) {
    final heures = _totalHeures(v);
    final montant = _montantTotal(v);
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          CircleAvatar(backgroundColor: const Color(0xFF00855A).withOpacity(0.1), child: Text(v['prenom'][0], style: const TextStyle(color: Color(0xFF00855A)))),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${v['prenom']} ${v['nom']}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                Text(v['matiere'], style: const TextStyle(color: Colors.grey, fontSize: 11), maxLines: 1, overflow: TextOverflow.ellipsis),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text('${_formaterMontant(montant)} F', style: const TextStyle(color: Colors.orange, fontWeight: FontWeight.bold, fontSize: 13)),
              Text('$heures h', style: const TextStyle(color: Colors.grey, fontSize: 11)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSignatureZone() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Signature du Chef de Département', 
              style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29))),
            if (_hasSigned)
              TextButton.icon(
                onPressed: () => setState(() {
                  _hasSigned = false;
                  _signatureController.clear();
                }),
                icon: const Icon(Icons.refresh, size: 16, color: Colors.red),
                label: const Text('Recommencer', style: TextStyle(color: Colors.red, fontSize: 12)),
              ),
          ],
        ),
        const SizedBox(height: 10),
        Container(
          height: 150,
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
            color: Colors.white,
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: _hasSigned 
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.verified, color: Colors.green, size: 50),
                      const SizedBox(height: 8),
                      const Text('Signature enregistrée', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                    ],
                  ),
                )
              : Signature(
                  controller: _signatureController,
                  backgroundColor: Colors.white,
                ),
          ),
        ),
        if (!_hasSigned)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => _signatureController.clear(),
                  icon: const Icon(Icons.clear, size: 16),
                  label: const Text('Effacer'),
                ),
              ],
            ),
          )
        else
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton.icon(
                  onPressed: () => setState(() {
                    _hasSigned = false;
                    _signatureController.clear();
                  }),
                  icon: const Icon(Icons.delete_outline, size: 16, color: Colors.red),
                  label: const Text('Effacer et recommencer', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
      ],
    );
  }

  Widget _buildActionButtons(bool hasData) {
    return Column(
      children: [
        if (!_hasSigned)
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => setState(() => _hasSigned = true),
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00855A), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
              child: const Text('Valider ma Signature', style: TextStyle(color: Colors.white)),
            ),
          ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: (_hasSigned && hasData) ? _genererPDF : null,
            icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
            label: const Text('Générer le PDF Officiel', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF003D29), disabledBackgroundColor: Colors.grey),
          ),
        ),
      ],
    );
  }
}
