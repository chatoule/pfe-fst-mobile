
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../controllers/shared_controller.dart';
import '../../controllers/auth_controller.dart';
import '../../services/export_service.dart';

class DoyenScreen extends StatefulWidget {
  const DoyenScreen({super.key});

  @override
  State<DoyenScreen> createState() => _DoyenScreenState();
}

class _DoyenScreenState extends State<DoyenScreen> {
  final SharedController _shared = SharedController.to;
  final AuthController _auth = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text(
          'Tableau de Bord Stratégique',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        backgroundColor: const Color(0xFF003D29),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () => _shared.fichesPointage.refresh(),
            tooltip: 'Actualiser',
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _auth.logout(),
          ),
        ],
      ),
      body: Obx(() {
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildWelcomeHeader(),
              const SizedBox(height: 20),
              _buildDepartementSelector(),
              const SizedBox(height: 24),
              _buildStatsGrid(),
              const SizedBox(height: 24),
              _buildChartSection(),
              const SizedBox(height: 24),
              const Text(
                'Flux d\'activités en temps réel',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF003D29)),
              ),
              const SizedBox(height: 12),
              _buildActivityFeed(),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  // ===== HEADER =====
  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
            colors: [Color(0xFF003D29), Color(0xFF00855A)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Bienvenue, Monsieur le Doyen',
                  style: TextStyle(color: Colors.white70, fontSize: 14),
                ),
                const SizedBox(height: 4),
                // ✅ CORRIGÉ : utilise AuthController au lieu de nomDoyen
                Obx(() {
                  final user = _auth.utilisateur.value;
                  final nom = user != null
                      ? '${user.prenom} ${user.nom}'
                      : 'Doyen FST';
                  return Text(
                    nom,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  );
                }),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Faculté des Sciences et Techniques',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/logo_uin.png',
              width: 70, height: 70),
        ],
      ),
    );
  }

  // ===== FILTRE DÉPARTEMENT =====
  Widget _buildDepartementSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 5)
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _shared.selectedDepartement.value,
          isExpanded: true,
          icon: const Icon(Icons.filter_list,
              color: Color(0xFF00855A)),
          items: _shared.departements.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value,
                  style: const TextStyle(fontWeight: FontWeight.w500)),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              _shared.selectedDepartement.value = newValue;
            }
          },
        ),
      ),
    );
  }

  // ===== GRILLE STATS =====
  Widget _buildStatsGrid() {
    // ✅ Calcul du taux de présence réel depuis les données
    final cours = _shared.coursDuJour;
    int totalPresents = 0;
    int totalInscrits = 0;
    for (var c in cours) {
      totalPresents += (c['nombrePresents'] as int?) ?? 0;
      totalInscrits += (c['nombreInscrits'] as int?) ?? 0;
    }
    final tauxPresence = totalInscrits > 0
        ? (totalPresents * 100 ~/ totalInscrits)
        : 0;

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Séances Validées',
            '${_shared.seancesValidees}',
            Icons.check_circle, Colors.green),
        _buildStatCard('En Attente',
            '${_shared.seancesEnAttente}',
            Icons.hourglass_empty, Colors.orange),
        _buildStatCard('Taux Présence',
            '$tauxPresence%',
            Icons.people, Colors.blue),
        _buildStatCard('Départements',
            '${_shared.departements.length - 1}',
            Icons.account_balance, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10)
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value,
              style: const TextStyle(
                  fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label,
              style: const TextStyle(
                  fontSize: 11, color: Colors.grey),
              textAlign: TextAlign.center),
        ],
      ),
    );
  }

  // ===== GRAPHIQUE =====
  Widget _buildChartSection() {
    final validees = _shared.seancesValidees;
    final enAttente = _shared.seancesEnAttente;
    final rejetees = _shared.seancesRejetees;
    final total = validees + enAttente + rejetees;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.03),
              blurRadius: 10)
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Répartition des Pointages',
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: total == 0
                ? const Center(
                child: Text('Aucune donnée disponible',
                    style: TextStyle(color: Colors.grey)))
                : PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  if (validees > 0)
                    PieChartSectionData(
                      value: validees.toDouble(),
                      color: Colors.green,
                      title: 'Validés',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  if (enAttente > 0)
                    PieChartSectionData(
                      value: enAttente.toDouble(),
                      color: Colors.orange,
                      title: 'Attente',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                  if (rejetees > 0)
                    PieChartSectionData(
                      value: rejetees.toDouble(),
                      color: Colors.red,
                      title: 'Rejetés',
                      radius: 50,
                      titleStyle: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 16,
            children: [
              _buildLegendItem('Validés', Colors.green),
              _buildLegendItem('En attente', Colors.orange),
              _buildLegendItem('Rejetés', Colors.red),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 12,
          height: 12,
          decoration:
          BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label,
            style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  // ===== FLUX D'ACTIVITÉS =====
  Widget _buildActivityFeed() {
    // ✅ CORRIGÉ : filteredFiches remplacé par un filtre local
    final selectedDept = _shared.selectedDepartement.value;
    final allFiches = _shared.fichesPointage;

    final activities = (selectedDept == 'Tous les départements'
        ? allFiches
        : allFiches
        .where((f) => f['departement'] == selectedDept)
        .toList())
        .reversed
        .toList();

    if (activities.isEmpty) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Text('Aucune activité pour ce département',
              style: TextStyle(color: Colors.grey)),
        ),
      );
    }

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length > 5 ? 5 : activities.length,
          itemBuilder: (context, index) {
            final a = activities[index];
            // ✅ CORRIGÉ : accès sécurisé à tous les champs
            final matiere = a['matiere'] as String? ?? 'Module inconnu';
            final enseignant = a['enseignantNom'] as String? ?? 'Inconnu';
            final statut = a['statut'] as String? ?? 'EN_ATTENTE';
            final heureDebut = a['heureDebut'] as String? ?? '--:--';

            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor:
                  _getStatusColor(statut).withValues(alpha: 0.1),
                  child: Icon(
                    _getStatusIcon(statut),
                    color: _getStatusColor(statut),
                    size: 20,
                  ),
                ),
                title: Text(
                  matiere,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 14),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text('Par $enseignant',
                    style: const TextStyle(fontSize: 12)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      statut,
                      style: TextStyle(
                          color: _getStatusColor(statut),
                          fontWeight: FontWeight.bold,
                          fontSize: 10),
                    ),
                    Text(heureDebut,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        ),

        const SizedBox(height: 16),

        // Bouton export global
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              final data = _shared.getVacatairesData();
              if (data.isNotEmpty) {
                Get.snackbar(
                  'Préparation de l\'export',
                  'Génération de l\'état global des vacations...',
                  backgroundColor: const Color(0xFF003D29),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );

                final formattedVacations = data
                    .map((v) => {
                  'enseignantNom':
                  '${v['prenom'] ?? ''} ${v['nom'] ?? ''}',
                  'matiere': v['matiere'] ?? '',
                  'totalHeures': v['totalHeures'] ?? 0,
                  'tauxHoraire': v['tauxHoraire'] ?? 0,
                })
                    .toList();

                ExportService.exporterEtatVacationPDF(
                    formattedVacations);
              } else {
                Get.snackbar(
                  'Information',
                  'Aucune séance validée à exporter.',
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            icon: const Icon(Icons.description, color: Colors.white),
            label: const Text(
              'Générer l\'état de vacation global',
              style: TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D29),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

  // ===== HELPERS =====
  Color _getStatusColor(String statut) {
    switch (statut) {
      case 'VALIDE': return Colors.green;
      case 'CONFIRME': return Colors.blue;
      case 'REJETE': return Colors.red;
      default: return Colors.orange;
    }
  }

  IconData _getStatusIcon(String statut) {
    switch (statut) {
      case 'VALIDE': return Icons.verified;
      case 'CONFIRME': return Icons.thumb_up;
      case 'REJETE': return Icons.cancel;
      default: return Icons.access_time;
    }
  }
}