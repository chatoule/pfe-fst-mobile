import 'dart:io';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:intl/intl.dart';
import 'package:excel/excel.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

class ExportService {
  static Future<pw.TextStyle> _getSafeStyle({double fontSize = 12, pw.FontWeight fontWeight = pw.FontWeight.normal}) async {
    final fontData = await rootBundle.load('assets/fonts/arial.ttf');
    final font = pw.Font.ttf(fontData);
    return pw.TextStyle(font: font, fontSize: fontSize, fontWeight: fontWeight);
  }

  static Future<void> exporterListeRougePDF(List<Map<String, dynamic>> etudiants, {Uint8List? signature}) async {
    final pdf = pw.Document();
    final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    
    final regularStyle = await _getSafeStyle(fontSize: 10);
    final boldStyle = await _getSafeStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final headerStyle = await _getSafeStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);

    // Chargement du logo
    final logoData = await rootBundle.load('assets/images/logo_uin.png');
    final logoImg = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // En-tête avec Logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImg, width: 60, height: 60),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('UNIVERSITE ISLAMIQUE AU NIGER',
                        style: boldStyle.copyWith(fontSize: 14)),
                    pw.Text('FACULTE DES SCIENCES ET TECHNIQUES',
                        style: regularStyle.copyWith(fontSize: 12)),
                  ],
                ),
                pw.SizedBox(width: 60), // Equilibre
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text('LISTE ROUGE - SESSION DE RATTRAPAGE', 
                    style: headerStyle.copyWith(color: PdfColors.red900)),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text('Date d\'exportation : $date', style: regularStyle),
            pw.SizedBox(height: 10),
            pw.Text(
              'Les étudiants listés ci-dessous ont dépassé le seuil de 3 absences non justifiées et sont par conséquent transférés en session de rattrapage.',
              style: regularStyle.copyWith(fontStyle: pw.FontStyle.italic),
            ),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['ID', 'Prénom', 'Nom', 'Absences NJ'],
              data: etudiants.map((e) => [
                e['id'].toString(),
                e['prenom'].toString(),
                e['nom'].toString(),
                e['absences'].toString(),
              ]).toList(),
              headerStyle: boldStyle.copyWith(color: PdfColors.white),
              cellStyle: regularStyle,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.red900),
              cellAlignment: pw.Alignment.centerLeft,
              cellAlignments: {3: pw.Alignment.center},
            ),
            pw.Padding(
              padding: const pw.EdgeInsets.only(top: 40),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Column(
                    children: [
                      pw.Text('Le Chef de Département', style: boldStyle),
                      pw.SizedBox(height: 10),
                      if (signature != null) 
                        pw.Image(pw.MemoryImage(signature), width: 100, height: 50),
                      pw.SizedBox(height: 10),
                      pw.Text('__________________________', style: regularStyle),
                      pw.Text('(Signature et Cachet)', style: regularStyle),
                    ],
                  ),
                ],
              ),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'liste_rouge_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<void> exporterRapportPresencesPDF(List<Map<String, dynamic>> stats) async {
    final pdf = pw.Document();
    final date = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());
    
    final regularStyle = await _getSafeStyle(fontSize: 10);
    final boldStyle = await _getSafeStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final headerStyle = await _getSafeStyle(fontSize: 18, fontWeight: pw.FontWeight.bold);

    // Chargement du logo
    final logoData = await rootBundle.load('assets/images/logo_uin.png');
    final logoImg = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            // En-tête avec Logo
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImg, width: 60, height: 60),
                pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.center,
                  children: [
                    pw.Text('UNIVERSITE ISLAMIQUE AU NIGER',
                        style: boldStyle.copyWith(fontSize: 14)),
                    pw.Text('FACULTE DES SCIENCES ET TECHNIQUES',
                        style: regularStyle.copyWith(fontSize: 12)),
                  ],
                ),
                pw.SizedBox(width: 60), // Equilibre
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Header(
              level: 0,
              child: pw.Center(
                child: pw.Text('RAPPORT DE PRÉSENCES PAR MATIÈRE', 
                  style: headerStyle.copyWith(color: PdfColors.green900)),
              ),
            ),
            pw.SizedBox(height: 10),
            pw.Text('Date : $date', style: regularStyle),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Matière', 'Séances', 'Taux de Présence'],
              data: stats.map((s) => [
                s['matiere'].toString(),
                s['totalSeances'].toString(),
                '${s['tauxPresence']}%',
              ]).toList(),
              headerStyle: boldStyle.copyWith(color: PdfColors.white),
              cellStyle: regularStyle,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
      name: 'rapport_presences_${DateTime.now().millisecondsSinceEpoch}.pdf',
    );
  }

  static Future<void> exporterEtatVacationPDF(List<Map<String, dynamic>> vacations, {Uint8List? signatureChef, Uint8List? signatureDoyen}) async {
    final pdf = pw.Document();
    
    final regularStyle = await _getSafeStyle(fontSize: 10);
    final boldStyle = await _getSafeStyle(fontSize: 10, fontWeight: pw.FontWeight.bold);
    final headerStyle = await _getSafeStyle(fontSize: 16, fontWeight: pw.FontWeight.bold);

    final logoData = await rootBundle.load('assets/images/logo_uin.png');
    final logoImg = pw.MemoryImage(logoData.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.landscape,
        build: (pw.Context context) {
          return [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Image(logoImg, width: 50, height: 50),
                pw.Column(
                  children: [
                    pw.Text('UNIVERSITE ISLAMIQUE AU NIGER', style: boldStyle.copyWith(fontSize: 12)),
                    pw.Text('FACULTE DES SCIENCES ET TECHNIQUES', style: regularStyle.copyWith(fontSize: 10)),
                  ],
                ),
                pw.SizedBox(width: 50),
              ],
            ),
            pw.SizedBox(height: 20),
            pw.Header(level: 0, child: pw.Center(child: pw.Text('ÉTAT DE VACATION GÉNÉRAL', style: headerStyle))),
            pw.SizedBox(height: 20),
            pw.TableHelper.fromTextArray(
              headers: ['Enseignant', 'Matière', 'Volume Horaire', 'Taux/H', 'Total (GNF)'],
              data: vacations.map((v) => [
                v['enseignantNom'],
                v['matiere'],
                '${v['totalHeures']} h',
                '${v['tauxHoraire']} GNF',
                '${(v['totalHeures'] as int) * (v['tauxHoraire'] as int)} GNF',
              ]).toList(),
              headerStyle: boldStyle.copyWith(color: PdfColors.white),
              cellStyle: regularStyle,
              headerDecoration: const pw.BoxDecoration(color: PdfColors.green900),
            ),
            pw.Spacer(),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Column(
                  children: [
                    pw.Text('Le Chef de Département', style: boldStyle),
                    if (signatureChef != null) pw.Image(pw.MemoryImage(signatureChef), width: 80, height: 40),
                    pw.Text('____________________', style: regularStyle),
                  ],
                ),
                pw.Column(
                  children: [
                    pw.Text('Le Doyen de la FST', style: boldStyle),
                    if (signatureDoyen != null) pw.Image(pw.MemoryImage(signatureDoyen), width: 80, height: 40),
                    pw.Text('____________________', style: regularStyle),
                  ],
                ),
              ],
            ),
          ];
        },
      ),
    );

    await Printing.layoutPdf(onLayout: (PdfPageFormat format) async => pdf.save(), name: 'etat_vacation.pdf');
  }

  static Future<void> exporterEtatVacationExcel(List<Map<String, dynamic>> vacations) async {
    var excel = Excel.createExcel();
    Sheet sheetObject = excel['Etat de Vacation'];
    excel.delete('Sheet1');

    CellStyle headerStyle = CellStyle(
      backgroundColorHex: ExcelColor.fromHexString('#00855A'),
      fontColorHex: ExcelColor.fromHexString('#FFFFFF'),
      bold: true,
      horizontalAlign: HorizontalAlign.Center,
    );

    var headers = ['Enseignant', 'Matière', 'Heures', 'Taux/H', 'Total (GNF)'];
    for (var i = 0; i < headers.length; i++) {
      var cell = sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
      cell.value = TextCellValue(headers[i]);
      cell.cellStyle = headerStyle;
    }

    for (var i = 0; i < vacations.length; i++) {
      var v = vacations[i];
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 0, rowIndex: i + 1)).value = TextCellValue(v['enseignantNom'].toString());
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 1, rowIndex: i + 1)).value = TextCellValue(v['matiere'].toString());
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 2, rowIndex: i + 1)).value = IntCellValue(v['totalHeures'] as int);
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 3, rowIndex: i + 1)).value = IntCellValue(v['tauxHoraire'] as int);
      sheetObject.cell(CellIndex.indexByColumnRow(columnIndex: 4, rowIndex: i + 1)).value = IntCellValue((v['totalHeures'] as int) * (v['tauxHoraire'] as int));
    }

    final String fileName = "etat_vacation_${DateTime.now().millisecondsSinceEpoch}.xlsx";
    
    final bytes = excel.save();
    if (bytes != null) {
      final directory = await getTemporaryDirectory();
      final file = File('${directory.path}/$fileName');
      await file.writeAsBytes(bytes);
      
      await Share.shareXFiles([XFile(file.path)], text: 'État de Vacation FST-UIN');
    }
  }
}
