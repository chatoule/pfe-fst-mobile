import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

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

  // Fichiers joints
  List<Map<String, dynamic>> _fichierJoints = [];

  final List<String> _types = [
    'Certificat medical',
    'Convocation officielle',
    'Deces dans la famille',
    'Autre',
  ];

  final ImagePicker _imagePicker = ImagePicker();

  // ===== CHOISIR UN PDF =====
  Future<void> _choisirPDF() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        allowMultiple: false,
      );

      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        setState(() {
          _fichierJoints.add({
            'nom': file.name,
            'chemin': file.path ?? '',
            'taille': _formaterTaille(file.size),
            'type': 'PDF',
            'icon': Icons.picture_as_pdf,
            'couleur': Colors.red,
          });
        });
        Get.snackbar('Succes', '${file.name} ajoute',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xFF00855A),
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de choisir le fichier',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // ===== CHOISIR UNE IMAGE DEPUIS LA GALERIE =====
  Future<void> _choisirImage() async {
    try {
      final XFile? image = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70,
      );

      if (image != null) {
        final file = File(image.path);
        final taille = await file.length();
        setState(() {
          _fichierJoints.add({
            'nom': image.name,
            'chemin': image.path,
            'taille': _formaterTaille(taille),
            'type': 'IMAGE',
            'icon': Icons.image,
            'couleur': Colors.blue,
          });
        });
        Get.snackbar('Succes', '${image.name} ajoute',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xFF00855A),
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de choisir l\'image',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  // ===== PRENDRE UNE PHOTO =====
  Future<void> _prendrePhoto() async {
    try {
      final XFile? photo = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 70,
      );

      if (photo != null) {
        final file = File(photo.path);
        final taille = await file.length();
        setState(() {
          _fichierJoints.add({
            'nom': photo.name,
            'chemin': photo.path,
            'taille': _formaterTaille(taille),
            'type': 'PHOTO',
            'icon': Icons.camera_alt,
            'couleur': Colors.green,
          });
        });
        Get.snackbar('Succes', 'Photo ajoutee',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Color(0xFF00855A),
            colorText: Colors.white);
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Impossible de prendre la photo',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  String _formaterTaille(int octets) {
    if (octets < 1024) return '$octets B';
    if (octets < 1024 * 1024) return '${(octets / 1024).toStringAsFixed(1)} KB';
    return '${(octets / (1024 * 1024)).toStringAsFixed(1)} MB';
  }

  void _supprimerFichier(int index) {
    setState(() => _fichierJoints.removeAt(index));
  }

  void _showOptionsJoindre() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => Container(
        padding: EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(height: 20),
            Text('Joindre un fichier',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D29))),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildOptionJoindre(
                  icon: Icons.picture_as_pdf,
                  label: 'PDF / DOC',
                  couleur: Colors.red,
                  onTap: () {
                    Navigator.pop(context);
                    _choisirPDF();
                  },
                ),
                _buildOptionJoindre(
                  icon: Icons.photo_library,
                  label: 'Galerie',
                  couleur: Colors.blue,
                  onTap: () {
                    Navigator.pop(context);
                    _choisirImage();
                  },
                ),
                _buildOptionJoindre(
                  icon: Icons.camera_alt,
                  label: 'Camera',
                  couleur: Color(0xFF00855A),
                  onTap: () {
                    Navigator.pop(context);
                    _prendrePhoto();
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildOptionJoindre({
    required IconData icon,
    required String label,
    required Color couleur,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: couleur.withOpacity(0.1),
              shape: BoxShape.circle,
              border: Border.all(color: couleur.withOpacity(0.3)),
            ),
            child: Icon(icon, color: couleur, size: 28),
          ),
          SizedBox(height: 8),
          Text(label,
              style: TextStyle(
                  color: Color(0xFF003D29),
                  fontSize: 13,
                  fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }

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
                    child: Icon(Icons.upload_file, color: Colors.white, size: 22),
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
                  _buildSection(
                    icon: Icons.category_outlined,
                    titre: 'Type de justificatif *',
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
                      padding: EdgeInsets.only(bottom: 8),
                      child: Row(
                        children: [
                          Icon(Icons.error_outline, color: Colors.red, size: 14),
                          SizedBox(width: 4),
                          Text('Veuillez selectionner un type',
                              style: TextStyle(color: Colors.red, fontSize: 12)),
                        ],
                      ),
                    ),

                  SizedBox(height: 16),

                  // ===== MOTIF =====
                  _buildSection(
                    icon: Icons.edit_note_outlined,
                    titre: 'Motif de l\'absence *',
                    child: TextField(
                      controller: _motifController,
                      maxLines: 4,
                      onChanged: (value) {
                        if (value.isNotEmpty) {
                          setState(() => _motifErreur = false);
                        }
                      },
                      decoration: InputDecoration(
                        hintText: 'Expliquez en detail la raison...',
                        hintStyle:
                        TextStyle(color: Colors.grey[400], fontSize: 13),
                        filled: true,
                        fillColor: Color(0xFFF5FAF7),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide:
                          BorderSide(color: Color(0xFF00855A), width: 2),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(
                            color: _motifErreur
                                ? Colors.red
                                : Colors.grey[200]!,
                          ),
                        ),
                        errorText:
                        _motifErreur ? 'Ce champ est obligatoire' : null,
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  // ===== FICHIERS JOINTS =====
                  _buildSection(
                    icon: Icons.attach_file,
                    titre: 'Fichiers joints (optionnel)',
                    child: Column(
                      children: [
                        // Liste des fichiers ajoutés
                        if (_fichierJoints.isNotEmpty) ...[
                          ..._fichierJoints.asMap().entries.map((entry) {
                            final index = entry.key;
                            final fichier = entry.value;
                            return Container(
                              margin: EdgeInsets.only(bottom: 8),
                              padding: EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: (fichier['couleur'] as Color)
                                    .withOpacity(0.05),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(
                                  color: (fichier['couleur'] as Color)
                                      .withOpacity(0.2),
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: (fichier['couleur'] as Color)
                                          .withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      fichier['icon'] as IconData,
                                      color: fichier['couleur'] as Color,
                                      size: 20,
                                    ),
                                  ),
                                  SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          fichier['nom'],
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                              color: Color(0xFF003D29)),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        Text(
                                          '${fichier['type']} • ${fichier['taille']}',
                                          style: TextStyle(
                                              color: Colors.grey, fontSize: 11),
                                        ),
                                      ],
                                    ),
                                  ),
                                  // Aperçu image
                                  if (fichier['type'] == 'IMAGE' ||
                                      fichier['type'] == 'PHOTO')
                                    Container(
                                      width: 40,
                                      height: 40,
                                      margin: EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(8),
                                        image: DecorationImage(
                                          image: FileImage(
                                              File(fichier['chemin'])),
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.close,
                                        color: Colors.red, size: 18),
                                    onPressed: () => _supprimerFichier(index),
                                    padding: EdgeInsets.zero,
                                    constraints: BoxConstraints(),
                                  ),
                                ],
                              ),
                            );
                          }).toList(),
                          SizedBox(height: 8),
                        ],

                        // Bouton joindre
                        GestureDetector(
                          onTap: _showOptionsJoindre,
                          child: Container(
                            width: double.infinity,
                            padding: EdgeInsets.symmetric(vertical: 14),
                            decoration: BoxDecoration(
                              color: Color(0xFFF5FAF7),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Color(0xFF00855A).withOpacity(0.3),
                                style: BorderStyle.solid,
                              ),
                            ),
                            child: Column(
                              children: [
                                Icon(Icons.add_circle_outline,
                                    color: Color(0xFF00855A), size: 28),
                                SizedBox(height: 6),
                                Text('Joindre un fichier',
                                    style: TextStyle(
                                        color: Color(0xFF00855A),
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14)),
                                SizedBox(height: 2),
                                Text('PDF, DOC, Image ou Photo',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11)),
                              ],
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

  Widget _buildSection({
    required IconData icon,
    required String titre,
    required Widget child,
  }) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 4),
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
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: Color(0xFF00855A).withOpacity(0.08),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(16),
                topRight: Radius.circular(16),
              ),
            ),
            child: Row(
              children: [
                Icon(icon, color: Color(0xFF00855A), size: 18),
                SizedBox(width: 8),
                Text(titre,
                    style: TextStyle(
                        color: Color(0xFF00855A),
                        fontWeight: FontWeight.bold,
                        fontSize: 14)),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: child,
          ),
        ],
      ),
    );
  }
}