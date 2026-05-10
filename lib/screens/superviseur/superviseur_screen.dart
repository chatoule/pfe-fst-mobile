// lib/screens/superviseur/superviseur_screen.dart
// Ce fichier contient UNIQUEMENT le drawer et la navigation
// Chaque section est dans son propre fichier dans tabs/

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/presences_tab.dart';
import 'tabs/statistiques_tab.dart';
import 'tabs/historique_tab.dart';
import 'tabs/liste_rouge_tab.dart';
import 'confirmation_seances_screen.dart';

class SuperviseurScreen extends StatefulWidget {
  const SuperviseurScreen({super.key});

  @override
  State<SuperviseurScreen> createState() =>
      _SuperviseurScreenState();
}

class _SuperviseurScreenState extends State<SuperviseurScreen> {
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

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
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
                    String initials = 'S';
                    if (user != null) {
                      final p = user.prenom.isNotEmpty
                          ? user.prenom[0]
                          : '';
                      final n =
                      user.nom.isNotEmpty ? user.nom[0] : '';
                      initials = (p + n).isEmpty
                          ? 'S'
                          : (p + n).toUpperCase();
                    }
                    return Center(
                      child: Text(initials,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold)),
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
                  child: const Text('SUPERVISEUR',
                      style: TextStyle(
                          color: Colors.white, fontSize: 11)),
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
          Expanded(
            child: ListView(
              padding: EdgeInsets.zero,
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(
                    0, Icons.dashboard_outlined, 'Dashboard'),
                _buildDrawerItem(
                    1, Icons.people_outline, 'Suivi Présences'),
                _buildDrawerItem(
                    2, Icons.bar_chart_outlined, 'Statistiques'),
                _buildDrawerItem(
                    3, Icons.history_outlined, 'Historique'),
                _buildDrawerItem(4, Icons.check_circle_outline,
                    'Valider Séances'),
                _buildDrawerItem(5, Icons.report_problem_outlined,
                    'Liste Rouge'),
                const SizedBox(height: 20),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se déconnecter',
                style: TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.w500)),
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
        leading: Icon(icon,
            color: isActive
                ? const Color(0xFF00855A)
                : Colors.grey[600],
            size: 22),
        title: Text(label,
            style: TextStyle(
                color: isActive
                    ? const Color(0xFF00855A)
                    : Colors.grey[800],
                fontWeight: isActive
                    ? FontWeight.bold
                    : FontWeight.normal,
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
      case 1: return 'Suivi Présences';
      case 2: return 'Statistiques';
      case 3: return 'Historique';
      case 4: return 'Valider Séances';
      case 5: return 'Liste Rouge';
      default: return 'Superviseur';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return const DashboardTab();
      case 1: return const PresencesSupTab();
      case 2: return const StatistiquesTab();
      case 3: return const HistoriqueTab();
      case 4: return const ConfirmationSeancesScreen();
      case 5: return const ListeRougeSupTab();
      default: return const DashboardTab();
    }
  }
}
