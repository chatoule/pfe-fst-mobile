// lib/screens/enseignant/presence_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shared_controller.dart';
import '../../widgets/app_drawer.dart';

class PresencesScreen extends StatefulWidget {
  final bool showAppBar;
  const PresencesScreen({super.key, this.showAppBar = true});

  @override
  State<PresencesScreen> createState() => _PresencesScreenState();
}

class _PresencesScreenState extends State<PresencesScreen> {
  final SharedController _sharedController = SharedController.to;

  // ✅ CORRIGÉ : on stocke l'objet cours complet (pour récupérer l'ID réel)
  Map<String, dynamic>? _coursSelectionne;
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  // Liste fictive — à remplacer par un appel API EtudiantService quand disponible
  final List<Map<String, dynamic>> _allEtudiants = [
    {'id': 1, 'matricule': 'UIN24-T001', 'nom': 'Abdoulaye Mamane Sani'},
    {'id': 2, 'matricule': 'UIN24-T002', 'nom': 'Fatouma Issoufou Amadou'},
    {'id': 3, 'matricule': 'UIN24-T003', 'nom': 'Ibrahim Mahamane Souley'},
    {'id': 4, 'matricule': 'UIN24-T004', 'nom': 'Zainabou Salami Moussa'},
    {'id': 5, 'matricule': 'UIN24-T005', 'nom': 'Ousseini Mamoudou Hamidou'},
    {'id': 6, 'matricule': 'UIN24-T006', 'nom': 'Aichatou Garba Dan Galadima'},
  ];

  // ✅ CORRIGÉ : récupérer l'ID réel de la séance depuis l'objet cours API
  int get _seanceId => _coursSelectionne?['id'] ?? 0;
  String get _matiereSelectionnee => _coursSelectionne?['matiere'] ?? '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: widget.showAppBar
          ? AppBar(
        title: const Text('Pointage Présences',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
      )
          : null,
      drawer: widget.showAppBar ? const AppDrawer() : null,
      body: Column(
        children: [
          _buildTopSelection(),
          if (_coursSelectionne != null) _buildSearchBar(),
          Expanded(
            child: _coursSelectionne == null
                ? _buildEmptyState()
                : _buildListeEtudiants(),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSelection() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF00855A).withValues(alpha: 0.05),
        border: const Border(
            bottom: BorderSide(color: Color(0xFF00855A), width: 0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Session en cours',
              style: TextStyle(
                  fontWeight: FontWeight.bold, color: Color(0xFF003D29))),
          const SizedBox(height: 12),
          SizedBox(
            height: 45,
            child: Obx(() {
              final cours = _sharedController.coursDuJour;
              if (cours.isEmpty) {
                return const Center(
                  child: Text('Aucun cours aujourd\'hui',
                      style: TextStyle(color: Colors.grey, fontSize: 13)),
                );
              }
              return ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: cours.length,
                itemBuilder: (context, index) {
                  final c = cours[index];
                  final isSelected =
                      _coursSelectionne?['id'] == c['id'];
                  return GestureDetector(
                    onTap: () => setState(() => _coursSelectionne = c),
                    child: Container(
                      margin: const EdgeInsets.only(right: 10),
                      padding:
                      const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFF00855A)
                            : Colors.white,
                        borderRadius: BorderRadius.circular(25),
                        border: Border.all(
                            color: const Color(0xFF00855A)),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        c['matiere'] ?? 'Cours',
                        style: TextStyle(
                          color: isSelected
                              ? Colors.white
                              : const Color(0xFF00855A),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: TextField(
        controller: _searchController,
        onChanged: (v) => setState(() => _searchQuery = v.toLowerCase()),
        decoration: InputDecoration(
          hintText: 'Rechercher un étudiant...',
          prefixIcon: const Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
        ),
      ),
    );
  }

  Widget _buildListeEtudiants() {
    final filteredList = _allEtudiants
        .where((e) =>
        e['nom'].toLowerCase().contains(_searchQuery))
        .toList();

    return Obx(() {
      final stats = _sharedController.presences
          .where((p) => p.matiere == _matiereSelectionnee)
          .toList();
      final presentsCount = stats.where((p) => p.estPresent).length;

      return Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                _buildStatBadge(
                    'Présents', '$presentsCount', Colors.green),
                const SizedBox(width: 10),
                _buildStatBadge(
                    'Absents',
                    '${_allEtudiants.length - presentsCount}',
                    Colors.red),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: filteredList.length,
              itemBuilder: (context, index) {
                final e = filteredList[index];
                final presence =
                _sharedController.presences.firstWhereOrNull((p) =>
                p.etudiantId == e['id'] &&
                    p.matiere == _matiereSelectionnee);
                final isPresent = presence?.estPresent ?? false;

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withValues(alpha: 0.02),
                          blurRadius: 4)
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 4),
                    leading: CircleAvatar(
                      backgroundColor: isPresent
                          ? Colors.green.withValues(alpha: 0.1)
                          : Colors.red.withValues(alpha: 0.1),
                      child: Icon(
                        isPresent
                            ? Icons.check_circle
                            : Icons.remove_circle_outline,
                        color: isPresent ? Colors.green : Colors.red,
                      ),
                    ),
                    title: Text(e['nom'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis),
                    subtitle: Text(e['matricule'],
                        style: const TextStyle(fontSize: 12)),
                    trailing: Switch(
                      value: isPresent,
                      activeColor: Colors.green,
                      // ✅ CORRIGÉ : appelle maintenant le bon seanceId
                      onChanged: (val) {
                        _sharedController.marquerPresence(
                          e['id'],
                          _seanceId, // ✅ ID réel de la séance depuis l'API
                          val,
                          DateTime.now().toString().split(' ')[0],
                          _matiereSelectionnee,
                          e['nom'].split(' ').last,
                          e['nom'].split(' ').first,
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ),
          _buildBottomAction(),
        ],
      );
    });
  }

  Widget _buildStatBadge(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Column(
          children: [
            Text(value,
                style: TextStyle(
                    color: color,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: color, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomAction() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 10,
              offset: Offset(0, -2))
        ],
      ),
      child: SizedBox(
        width: double.infinity,
        height: 50,
        child: ElevatedButton(
          onPressed: () => Get.snackbar(
            'Succès',
            'Liste de présences enregistrée',
            backgroundColor: Colors.green,
            colorText: Colors.white,
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF00855A),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12)),
          ),
          child: const Text('Valider la liste',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.touch_app, size: 80, color: Colors.grey[300]),
          const SizedBox(height: 16),
          const Text(
            'Veuillez sélectionner un cours\npour commencer le pointage.',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
