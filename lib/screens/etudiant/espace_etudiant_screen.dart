// lib/screens/etudiant/espace_etudiant_screen.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shared_controller.dart';
import 'justificatif_screen.dart';
import '../enseignant/support_screen.dart';

class EspaceEtudiantScreen extends StatefulWidget {
  const EspaceEtudiantScreen({super.key});

  @override
  State<EspaceEtudiantScreen> createState() => _EspaceEtudiantScreenState();
}

class _EspaceEtudiantScreenState extends State<EspaceEtudiantScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  // ✅ CORRIGÉ : getter sécurisé pour l'ID étudiant
  int get _etudiantId => _authController.utilisateur.value?.id ?? 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_getTitre(),
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: const Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => _authController.logout(),
          ),
        ],
      ),
      drawer: _buildDrawer(),
      body: _getScreen(),
    );
  }

  Widget _buildDrawer() {
    return Drawer(
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(
                top: 50, bottom: 24, left: 20, right: 20),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Color(0xFF00A86B), Color(0xFF003D29)],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final user = _authController.utilisateur.value;
                    return Center(
                      child: Text(
                        user != null
                            ? '${user.prenom[0]}${user.nom[0]}'
                            : 'E',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 12),
                Obx(() => Text(
                  '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                const SizedBox(height: 4),
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text('ÉTUDIANT',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                const SizedBox(height: 4),
                Obx(() => Text(
                  _authController.utilisateur.value?.email ?? '',
                  style: const TextStyle(
                      color: Colors.white70, fontSize: 11),
                )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Mon Espace'),
                _buildDrawerItem(
                    1, Icons.event_busy_outlined, 'Mes Absences'),
                _buildDrawerItem(
                    2, Icons.upload_file_outlined, 'Justificatifs'),
                _buildDrawerItem(
                    3, Icons.library_books_outlined, 'Supports de cours'),
              ],
            ),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.red),
            title: const Text('Se déconnecter',
                style: TextStyle(
                    color: Colors.red, fontWeight: FontWeight.w500)),
            onTap: () => _authController.logout(),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text('FST - UIN v1.0',
                style: TextStyle(color: Colors.grey, fontSize: 11)),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(int index, IconData icon, String label) {
    final isActive = _currentIndex == index;
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFF00855A).withValues(alpha: 0.1)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? const Color(0xFF00855A) : Colors.grey[600],
            size: 22),
        title: Text(label,
            style: TextStyle(
                color: isActive
                    ? const Color(0xFF00855A)
                    : Colors.grey[800],
                fontWeight:
                isActive ? FontWeight.bold : FontWeight.normal,
                fontSize: 14)),
        onTap: () {
          setState(() => _currentIndex = index);
          Navigator.pop(context);
        },
      ),
    );
  }

  String _getTitre() {
    switch (_currentIndex) {
      case 0: return 'Mon Espace';
      case 1: return 'Mes Absences';
      case 2: return 'Mes Justificatifs';
      case 3: return 'Supports de cours';
      default: return 'Étudiant';
    }
  }

  Widget _getScreen() {
    switch (_currentIndex) {
      case 0: return _buildDashboard();
      case 1: return _buildAbsences();
      case 2: return _buildJustificatifs();
      case 3: return const SupportsScreen(isReadOnly: true);
      default: return _buildDashboard();
    }
  }

  // ===================== DASHBOARD =====================
  Widget _buildDashboard() {
    // ✅ CORRIGÉ : vérification que l'utilisateur est connecté
    if (_etudiantId == 0) {
      return const Center(
        child: Text('Utilisateur non connecté',
            style: TextStyle(color: Colors.grey)),
      );
    }

    return Obx(() {
      final presences =
      SharedController.to.getPresencesEtudiant(_etudiantId);
      final absences =
      SharedController.to.getAbsencesEtudiant(_etudiantId);
      final taux = SharedController.to.getTauxPresence(_etudiantId);
      final tauxStr = taux.toStringAsFixed(1);
      final tauxOk = taux >= 75;
      final enRattrapage =
      SharedController.to.estEnSessionRattrapage(_etudiantId);
      final user = _authController.utilisateur.value;

      return SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Color(0xFF00855A), Color(0xFF003D29)],
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                          border:
                          Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user != null
                                ? '${user.prenom[0]}${user.nom[0]}'
                                : 'E',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Bonjour,',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text(
                            '${user?.prenom ?? ""} ${user?.nom ?? ""}',
                            style: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  const Text('Étudiant - FST UIN',
                      style: TextStyle(
                          color: Colors.white60, fontSize: 12)),
                  const SizedBox(height: 20),

                  // Taux de présence
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Taux de présence',
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12)),
                              const SizedBox(height: 4),
                              Text('$tauxStr%',
                                  style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              const SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: taux / 100,
                                  backgroundColor:
                                  Colors.white.withValues(alpha: 0.2),
                                  color: tauxOk
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 16),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: tauxOk
                                ? Colors.greenAccent.withValues(alpha: 0.2)
                                : Colors.redAccent.withValues(alpha: 0.2),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            tauxOk
                                ? Icons.check_circle
                                : Icons.warning_rounded,
                            color: tauxOk
                                ? Colors.greenAccent
                                : Colors.redAccent,
                            size: 28,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alerte session rattrapage
                  if (enRattrapage)
                    Container(
                      padding: const EdgeInsets.all(14),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 24),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              children: [
                                const Text('SESSION DE RATTRAPAGE DIRECTE',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                const SizedBox(height: 4),
                                Text(
                                  'Vous avez ${SharedController.to.getNombreAbsencesNonJustifiees(_etudiantId)} absences non justifiées. Vous êtes automatiquement transféré en session de rattrapage.',
                                  style: TextStyle(
                                      color: Colors.red[700],
                                      fontSize: 11),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Alerte taux insuffisant
                  if (!tauxOk && !enRattrapage)
                    Container(
                      padding: const EdgeInsets.all(12),
                      margin: const EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border:
                        Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.info_outline,
                              color: Colors.orange, size: 20),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Attention ! Votre taux de présence est insuffisant. Le minimum requis est 75%.',
                              style: TextStyle(
                                  color: Colors.orange[700],
                                  fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Stats
                  const Text('Mes statistiques',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildStatCard('Total', presences.length,
                          const Color(0xFF00855A), Icons.list_alt),
                      const SizedBox(width: 12),
                      _buildStatCard(
                          'Présents',
                          presences.where((p) => p.estPresent).length,
                          Colors.blue,
                          Icons.check_circle_outline),
                      const SizedBox(width: 12),
                      _buildStatCard('Absences', absences.length,
                          Colors.red, Icons.cancel_outlined),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Actions rapides
                  const Text('Actions rapides',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  const SizedBox(height: 12),

                  Row(
                    children: [
                      _buildActionCard('Mes Absences',
                          Icons.event_busy, Colors.orange, 1),
                      const SizedBox(width: 12),
                      _buildActionCard('Justificatifs',
                          Icons.upload_file, Colors.purple, 2),
                      const SizedBox(width: 12),
                      _buildActionCard('Supports',
                          Icons.library_books, Colors.blue, 3),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Absences récentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Absences récentes',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      if (absences.isNotEmpty)
                        TextButton(
                          onPressed: () =>
                              setState(() => _currentIndex = 1),
                          child: const Text('Voir tout',
                              style: TextStyle(
                                  color: Color(0xFF00855A),
                                  fontSize: 13)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),

                  if (absences.isEmpty)
                    _buildEmptyState(
                        'Aucune absence !', Icons.celebration)
                  else
                    ...absences
                        .take(3)
                        .map((absence) => _buildAbsenceCard(absence)),
                ],
              ),
            ),
          ],
        ),
      );
    });
  }

  // ===================== ABSENCES =====================
  Widget _buildAbsences() {
    // ✅ CORRIGÉ : vérification ID
    if (_etudiantId == 0) {
      return const Center(
          child: Text('Utilisateur non connecté'));
    }

    return Obx(() {
      final absences =
      SharedController.to.getAbsencesEtudiant(_etudiantId);
      if (absences.isEmpty) {
        return Center(
            child:
            _buildEmptyState('Aucune absence !', Icons.celebration));
      }
      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: absences.length,
        itemBuilder: (context, index) =>
            _buildAbsenceCard(absences[index]),
      );
    });
  }

  // ===================== JUSTIFICATIFS =====================
  Widget _buildJustificatifs() {
    if (_etudiantId == 0) {
      return const Center(
          child: Text('Utilisateur non connecté'));
    }

    return Obx(() {
      final absences =
      SharedController.to.getAbsencesEtudiant(_etudiantId);

      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline,
                    color: Colors.white70, size: 18),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Soumettez un justificatif pour chaque absence. Le Chef de Département validera ou rejettera votre demande.',
                    style:
                    TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),
          if (absences.isEmpty)
            Expanded(
              child: Center(
                child: _buildEmptyState(
                    'Aucune absence à justifier',
                    Icons.celebration),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: absences.length,
                itemBuilder: (context, index) =>
                    _buildJustificatifCard(absences[index]),
              ),
            ),
        ],
      );
    });
  }

  // ===================== WIDGETS =====================
  Widget _buildAbsenceCard(dynamic absence) {
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.red.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.event_busy,
                  color: Colors.red, size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    absence.matiere ??
                        'Cours du ${absence.dateSeance}',
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF003D29)),
                  ),
                  const SizedBox(height: 2),
                  Row(children: [
                    const Icon(Icons.calendar_today,
                        size: 12, color: Colors.grey),
                    const SizedBox(width: 4),
                    Text(absence.dateSeance,
                        style: const TextStyle(
                            color: Colors.grey, fontSize: 12)),
                  ]),
                  if (absence.statutJustification != null) ...[
                    const SizedBox(height: 4),
                    _buildStatutJustif(absence.statutJustification!),
                  ],
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() =>
                  JustificatifScreen(presenceId: absence.id)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding: const EdgeInsets.symmetric(
                    horizontal: 14, vertical: 10),
              ),
              child: const Text('Justifier',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildJustificatifCard(dynamic absence) {
    final aJustificatif = absence.justificatifUrl != null;
    final statut = absence.statutJustification;

    Color couleurStatut;
    IconData iconStatut;
    String texteStatut;

    if (statut == 'VALIDE') {
      couleurStatut = const Color(0xFF00855A);
      iconStatut = Icons.check_circle;
      texteStatut = 'Justificatif validé';
    } else if (statut == 'REJETE') {
      couleurStatut = Colors.red;
      iconStatut = Icons.cancel;
      texteStatut = 'Justificatif rejeté';
    } else if (statut == 'EN_ATTENTE') {
      couleurStatut = Colors.orange;
      iconStatut = Icons.pending;
      texteStatut = 'En attente de validation';
    } else {
      couleurStatut = Colors.grey;
      iconStatut = Icons.upload_file;
      texteStatut = 'Aucun justificatif';
    }

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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: couleurStatut.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconStatut,
                      color: couleurStatut, size: 22),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        absence.matiere ??
                            'Cours du ${absence.dateSeance}',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29)),
                      ),
                      const SizedBox(height: 2),
                      Row(children: [
                        const Icon(Icons.calendar_today,
                            size: 12, color: Colors.grey),
                        const SizedBox(width: 4),
                        Text(absence.dateSeance,
                            style: const TextStyle(
                                color: Colors.grey, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: couleurStatut.withValues(alpha: 0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                    color: couleurStatut.withValues(alpha: 0.2)),
              ),
              child: Row(
                children: [
                  Icon(iconStatut, color: couleurStatut, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(texteStatut,
                            style: TextStyle(
                                color: couleurStatut,
                                fontWeight: FontWeight.bold,
                                fontSize: 12)),
                        if (absence.typeJustificatif != null)
                          Text('Type: ${absence.typeJustificatif}',
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            if (!aJustificatif || statut == 'REJETE') ...[
              const SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() =>
                      JustificatifScreen(presenceId: absence.id)),
                  icon: const Icon(Icons.upload_file,
                      color: Colors.white, size: 16),
                  label: Text(
                    statut == 'REJETE'
                        ? 'Renvoyer un justificatif'
                        : 'Soumettre un justificatif',
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statut == 'REJETE'
                        ? Colors.orange
                        : const Color(0xFF00855A),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildStatutJustif(String statut) {
    Color couleur;
    String texte;
    IconData icon;

    switch (statut) {
      case 'VALIDE':
        couleur = const Color(0xFF00855A);
        texte = 'Validé';
        icon = Icons.check_circle;
        break;
      case 'REJETE':
        couleur = Colors.red;
        texte = 'Rejeté';
        icon = Icons.cancel;
        break;
      case 'EN_ATTENTE':
        couleur = Colors.orange;
        texte = 'En attente';
        icon = Icons.pending;
        break;
      default:
        return const SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(icon, size: 12, color: couleur),
        const SizedBox(width: 4),
        Text(texte,
            style: TextStyle(
                color: couleur,
                fontSize: 11,
                fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatCard(
      String label, int valeur, Color couleur, IconData icon) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: couleur.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: couleur.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: couleur, size: 20),
            ),
            const SizedBox(height: 8),
            Text('$valeur',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: couleur)),
            Text(label,
                style:
                TextStyle(fontSize: 11, color: Colors.grey[600])),
          ],
        ),
      ),
    );
  }

  Widget _buildActionCard(
      String label, IconData icon, Color couleur, int index) {
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _currentIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: couleur.withValues(alpha: 0.15),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: couleur, size: 22),
              ),
              const SizedBox(height: 8),
              Text(label,
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF003D29))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(String message, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          const SizedBox(height: 16),
          Text(message,
              style: TextStyle(fontSize: 15, color: Colors.grey[500])),
        ],
      ),
    );
  }
}
