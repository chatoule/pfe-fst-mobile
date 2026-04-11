import 'package:flutter/material.dart';
import 'package:get/get.dart';

class JustificatifScreen extends StatefulWidget {
  final int presenceId;
  JustificatifScreen({required this.presenceId});

  @override
  _JustificatifScreenState createState() => _JustificatifScreenState();
}

class _JustificatifScreenState extends State<JustificatifScreen> {
  final TextEditingController _motifController = TextEditingController();
  String? _typeSelectionne;
  bool _typeErreur = false;
  bool _motifErreur = false;

  final List<String> _types = [
    'Certificat medical',
    'Convocation officielle',
    'Deces dans la famille',
    'Autre',
  ];

  void _soumettre() {
    setState(() {
      _typeErreur = _typeSelectionne == null;
      _motifErreur = _motifController.text.trim().isEmpty;
    });

    if (_typeErreur || _motifErreur) {
      Get.snackbar(
        'Champs manquants',
        'Veuillez remplir tous les champs obligatoires',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        icon: Icon(Icons.error_outline, color: Colors.white),
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Color(0xFF00855A)),
              SizedBox(height: 16),
              Text('Envoi en cours...'),
            ],
          ),
        ),
      ),
    );

    Future.delayed(Duration(seconds: 2), () {
      Get.back();
      Get.snackbar(
        'Succes !',
        'Justificatif soumis avec succes',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Color(0xFF00855A),
        colorText: Colors.white,
        icon: Icon(Icons.check_circle, color: Colors.white),
      );
      Get.back();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Soumettre un justificatif',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
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
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(Icons.upload_file,
                        color: Colors.white, size: 22),
                  ),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'Soumettez un justificatif pour votre absence. Il sera examine par le chef de departement.',
                      style: TextStyle(color: Colors.white, fontSize: 13),
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ===== TYPE =====
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
                              Icon(Icons.category_outlined,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Type de justificatif *',
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
                            children: _types.map((type) {
                              final isSelected = _typeSelectionne == type;
                              return GestureDetector(
                                onTap: () => setState(() {
                                  _typeSelectionne = type;
                                  _typeErreur = false;
                                }),
                                child: Container(
                                  margin: EdgeInsets.only(bottom: 8),
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 12),
                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? Color(0xFF00855A).withOpacity(0.08)
                                        : Color(0xFFF5F7FA),
                                    borderRadius: BorderRadius.circular(10),
                                    border: Border.all(
                                      color: isSelected
                                          ? Color(0xFF00855A)
                                          : _typeErreur
                                          ? Colors.red.withOpacity(0.5)
                                          : Colors.grey[200]!,
                                      width: isSelected ? 1.5 : 1,
                                    ),
                                  ),
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          border: Border.all(
                                            color: isSelected
                                                ? Color(0xFF00855A)
                                                : Colors.grey[400]!,
                                            width: 2,
                                          ),
                                          color: isSelected
                                              ? Color(0xFF00855A)
                                              : Colors.transparent,
                                        ),
                                        child: isSelected
                                            ? Icon(Icons.check,
                                            color: Colors.white, size: 12)
                                            : null,
                                      ),
                                      SizedBox(width: 12),
                                      Text(type,
                                          style: TextStyle(
                                              color: isSelected
                                                  ? Color(0xFF00855A)
                                                  : Color(0xFF003D29),
                                              fontWeight: isSelected
                                                  ? FontWeight.bold
                                                  : FontWeight.normal,
                                              fontSize: 14)),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                        if (_typeErreur)
                          Padding(
                            padding: EdgeInsets.only(
                                left: 16, right: 16, bottom: 12),
                            child: Row(
                              children: [
                                Icon(Icons.error_outline,
                                    color: Colors.red, size: 14),
                                SizedBox(width: 4),
                                Text('Veuillez selectionner un type',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                              ],
                            ),
                          ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ===== MOTIF =====
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
                              Icon(Icons.edit_note_outlined,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Motif de l\'absence *',
                                  style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: TextField(
                            controller: _motifController,
                            maxLines: 5,
                            onChanged: (value) {
                              if (value.isNotEmpty) {
                                setState(() => _motifErreur = false);
                              }
                            },
                            decoration: InputDecoration(
                              hintText:
                              'Expliquez en detail la raison de votre absence...',
                              hintStyle: TextStyle(
                                  color: Colors.grey[400], fontSize: 13),
                              filled: true,
                              fillColor: Color(0xFFF5FAF7),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide.none,
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                    color: Color(0xFF00855A), width: 2),
                              ),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(color: Colors.red),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12),
                                borderSide: BorderSide(
                                  color: _motifErreur
                                      ? Colors.red
                                      : Colors.grey[200]!,
                                ),
                              ),
                              errorText: _motifErreur
                                  ? 'Ce champ est obligatoire'
                                  : null,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 24),

                  // Bouton soumettre
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
                      onPressed: _soumettre,
                      icon: Icon(Icons.send_rounded, color: Colors.white),
                      label: Text('Soumettre le justificatif',
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
}