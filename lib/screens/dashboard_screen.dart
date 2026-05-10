import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';
import '../controllers/shared_controller.dart';
import '../widgets/app_drawer.dart';

class DashboardScreen extends StatelessWidget {
  final AuthController _authController = Get.find<AuthController>();
  final SharedController _sharedController = Get.find<SharedController>();

  DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: const Text('Tableau de bord', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          )
        ],
      ),
      drawer: const AppDrawer(),
      body: RefreshIndicator(
        onRefresh: () async {
          await _sharedController.rafraichirDonnees();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
            Obx(() {
              final user = _authController.utilisateur.value;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF00855A), Color(0xFF003D29)],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF003D29).withValues(alpha: 0.3),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    )
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Bienvenue,',
                      style: TextStyle(color: Colors.white70, fontSize: 14),
                    ),
                    Text(
                      user != null ? '${user.prenom} ${user.nom}' : 'Utilisateur',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        user?.role ?? 'ENSEIGNANT',
                        style: const TextStyle(color: Colors.white, fontSize: 11, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'Statistiques de pointage',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003D29)),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final fiches = _sharedController.fichesPointage;
              final total = fiches.length;
              final validees = fiches.where((f) => f['statut'] == 'VALIDE').length;
              final attentes = fiches.where((f) => f['statut'] == 'EN_COURS' || f['statut'] == 'CONFIRME').length;
              final rejetees = fiches.where((f) => f['statut'] == 'REJETE').length;

              return GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.5,
                children: [
                  _buildStatCard('Total fiches', '$total', Colors.blue, Icons.description),
                  _buildStatCard('Validées', '$validees', const Color(0xFF00855A), Icons.check_circle),
                  _buildStatCard('En attente', '$attentes', Colors.orange, Icons.hourglass_empty),
                  _buildStatCard('Rejetées', '$rejetees', Colors.red, Icons.cancel),
                ],
              );
            }),
            const SizedBox(height: 24),
            const Text(
              'À pointer aujourd\'hui',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003D29)),
            ),
            const SizedBox(height: 12),
            Obx(() {
              final cours = _sharedController.coursDuJour;
              if (cours.isEmpty) {
                return Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.grey.shade200),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.event_busy, color: Colors.grey, size: 40),
                      const SizedBox(height: 8),
                      const Text('Aucun cours prévu aujourd\'hui', style: TextStyle(color: Colors.grey)),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        onPressed: () => Get.toNamed('/fiche-pointage'),
                        icon: const Icon(Icons.add),
                        label: const Text('POINTAGE LIBRE'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF00855A),
                          foregroundColor: Colors.white,
                        ),
                      )
                    ],
                  ),
                );
              }
              return SizedBox(
                height: 160,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: cours.length,
                  itemBuilder: (context, index) {
                    final c = cours[index];
                    return Container(
                      width: 300,
                      margin: const EdgeInsets.only(right: 16),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10)
                        ],
                        border: Border.all(color: const Color(0xFF00855A).withValues(alpha: 0.2)),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF00855A).withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(c['heure'], style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF00855A), fontSize: 12)),
                              ),
                              const Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey),
                            ],
                          ),
                          const SizedBox(height: 10),
                          Text(c['matiere'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16), maxLines: 1, overflow: TextOverflow.ellipsis),
                          Text(c['niveau'], style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                          const Spacer(),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () => Get.toNamed('/fiche-pointage', arguments: c),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF00855A),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                              ),
                              child: const Text('POINTER CETTE SÉANCE', style: TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              );
            }),
            const SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Mes dernières séances',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF003D29)),
                ),
                TextButton(
                  onPressed: () {}, // Voir tout l'historique
                  child: const Text('Voir tout', style: TextStyle(color: Color(0xFF00855A))),
                )
              ],
            ),
            const SizedBox(height: 8),
            Obx(() {
              final fiches = _sharedController.fichesPointage;
              if (fiches.isEmpty) {
                return Center(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    child: const Column(
                      children: [
                        Icon(Icons.history, size: 48, color: Colors.grey),
                        SizedBox(height: 8),
                        Text('Aucune séance enregistrée', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              }
              return ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: fiches.length > 5 ? 5 : fiches.length,
                itemBuilder: (context, index) {
                  final f = fiches[fiches.length - 1 - index];
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    elevation: 2,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      leading: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00855A).withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.book, color: Color(0xFF00855A)),
                      ),
                      title: Text(f['matiere'], style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text('${f['dateSeance']} • ${f['heureDebut']}'),
                      trailing: _buildStatutBadge(f['statut']),
                    ),
                  );
                },
              );
            }),
          ],
        ),
      ),
    ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Naviguer vers le pointage avec un objet de cours structuré
          Get.toNamed('/fiche-pointage', arguments: {
            'matiere': 'Nouveau Module',
            'dateSeance': DateTime.now().toString().split(' ')[0],
            'heureDebut': '08h00',
            'heureFin': '10h00',
            'niveau': 'L3',
            'semestre': 'S1',
          });
        },
        label: const Text('POINTER UNE SEANCE', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        icon: const Icon(Icons.add, color: Colors.white),
        backgroundColor: const Color(0xFF00855A),
      ),
    );
  }

  Widget _buildStatCard(String titre, String valeur, Color couleur, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: couleur, size: 20),
          const SizedBox(height: 8),
          Text(
            valeur,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: couleur),
          ),
          Text(
            titre,
            style: TextStyle(fontSize: 11, color: Colors.grey[600], fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget _buildStatutBadge(String statut) {
    Color color;
    switch (statut) {
      case 'VALIDE': color = Colors.green; break;
      case 'CONFIRME': color = Colors.blue; break;
      case 'REJETE': color = Colors.red; break;
      default: color = Colors.orange;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.5)),
      ),
      child: Text(
        statut,
        style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.bold),
      ),
    );
  }
}
