import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../../controllers/shared_controller.dart';
import '../../controllers/auth_controller.dart';

class EtatVacationScreen extends StatefulWidget {
  @override
  _EtatVacationScreenState createState() => _EtatVacationScreenState();
}

class _EtatVacationScreenState extends State<EtatVacationScreen> {
  final AuthController _authController = Get.find<AuthController>();

  final List<Map<String, dynamic>> vacataires = [
    {
      'id': 1,
      'nom': 'Moussa',
      'prenom': 'Ali',
      'grade': 'Vacataire',
      'tauxHoraire': 5000,
      'module': 'Algorithme', // ← vrai nom
      //'seances': [...],
    },
    {
      'id': 2,
      'nom': 'Diallo',
      'prenom': 'Ibrahim',
      'grade': 'Vacataire',
      'tauxHoraire': 5000,
      'module': 'Programmation Java', // ← vrai nom
      //'seances': [...],
    },
    {
      'id': 3,
      'nom': 'Maiga',
      'prenom': 'Fatima',
      'grade': 'Vacataire',
      'tauxHoraire': 5000,
      'module': 'Structure de Donnees', // ← vrai nom
      //'seances': [...],
    },
  ];

  int _totalHeures(Map<String, dynamic> vacataire) {
    final seances = vacataire['seances'] as List;
    return seances
        .where((s) => s['statut'] == 'VALIDE')
        .fold(0, (sum, s) => sum + (s['duree'] as int));
  }

  int _montantTotal(Map<String, dynamic> vacataire) {
    return _totalHeures(vacataire) * (vacataire['tauxHoraire'] as int);
  }

