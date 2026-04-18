import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:file_picker/file_picker.dart' as file_picker;

class SupportsScreen extends StatefulWidget {
  @override
  _SupportsScreenState createState() => _SupportsScreenState();
}

class _SupportsScreenState extends State<SupportsScreen> {
  final List<Map<String, dynamic>> supports = [
    {
      'titre': 'Cours Chapitre 1 - Introduction',
      'matiere': 'Informatique',
      'type': 'PDF',
      'date': '2024-03-10',
      'taille': '2.4 MB',
      'icon': Icons.picture_as_pdf,
      'couleur': Colors.red,
    },
    {
      'titre': 'TD Exercices Chapitre 2',
      'matiere': 'Mathematiques',
      'type': 'WORD',
      'date': '2024-03-12',
      'taille': '1.1 MB',
      'icon': Icons.description,
      'couleur': Colors.blue,
    },
  ];

  void _ajouterSupport(String titre, String matiere, String type) {
    setState(() {
      supports.add({
        'titre': titre,
        'matiere': matiere,
        'type': type.toUpperCase(),
        'date': DateTime.now().toString().split(' ')[0],
        'taille': '0.0 MB',
        'icon': type.toUpperCase() == 'PDF' ? Icons.picture_as_pdf : Icons.description,
        'couleur': type.toUpperCase() == 'PDF' ? Colors.red : Colors.blue,
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Header stats
        Container(
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF00855A), Color(0xFF003D29)],
            ),
          ),
          child: Row(
            children: [
              _buildStatBadge('Total', '${supports.length}', Colors.white),
              SizedBox(width: 12),
              _buildStatBadge('PDF', '${supports.where((s) => s['type'] == 'PDF').length}', Colors.redAccent),
              SizedBox(width: 12),
              _buildStatBadge('Autres', '${supports.where((s) => s['type'] != 'PDF').length}', Colors.blueAccent),
            ],
          ),
        ),

        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: supports.length,
            itemBuilder: (context, index) {
              final s = supports[index];
              return _buildCard(s);
            },
          ),
        ),

        Padding(
          padding: EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: ElevatedButton.icon(
              onPressed: () => _showAddSupportDialog(context),
              icon: Icon(Icons.upload_file, color: Colors.white),
              label: Text('Ajouter un support',
                  style: TextStyle(color: Colors.white, fontSize: 15,
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
  }

  Widget _buildCard(Map<String, dynamic> s) {
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
        padding: EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: (s['couleur'] as Color).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(s['icon'] as IconData,
                  color: s['couleur'] as Color, size: 24),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(s['titre'],
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 4),
                  Text(s['matiere'],
                      style: TextStyle(
                          color: Color(0xFF00855A),
                          fontSize: 12,
                          fontWeight: FontWeight.w500)),
                  SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.calendar_today, size: 11, color: Colors.grey),
                    SizedBox(width: 3),
                    Text(s['date'],
                        style: TextStyle(color: Colors.grey, fontSize: 11)),
                  ]),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.download, color: Color(0xFF00855A), size: 20),
              onPressed: () {},
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
                      // Importation réelle de fichier
                      try {
                        final result = await file_picker.FilePicker.platform.pickFiles(
                          type: file_picker.FileType.custom,
                          allowedExtensions: ['pdf', 'doc', 'docx', 'ppt', 'pptx'],
                        );

                        if (result != null) {
                          setDialogState(() {
                            fileName = result.files.single.name;
                            double sizeMb = result.files.single.size / (1024 * 1024);
                            fileSize = '${sizeMb.toStringAsFixed(1)} MB';
                            
                            // Auto-détection du type et titre si vide
                            if (titreController.text.isEmpty) {
                              titreController.text = fileName!.split('.').first;
                            }
                            String ext = fileName!.split('.').last.toUpperCase();
                            if (['DOC', 'DOCX'].contains(ext)) typeSelectionne = 'WORD';
                            else if (['PPT', 'PPTX'].contains(ext)) typeSelectionne = 'PPT';
                            else if (ext == 'PDF') typeSelectionne = 'PDF';
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
                  value: typeSelectionne,
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
                  setState(() {
                    supports.add({
                      'titre': titreController.text,
                      'matiere': matiereController.text.isEmpty ? 'Général' : matiereController.text,
                      'type': typeSelectionne,
                      'date': DateTime.now().toString().split(' ')[0],
                      'taille': fileSize ?? '0.0 MB',
                      'icon': typeSelectionne == 'PDF' ? Icons.picture_as_pdf : Icons.description,
                      'couleur': typeSelectionne == 'PDF' ? Colors.red : Colors.blue,
                    });
                  });
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
          color: Colors.white.withOpacity(0.15),
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