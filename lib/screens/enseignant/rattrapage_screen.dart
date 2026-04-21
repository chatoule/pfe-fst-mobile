import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/shared_controller.dart';

class RattrapagesScreen extends StatelessWidget {
  final controller = SharedController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final rattrapages = controller.rattrapages;
      final enAttente =
          rattrapages.where((r) => r['statut'] == 'EN_ATTENTE').length;
      final valides =
          rattrapages.where((r) => r['statut'] == 'VALIDE').length;

      return Column(
        children: [
          // Stats header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                _buildStatBadge('Total', '${rattrapages.length}', Colors.white),
                SizedBox(width: 12),
                _buildStatBadge('En attente', '$enAttente', Colors.orange),
                SizedBox(width: 12),
                _buildStatBadge('Valides', '$valides', Colors.greenAccent),
              ],
            ),
          ),

          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: rattrapages.length,
              itemBuilder: (context, index) {
                final r = rattrapages[index];
                return _buildCard(r);
              },
            ),
          ),

          Padding(
            padding: EdgeInsets.all(16),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                onPressed: () => _showDemandeRattrapage(context),
                icon: Icon(Icons.add, color: Colors.white),
                label: Text('Demander un rattrapage',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.bold)),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF00855A),
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildCard(Map<String, String> r) {
    Color couleur;
    IconData icon;
    switch (r['statut']) {
      case 'VALIDE':
        couleur = Color(0xFF00855A);
        icon = Icons.check_circle;
        break;
      case 'REJETE':
        couleur = Colors.red;
        icon = Icons.cancel;
        break;
      case 'EN_ATTENTE':
        couleur = Colors.orange;
        icon = Icons.hourglass_empty;
        break;
      default:
        couleur = Colors.grey;
        icon = Icons.schedule;
    }

    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: couleur.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(icon, color: couleur, size: 24),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(r['matiere']!,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 15,
                              color: Color(0xFF003D29))),
                      SizedBox(height: 4),
                      Wrap(
                        spacing: 10,
                        runSpacing: 4,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.calendar_today,
                                  size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(r['date']!,
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.access_time, size: 12, color: Colors.grey),
                              SizedBox(width: 4),
                              Text(r['heure']!,
                                  style:
                                      TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 8),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: couleur.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: couleur.withOpacity(0.3)),
                  ),
                  child: Text(r['statut']!,
                      style: TextStyle(
                          color: couleur,
                          fontWeight: FontWeight.bold,
                          fontSize: 10)),
                ),
              ],
            ),
            if (r['statut'] == 'EN_ATTENTE') ...[
              Divider(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: _buildValidationStatus('Superviseur', true)),
                  Icon(Icons.arrow_forward, size: 16, color: Colors.grey),
                  Expanded(child: _buildValidationStatus('Chef Dept.', false)),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildValidationStatus(String role, bool isOk) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(isOk ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 14, color: isOk ? Colors.green : Colors.orange),
        SizedBox(width: 4),
        Flexible(
          child: Text(role,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(fontSize: 11, color: Colors.grey[700])),
        ),
      ],
    );
  }

  Widget _buildStatBadge(String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(valeur,
                style: TextStyle(
                    color: couleur, fontSize: 20, fontWeight: FontWeight.bold)),
            Text(label, style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }

  void _showDemandeRattrapage(BuildContext context) {
    final matiereController = TextEditingController();
    final dateController = TextEditingController();
    final heureController = TextEditingController();
    final motifController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        scrollable: true,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Icon(Icons.replay, color: Color(0xFF00855A)),
            SizedBox(width: 8),
            Expanded(
              child: Text(
                'Demander un rattrapage',
                style: TextStyle(fontSize: 18),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildDialogField('Matière', Icons.book, matiereController),
              SizedBox(height: 12),
              _buildDialogField(
                  'Date souhaitée', Icons.calendar_today, dateController),
              SizedBox(height: 12),
              _buildDialogField(
                  'Heure (ex: 08h-10h)', Icons.access_time, heureController),
              SizedBox(height: 12),
              _buildDialogField('Motif', Icons.note, motifController,
                  maxLines: 3),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text('Annuler', style: TextStyle(color: Colors.grey)),
          ),
          ElevatedButton(
            onPressed: () {
              if (matiereController.text.isNotEmpty) {
                // Envoyer la demande au contrôleur
                controller.ajouterRattrapage(
                  matiereController.text,
                  dateController.text.isEmpty ? 'Aujourd\'hui' : dateController.text,
                  heureController.text.isEmpty ? 'Non spécifié' : heureController.text,
                  'A définir',
                );

                // Fermer le dialogue
                Navigator.of(context).pop();

                // Notification de succès
                Get.snackbar(
                  'Demande Envoyée',
                  'Votre demande de rattrapage pour ${matiereController.text} a été transmise.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Color(0xFF00855A),
                  colorText: Colors.white,
                  duration: Duration(seconds: 4),
                  icon: Icon(Icons.send, color: Colors.white),
                  margin: EdgeInsets.all(15),
                );
              } else {
                // Feedback si la matière est vide
                Get.snackbar(
                  'Champ requis',
                  'Veuillez au moins renseigner la matière.',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.orange,
                  colorText: Colors.white,
                );
              }
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            child: Text('Envoyer', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildDialogField(String label, IconData icon,
      TextEditingController controller,
      {int maxLines = 1}) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Color(0xFF00855A), size: 20),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: Color(0xFF00855A)),
        ),
      ),
    );
  }
}