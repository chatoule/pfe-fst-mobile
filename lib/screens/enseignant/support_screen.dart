import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart' as file_picker;
import '../../controllers/shared_controller.dart';
import '../common/pdf_viewer_screen.dart';

class SupportsScreen extends StatefulWidget {
  final bool isReadOnly;

  const SupportsScreen({super.key, this.isReadOnly = false});

  @override
  State<SupportsScreen> createState() => _SupportsScreenState();
}

class _SupportsScreenState extends State<SupportsScreen> {
  final SharedController controller = SharedController.to;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final supports = controller.supportsDeCours;
      return Column(
        children: [
          // Header stats
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                _buildStatBadge('Total', '${supports.length}', Colors.white),
                const SizedBox(width: 12),
                _buildStatBadge('PDF', '${supports.where((s) => s['type'] == 'PDF').length}', Colors.redAccent),
                const SizedBox(width: 12),
                _buildStatBadge('Autres', '${supports.where((s) => s['type'] != 'PDF').length}', Colors.blueAccent),
              ],
            ),
          ),

          Expanded(
            child: supports.isEmpty
                ? const Center(child: Text('Aucun support disponible'))
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: supports.length,
                    itemBuilder: (context, index) {
                      final s = supports[index];
                      return _buildCard(s);
                    },
                  ),
          ),

          if (!widget.isReadOnly)
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _showAddSupportDialog(context),
                  icon: const Icon(Icons.upload_file, color: Colors.white),
                  label: const Text('Ajouter un support',
                      style: TextStyle(color: Colors.white, fontSize: 15,
                          fontWeight: FontWeight.bold)),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00855A),
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

  Widget _buildCard(Map<String, dynamic> s) {
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
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (s['couleur'] as Color).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s['icon'] as IconData,
                  color: s['couleur'] as Color, size: 24),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: GestureDetector(
                onTap: () {
                  if (s['type'] == 'PDF' && s['path'] != null) {
                    Get.to(() => PdfViewerScreen(
                      titre: s['titre'],
                      filePath: s['path'],
                    ));
                  } else if (s['type'] == 'PDF') {
                    Get.snackbar('Information', 'Ce PDF est un exemple statique sans fichier réel.',
                        backgroundColor: Colors.blue, colorText: Colors.white);
                  }
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(s['titre'],
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29))),
                    const SizedBox(height: 4),
                    Text(s['matiere'],
                        style: const TextStyle(
                            color: Color(0xFF00855A),
                            fontSize: 12,
                            fontWeight: FontWeight.w500)),
                    const SizedBox(height: 2),
                    Row(children: [
                      const Icon(Icons.calendar_today, size: 11, color: Colors.grey),
                      const SizedBox(width: 3),
                      Text(s['date'],
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),
                      const SizedBox(width: 8),
                      Text('• ${s['taille']}',
                          style: const TextStyle(color: Colors.grey, fontSize: 11)),
                    ]),
                  ],
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.download, color: Color(0xFF00855A), size: 20),
              onPressed: () => controller.telechargerSupport(s['titre']),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddSupportDialog(BuildContext context) async {
    final titreController = TextEditingController();
    final matiereController = TextEditingController();
    String typeSelectionne = 'PDF';
    String? fileName;
    String? fileSize;

    String? filePath;

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Ajouter un support'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titreController,
                  decoration: const InputDecoration(labelText: 'Titre du support'),
                ),
                TextField(
                  controller: matiereController,
                  decoration: const InputDecoration(labelText: 'Matière'),
                ),
                const SizedBox(height: 20),
                if (fileName != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.green[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.green[200]!),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.attach_file, color: Colors.green, size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(fileName!,
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                              overflow: TextOverflow.ellipsis),
                        ),
                        Text(fileSize ?? '', style: const TextStyle(fontSize: 10, color: Colors.grey)),
                      ],
                    ),
                  ),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    onPressed: () async {
                      try {
                        final result = await file_picker.FilePicker.platform.pickFiles(
                          type: file_picker.FileType.custom,
                          allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
                        );

                        if (result != null) {
                          setDialogState(() {
                            fileName = result.files.single.name;
                            filePath = result.files.single.path;
                            double sizeMb = result.files.single.size / (1024 * 1024);
                            fileSize = '${sizeMb.toStringAsFixed(1)} MB';
                            
                            if (titreController.text.isEmpty) {
                              titreController.text = fileName!.split('.').first;
                            }
                            String ext = fileName!.split('.').last.toUpperCase();
                            if (['DOC', 'DOCX'].contains(ext)) {
                              typeSelectionne = 'WORD';
                            } else if (['PPT', 'PPTX'].contains(ext)) {
                              typeSelectionne = 'PPT';
                            } else if (ext == 'PDF') {
                              typeSelectionne = 'PDF';
                            }
                          });
                        }
                      } catch (e) {
                        print("Erreur picking: $e");
                      }
                    },
                    icon: const Icon(Icons.file_open),
                    label: Text(fileName == null ? 'Choisir un fichier' : 'Changer de fichier'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: const Color(0xFF00855A),
                      side: const BorderSide(color: Color(0xFF00855A)),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                DropdownButtonFormField<String>(
                  initialValue: typeSelectionne,
                  decoration: const InputDecoration(labelText: 'Type de document'),
                  items: ['PDF', 'WORD', 'PPT'].map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: (newValue) {
                    setDialogState(() {
                      typeSelectionne = newValue!;
                    });
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(context), child: const Text('Annuler')),
            ElevatedButton(
              onPressed: () {
                if (titreController.text.isNotEmpty && fileName != null) {
                  controller.ajouterSupport(
                    titreController.text,
                    matiereController.text.isEmpty ? 'Général' : matiereController.text,
                    typeSelectionne,
                    fileSize ?? '0.0 MB',
                    path: filePath
                  );
                  Navigator.pop(context);
                  Get.snackbar(
                    'Succès', 
                    'Le support a été téléchargé avec succès.',
                    backgroundColor: const Color(0xFF00855A),
                    colorText: Colors.white,
                  );
                } else if (fileName == null) {
                  Get.snackbar('Attention', 'Veuillez sélectionner un fichier',
                    backgroundColor: Colors.orange, colorText: Colors.white);
                }
              },
              style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00855A)),
              child: const Text('Télécharger', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            Text(valeur,
                style: TextStyle(
                    color: couleur,
                    fontSize: 20,
                    fontWeight: FontWeight.bold)),
            Text(label,
                style: TextStyle(color: Colors.white70, fontSize: 11)),
          ],
        ),
      ),
    );
  }
}