  // ===== GENERER PDF =====
  Future<void> _genererPDF() async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            // En-tête
            pw.Center(
              child: pw.Column(
                children: [
                  pw.Text('UNIVERSITE ISLAMIQUE AU NIGER',
                      style: pw.TextStyle(
                          fontSize: 14, fontWeight: pw.FontWeight.bold)),
                  pw.Text('FACULTE DES SCIENCES ET TECHNIQUES',
                      style: pw.TextStyle(fontSize: 12)),
                  pw.SizedBox(height: 4),
                  pw.Container(
                    padding: pw.EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(),
                    ),
                    child: pw.Text('ETAT DE PAIEMENT DES VACATAIRES',
                        style: pw.TextStyle(
                            fontSize: 13, fontWeight: pw.FontWeight.bold)),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 16),

            // Infos
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                    'Annee academique : 2025-2026',
                    style: pw.TextStyle(fontSize: 11)),
                pw.Text(
                    'Semestre : ${SharedController.to.semestre.value}',
                    style: pw.TextStyle(fontSize: 11)),
              ],
            ),
            pw.SizedBox(height: 16),

            // Tableau principal
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: pw.FlexColumnWidth(2),
                1: pw.FlexColumnWidth(2),
                2: pw.FlexColumnWidth(1),
                3: pw.FlexColumnWidth(1),
                4: pw.FlexColumnWidth(1.5),
              },
              children: [
                // En-tête tableau
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildPDFCell('Nom & Prenom', bold: true),
                    _buildPDFCell('Module', bold: true),
                    _buildPDFCell('Nb Seances', bold: true),
                    _buildPDFCell('Total Heures', bold: true),
                    _buildPDFCell('Montant (FCFA)', bold: true),
                  ],
                ),
                // Lignes
                ...vacataires.map((v) {
                  final heures = _totalHeures(v);
                  final montant = _montantTotal(v);
                  final nbSeances = (v['seances'] as List)
                      .where((s) => s['statut'] == 'VALIDE')
                      .length;
                  return pw.TableRow(
                    children: [
                      _buildPDFCell('${v['prenom']} ${v['nom']}'),
                      _buildPDFCell(v['module']),
                      _buildPDFCell('$nbSeances'),
                      _buildPDFCell('$heures h'),
                      _buildPDFCell('${_formaterMontant(montant)} FCFA'),
                    ],
                  );
                }).toList(),

                // Total
                pw.TableRow(
                  decoration: pw.BoxDecoration(color: PdfColors.grey200),
                  children: [
                    _buildPDFCell('TOTAL GENERAL', bold: true),
                    _buildPDFCell(''),
                    _buildPDFCell(
                        '${vacataires.fold(0, (sum, v) => sum + (v['seances'] as List).where((s) => s['statut'] == 'VALIDE').length)}',
                        bold: true),
                    _buildPDFCell(
                        '${vacataires.fold(0, (sum, v) => sum + _totalHeures(v))} h',
                        bold: true),
                    _buildPDFCell(
                        '${_formaterMontant(vacataires.fold(0, (sum, v) => sum + _montantTotal(v)))} FCFA',
                        bold: true),
                  ],
                ),
              ],
            ),

            pw.SizedBox(height: 40),

            // Signatures
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('LE SUPERVISEUR',
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 120, height: 1, color: PdfColors.black),
                    pw.Text(
                        SharedController.to.signatureSuperviseur.value.isNotEmpty
                            ? 'Signe'
                            : 'En attente',
                        style: pw.TextStyle(fontSize: 10)),
                  ],
                ),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('LE CHEF DE DEPARTEMENT',
                        style: pw.TextStyle(
                            fontSize: 11, fontWeight: pw.FontWeight.bold)),
                    pw.SizedBox(height: 40),
                    pw.Container(width: 120, height: 1, color: PdfColors.black),
                    pw.Text(
                        SharedController.to.signatureChefDep.value.isNotEmpty
                            ? 'Signe'
                            : 'En attente',
                        style: pw.TextStyle(fontSize: 10)),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'etat_vacation_${SharedController.to.semestre.value}.pdf',
    );
  }

  pw.Widget _buildPDFCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: pw.EdgeInsets.all(6),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 10,
          fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  String _formaterMontant(int montant) {
    final str = montant.toString();
    final buffer = StringBuffer();
    for (int i = 0; i < str.length; i++) {
      if (i > 0 && (str.length - i) % 3 == 0) buffer.write(' ');
      buffer.write(str[i]);
    }
    return buffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    final totalHeuresGlobal =
    vacataires.fold(0, (sum, v) => sum + _totalHeures(v));
    final totalMontantGlobal =
    vacataires.fold(0, (sum, v) => sum + _montantTotal(v));

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Etat de Vacation',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.picture_as_pdf),
            onPressed: _genererPDF,
            tooltip: 'Generer PDF',
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Header
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                children: [
                  Text('ETAT DE PAIEMENT DES VACATAIRES',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4),
                  Text(
                      'Semestre : ${SharedController.to.semestre.value}',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildHeaderStat('Vacataires', '${vacataires.length}'),
                      _buildHeaderStat('Total Heures', '${totalHeuresGlobal}h'),
                      _buildHeaderStat('Total Montant',
                          '${_formaterMontant(totalMontantGlobal)} F'),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Liste vacataires
                  Text('Detail par enseignant',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 12),

                  ...vacataires.map((v) => _buildVacataireCard(v)).toList(),

                  SizedBox(height: 24),

                  // Récapitulatif
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
                              Icon(Icons.summarize,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Recapitulatif general',
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
                              _buildRecapRow('Nombre de vacataires',
                                  '${vacataires.length}', Color(0xFF00855A)),
                              Divider(height: 16),
                              _buildRecapRow('Total seances validees',
                                  '${vacataires.fold(0, (sum, v) => sum + (v['seances'] as List).where((s) => s['statut'] == 'VALIDE').length)}',
                                  Colors.blue),
                              Divider(height: 16),
                              _buildRecapRow('Total heures effectuees',
                                  '${totalHeuresGlobal} heures', Colors.purple),
                              Divider(height: 16),
                              _buildRecapRow(
                                  'MONTANT TOTAL A PAYER',
                                  '${_formaterMontant(totalMontantGlobal)} FCFA',
                                  Colors.orange,
                                  bold: true),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // Statut signatures
                  Obx(() {
                    final sigSup = SharedController.to.signatureSuperviseur.value.isNotEmpty;
                    final sigChef = SharedController.to.signatureChefDep.value.isNotEmpty;
                    return Container(
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
                                Icon(Icons.verified_outlined,
                                    color: Color(0xFF00855A), size: 18),
                                SizedBox(width: 8),
                                Text('Statut des signatures',
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14)),
                              ],
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(16),
                            child: Row(
                              children: [
                                Expanded(
                                  child: _buildSignatureStatus(
                                      'Superviseur', sigSup),
                                ),
                                SizedBox(width: 12),
                                Expanded(
                                  child: _buildSignatureStatus(
                                      'Chef Departement', sigChef),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    );
                  }),

                  SizedBox(height: 24),

                  // Bouton générer PDF
                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [Color(0xFF00A86B), Color(0xFF00855A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF00855A).withOpacity(0.4),
                          blurRadius: 15,
                          offset: Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _genererPDF,
                      icon: Icon(Icons.picture_as_pdf, color: Colors.white),
                      label: Text('Generer le PDF',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),

                  SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildVacataireCard(Map<String, dynamic> v) {
    final heures = _totalHeures(v);
    final montant = _montantTotal(v);
    final seancesValidees = (v['seances'] as List)
        .where((s) => s['statut'] == 'VALIDE')
        .toList();

    return Container(
      margin: EdgeInsets.only(bottom: 16),
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
          // Header enseignant
          Container(
            padding: EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Color(0xFF00855A).withOpacity(0.05),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Color(0xFF00855A).withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(
                      '${v['prenom'][0]}${v['nom'][0]}',
                      style: TextStyle(
                          color: Color(0xFF00855A),
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${v['prenom']} ${v['nom']}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF003D29))),
                      Text(v['module'],
                          style: TextStyle(
                              color: Color(0xFF00855A),
                              fontSize: 12,
                              fontWeight: FontWeight.w500)),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text('${_formaterMontant(montant)} FCFA',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 14)),
                    Text('$heures heures',
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ],
                ),
              ],
            ),
          ),

          // Tableau séances
          Padding(
            padding: EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Seances effectuees :',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 13,
                        color: Color(0xFF003D29))),
                SizedBox(height: 8),

                // En-tête tableau
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Color(0xFF00855A).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Expanded(flex: 2, child: Text('Date', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00855A)))),
                      Expanded(flex: 2, child: Text('Horaire', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00855A)))),
                      Expanded(flex: 1, child: Text('Duree', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00855A)))),
                      Expanded(flex: 1, child: Text('Statut', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 11, color: Color(0xFF00855A)))),
                    ],
                  ),
                ),
                SizedBox(height: 4),

                // Lignes séances
                ...(v['seances'] as List).map((s) {
                  final estValide = s['statut'] == 'VALIDE';
                  return Container(
                    padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    margin: EdgeInsets.only(bottom: 4),
                    decoration: BoxDecoration(
                      color: estValide
                          ? Color(0xFF00855A).withOpacity(0.04)
                          : Colors.orange.withOpacity(0.04),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: estValide
                            ? Color(0xFF00855A).withOpacity(0.1)
                            : Colors.orange.withOpacity(0.1),
                      ),
                    ),
                    child: Row(
                      children: [
                        Expanded(flex: 2, child: Text(s['date'], style: TextStyle(fontSize: 11, color: Color(0xFF003D29)))),
                        Expanded(flex: 2, child: Text('${s['heureDebut']}-${s['heureFin']}', style: TextStyle(fontSize: 11, color: Colors.grey[600]))),
                        Expanded(flex: 1, child: Text('${s['duree']}h', style: TextStyle(fontSize: 11, color: Colors.grey[600]))),
                        Expanded(
                          flex: 1,
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: estValide
                                  ? Color(0xFF00855A).withOpacity(0.1)
                                  : Colors.orange.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              estValide ? 'OK' : 'ATT',
                              style: TextStyle(
                                  color: estValide ? Color(0xFF00855A) : Colors.orange,
                                  fontSize: 9,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }).toList(),

                SizedBox(height: 8),
                Divider(height: 1),
                SizedBox(height: 8),

                // Total enseignant
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('Total : $heures heures × ${_formaterMontant(v['tauxHoraire'])} FCFA/h',
                        style: TextStyle(color: Colors.grey[600], fontSize: 12)),
                    Text('= ${_formaterMontant(montant)} FCFA',
                        style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                            fontSize: 13)),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeaderStat(String label, String valeur) {
    return Column(
      children: [
        Text(valeur,
            style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold)),
        Text(label,
            style: TextStyle(color: Colors.white70, fontSize: 11)),
      ],
    );
  }

  Widget _buildRecapRow(String label, String valeur, Color couleur,
      {bool bold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label,
            style: TextStyle(
                color: bold ? Color(0xFF003D29) : Colors.grey[600],
                fontSize: 13,
                fontWeight: bold ? FontWeight.bold : FontWeight.normal)),
        Text(valeur,
            style: TextStyle(
                color: couleur,
                fontSize: 13,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildSignatureStatus(String label, bool estSigne) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: estSigne
            ? Color(0xFF00855A).withOpacity(0.08)
            : Colors.orange.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: estSigne
              ? Color(0xFF00855A).withOpacity(0.3)
              : Colors.orange.withOpacity(0.3),
        ),
      ),
      child: Column(
        children: [
          Icon(
            estSigne ? Icons.check_circle : Icons.pending,
            color: estSigne ? Color(0xFF00855A) : Colors.orange,
            size: 24,
          ),
          SizedBox(height: 6),
          Text(label,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                  color: Color(0xFF003D29)),
              textAlign: TextAlign.center),
          SizedBox(height: 4),
          Text(
            estSigne ? 'Signe' : 'En attente',
            style: TextStyle(
                color: estSigne ? Color(0xFF00855A) : Colors.orange,
                fontSize: 11),
          ),
        ],
      ),
    );
  }
}