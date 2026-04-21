import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shared_controller.dart';
import '../../services/export_service.dart';
import 'confirmation_seances_screen.dart';

class SuperviseurScreen extends StatefulWidget {
  const SuperviseurScreen({super.key});

  @override
  State<SuperviseurScreen> createState() => _SuperviseurScreenState();
}

class _SuperviseurScreenState extends State<SuperviseurScreen> {
  final AuthController _authController = Get.find<AuthController>();
  final SharedController _sharedController = Get.find<SharedController>();
  int _currentIndex = 0;
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange(BuildContext context) async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: const Color(0xFF00855A),
              onPrimary: Colors.white,
              onSurface: const Color(0xFF003D29),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

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
                    String initials = 'S';
                    if (user != null) {
                      String p = user.prenom.isNotEmpty ? user.prenom[0] : '';
                      String n = user.nom.isNotEmpty ? user.nom[0] : '';
                      initials = (p + n).isEmpty ? 'S' : (p + n).toUpperCase();
                    }
                    return Center(
                      child: Text(
                        initials,
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
                  child: const Text('SUPERVISEUR',
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
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Dashboard'),
                _buildDrawerItem(1, Icons.people_outline, 'Suivi Presences'),
                _buildDrawerItem(2, Icons.bar_chart_outlined, 'Statistiques'),
                _buildDrawerItem(3, Icons.history_outlined, 'Historique'),
                _buildDrawerItem(4, Icons.check_circle_outline, 'Valider Seances'),
                _buildDrawerItem(5, Icons.report_problem_outlined, 'Liste Rouge'),
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
      case 0: return 'Dashboard';
      case 1: return 'Suivi Presences';
      case 2: return 'Statistiques';
      case 3: return 'Historique';
      case 4: return 'Valider Seances';
      case 5: return 'Liste Rouge';
      default: return 'Superviseur';
    }
  }

  Widget _getScreen() {
    return Column(
      children: [
        if (_currentIndex == 1 || _currentIndex == 2) _buildDeptFilter(),
        if (_currentIndex == 3) _buildDateFilter(),
        Expanded(
          child: _getTabContent(),
        ),
      ],
    );
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.date_range, size: 18, color: Color(0xFF00855A)),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: () => _selectDateRange(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _startDate == null 
                    ? 'Filtrer par période' 
                    : '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                  style: TextStyle(
                    fontSize: 13, 
                    color: _startDate == null ? Colors.grey[600] : const Color(0xFF003D29),
                    fontWeight: _startDate == null ? FontWeight.normal : FontWeight.bold
                  ),
                ),
              ),
            ),
          ),
          if (_startDate != null)
            IconButton(
              icon: const Icon(Icons.clear, size: 18, color: Colors.red),
              onPressed: () => setState(() {
                _startDate = null;
                _endDate = null;
              }),
            ),
        ],
      ),
    );
  }

  Widget _getTabContent() {
    switch (_currentIndex) {
      case 0: return _buildDashboard();
      case 1: return _buildPresences();
      case 2: return _buildStatistiques();
      case 3: return _buildHistorique();
      case 4: return ConfirmationSeancesScreen();
      case 5: return _buildListeRouge();
      default: return _buildDashboard();
    }
  }

  Widget _buildDashboard() {
    return Obx(() {
      final fiches = _sharedController.fichesPointage;
      final enAttente = fiches.where((f) => f['confirmerSuperviseur'] == false && f['statut'] != 'REJETE').length;
      final validees = fiches.where((f) => f['statut'] == 'VALIDE').length;

      return SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Bienvenue Mubarak,', style: TextStyle(color: Colors.white70, fontSize: 14)),
                  const Text('Superviseur FST', style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      _buildStatCard('Total', '${fiches.length}', Colors.white),
                      const SizedBox(width: 8),
                      _buildStatCard('A confirmer', '$enAttente', Colors.orange),
                      const SizedBox(width: 8),
                      _buildStatCard('Validées', '$validees', Colors.greenAccent),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            const Text('Derniers Pointages', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            if (fiches.isEmpty)
              const Center(child: Text('Aucun pointage enregistré'))
            else
              ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fiches.length > 5 ? 5 : fiches.length,
                itemBuilder: (context, index) {
                  final f = fiches[fiches.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 8),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      leading: const CircleAvatar(backgroundColor: Color(0xFF00855A), child: Icon(Icons.person, color: Colors.white)),
                      title: Text(f['matiere'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(f['enseignantNom'] ?? 'Inconnu'),
                      trailing: _buildStatutBadge(f['statut']),
                    ),
                  );
                },
              ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => setState(() => _currentIndex = 3),
                child: const Text('Voir tout l\'historique'),
              ),
            )
          ],
        ),
      );
    });
  }

  Widget _buildStatCard(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(value, style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(label, style: const TextStyle(color: Colors.white70, fontSize: 10), textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeptFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Text('Département:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
          const SizedBox(width: 12),
          Expanded(
            child: Obx(() => Container(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: _sharedController.selectedDepartement.value,
                  isExpanded: true,
                  icon: const Icon(Icons.filter_list, size: 20),
                  items: _sharedController.departements.map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value, style: const TextStyle(fontSize: 13)),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    _sharedController.selectedDepartement.value = newValue!;
                  },
                ),
              ),
            )),
          ),
        ],
      ),
    );
  }

  // ===================== POINTAGES =====================
  Widget _buildPointages() {
    return Obx(() {
      final pointages = _sharedController.fichesPointage
          .where((f) => f['confirmerSuperviseur'] == false && f['statut'] != 'REJETE')
          .toList();

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
                _buildStatBadge('Total', '${_sharedController.fichesPointage.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge('En attente', '${pointages.length}', Colors.orange),
                const SizedBox(width: 8),
                _buildStatBadge('Confirmés',
                  '${_sharedController.fichesPointage.where((f) => f['confirmerSuperviseur'] == true).length}', 
                  Colors.greenAccent),
              ],
            ),
          ),
          Expanded(
            child: pointages.isEmpty 
            ? const Center(child: Text('Aucun pointage en attente de confirmation'))
            : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pointages.length,
              itemBuilder: (context, index) {
                final p = pointages[index];
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
                                color: const Color(0xFF00855A).withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: const Icon(Icons.person,
                                  color: Color(0xFF00855A), size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(p['matiere'],
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 14,
                                          color: Color(0xFF003D29)),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis),
                                  Text(p['enseignantNom'] ?? 'Inconnu',
                                      style: const TextStyle(
                                          color: Color(0xFF00855A),
                                          fontSize: 11,
                                          fontWeight: FontWeight.w500),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis),
                                ],
                              ),
                            ),
                            _buildStatutBadge(p['statut']),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5F7FA),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Expanded(child: _buildDetailInfo(Icons.calendar_today, p['dateSeance'])),
                              Expanded(child: _buildDetailInfo(Icons.access_time, '${p['heureDebut']} - ${p['heureFin']}')),
                              _buildDetailInfo(Icons.timer, '${p['duree']} min'),
                            ],
                          ),
                        ),
                        const SizedBox(height: 12),
                        Row(
                          children: [
                            Expanded(
                              child: OutlinedButton(
                                onPressed: () => _showDetailsDialog(context, p),
                                style: OutlinedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  foregroundColor: const Color(0xFF00855A),
                                  side: const BorderSide(color: Color(0xFF00855A)),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const FittedBox(child: Text('Détails')),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _sharedController.confirmerParSuperviseur(p['id']),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  backgroundColor: const Color(0xFF00855A),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const FittedBox(child: Text('Confirmer', style: TextStyle(color: Colors.white))),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: ElevatedButton(
                                onPressed: () => _sharedController.rejeterFiche(p['id'], 'Superviseur'),
                                style: ElevatedButton.styleFrom(
                                  padding: const EdgeInsets.symmetric(horizontal: 4),
                                  backgroundColor: Colors.red,
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                ),
                                child: const FittedBox(child: Text('Rejeter', style: TextStyle(color: Colors.white))),
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

  void _showDetailsDialog(BuildContext context, Map<String, dynamic> p) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            const Icon(Icons.description, color: Color(0xFF00855A)),
            const SizedBox(width: 10),
            Expanded(child: Text(p['matiere'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDetailItemPopup('Enseignant', p['enseignantNom'] ?? 'Inconnu'),
              _buildDetailItemPopup('Date', p['dateSeance']),
              _buildDetailItemPopup('Horaire', '${p['heureDebut']} - ${p['heureFin']}'),
              _buildDetailItemPopup('Durée', '${p['duree']} min'),
              const Divider(),
              const Text('Contenu du cours :', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29), fontSize: 14)),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(p['contenu'] ?? 'Aucun contenu renseigné', style: const TextStyle(fontSize: 13)),
              ),
              const SizedBox(height: 16),
              const Text('Signature Enseignant :', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29), fontSize: 14)),
              const SizedBox(height: 8),
              p['signatureEnseignant'] != null
                  ? Container(
                      height: 100,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Image.memory(p['signatureEnseignant'], fit: BoxFit.contain),
                    )
                  : const Text('Aucune signature', style: TextStyle(fontStyle: FontStyle.italic, color: Colors.grey, fontSize: 12)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Fermer', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              _sharedController.confirmerParSuperviseur(p['id']);
              Navigator.pop(context);
              Get.snackbar('Succès', 'Pointage confirmé avec succès',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: const Color(0xFF00855A),
                  colorText: Colors.white);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF00855A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Confirmer maintenant', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailItemPopup(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('$label : ', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey)),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF003D29)))),
        ],
      ),
    );
  }

  // ===================== PRESENCES =====================
  Widget _buildPresences() {
    return Obx(() {
      final allCours = _sharedController.coursDuJour;
      final selectedDept = _sharedController.selectedDepartement.value;
      
      final cours = selectedDept == 'Tous les départements' 
          ? allCours 
          : allCours.where((c) => c['departement'] == selectedDept).toList();

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
                _buildStatBadge('Modules', '${cours.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge('Taux moyen',
                    '${cours.isEmpty ? 0 : (cours.fold<int>(0, (sum, c) => sum + ((c['presents'] as int) * 100 ~/ (c['total'] as int))) ~/ cours.length)}%',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge('Critiques',
                    '${cours.where((c) => ((c['presents'] as int) * 100 ~/ (c['total'] as int)) < 75).length}',
                    Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: cours.length,
              itemBuilder: (context, index) {
                final c = cours[index];
                final taux = (c['presents'] as int) * 100 ~/ (c['total'] as int);
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
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: BoxDecoration(
                                color: couleur.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Icon(Icons.book,
                                  color: couleur, size: 22),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(c['matiere'],
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF003D29)),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis),
                            ),
                            Text('$taux%',
                                style: TextStyle(
                                    color: couleur,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18)),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildMiniStat('Presents', c['presents'], const Color(0xFF00855A)),
                            _buildMiniStat('Absents',
                                (c['total'] as int) - (c['presents'] as int), Colors.red),
                            _buildMiniStat('Total', c['total'], Colors.blue),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(4),
                          child: LinearProgressIndicator(
                            value: (c['presents'] as int) / (c['total'] as int),
                            backgroundColor: Colors.grey[200],
                            color: couleur,
                            minHeight: 8,
                          ),
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

  // ===================== STATISTIQUES =====================
  Widget _buildStatistiques() {
    return Obx(() {
      final allStats = _sharedController.statistiquesMatieres;
      final selectedDept = _sharedController.selectedDepartement.value;
      
      // Note: In a real app, stats would also be filtered by dept in the controller
      final stats = allStats; 

      return SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                children: [
                  const Text('Vue globale - FST UIN',
                      style: TextStyle(color: Colors.white70, fontSize: 13)),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      _buildGlobalStat('Séances', '${_sharedController.totalSeances}'),
                      _buildGlobalStat('Validées', '${_sharedController.seancesValidees}'),
                      _buildGlobalStat('Attente', '${_sharedController.seancesEnAttente}'),
                      _buildGlobalStat('Sém.', 'S1'),
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
                  const Text('Taux de présence par module',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 400, // Hauteur fixe pour éviter les erreurs RenderBox
                    child: ListView.builder(
                      shrinkWrap: true,
                      itemCount: stats.length,
                      itemBuilder: (context, index) {
                        final s = stats[index];
                        final taux = s['tauxPresence'] as int;
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
                            padding: const EdgeInsets.all(14),
                            child: Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
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
                                        SizedBox(
                                          width: MediaQuery.of(context).size.width * 0.4,
                                          child: Text(s['matiere'],
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 14,
                                                  color: Color(0xFF003D29)),
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis),
                                        ),
                                      ],
                                    ),
                                    Text('$taux%',
                                        style: TextStyle(
                                            color: couleur,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20)),
                                  ],
                                ),
                                const SizedBox(height: 8),
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
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ===================== HISTORIQUE =====================
  Widget _buildHistorique() {
    return Obx(() {
      final pointages = _sharedController.fichesPointage.where((f) {
        final isCorrectStatut = f['confirmerSuperviseur'] == true || f['statut'] == 'REJETE';
        if (!isCorrectStatut) return false;

        if (_startDate != null && _endDate != null) {
          try {
            final dateSeance = DateTime.parse(f['dateSeance']);
            return dateSeance.isAfter(_startDate!.subtract(const Duration(days: 1))) &&
                dateSeance.isBefore(_endDate!.add(const Duration(days: 1)));
          } catch (e) {
            return true;
          }
        }
        return true;
      }).toList();

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
                _buildStatBadge('Total', '${pointages.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge('Validés',
                    '${pointages.where((h) => h['statut'] != 'REJETE').length}',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge('Rejetés',
                    '${pointages.where((h) => h['statut'] == 'REJETE').length}',
                    Colors.redAccent),
              ],
            ),
          ),
          Expanded(
            child: pointages.isEmpty 
            ? const Center(child: Text('Aucun historique disponible'))
            : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pointages.length,
              itemBuilder: (context, index) {
                final h = pointages[index];
                Color couleur;
                IconData icon;
                if (h['statut'] == 'REJETE') {
                  couleur = Colors.red;
                  icon = Icons.cancel;
                } else {
                  couleur = const Color(0xFF00855A);
                  icon = Icons.check_circle;
                }
                
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
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 8),
                    leading: Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: couleur.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(icon, color: couleur, size: 22),
                    ),
                    title: Text(h['statut'] == 'REJETE' ? 'Pointage Rejeté' : 'Pointage Confirmé',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29))),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 2),
                        Text('${h['matiere']} - ${h['enseignantNom']}',
                            style: const TextStyle(
                                color: Color(0xFF00855A),
                                fontSize: 12,
                                fontWeight: FontWeight.w500)),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(Icons.access_time, size: 11, color: Colors.grey),
                            const SizedBox(width: 3),
                            Text(h['dateSeance'],
                                style: const TextStyle(color: Colors.grey, fontSize: 11)),
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

  // ===================== LISTE ROUGE =====================
  Widget _buildListeRouge() {
    return Obx(() {
      final etudiants = _sharedController.etudiantsEnSession;

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

          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFFB71C1C), Color(0xFF7F0000)],
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('SESSION DE RATTRAPAGE',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
                    Text('${etudiants.length} Étudiants concernés',
                        style: const TextStyle(color: Colors.white70, fontSize: 12)),
                  ],
                ),
                ElevatedButton.icon(
                  onPressed: etudiants.isEmpty ? null : () async {
                    await ExportService.exporterListeRougePDF(
                      etudiants,
                      signature: _sharedController.signatureChefDep.value,
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf, size: 18),
                  label: const Text('Exporter'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.red[900],
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: etudiants.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.check_circle_outline, size: 64, color: Colors.green[200]),
                        const SizedBox(height: 16),
                        const Text('Aucun étudiant sur la liste rouge',
                            style: TextStyle(color: Colors.grey, fontSize: 16)),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: etudiants.length,
                    itemBuilder: (context, index) {
                      final e = etudiants[index];
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
                          border: Border.all(color: Colors.red.withValues(alpha: 0.2)),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Colors.red[50],
                            child: Text('${e['prenom'][0]}${e['nom'][0]}',
                                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold)),
                          ),
                          title: Text('${e['prenom']} ${e['nom']}',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF003D29))),
                          subtitle: Text('ID: ${e['id']} • ${e['absences']} absences NJ',
                              style: TextStyle(color: Colors.red[700], fontWeight: FontWeight.w500)),
                          trailing: const Icon(Icons.warning_amber_rounded, color: Colors.red),
                        ),
                      );
                    },
                  ),
          ),
        ],
      );
    });
  }

  // ===================== WIDGETS COMMUNS =====================
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
                  style: const TextStyle(color: Colors.white70, fontSize: 10),
                  textAlign: TextAlign.center),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGlobalStat(String label, String valeur) {
    return Expanded(
      child: Column(
        children: [
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(valeur,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold)),
          ),
          FittedBox(
            fit: BoxFit.scaleDown,
            child: Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
          ),
        ],
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

  Widget _buildStatutBadge(String statut) {
    Color couleur;
    switch (statut) {
      case 'VALIDE':
      case 'CONFIRME': 
        couleur = const Color(0xFF00855A); break;
      case 'REJETE': couleur = Colors.red; break;
      default: couleur = Colors.orange;
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
}
