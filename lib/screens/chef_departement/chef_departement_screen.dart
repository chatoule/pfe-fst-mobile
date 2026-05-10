
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';

// ✅ Ces imports sont obligatoires — un par tab
import 'tabs/tableau_bord_tab.dart';
import 'tabs/presences_tab.dart';
import 'tabs/pointages_tab.dart';
import 'tabs/rapports_tab.dart';
import 'tabs/justificatifs_tab.dart';
import 'tabs/liste_rouge_tab.dart';
import 'tabs/rattrapages_tab.dart';
import 'tabs/utilisateurs_tab.dart';

// ✅ Ces deux écrans séparés aussi
import 'validation_seances_screen.dart';
import 'etat_vacation_screen.dart';

class ChefDepartementScreen extends StatefulWidget {
  const ChefDepartementScreen({super.key});

  @override
  State<ChefDepartementScreen> createState() =>
      _ChefDepartementScreenState();
}

class _ChefDepartementScreenState
    extends State<ChefDepartementScreen> {
  final AuthController _authController =
  Get.find<AuthController>();

  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(
          _getTitre(),
          style: const TextStyle(
              fontWeight: FontWeight.bold, fontSize: 18),
        ),
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

  // ===== DRAWER =====
  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          // Header du drawer
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, bottom: 24, left: 20, right: 20),
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
                    border:
                    Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final user =
                        _authController.utilisateur.value;
                    return Center(
                      child: Text(
                        user != null
                            ? '${user.prenom[0]}${user.nom[0]}'
                            : 'C',
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
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'CHEF DÉPARTEMENT',
                    style: TextStyle(
                        color: Colors.white, fontSize: 11),
                  ),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  _authController.utilisateur.value?.email ??
                      '',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11),
                )),
              ],
            ),
          ),

          // Items du drawer
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(
                    0, Icons.dashboard_outlined, 'Tableau de bord'),
                _buildDrawerItem(
                    1, Icons.people_outline, 'Suivi Présences'),
                _buildDrawerItem(
                    8, Icons.people_alt_outlined, 'Utilisateurs'),
                _buildDrawerItem(2, Icons.check_circle_outline,
                    'Valider Pointages'),
                _buildDrawerItem(
                    9, Icons.replay_outlined, 'Valider Rattrapages'),
                _buildDrawerItem(
                    6, Icons.description_outlined, 'Justificatifs'),
                _buildDrawerItem(
                    7, Icons.gavel_outlined, 'Liste Rouge'),
                _buildDrawerItem(
                    3, Icons.bar_chart_outlined, 'Rapports'),
                _buildDrawerItem(
                    4, Icons.verified_outlined, 'Valider Séances'),
                _buildDrawerItem(
                    5, Icons.payments_outlined, 'État de Vacation'),
                const SizedBox(height: 20),
              ],
            ),
          ),

          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text(
              'Se déconnecter',
              style: TextStyle(
                  color: Colors.red, fontWeight: FontWeight.w500),
            ),
            onTap: () => _authController.logout(),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'FST - UIN v1.0',
              style: TextStyle(color: Colors.grey, fontSize: 11),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
      int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(
          horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF00855A).withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive
              ? const Color(0xFF00855A)
              : Colors.grey[600],
          size: 22,
        ),
        title: Text(
          label,
          style: TextStyle(
            color: isActive
                ? const Color(0xFF00855A)
                : Colors.grey[800],
            fontWeight: isActive
                ? FontWeight.bold
                : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        onTap: () {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  // ===== TITRE SELON LA SECTION =====
  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Tableau de bord';
      case 1: return 'Suivi Présences';
      case 2: return 'Valider Pointages';
      case 3: return 'Rapports';
      case 4: return 'Valider Séances';
      case 5: return 'État de Vacation';
      case 6: return 'Justificatifs';
      case 7: return 'Liste Rouge';
      case 8: return 'Utilisateurs';
      case 9: return 'Validation Rattrapages';
      default: return 'Chef Département';
    }
  }

  // ===== NAVIGATION VERS LES TABS =====
  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return const TableauBordTab();
      case 1: return const PresencesTab();
      case 2: return const PointagesTab();
      case 3: return const RapportsTab();
      case 4: return const ValidationSeancesScreen();
      case 5: return const EtatVacationScreen();
      case 6: return const JustificatifsTab();
      case 7: return const ListeRougeTab();
      case 8: return const UtilisateursTab();
      case 9: return const RattrapagesTab();
      default: return const TableauBordTab();
    }
  }
}
