import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../controllers/auth_controller.dart';

class FichePointageScreen extends StatefulWidget {
  final Map<String, dynamic> cours;
  FichePointageScreen({required this.cours});

  @override
  _FichePointageScreenState createState() => _FichePointageScreenState();
}

class _FichePointageScreenState extends State<FichePointageScreen> {
  final AuthController _authController = Get.find<AuthController>();
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
      return '';
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
    const moisList = ['Janvier', 'Fevrier', 'Mars', 'Avril', 'Mai', 'Juin',
      'Juillet', 'Aout', 'Septembre', 'Octobre', 'Novembre', 'Decembre'];
    return moisList[mois - 1];
  }

  int _calculerNbHeures(String heureDebut, String heureFin) {
    try {
      final debut = int.parse(heureDebut.replaceAll('h', '').split(':')[0]);
      final fin = int.parse(heureFin.replaceAll('h', '').split(':')[0]);
      return fin - debut;
    } catch (e) {
      return 0;
    }
  }

  void _soumettre() async {
    setState(() {
      _contenuVide = _contenuController.text.trim().isEmpty;
      _signatureVide = _signatureController.isEmpty;
    });

    if (_contenuVide || _signatureVide) return;

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

    await Future.delayed(Duration(seconds: 2));
    Get.back();

    Get.snackbar(
      'Succes !',
      'Fiche de pointage soumise avec succes',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Color(0xFF00855A),
      colorText: Colors.white,
      duration: Duration(seconds: 3),
      icon: Icon(Icons.check_circle, color: Colors.white),
    );

    await Future.delayed(Duration(milliseconds: 500));
    Get.back();
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
        cours['heureDebut'] ?? '', cours['heureFin'] ?? '');
    final maintenant = DateTime.now();

    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text('Fiche de Pointage',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ===== EN-TETE AVEC GRADIENT =====
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(vertical: 24, horizontal: 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                children: [
                  // Logo
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 15,
                          offset: Offset(0, 5),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Padding(
                        padding: EdgeInsets.all(8),
                        child: Image.asset(
                          'assets/images/logo_uin.png',
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text('UNIVERSITE ISLAMIQUE AU NIGER',
                      style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          letterSpacing: 0.5),
                      textAlign: TextAlign.center),
                  SizedBox(height: 4),
                  Text('FACULTE DES SCIENCES ET TECHNIQUES',
                      style: TextStyle(color: Colors.white70, fontSize: 11),
                      textAlign: TextAlign.center),
                  Text('ORGANISATION DE LA COOPERATION ISLAMIQUE',
                      style: TextStyle(color: Colors.white60, fontSize: 10),
                      textAlign: TextAlign.center),
                  SizedBox(height: 16),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Text('FICHE DE POINTAGE',
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
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // ===== INFOS GENERALES =====
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
                        // Titre section
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
                              Icon(Icons.info_outline,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Informations generales',
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
                              _buildInfoRow(Icons.calendar_today,
                                  'Annee academique', '2025-2026'),
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
                              _buildInfoRow(Icons.workspace_premium,
                                  'Programme', 'Bachelor'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ===== SEANCE =====
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
                              Icon(Icons.event_note,
                                  color: Color(0xFF00855A), size: 18),
                              SizedBox(width: 8),
                              Text('Detail de la seance',
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
                              // Infos seance
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.calendar_today,
                                      'Jour',
                                      _getNomJour(cours['dateSeance'] ??
                                          maintenant.toString()),
                                      Colors.blue,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.date_range,
                                      'Date',
                                      _formaterDate(cours['dateSeance'] ??
                                          maintenant.toString()),
                                      Colors.purple,
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.access_time,
                                      'Horaire',
                                      '${cours['heureDebut'] ?? ''} - ${cours['heureFin'] ?? ''}',
                                      Colors.orange,
                                    ),
                                  ),
                                  SizedBox(width: 12),
                                  Expanded(
                                    child: _buildSeanceInfo(
                                      Icons.timer,
                                      'Duree',
                                      '${nbHeures}h00',
                                      Color(0xFF00855A),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),

                              // Contenu du cours
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text('Contenu du cours',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14,
                                        color: Color(0xFF003D29))),
                              ),
                              SizedBox(height: 8),
                              TextField(
                                controller: _contenuController,
                                maxLines: 5,
                                decoration: InputDecoration(
                                  hintText:
                                  'Decrivez les grandes lignes du cours dispense...',
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
                                  errorText:
                                  _contenuVide ? 'Champ obligatoire' : null,
                                  errorBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(12),
                                    borderSide: BorderSide(color: Colors.red),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 16),

                  // ===== SIGNATURE =====
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
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
                                icon: Icon(Icons.refresh,
                                    color: Colors.red, size: 16),
                                label: Text('Effacer',
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 12)),
                                style: TextButton.styleFrom(
                                    padding: EdgeInsets.zero),
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.all(16),
                          child: Column(
                            children: [
                              if (_signatureVide)
                                Container(
                                  padding: EdgeInsets.all(8),
                                  margin: EdgeInsets.only(bottom: 8),
                                  decoration: BoxDecoration(
                                    color: Colors.red[50],
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: Colors.red[200]!),
                                  ),
                                  child: Row(
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
                                  color: Color(0xFFF5FAF7),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                      color: Colors.grey[200]!, width: 1),
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(12),
                                  child: Signature(
                                    controller: _signatureController,
                                    height: 180,
                                    backgroundColor: Color(0xFFF5FAF7),
                                  ),
                                ),
                              ),
                              SizedBox(height: 8),
                              Row(
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

                  SizedBox(height: 16),

                  // ===== VALIDATION =====
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
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Expanded(
                                child: _buildValidationBox(
                                    'LE SUPERVISEUR', Icons.manage_accounts),
                              ),
                              SizedBox(width: 16),
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

                  SizedBox(height: 24),

                  // ===== BOUTON SOUMETTRE =====
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
                      label: Text('Soumettre la fiche',
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

                  SizedBox(height: 32),
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
      padding: EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Color(0xFF00855A).withOpacity(0.08),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Color(0xFF00855A), size: 16),
          ),
          SizedBox(width: 12),
          SizedBox(
            width: 130,
            child: Text('$label :',
                style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ),
          Expanded(
            child: Text(valeur,
                style: TextStyle(
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
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: couleur.withOpacity(0.08),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: couleur.withOpacity(0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: couleur, size: 14),
              SizedBox(width: 4),
              Text(label,
                  style: TextStyle(color: couleur, fontSize: 11,
                      fontWeight: FontWeight.w500)),
            ],
          ),
          SizedBox(height: 4),
          Text(valeur,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Color(0xFF003D29))),
        ],
      ),
    );
  }

  Widget _buildValidationBox(String titre, IconData icon) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.orange, size: 28),
          SizedBox(height: 8),
          Text(titre,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 11,
                  color: Colors.grey[700]),
              textAlign: TextAlign.center),
          SizedBox(height: 8),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text('En attente',
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