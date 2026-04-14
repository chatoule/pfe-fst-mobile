class ModulesData {
  static const List<Map<String, dynamic>> modules = [
    {
      'code': 'ALG101',
      'intitule': 'Algorithme',
      'semestre': 'S1',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFF2196F3,
    },
    {
      'code': 'ABL102',
      'intitule': 'Algebre de Boole',
      'semestre': 'S1',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF9C27B0,
    },
    {
      'code': 'STD103',
      'intitule': 'Structure de Donnees',
      'semestre': 'S2',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFF00855A,
    },
    {
      'code': 'CGE104',
      'intitule': 'Creation et Gestion des Entreprises',
      'semestre': 'S1',
      'coefficient': '2',
      'volumeHoraire': '30',
      'couleur': 0xFFFF9800,
    },
    {
      'code': 'TIC105',
      'intitule': 'Environnement TIC et Architecture des Ordinateurs',
      'semestre': 'S1',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF607D8B,
    },
    {
      'code': 'CIS106',
      'intitule': 'Culture Islamique',
      'semestre': 'S1',
      'coefficient': '2',
      'volumeHoraire': '30',
      'couleur': 0xFF4CAF50,
    },
    {
      'code': 'ARA107',
      'intitule': 'Langue Arabe',
      'semestre': 'S1',
      'coefficient': '2',
      'volumeHoraire': '30',
      'couleur': 0xFF795548,
    },
    {
      'code': 'CAL108',
      'intitule': 'Calcul Integral et Equation Differentielle',
      'semestre': 'S2',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFFE91E63,
    },
    {
      'code': 'ANG109',
      'intitule': 'Anglais Technique',
      'semestre': 'S1',
      'coefficient': '2',
      'volumeHoraire': '30',
      'couleur': 0xFF009688,
    },
    {
      'code': 'ELN110',
      'intitule': 'Electronique Numerique',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFFFF5722,
    },
    {
      'code': 'PRB111',
      'intitule': 'Probabilite et Statistique',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF3F51B5,
    },
    {
      'code': 'MIC112',
      'intitule': 'Programmation des Microcontroleurs et Robotique',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF673AB7,
    },
    {
      'code': 'ADM113',
      'intitule': 'Administration Serveur Windows',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF0288D1,
    },
    {
      'code': 'ACS114',
      'intitule': 'Analyse et Conception des SI: Merise/UML',
      'semestre': 'S2',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFFF44336,
    },
    {
      'code': 'PHP115',
      'intitule': 'Programmation PHP',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF7986CB,
    },
    {
      'code': 'LNX116',
      'intitule': 'Systeme Linux Shell',
      'semestre': 'S2',
      'coefficient': '3',
      'volumeHoraire': '45',
      'couleur': 0xFF455A64,
    },
    {
      'code': 'WEB117',
      'intitule': 'Technologie Web et Framework (JS, Flutter)',
      'semestre': 'S2',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFF00BCD4,
    },
    {
      'code': 'JAV118',
      'intitule': 'Programmation Java',
      'semestre': 'S2',
      'coefficient': '4',
      'volumeHoraire': '60',
      'couleur': 0xFFFF6F00,
    },
  ];

  // Modules par semestre
  static List<Map<String, dynamic>> getModulesBySemestre(String semestre) {
    return modules.where((m) => m['semestre'] == semestre).toList();
  }

  // Rechercher un module
  static List<Map<String, dynamic>> rechercher(String query) {
    return modules
        .where((m) => m['intitule']
        .toString()
        .toLowerCase()
        .contains(query.toLowerCase()))
        .toList();
  }
}