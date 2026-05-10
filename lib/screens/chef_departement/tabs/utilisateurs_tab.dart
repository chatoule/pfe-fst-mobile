// lib/screens/chef_departement/tabs/utilisateurs_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../services/etudiant_service.dart';
import '../../../services/core/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UtilisateursTab extends StatefulWidget {
  const UtilisateursTab({super.key});

  @override
  State<UtilisateursTab> createState() => _UtilisateursTabState();
}

class _UtilisateursTabState extends State<UtilisateursTab> {
  final EtudiantService _etudiantService = EtudiantService();

  List<dynamic> _enseignants = [];
  List<dynamic> _etudiants = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _chargerUtilisateurs();
  }

  Future<void> _chargerUtilisateurs() async {
    setState(() => _isLoading = true);
    try {
      // Enseignants
      final resEns = await http.get(
        Uri.parse('${ApiConfig.baseUrl}/enseignants'),
        headers: ApiConfig.headers,
      );
      if (resEns.statusCode == 200) {
        _enseignants = jsonDecode(resEns.body);
      }
      // Étudiants
      _etudiants = await _etudiantService.getAllEtudiants();
    } catch (e) {
      print('Erreur chargement utilisateurs: $e');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header
        Container(
          padding: const EdgeInsets.all(20),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)]),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
                children: [
                  const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Personnel & Étudiants',
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 18)),
                      Text('Comptes enregistrés',
                          style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12)),
                    ],
                  ),
                  IconButton(
                    onPressed: _chargerUtilisateurs,
                    icon: const Icon(Icons.refresh,
                        color: Colors.white),
                    tooltip: 'Actualiser',
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline,
                        color: Colors.white70, size: 15),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'La création de comptes se fait depuis l\'écran de connexion.',
                        style: TextStyle(
                            color: Colors.white70, fontSize: 12),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // Contenu
        Expanded(
          child: _isLoading
              ? const Center(
            child: CircularProgressIndicator(
                color: Color(0xFF00855A)),
          )
              : RefreshIndicator(
            onRefresh: _chargerUtilisateurs,
            color: const Color(0xFF00855A),
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Enseignants
                _buildCategoryHeader(
                    'Enseignants & Personnel',
                    Icons.person_outlined,
                    Colors.purple,
                    _enseignants.length),
                const SizedBox(height: 8),
                if (_enseignants.isEmpty)
                  _buildEmptySection(
                      'Aucun enseignant enregistré')
                else
                  ..._enseignants.map((e) =>
                      _buildUserCard(e,
                          isEnseignant: true)),

                const SizedBox(height: 20),

                // Étudiants
                _buildCategoryHeader(
                    'Étudiants',
                    Icons.school_outlined,
                    Colors.blue,
                    _etudiants.length),
                const SizedBox(height: 8),
                if (_etudiants.isEmpty)
                  _buildEmptySection(
                      'Aucun étudiant enregistré')
                else
                  ..._etudiants.map((e) =>
                      _buildUserCard(e,
                          isEnseignant: false)),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCategoryHeader(String title, IconData icon,
      Color color, int count) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 18),
        ),
        const SizedBox(width: 10),
        Text(title,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF003D29),
                fontSize: 15)),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text('$count',
              style: TextStyle(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: 12)),
        ),
      ],
    );
  }

  Widget _buildUserCard(dynamic user,
      {required bool isEnseignant}) {
    final prenom = (user['prenom'] as String? ?? '').trim();
    final nom = (user['nom'] as String? ?? '').trim();
    final email = user['email'] as String? ?? '';
    final role = user['role'] as String? ?? '';
    final statut = isEnseignant
        ? (user['statutEnseignant'] as String? ?? 'Actif')
        : ((user['statut'] == true) ? 'Actif' : 'Inactif');

    final isInactif = statut == 'Inactif';
    final isPending = statut == 'En attente';
    Color statutColor = isInactif
        ? Colors.red
        : isPending
        ? Colors.orange
        : const Color(0xFF00855A);

    String roleLabel = role;
    switch (role) {
      case 'ENSEIGNANT': roleLabel = 'Enseignant'; break;
      case 'CHEF_DEPARTEMENT': roleLabel = 'Chef Dép.'; break;
      case 'SUPERVISEUR': roleLabel = 'Superviseur'; break;
      case 'ETUDIANT': roleLabel = 'Étudiant'; break;
    }

    final initiales =
        '${prenom.isNotEmpty ? prenom[0] : '?'}${nom.isNotEmpty ? nom[0] : '?'}';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 2))
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 6),
        leading: CircleAvatar(
          backgroundColor: isEnseignant
              ? Colors.purple.withValues(alpha: 0.1)
              : Colors.blue.withValues(alpha: 0.1),
          child: Text(initiales,
              style: TextStyle(
                  color: isEnseignant
                      ? Colors.purple
                      : Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 14)),
        ),
        title: Text('$prenom $nom',
            style: const TextStyle(
                fontWeight: FontWeight.bold, fontSize: 14)),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(email,
                style: const TextStyle(
                    fontSize: 11, color: Colors.grey)),
            const SizedBox(height: 2),
            Text(roleLabel,
                style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFF00855A),
                    fontWeight: FontWeight.w500)),
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(
              horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: statutColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
                color: statutColor.withValues(alpha: 0.3)),
          ),
          child: Text(statut,
              style: TextStyle(
                  color: statutColor,
                  fontSize: 10,
                  fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildEmptySection(String message) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.inbox, color: Colors.grey[300], size: 24),
          const SizedBox(width: 8),
          Text(message,
              style: TextStyle(
                  color: Colors.grey[400], fontSize: 13)),
        ],
      ),
    );
  }
}
