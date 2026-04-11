import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class AppDrawer extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();

  @override
  Widget build(BuildContext context) {
    final user = _authController.utilisateur.value;

    return Drawer(
      child: Column(
        children: [
          // ===== EN-TETE DU DRAWER =====
          Container(
            width: double.infinity,
            padding: EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF00855A),
                  Color(0xFF005C3E),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Avatar
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Center(
                    child: Text(
                      user != null
                          ? '${user.prenom[0]}${user.nom[0]}'
                          : 'U',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 12),
                Text(
                  '${user?.prenom ?? ""} ${user?.nom ?? ""}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    user?.role ?? '',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  user?.email ?? '',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),

          // ===== MENU ITEMS =====
          Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(vertical: 8),
              children: [
                ..._buildMenuItems(user?.role ?? '', context),
              ],
            ),
          ),

          // ===== FOOTER =====
          Divider(height: 1),
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              leading: Icon(Icons.logout, color: Colors.red),
              title: Text(
                'Se deconnecter',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500),
              ),
              onTap: () => _authController.logout(),
            ),
          ),
          Padding(
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

  List<Widget> _buildMenuItems(String role, BuildContext context) {
    switch (role) {
      case 'ENSEIGNANT':
        return [
          _buildMenuItem(Icons.check_circle, 'Mes Cours', '/pointage', context),
          _buildMenuItem(Icons.people, 'Presences', '/pointage', context),
          _buildMenuItem(Icons.replay, 'Rattrapages', '/pointage', context),
          _buildMenuItem(Icons.fast_forward, 'Anticipations', '/pointage', context),
          _buildMenuItem(Icons.folder, 'Supports', '/pointage', context),
          _buildMenuItem(Icons.history, 'Historique', '/pointage', context),
        ];
      case 'ETUDIANT':
        return [
          _buildMenuItem(Icons.dashboard, 'Mon Espace', '/presences', context),
          _buildMenuItem(Icons.assignment, 'Mes Absences', '/presences', context),
          _buildMenuItem(Icons.upload_file, 'Justificatifs', '/presences', context),
        ];
      case 'CHEF_DEPARTEMENT':
        return [
          _buildMenuItem(Icons.dashboard, 'Tableau de bord', '/chef-departement', context),
          _buildMenuItem(Icons.people, 'Presences', '/chef-departement', context),
          _buildMenuItem(Icons.check_circle, 'Pointages', '/chef-departement', context),
          _buildMenuItem(Icons.bar_chart, 'Rapports', '/chef-departement', context),
        ];
      case 'SUPERVISEUR':
        return [
          _buildMenuItem(Icons.check_circle, 'Pointages', '/superviseur', context),
          _buildMenuItem(Icons.people, 'Presences', '/superviseur', context),
          _buildMenuItem(Icons.bar_chart, 'Statistiques', '/superviseur', context),
          _buildMenuItem(Icons.history, 'Historique', '/superviseur', context),
        ];
      case 'SECRETAIRE':
        return [
          _buildMenuItem(Icons.people, 'Utilisateurs', '/secretaire', context),
          _buildMenuItem(Icons.book, 'Modules', '/secretaire', context),
          _buildMenuItem(Icons.assignment, 'Justifications', '/secretaire', context),
          _buildMenuItem(Icons.bar_chart, 'Rapports', '/secretaire', context),
        ];
      case 'DOYEN':
        return [
          _buildMenuItem(Icons.dashboard, 'Tableau de bord', '/dashboard', context),
          _buildMenuItem(Icons.verified, 'Valider Etats', '/dashboard', context),
          _buildMenuItem(Icons.bar_chart, 'Statistiques', '/dashboard', context),
          _buildMenuItem(Icons.picture_as_pdf, 'Rapports', '/dashboard', context),
        ];
      default:
        return [];
    }
  }

  Widget _buildMenuItem(
      IconData icon, String titre, String route, BuildContext context) {
    final currentRoute = Get.currentRoute;
    final isActive = currentRoute == route;

    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? Color(0xFF00855A).withOpacity(0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(
          icon,
          color: isActive ? Color(0xFF00855A) : Colors.grey[700],
          size: 22,
        ),
        title: Text(
          titre,
          style: TextStyle(
            color: isActive ? Color(0xFF00855A) : Colors.grey[800],
            fontWeight:
            isActive ? FontWeight.bold : FontWeight.normal,
            fontSize: 14,
          ),
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        onTap: () {
          Navigator.pop(context);
          Get.offAllNamed(route);
        },
      ),
    );
  }
}