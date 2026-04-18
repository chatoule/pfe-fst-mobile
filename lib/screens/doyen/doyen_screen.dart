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
  final SharedController _sharedController = SharedController.to;
  final AuthController _authController = AuthController.to;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        title: const Text('Tableau de Bord Stratégique', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF003D29),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(icon: const Icon(Icons.refresh), onPressed: () => _sharedController.refresh()),
          IconButton(icon: const Icon(Icons.logout), onPressed: () => _authController.logout()),
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
              const Text('Flux d\'activités en temps réel', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003D29))),
              const SizedBox(height: 12),
              _buildActivityFeed(),
              const SizedBox(height: 30),
            ],
          ),
        );
      }),
    );
  }

  Widget _buildDepartementSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 5)],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _sharedController.selectedDepartement.value,
          isExpanded: true,
          items: _sharedController.departements.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
            );
          }).toList(),
          onChanged: (newValue) {
            if (newValue != null) {
              _sharedController.selectedDepartement.value = newValue;
            }
          },
        ),
      ),
    );
  }

  Widget _buildWelcomeHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFF003D29), Color(0xFF00855A)]),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Bienvenue, Monsieur le Doyen', style: TextStyle(color: Colors.white70, fontSize: 14)),
                const SizedBox(height: 4),
                Text(_sharedController.nomDoyen.value, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                  child: const Text('Faculté des Sciences et Techniques', style: TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ],
            ),
          ),
          Image.asset('assets/images/logo_uin.png', width: 70, height: 70),
        ],
      ),
    );
  }

  Widget _buildStatsGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Séances Validées', '${_sharedController.seancesValidees}', Icons.check_circle, Colors.green),
        _buildStatCard('En Attente', '${_sharedController.seancesEnAttente}', Icons.hourglass_empty, Colors.orange),
        _buildStatCard('Taux Présence', '88%', Icons.people, Colors.blue),
        _buildStatCard('Départements', '04', Icons.account_balance, Colors.purple),
      ],
    );
  }

  Widget _buildStatCard(String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          Text(label, style: const TextStyle(fontSize: 11, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildChartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(20), boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Répartition des Pointages', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 4,
                centerSpaceRadius: 40,
                sections: [
                  PieChartSectionData(value: _sharedController.seancesValidees.toDouble(), color: Colors.green, title: 'Validés', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: _sharedController.seancesEnAttente.toDouble(), color: Colors.orange, title: 'Attente', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  PieChartSectionData(value: 2, color: Colors.red, title: 'Rejetés', radius: 50, titleStyle: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildChartLegend(),
        ],
      ),
    );
  }

  Widget _buildChartLegend() {
    return Wrap(
      spacing: 16,
      children: [
        _buildLegendItem('Validés', Colors.green),
        _buildLegendItem('En attente', Colors.orange),
        _buildLegendItem('Rejetés', Colors.red),
      ],
    );
  }

  Widget _buildLegendItem(String label, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(width: 12, height: 12, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 6),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }

  Widget _buildActivityFeed() {
    final activities = _sharedController.filteredFiches.reversed.toList();
    if (activities.isEmpty) return const Center(child: Padding(padding: EdgeInsets.all(20), child: Text('Aucune activité pour ce département')));

    return Column(
      children: [
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: activities.length > 5 ? 5 : activities.length,
          itemBuilder: (context, index) {
            final a = activities[index];
            return Card(
              elevation: 0,
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _getStatusColor(a['statut']).withOpacity(0.1),
                  child: Icon(_getStatusIcon(a['statut']), color: _getStatusColor(a['statut']), size: 20),
                ),
                title: Text(a['matiere'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis),
                subtitle: Text('Par ${a['enseignantNom']}', style: const TextStyle(fontSize: 12)),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(a['statut'], style: TextStyle(color: _getStatusColor(a['statut']), fontWeight: FontWeight.bold, fontSize: 10)),
                    Text(a['heureDebut'], style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  ],
                ),
              ),
            );
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          height: 50,
          child: ElevatedButton.icon(
            onPressed: () {
              // Exportation globale de l'état de vacation pour le Doyen
              final data = _sharedController.getVacatairesData();
              if (data.isNotEmpty) {
                Get.snackbar(
                  'Préparation de l\'export',
                  'Génération de l\'état global des vacations...',
                  backgroundColor: const Color(0xFF003D29),
                  colorText: Colors.white,
                  duration: const Duration(seconds: 2),
                );
                
                final formattedVacations = data.map((v) => {
                  'enseignantNom': '${v['prenom']} ${v['nom']}',
                  'matiere': v['matiere'],
                  'totalHeures': v['totalHeures'],
                  'tauxHoraire': v['tauxHoraire'],
                }).toList();

                ExportService.exporterEtatVacationPDF(formattedVacations);
              } else {
                Get.snackbar('Information', 'Aucune séance validée à exporter.',
                  backgroundColor: Colors.orange, colorText: Colors.white);
              }
            },
            icon: const Icon(Icons.description, color: Colors.white),
            label: const Text('Générer l\'état de vacation global', 
              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF003D29),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }

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
