import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:signature/signature.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shared_controller.dart';
import '../../controllers/pointage_controller.dart';

class FichePointageScreen extends StatefulWidget {
  final Map<String, dynamic> cours;
  const FichePointageScreen({super.key, required this.cours});

  @override
  State<FichePointageScreen> createState() => _FichePointageScreenState();
}

class _FichePointageScreenState extends State<FichePointageScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final SharedController _sharedController = Get.find<SharedController>();
  final TextEditingController _contenuController = TextEditingController();
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
    exportBackgroundColor: Colors.white,
  );

  bool _signatureVide = false;
  bool _contenuVide = false;

  String _getNomJour(String date) {
    try {
      final d = DateTime.parse(date);
      const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi',
        'Vendredi', 'Samedi', 'Dimanche'];
      return jours[d.weekday - 1];
    } catch (e) {
      return 'Inconnu';
    }
  }

  String _formaterDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
    } catch (e) {
      return date;
    }
  }

  String _getMois(int mois) {
    const moisList = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    return moisList[mois - 1];
  }

  int _calculerNbHeures(String heureDebut, String heureFin) {
    try {
      final h1 = int.parse(heureDebut.split('h')[0]);
      final h2 = int.parse(heureFin.split('h')[0]);
      return h2 - h1;
    } catch (e) {
      return 2;
    }
  }

  void _soumettre() async {
    setState(() {
      _contenuVide = _contenuController.text.trim().isEmpty;
      _signatureVide = _signatureController.isEmpty;
    });

    if (_contenuVide || _signatureVide) {
      Get.snackbar(
        'Champs manquants',
        'Veuillez remplir le contenu et signer.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Center(
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: const Column(
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

    // Capture de la signature
    final signatureBytes = await _signatureController.toPngBytes();
    
    final user = _authController.utilisateur.value;
    final fiche = {
      'enseignantId': user?.id ?? 0,
      'enseignantNom': '${user?.prenom} ${user?.nom}',
      'matiere': widget.cours['matiere'],
      'dateSeance': widget.cours['dateSeance'] ?? DateTime.now().toString().split(' ')[0],
      'heureDebut': widget.cours['heureDebut'] ?? '08h00',
      'heureFin': widget.cours['heureFin'] ?? '10h00',
      'duree': _calculerNbHeures(widget.cours['heureDebut'] ?? '08h00', widget.cours['heureFin'] ?? '10h00') * 60,
      'contenu': _contenuController.text,
      'niveau': widget.cours['niveau'] ?? 'L3',
      'signatureEnseignant': signatureBytes,
    };

    _sharedController.soumettreFiche(fiche);

    // Mettre à jour le statut du cours dans le planning
    if (widget.cours['id'] != null) {
      Get.find<PointageController>().pointerCours(widget.cours['id']);
    }

    Get.back(); // Retourne à l'écran précédent (Dashboard)

    Get.snackbar(
      'Fiche Soumise !',
      'Votre fiche est en attente de confirmation par le Superviseur et de validation par le Chef de Département.',
      snackPosition: SnackPosition.TOP, // Changé en TOP pour être plus visible sur le Dashboard
      backgroundColor: const Color(0xFF00855A),
      colorText: Colors.white,
      duration: const Duration(seconds: 4),
      icon: const Icon(Icons.send_rounded, color: Colors.white),
    );
  }

  @override
  void dispose() {
    _signatureController.dispose();
    _contenuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user = _authController.utilisateur.value;
    final cours = widget.cours;
    final nbHeures = _calculerNbHeures(
        cours['heureDebut'] ?? '08h00', cours['heureFin'] ?? '10h00');
    final maintenant = DateTime.now();

    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Fiche de Pointage',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.2),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: const EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/logo_uin.png',
                          fit: BoxFit.contain,
                          errorBuilder: (_, __, ___) => const Icon(Icons.school, size: 40, color: Color(0xFF00855A)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text('UNIVERSITE ISLAMIQUE AU NIGER',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 4),
                  const Text('FACULTE DES SCIENCES ET TECHNIQUES',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      textAlign: TextAlign.center),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: const Text('FICHE DE POINTAGE',
                        style: TextStyle(
                            color: Color(0xFF00855A),
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            letterSpacing: 1)),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Container(
                    width: double.infinity,
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00855A).withValues(alpha: 0.08),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.info_outline,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Informations générales',
                                  style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              _buildInfoRow(Icons.calendar_today,
                                  'Année académique', '2025-2026'),
                              _buildInfoRow(Icons.layers,
                                  'Semestre', cours['semestre'] ?? 'S1'),
                              _buildInfoRow(Icons.date_range,
                                  'Mois', _getMois(maintenant.month)),
                              _buildInfoRow(Icons.person,
                                  'Enseignant',
                                  '${user?.prenom ?? ""} ${user?.nom ?? ""}'),
                              _buildInfoRow(Icons.book,
                                  'Module', cours['matiere'] ?? ''),
                              _buildInfoRow(Icons.school,
                                  'Niveau', cours['niveau'] ?? 'L3'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00855A).withValues(alpha: 0.08),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.event_note,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Détail de la séance',
                                  style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.calendar_today,
                                      'Jour',
                                      _getNomJour(cours['dateSeance'] ??
                                          maintenant.toString().split(' ')[0]),
                                      Colors.blue,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.date_range,
                                      'Date',
                                      _formaterDate(cours['dateSeance'] ??
                                          maintenant.toString().split(' ')[0]),
                                      Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.access_time,
                                      'Horaire',
                                      '${cours['heureDebut'] ?? '08h00'} - ${cours['heureFin'] ?? '10h00'}',
                                      Colors.orange,
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.timer,
                                      'Durée',
                                      '${nbHeures}h00',
                                      const Color(0xFF00855A),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Contenu du cours',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF003D29))),
                              ),
                              const SizedBox(height: 8),
                              TextField(
                                controller: _contenuController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText:
                                  'Décrivez les grandes lignes du cours dispensé...',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 13),
                                  filled: true,
                                  fillColor: const Color(0xFFF5FAF7),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide.none,
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(
                                        color: Color(0xFF00855A), width: 2),
                                  ),
                                  errorText:
                                  _contenuVide ? 'Champ obligatoire' : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: const BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: _signatureVide
                            ? Colors.red
                            : Colors.transparent,
                        width: 1.5,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.06),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00855A).withValues(alpha: 0.08),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Row(
                                children: [
                                  Icon(Icons.draw_outlined,
                                      color: Color(0xFF00855A), size: 18),
                                  SizedBox(width: 8),
                                  Text('Signature de l\'enseignant',
                                      style: TextStyle(
                                          color: Color(0xFF00855A),
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14)),
                                ],
                              ),
                              TextButton.icon(
                                onPressed: () {
                                  _signatureController.clear();
                                  setState(() => _signatureVide = false);
                                },
                                icon: const Icon(Icons.refresh,
                                    color: Colors.red, size: 16),
                                label: const Text('Effacer',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            children: [
                              if (_signatureVide)
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  margin: const EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.error_outline,
                                          color: Colors.red, size: 16),
                                      SizedBox(width: 8),
                                      Text('Veuillez signer avant de soumettre',
                                          style: TextStyle(
                                              color: Colors.red, fontSize: 12)),
                                    ],
                                  ),
                                ),
                              Container(
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF5FAF7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Signature(
                                    controller: _signatureController,
                                    height: 180,
                                    backgroundColor: const Color(0xFFF5FAF7),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.touch_app,
                                      color: Colors.grey, size: 14),
                                  SizedBox(width: 4),
                                  Text(
                                    'Signez avec votre doigt dans le cadre',
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 11),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    width: double.infinity,
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
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF00855A).withValues(alpha: 0.08),
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(16),
                              topRight: Radius.circular(16),
                            ),
                          ),
                          child: const Row(
                            children: [
                              Icon(Icons.verified_outlined,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Validation',
                                  style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildValidationBox(
                                    'LE SUPERVISEUR', Icons.manage_accounts),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: _buildValidationBox(
                                    'CHEF DEPARTEMENT', Icons.supervisor_account),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  Container(
                    width: double.infinity,
                    height: 56,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF00A86B), Color(0xFF00855A)],
                      ),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF00855A).withValues(alpha: 0.4),
                          blurRadius: 15,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: ElevatedButton.icon(
                      onPressed: _soumettre,
                      icon: const Icon(Icons.send_rounded, color: Colors.white),
                      label: const Text('Soumettre la fiche',
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16)),
                      ),
                    ),
                  ),

                  const SizedBox(height: 32),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String valeur) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFF00855A).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: const Color(0xFF00855A), size: 16),
          ),
          const SizedBox(width: 12),
          SizedBox(
            width: 130,
            child: Text('$label :',
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
          Expanded(
            child: Text(valeur,
                style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: Color(0xFF003D29))),
          ),
        ],
      ),
    );
  }

  Widget _buildSeanceInfo(
      IconData icon, String label, String valeur, Color couleur) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: couleur, size: 14),
              const SizedBox(width: 4),
              Text(label,
                  style: TextStyle(color: couleur, fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          const SizedBox(height: 4),
          Text(valeur,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF003D29))),
        ],
      ),
    );
  }

  Widget _buildValidationBox(String titre, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withValues(alpha: 0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          const SizedBox(height: 8),
          Text(titre,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey[700]),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.3)),
            ),
            child: const Text('En attente',
                style: TextStyle(
                    color: Colors.orange,
                    fontSize: 10,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}
