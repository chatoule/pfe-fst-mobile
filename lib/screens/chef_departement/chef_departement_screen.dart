import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:signature/signature.dart';
import '../../controllers/auth_controller.dart';
import 'validation_seances_screen.dart';
import 'etat_vacation_screen.dart';
import '../../controllers/shared_controller.dart';
import '../../services/export_service.dart';

class ChefDepartementScreen extends StatefulWidget {
  const ChefDepartementScreen({super.key});

  @override
  State<ChefDepartementScreen> createState() => _ChefDepartementScreenState();
}

class _ChefDepartementScreenState extends State<ChefDepartementScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final SharedController _sharedController = Get.find<SharedController>();
  int _currentIndex = 0;
  bool _isExportingExcel = false;
  bool _isExportingPDF = false;
  
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 3,
    penColor: Colors.black,
    exportBackgroundColor: Colors.transparent,
  );
  bool _hasSigned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_getTitre(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A86B), Color(0xFF003D29)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final user = _authController.utilisateur.value;
                    return Center(
                      child: Text(
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'C',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Obx(() => Text(
                  '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 4),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('CHEF DEPARTEMENT',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  _authController.utilisateur.value?.email ?? '',
                  style: const TextStyle(color: Colors.white70, fontSize: 11),
                )),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Tableau de bord'),
                _buildDrawerItem(1, Icons.people_outline, 'Suivi Presences'),
                _buildDrawerItem(8, Icons.person_add_outlined, 'Gestion Utilisateurs'),
                _buildDrawerItem(2, Icons.check_circle_outline, 'Valider Pointages'),
                _buildDrawerItem(6, Icons.description_outlined, 'Justificatifs'),
                _buildDrawerItem(7, Icons.gavel_outlined, 'Liste Rouge (Session)'),
                _buildDrawerItem(3, Icons.bar_chart_outlined, 'Rapports'),
                _buildDrawerItem(4, Icons.verified_outlined, 'Valider Seances'),
                _buildDrawerItem(5, Icons.payments_outlined, 'Etat de Vacation'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se deconnecter',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            onTap: () => _authController.logout(),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('FST - UIN v1.0',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF00855A).withValues(alpha: 0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? const Color(0xFF00855A) : Colors.grey[600], size: 22),
        title: Text(label,
            style: TextStyle(
                color: isActive ? const Color(0xFF00855A) : Colors.grey[800],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14)),
        onTap: () {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Tableau de bord';
      case 1: return 'Suivi Presences';
      case 2: return 'Valider Pointages';
      case 3: return 'Rapports';
      case 6: return 'Justificatifs Absences';
      case 7: return 'Liste Rouge - Session';
      case 8: return 'Gestion Utilisateurs';
      default: return 'Chef Departement';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildTableauBord();
      case 1: return _buildPresences();
      case 2: return _buildPointages();
      case 3: return _buildRapports();
      case 4: return ValidationSeancesScreen();
      case 5: return EtatVacationScreen();
      case 6: return _buildJustificatifsView();
      case 7: return _buildListeRouge();
      case 8: return _buildGestionUtilisateurs();
      default: return _buildTableauBord();
    }
  }

  // ===================== GESTION UTILISATEURS =====================
  Widget _buildGestionUtilisateurs() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Personnel Académique',
                      style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 18)),
                  Text('Inscrire et gérer les comptes',
                      style: TextStyle(color: Colors.white70, fontSize: 12)),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddUserDialog(context),
                icon: const Icon(Icons.person_add, size: 18),
                label: const Text('Inviter'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: const Color(0xFF00855A),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
        ),
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              _buildUserCategoryHeader('Enseignants'),
              _buildUserTile('Adamou Issaka Kodo', 'Enseignant', 'Telecom', 'Actif'),
              _buildUserTile('Dr. Moussa Ibrahim', 'Enseignant', 'Informatique', 'Actif'),
              _buildUserTile('Mme. Fatouma Zakari', 'Enseignant', 'Informatique', 'En attente', isPending: true),
              const SizedBox(height: 16),
              _buildUserCategoryHeader('Superviseurs'),
              _buildUserTile('Abdoulaye Soumana', 'Superviseur', 'FST', 'Actif'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildUserCategoryHeader(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Text(title,
          style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29), fontSize: 16)),
    );
  }

  Widget _buildUserTile(String name, String role, String dept, String status, {bool isPending = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 5)],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: isPending ? Colors.orange[50] : const Color(0xFF00855A).withValues(alpha: 0.1),
          child: Text(name[0], style: TextStyle(color: isPending ? Colors.orange : const Color(0xFF00855A), fontWeight: FontWeight.bold)),
        ),
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text('$role • $dept', style: const TextStyle(fontSize: 12)),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: isPending ? Colors.orange[50] : Colors.green[50],
            borderRadius: BorderRadius.circular(12),
          ),
          child: Text(status, style: TextStyle(color: isPending ? Colors.orange : Colors.green, fontSize: 10, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  void _showAddUserDialog(BuildContext context) {
    final emailController = TextEditingController();
    final nomController = TextEditingController();
    final prenomController = TextEditingController();
    String selectedRole = 'Enseignant';
    String selectedDept = 'Informatique';

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Inviter un utilisateur', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29))),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: prenomController,
              decoration: const InputDecoration(
                labelText: 'Prénom', 
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nomController,
              decoration: const InputDecoration(
                labelText: 'Nom', 
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(
                labelText: 'Email institutionnel', 
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            DropdownButtonFormField<String>(
              value: selectedRole,
              decoration: const InputDecoration(
                labelText: 'Rôle',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: ['Enseignant', 'Superviseur'].map((r) => DropdownMenuItem(value: r, child: Text(r))).toList(),
              onChanged: (v) => selectedRole = v!,
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<String>(
              isExpanded: true,
              value: selectedDept,
              decoration: const InputDecoration(
                labelText: 'Département',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              ),
              items: ['Informatique', 'Télécommunications'].map((d) => DropdownMenuItem(value: d, child: Text(d, overflow: TextOverflow.ellipsis))).toList(),
              onChanged: (v) => selectedDept = v!,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              Get.snackbar(
                'Invitation envoyée',
                'Un lien de confirmation a été envoyé à ${emailController.text}',
                backgroundColor: const Color(0xFF00855A),
                colorText: Colors.white,
                duration: const Duration(seconds: 4),
                icon: const Icon(Icons.send, color: Colors.white),
                snackPosition: SnackPosition.BOTTOM,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00855A)),
            child: const Text('Envoyer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _exporterListeRouge() async {
    Uint8List? signatureData;
    
    // Priorité à la signature du contrôleur (plus globale)
    if (_sharedController.signatureChefDep.value != null) {
      signatureData = _sharedController.signatureChefDep.value;
    } else if (_signatureController.isNotEmpty) {
      signatureData = await _signatureController.toPngBytes();
      // On la sauvegarde pour la session
      if (signatureData != null) {
        _sharedController.signerChefDep(signatureData);
      }
    }

    if (signatureData != null) {
      ExportService.exporterListeRougePDF(
        _sharedController.etudiantsEnSession, 
        signature: signatureData
      );
    } else {
      Get.snackbar(
        'Signature manquante',
        'Veuillez signer le document avant l\'exportation.',
        backgroundColor: Colors.orange,
        colorText: Colors.white
      );
    }
  }

  // ===================== LISTE ROUGE =====================
  Widget _buildListeRouge() {
    return Obx(() {
      final etudiantsSanctionnes = _sharedController.etudiantsEnSession;
      final bool hasGlobalSignature = _sharedController.signatureChefDep.value != null;

      return Column(
        children: [
          // En-tête Institutionnel
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFEEEEEE))),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo_uin.png', width: 45, height: 45),
                const SizedBox(width: 12),
                const Column(
                  children: [
                    Text('UNIVERSITE ISLAMIQUE AU NIGER',
                        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF003D29))),
                    Text('FACULTE DES SCIENCES ET TECHNIQUES',
                        style: TextStyle(fontSize: 11, color: Color(0xFF00855A))),
                  ],
                ),
              ],
            ),
          ),
          
          if (etudiantsSanctionnes.isEmpty)
            Expanded(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.sentiment_satisfied_alt, size: 60, color: Colors.green[200]),
                    const SizedBox(height: 16),
                    const Text('Aucun étudiant en session de rattrapage',
                        style: TextStyle(color: Colors.grey)),
                  ],
                ),
              ),
            )
          else ...[
            Container(
              padding: const EdgeInsets.all(16),
              color: Colors.red[900],
              child: const Row(
                children: [
                  Icon(Icons.warning_amber_rounded, color: Colors.white),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'LISTE ROUGE : Étudiants transférés en session de rattrapage',
                      style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: etudiantsSanctionnes.length,
                itemBuilder: (context, index) {
                  final e = etudiantsSanctionnes[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: Colors.red[100]!),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.red.withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: CircleAvatar(
                        backgroundColor: Colors.red[50],
                        child: Text(
                          '${e['prenom'][0]}${e['nom'][0]}',
                          style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
                        ),
                      ),
                      title: Text(
                        '${e['prenom']} ${e['nom']}',
                        style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red[900]),
                      ),
                      subtitle: Text('ID: ${e['id']} • Matricule: FST-2024-${e['id']}'),
                      trailing: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            '${e['absences']}',
                            style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                          ),
                          const Text('absences NJ', style: TextStyle(fontSize: 10, color: Colors.grey)),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            
            // Zone de Signature
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'Signature du Chef de Département :',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF003D29)),
              ),
            ),
            const SizedBox(height: 8),
            
            if (hasGlobalSignature) ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green[50],
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.green[200]!),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle, color: Colors.green),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Signé numériquement', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          Text('Utilisation de la signature enregistrée', style: TextStyle(color: Colors.green, fontSize: 10)),
                        ],
                      ),
                    ),
                    Image.memory(_sharedController.signatureChefDep.value!, height: 40, width: 80, fit: BoxFit.contain),
                    IconButton(
                      icon: const Icon(Icons.edit, color: Colors.grey, size: 20),
                      onPressed: () => _sharedController.signatureChefDep.value = null,
                    ),
                  ],
                ),
              ),
            ] else ...[
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey[300]!),
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.white,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Signature(
                    controller: _signatureController,
                    height: 120,
                    backgroundColor: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton.icon(
                    onPressed: () => _signatureController.clear(),
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Effacer'),
                  ),
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () async {
                      if (_signatureController.isNotEmpty) {
                        final bytes = await _signatureController.toPngBytes();
                        if (bytes != null) {
                          _sharedController.signerChefDep(bytes);
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00855A)),
                    child: const Text('Valider pour ce document', style: TextStyle(color: Colors.white)),
                  ),
                ],
              ),
            ],
            
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 54,
                child: ElevatedButton.icon(
                  onPressed: (hasGlobalSignature || _signatureController.isNotEmpty) 
                    ? _exporterListeRouge 
                    : null,
                  icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                  label: const Text('Générer la Liste Rouge Officielle', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: (hasGlobalSignature || _signatureController.isNotEmpty) ? const Color(0xFF00855A) : Colors.grey,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                ),
              ),
            ),
          ],
        ],
      );
    });
  }


  // ===================== JUSTIFICATIFS =====================
  Widget _buildJustificatifsView() {
    return Obx(() {
      final justificatifs = _sharedController.getJustificatifsEnAttente();

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                _buildStatBadge('En attente', '${justificatifs.length}', Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge('Valides',
                    '${_sharedController.presences.where((p) => p.statutJustification == 'VALIDE').length}',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge('Rejetes',
                    '${_sharedController.presences.where((p) => p.statutJustification == 'REJETE').length}',
                    Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: justificatifs.isEmpty
                ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.inbox, size: 60, color: Colors.grey),
                  SizedBox(height: 16),
                  Text('Aucun justificatif en attente',
                      style: TextStyle(color: Colors.grey)),
                ],
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: justificatifs.length,
              itemBuilder: (context, index) {
                final j = justificatifs[index];
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
                                      '${j.prenomEtudiant} ${j.nomEtudiant}',
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF003D29))),
                                  Text(
                                      '${j.matiere ?? ''} • ${j.typeJustificatif ?? ''}',
                                      style: const TextStyle(
                                          color: Color(0xFF00855A),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500)),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 4),
                              decoration: BoxDecoration(
                                color: Colors.orange.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(
                                    color:
                                    Colors.orange.withValues(alpha: 0.3)),
                              ),
                              child: const Text('EN ATTENTE',
                                  style: TextStyle(
                                      color: Colors.orange,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 10)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(children: [
                                const Icon(Icons.calendar_today,
                                    size: 12, color: Colors.grey),
                                const SizedBox(width: 4),
                                Text(j.dateSeance,
                                    style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12)),
                              ]),
                              if (j.motifJustificatif != null) ...[
                                const SizedBox(height: 4),
                                Row(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.notes,
                                        size: 12, color: Colors.grey),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Text(
                                          j.motifJustificatif!,
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
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: ElevatedButton.icon(
                                onPressed: () {
                                  _sharedController
                                      .traiterJustificatif(j.id, true);
                                },
                                icon: const Icon(Icons.check,
                                    color: Colors.white, size: 16),
                                label: const Text('Valider',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00855A),
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
                                  _sharedController
                                      .traiterJustificatif(j.id, false);
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
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      );
    });
  }

  // ===================== TABLEAU DE BORD =====================
  Widget _buildTableauBord() {
    return Obx(() {
      final totalCours = _sharedController.coursDuJour.length;
      final enCours = _sharedController.coursDuJour.where((c) => c['statut'] == 'EN_COURS').length;
      final planifies = _sharedController.coursDuJour.where((c) => c['statut'] == 'PLANIFIE').length;
      final pointagesAttente = _sharedController.fichesPointage.where((f) => f['valideChefDep'] == false).length;

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            _authController.utilisateur.value != null ? '${_authController.utilisateur.value!.prenom[0]}${_authController.utilisateur.value!.nom[0]}' : 'C',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bonjour,',
                              style: TextStyle(color: Colors.white70, fontSize: 13)),
                          Text(
                            '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Chef de Departement - FST UIN',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      _buildHeaderStat('Total', '$totalCours', Icons.list_alt),
                      const SizedBox(width: 6),
                      _buildHeaderStat('En cours', '$enCours', Icons.play_circle_outline),
                      const SizedBox(width: 6),
                      _buildHeaderStat('Planifies', '$planifies', Icons.schedule),
                      const SizedBox(width: 6),
                      _buildHeaderStat('En attente', '$pointagesAttente', Icons.pending_outlined),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Actions rapides',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      _buildActionCard('Presences', Icons.people, Colors.blue, 1),
                      const SizedBox(width: 12),
                      _buildActionCard('Pointages', Icons.check_circle, Colors.orange, 2),
                      const SizedBox(width: 12),
                      _buildActionCard('Rapports', Icons.bar_chart, Colors.purple, 3),
                    ],
                  ),
                  const SizedBox(height: 24),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Cours du jour',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      TextButton(
                        onPressed: () => setState(() => _currentIndex = 1),
                        child: const Text('Voir tout',
                            style: TextStyle(
                                color: Color(0xFF00855A), fontSize: 13)),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ..._sharedController.coursDuJour.map((cours) => _buildCoursCard(cours)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ===================== PRESENCES =====================
  Widget _buildPresences() {
    return Obx(() {
      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Row(
                children: [
                  _buildStatBadge('Total', '${_sharedController.coursDuJour.length}', Colors.white),
                  const SizedBox(width: 8),
                  _buildStatBadge('EN_COURS',
                      '${_sharedController.coursDuJour.where((c) => c['statut'] == 'EN_COURS').length}',
                      Colors.orange),
                  const SizedBox(width: 8),
                  _buildStatBadge('PLANIFIE',
                      '${_sharedController.coursDuJour.where((c) => c['statut'] == 'PLANIFIE').length}',
                      Colors.blueAccent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: _sharedController.coursDuJour.map((cours) {
                  final taux = (cours['presents'] / cours['total'] * 100).toInt();
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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(cours['matiere'],
                                  style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF003D29))),
                              _buildStatutBadge(cours['statut']),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(cours['enseignant'],
                              style: const TextStyle(
                                  color: Color(0xFF00855A),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500)),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              _buildMiniStat('Presents', cours['presents'], const Color(0xFF00855A)),
                              _buildMiniStat('Absents',
                                  cours['total'] - cours['presents'], Colors.red),
                              _buildMiniStat('Total', cours['total'], Colors.blue),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text('Taux de presence',
                                  style: TextStyle(
                                      color: Colors.grey[600], fontSize: 12)),
                              Text('$taux%',
                                  style: TextStyle(
                                      color: taux >= 75
                                          ? const Color(0xFF00855A)
                                          : Colors.red,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14)),
                            ],
                          ),
                          const SizedBox(height: 6),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: LinearProgressIndicator(
                              value: cours['presents'] / cours['total'],
                              backgroundColor: Colors.grey[200],
                              color: taux >= 75 ? const Color(0xFF00855A) : Colors.red,
                              minHeight: 8,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildPointages() {
    return Obx(() {
      final pointages = _sharedController.fichesPointage;

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Row(
                children: [
                  _buildStatBadge('En attente',
                      '${pointages.where((f) => f['valideChefDep'] == false && f['statut'] != 'REJETE').length}', Colors.orange),
                  const SizedBox(width: 8),
                  _buildStatBadge('Valides', 
                      '${pointages.where((f) => f['valideChefDep'] == true).length}', 
                      Colors.greenAccent),
                  const SizedBox(width: 8),
                  _buildStatBadge('Rejetes', 
                      '${pointages.where((f) => f['statut'] == 'REJETE').length}', 
                      Colors.redAccent),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: pointages.isEmpty 
                ? const Center(child: Padding(
                    padding: EdgeInsets.all(40.0),
                    child: Text("Aucun pointage disponible"),
                  ))
                : Column(
                children: pointages.map((p) {
                  final bool isPending = p['valideChefDep'] == false && p['statut'] != 'REJETE';
                  final bool isRejected = p['statut'] == 'REJETE';
                  final bool isValidated = p['valideChefDep'] == true;

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
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      width: 44,
                                      height: 44,
                                      decoration: BoxDecoration(
                                        color: (isRejected ? Colors.red : (isValidated ? Colors.green : Colors.orange)).withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                          isRejected ? Icons.cancel : (isValidated ? Icons.check_circle : Icons.pending_actions),
                                          color: isRejected ? Colors.red : (isValidated ? Colors.green : Colors.orange), 
                                          size: 22),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(p['matiere'],
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 15,

                                                  color: Color(0xFF003D29))),
                                          Text(p['enseignantNom'] ?? '',
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                  color: Color(0xFF00855A),
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: (p['statut'] == 'CONFIRME' ? Colors.blue : Colors.orange).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                      color: (p['statut'] == 'CONFIRME' ? Colors.blue : Colors.orange).withValues(alpha: 0.3)),
                                ),
                                child: Text(p['statut'],
                                    style: TextStyle(
                                        color: p['statut'] == 'CONFIRME' ? Colors.blue : Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 10)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF5F7FA),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                _buildDetailInfo(
                                    Icons.calendar_today, p['dateSeance']),
                                _buildDetailInfo(Icons.access_time,
                                    '${p['heureDebut']} - ${p['heureFin']}'),
                                _buildDetailInfo(
                                    Icons.timer, '${p['duree']} min'),
                              ],
                            ),
                          ),
                          const SizedBox(height: 12),
                          if (isPending)
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _sharedController.validerParChefDep(p['id']),
                                    icon: const Icon(Icons.check, color: Colors.white, size: 16),
                                    label: const Text('Valider',
                                        style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF00855A),
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () => _sharedController.rejeterFiche(p['id'], 'Chef Departement'),
                                    icon: const Icon(Icons.close, color: Colors.white, size: 16),
                                    label: const Text('Rejeter',
                                        style: TextStyle(color: Colors.white,
                                            fontWeight: FontWeight.bold)),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.red,
                                      elevation: 0,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)),
                                    ),
                                  ),
                                ),
                              ],
                            )
                          else
                            Container(
                              width: double.infinity,
                              padding: const EdgeInsets.symmetric(vertical: 8),
                              decoration: BoxDecoration(
                                color: (isRejected ? Colors.red : Colors.green).withValues(alpha: 0.05),
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Text(
                                isRejected ? "Ce pointage a été rejeté" : "Ce pointage a été validé",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isRejected ? Colors.red : Colors.green,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      );
    });
  }

  // ===================== RAPPORTS =====================
  Widget _buildRapports() {
    return Obx(() {
      final stats = _sharedController.statistiquesMatieres;
      final totalModules = stats.length;
      final tauxMoyen = totalModules > 0 
          ? (stats.fold(0, (sum, s) => sum + (s['tauxPresence'] as int)) / totalModules).toInt()
          : 0;
      final critiques = stats.where((s) => (s['tauxPresence'] as int) < 75).length;

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Row(
                children: [
                  _buildStatBadge('Modules', '$totalModules', Colors.white),
                  const SizedBox(width: 8),
                  _buildStatBadge('Taux moyen', '$tauxMoyen%', Colors.greenAccent),
                  const SizedBox(width: 8),
                  _buildStatBadge('Critiques', '$critiques', Colors.redAccent),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Statistiques par matiere',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),

                  ...stats.map((stat) {
                    final taux = stat['tauxPresence'] as int;
                    final couleur = taux >= 75 ? const Color(0xFF00855A) : Colors.red;
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
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: couleur.withValues(alpha: 0.1),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Icon(Icons.book,
                                            color: couleur, size: 20),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(stat['matiere'],
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15,
                                                    color: Color(0xFF003D29))),
                                            Text('${stat['totalSeances']} seances',
                                                style: const TextStyle(
                                                    color: Colors.grey, fontSize: 12)),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text('$taux%',
                                    style: TextStyle(
                                        color: couleur,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22)),
                              ],
                            ),
                            const SizedBox(height: 10),
                            ClipRRect(
                              borderRadius: BorderRadius.circular(4),
                              child: LinearProgressIndicator(
                                value: taux / 100,
                                backgroundColor: Colors.grey[200],
                                color: couleur,
                                minHeight: 8,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }),
                const SizedBox(height: 8),
                const Text('Generer des rapports',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF003D29))),
                const SizedBox(height: 12),
                _buildRapportCard('Rapport de presences',
                    'Liste complete des presences', Icons.people, Colors.blue),
                _buildRapportCard('Rapport des pointages',
                    'Historique des pointages', Icons.check_circle, const Color(0xFF00855A)),
                _buildRapportCard('Etat paiement vacataires',
                    'Calcul heures et paiements', Icons.payment, Colors.orange),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.green,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => ExportService.exporterEtatVacationExcel(_sharedController.getVacatairesData()),
                          icon: const Icon(Icons.table_chart, color: Colors.white),
                          label: const Text('Excel',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: ElevatedButton.icon(
                          onPressed: () => ExportService.exporterRapportPresencesPDF(_sharedController.statistiquesMatieres),
                          icon: const Icon(Icons.picture_as_pdf, color: Colors.white),
                          label: const Text('PDF',
                              style: TextStyle(color: Colors.white,
                                  fontWeight: FontWeight.bold)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  });
}

  // ===================== WIDGETS COMMUNS =====================
  Widget _buildHeaderStat(String label, String valeur, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Icon(icon, color: Colors.white, size: 16),
            const SizedBox(height: 4),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(valeur,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label,
                  style: const TextStyle(color: Colors.white70, fontSize: 8),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String label, IconData icon, Color couleur, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: couleur.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: couleur, size: 22),
              ),
              const SizedBox(height: 8),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF003D29))),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCoursCard(Map<String, dynamic> cours) {
    final taux = (cours['presents'] / cours['total'] * 100).toInt();
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
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Text(cours['matiere'],
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                ),
                _buildStatutBadge(cours['statut']),
              ],
            ),
            const SizedBox(height: 4),
            Text(cours['enseignant'],
                style: const TextStyle(
                    color: Color(0xFF00855A),
                    fontSize: 12,
                    fontWeight: FontWeight.w500)),
            const SizedBox(height: 6),
            Row(children: [
              const Icon(Icons.access_time, size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Text(cours['heure'],
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
              const SizedBox(width: 12),
              const Icon(Icons.location_on, size: 13, color: Colors.grey),
              const SizedBox(width: 4),
              Text('Salle ${cours['salle']}',
                  style: TextStyle(color: Colors.grey[600], fontSize: 12)),
            ]),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('${cours['presents']}/${cours['total']} presents',
                    style: const TextStyle(
                        color: Color(0xFF00855A),
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
                Text('$taux%',
                    style: TextStyle(
                        color: taux >= 75 ? const Color(0xFF00855A) : Colors.red,
                        fontWeight: FontWeight.bold,
                        fontSize: 13)),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: cours['presents'] / cours['total'],
                backgroundColor: Colors.grey[200],
                color: taux >= 75 ? const Color(0xFF00855A) : Colors.red,
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'EN_COURS': couleur = Colors.orange; break;
      case 'TERMINE': couleur = const Color(0xFF00855A); break;
      case 'ANNULE': couleur = Colors.red; break;
      default: couleur = Colors.blue;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: couleur.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: couleur.withValues(alpha: 0.3)),
      ),
      child: Text(statut,
          style: TextStyle(
              color: couleur, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  Widget _buildStatBadge(String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 4),
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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.w500)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMiniStat(String label, int valeur, Color couleur) {
    return Column(
      children: [
        Text('$valeur',
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, color: couleur)),
        Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }

  Widget _buildDetailInfo(IconData icon, String valeur) {
    return Row(
      children: [
        Icon(icon, size: 13, color: Colors.grey),
        const SizedBox(width: 4),
        Text(valeur, style: TextStyle(color: Colors.grey[600], fontSize: 12)),
      ],
    );
  }

  Widget _buildRapportCard(
      String titre, String description, IconData icon, Color couleur) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: couleur),
        ),
        title: Text(titre,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Text(description,
            style: const TextStyle(color: Colors.grey, fontSize: 12)),
        trailing: Icon(Icons.download, color: couleur),
        onTap: () => Get.snackbar('Rapport', '$titre genere',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: couleur,
            colorText: Colors.white),
      ),
    );
  }
}
