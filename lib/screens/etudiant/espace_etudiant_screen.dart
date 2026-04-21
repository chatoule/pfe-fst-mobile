import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/auth_controller.dart';
import '../../controllers/shared_controller.dart';
import 'justificatif_screen.dart';
import '../enseignant/support_screen.dart';

class EspaceEtudiantScreen extends StatefulWidget {
  @override
  _EspaceEtudiantScreenState createState() => _EspaceEtudiantScreenState();
}

class _EspaceEtudiantScreenState extends State<EspaceEtudiantScreen> {
  final AuthController _authController = Get.find<AuthController>();
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF5F7FA),
      appBar: AppBar(
        title: Text(_getTitre(),
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        backgroundColor: Color(0xFF00855A),
        foregroundColor: Colors.white,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: Icon(Icons.menu, color: Colors.white),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.notifications_outlined),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.logout),
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
            padding: EdgeInsets.only(top: 50, bottom: 24, left: 20, right: 20),
            decoration: BoxDecoration(
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
                    color: Colors.white.withOpacity(0.2),
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 2),
                  ),
                  child: Obx(() {
                    final user = _authController.utilisateur.value;
                    return Center(
                      child: Text(
                        user != null ? '${user.prenom[0]}${user.nom[0]}' : 'E',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                    );
                  }),
                ),
                SizedBox(height: 12),
                Obx(() => Text(
                  '${_authController.utilisateur.value?.prenom ?? ""} ${_authController.utilisateur.value?.nom ?? ""}',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                )),
                SizedBox(height: 4),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text('ETUDIANT',
                      style: TextStyle(color: Colors.white, fontSize: 11)),
                ),
                SizedBox(height: 4),
                Obx(() => Text(
                  _authController.utilisateur.value?.email ?? '',
                  style: TextStyle(color: Colors.white70, fontSize: 11),
                )),
              ],
            ),
          ),
          Expanded(
            child: Column(
              children: [
                SizedBox(height: 8),
                _buildDrawerItem(0, Icons.dashboard_outlined, 'Mon Espace'),
                _buildDrawerItem(1, Icons.event_busy_outlined, 'Mes Absences'),
                _buildDrawerItem(2, Icons.upload_file_outlined, 'Justificatifs'),
                _buildDrawerItem(3, Icons.library_books_outlined, 'Supports de cours'),
              ],
            ),
          ),
          Divider(height: 1),
          ListTile(
            leading: Icon(Icons.logout, color: Colors.red),
            title: Text('Se deconnecter',
                style: TextStyle(color: Colors.red, fontWeight: FontWeight.w500)),
            onTap: () => _authController.logout(),
          ),
          Padding(
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
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: isActive ? Color(0xFF00855A).withOpacity(0.1) : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
      ),
      child: ListTile(
        leading: Icon(icon,
            color: isActive ? Color(0xFF00855A) : Colors.grey[600], size: 22),
        title: Text(label,
            style: TextStyle(
                color: isActive ? Color(0xFF00855A) : Colors.grey[800],
                fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
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
      default: return 'Etudiant';
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
    return Obx(() {
      final user = _authController.utilisateur.value;
      final etudiantId = user?.id ?? 2;
      final presences = SharedController.to.getPresencesEtudiant(etudiantId);
      final absences = SharedController.to.getAbsencesEtudiant(etudiantId);
      final taux = SharedController.to.getTauxPresence(etudiantId);
      final tauxStr = taux.toStringAsFixed(1);
      final tauxOk = taux >= 75;
      final enRattrapage = SharedController.to.estEnSessionRattrapage(etudiantId);

      return SingleChildScrollView(
        child: Column(
          children: [
            // Header gradient
            Container(
              width: double.infinity,
              padding: EdgeInsets.fromLTRB(20, 20, 20, 30),
              decoration: BoxDecoration(
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
                          color: Colors.white.withOpacity(0.2),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: Center(
                          child: Text(
                            user != null
                                ? '${user.prenom[0]}${user.nom[0]}'
                                : 'E',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Bonjour,',
                              style: TextStyle(
                                  color: Colors.white70, fontSize: 13)),
                          Text(
                            '${user?.prenom ?? ""} ${user?.nom ?? ""}',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  Text('Etudiant - FST UIN',
                      style: TextStyle(color: Colors.white60, fontSize: 12)),
                  SizedBox(height: 20),

                  // Taux de présence
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Taux de presence',
                                  style: TextStyle(
                                      color: Colors.white70, fontSize: 12)),
                              SizedBox(height: 4),
                              Text('$tauxStr%',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 32,
                                      fontWeight: FontWeight.bold)),
                              SizedBox(height: 8),
                              ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: LinearProgressIndicator(
                                  value: taux / 100,
                                  backgroundColor:
                                  Colors.white.withOpacity(0.2),
                                  color: tauxOk
                                      ? Colors.greenAccent
                                      : Colors.redAccent,
                                  minHeight: 6,
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(width: 16),
                        Container(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: tauxOk
                                ? Colors.greenAccent.withOpacity(0.2)
                                : Colors.redAccent.withOpacity(0.2),
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
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Alerte session rattrapage
                  if (enRattrapage)
                    Container(
                      padding: EdgeInsets.all(14),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.red[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.red[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.warning_amber_rounded,
                              color: Colors.red, size: 24),
                          SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('SESSION DE RATTRAPAGE DIRECTE',
                                    style: TextStyle(
                                        color: Colors.red,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 12)),
                                SizedBox(height: 4),
                                Text(
                                  'Vous avez ${SharedController.to.getNombreAbsencesNonJustifiees(etudiantId)} absences non justifiees. Vous etes automatiquement transfere en session de rattrapage.',
                                  style: TextStyle(
                                      color: Colors.red[700], fontSize: 11),
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
                      padding: EdgeInsets.all(12),
                      margin: EdgeInsets.only(bottom: 16),
                      decoration: BoxDecoration(
                        color: Colors.orange[50],
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.orange[300]!),
                      ),
                      child: Row(
                        children: [
                          Icon(Icons.info_outline,
                              color: Colors.orange, size: 20),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Attention ! Votre taux de presence est insuffisant. Le minimum requis est 75%.',
                              style: TextStyle(
                                  color: Colors.orange[700], fontSize: 12),
                            ),
                          ),
                        ],
                      ),
                    ),

                  // Stats
                  Text('Mes statistiques',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      _buildStatCard('Total', presences.length,
                          Color(0xFF00855A), Icons.list_alt),
                      SizedBox(width: 12),
                      _buildStatCard('Presents',
                          presences.where((p) => p.estPresent).length,
                          Colors.blue, Icons.check_circle_outline),
                      SizedBox(width: 12),
                      _buildStatCard('Absences', absences.length,
                          Colors.red, Icons.cancel_outlined),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Actions rapides
                  Text('Actions rapides',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF003D29))),
                  SizedBox(height: 12),

                  Row(
                    children: [
                      _buildActionCard('Mes Absences',
                          Icons.event_busy, Colors.orange, 1),
                      SizedBox(width: 12),
                      _buildActionCard('Justificatifs',
                          Icons.upload_file, Colors.purple, 2),
                      SizedBox(width: 12),
                      _buildActionCard('Supports',
                          Icons.library_books, Colors.blue, 3),
                    ],
                  ),

                  SizedBox(height: 24),

                  // Absences récentes
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('Absences recentes',
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      if (absences.isNotEmpty)
                        TextButton(
                          onPressed: () =>
                              setState(() => _currentIndex = 1),
                          child: Text('Voir tout',
                              style: TextStyle(
                                  color: Color(0xFF00855A), fontSize: 13)),
                        ),
                    ],
                  ),
                  SizedBox(height: 8),

                  if (absences.isEmpty)
                    _buildEmptyState('Aucune absence !', Icons.celebration)
                  else
                    ...absences
                        .take(3)
                        .map((absence) => _buildAbsenceCard(absence))
                        .toList(),
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
    return Obx(() {
      final etudiantId = _authController.utilisateur.value?.id ?? 2;
      final absences = SharedController.to.getAbsencesEtudiant(etudiantId);

      if (absences.isEmpty) {
        return Center(
            child: _buildEmptyState('Aucune absence !', Icons.celebration));
      }

      return ListView.builder(
        padding: EdgeInsets.all(16),
        itemCount: absences.length,
        itemBuilder: (context, index) {
          return _buildAbsenceCard(absences[index]);
        },
      );
    });
  }

  // ===================== JUSTIFICATIFS =====================
  Widget _buildJustificatifs() {
    return Obx(() {
      final etudiantId = _authController.utilisateur.value?.id ?? 2;
      final absences = SharedController.to.getAbsencesEtudiant(etudiantId);

      return Column(
        children: [
          // Info header
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF00855A), Color(0xFF003D29)],
              ),
            ),
            child: Row(
              children: [
                Icon(Icons.info_outline, color: Colors.white70, size: 18),
                SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Soumettez un justificatif pour chaque absence. Le Chef de Departement validera ou rejettera votre demande.',
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ],
            ),
          ),

          if (absences.isEmpty)
            Expanded(
              child: Center(
                child: _buildEmptyState(
                    'Aucune absence a justifier', Icons.celebration),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: absences.length,
                itemBuilder: (context, index) {
                  final absence = absences[index];
                  return _buildJustificatifCard(absence);
                },
              ),
            ),
        ],
      );
    });
  }

  // ===================== WIDGETS =====================
  Widget _buildAbsenceCard(dynamic absence) {
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
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: Colors.red.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(Icons.event_busy, color: Colors.red, size: 22),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    absence.matiere ?? 'Cours du ${absence.dateSeance}',
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Color(0xFF003D29)),
                  ),
                  SizedBox(height: 2),
                  Row(children: [
                    Icon(Icons.calendar_today, size: 12, color: Colors.grey),
                    SizedBox(width: 4),
                    Text(absence.dateSeance,
                        style: TextStyle(color: Colors.grey, fontSize: 12)),
                  ]),
                  // Statut justificatif
                  if (absence.statutJustification != null)
                    SizedBox(height: 4),
                  if (absence.statutJustification != null)
                    _buildStatutJustif(absence.statutJustification!),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () => Get.to(() =>
                  JustificatifScreen(presenceId: absence.id)),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF00855A),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                padding:
                EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              child: Text('Justifier',
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
      couleurStatut = Color(0xFF00855A);
      iconStatut = Icons.check_circle;
      texteStatut = 'Justificatif valide';
    } else if (statut == 'REJETE') {
      couleurStatut = Colors.red;
      iconStatut = Icons.cancel;
      texteStatut = 'Justificatif rejete';
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: couleurStatut.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(iconStatut, color: couleurStatut, size: 22),
                ),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        absence.matiere ?? 'Cours du ${absence.dateSeance}',
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Color(0xFF003D29)),
                      ),
                      SizedBox(height: 2),
                      Row(children: [
                        Icon(Icons.calendar_today,
                            size: 12, color: Colors.grey),
                        SizedBox(width: 4),
                        Text(absence.dateSeance,
                            style:
                            TextStyle(color: Colors.grey, fontSize: 12)),
                      ]),
                    ],
                  ),
                ),
              ],
            ),

            SizedBox(height: 10),

            // Statut
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: couleurStatut.withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: couleurStatut.withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(iconStatut, color: couleurStatut, size: 16),
                  SizedBox(width: 8),
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
                              style: TextStyle(
                                  color: Colors.grey, fontSize: 11)),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Bouton soumettre si pas encore de justificatif
            if (!aJustificatif || statut == 'REJETE') ...[
              SizedBox(height: 10),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => Get.to(() =>
                      JustificatifScreen(presenceId: absence.id)),
                  icon: Icon(Icons.upload_file, color: Colors.white, size: 16),
                  label: Text(
                    statut == 'REJETE'
                        ? 'Renvoyer un justificatif'
                        : 'Soumettre un justificatif',
                    style: TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: statut == 'REJETE'
                        ? Colors.orange
                        : Color(0xFF00855A),
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
        couleur = Color(0xFF00855A);
        texte = 'Valide';
        icon = Icons.check_circle;
        break;
      case 'REJETE':
        couleur = Colors.red;
        texte = 'Rejete';
        icon = Icons.cancel;
        break;
      case 'EN_ATTENTE':
        couleur = Colors.orange;
        texte = 'En attente';
        icon = Icons.pending;
        break;
      default:
        return SizedBox.shrink();
    }

    return Row(
      children: [
        Icon(icon, size: 12, color: couleur),
        SizedBox(width: 4),
        Text(texte,
            style: TextStyle(
                color: couleur, fontSize: 11, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _buildStatCard(String label, int valeur, Color couleur, IconData icon) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: couleur.withOpacity(0.1),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: couleur.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: couleur, size: 20),
            ),
            SizedBox(height: 8),
            Text('$valeur',
                style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: couleur)),
            Text(label,
                style: TextStyle(fontSize: 11, color: Colors.grey[600])),
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
          padding: EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            boxShadow: [
              BoxShadow(
                color: couleur.withOpacity(0.15),
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: couleur.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: couleur, size: 22),
              ),
              SizedBox(height: 8),
              Text(label,
                  style: TextStyle(
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
      padding: EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 60, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text(message,
              style: TextStyle(fontSize: 15, color: Colors.grey[500])),
        ],
      ),
    );
  }
}