import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:local_auth/local_auth.dart';
import '../controllers/auth_controller.dart';
import '../services/core/api_config.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final AuthController _authController = Get.find<AuthController>();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final LocalAuthentication _localAuth = LocalAuthentication();

  bool _obscurePassword = true;

  late AnimationController _animController;
  late Animation<double> _fadeAnim;
  late Animation<Offset> _slideAnim;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );
    _fadeAnim = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animController, curve: Curves.easeIn),
    );
    _slideAnim =
        Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
          CurvedAnimation(parent: _animController, curve: Curves.easeOut),
        );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _authenticateWithBiometrics() async {
    try {
      final List<BiometricType> availableBiometrics =
      await _localAuth.getAvailableBiometrics();
      if (availableBiometrics.isEmpty) {
        Get.snackbar('Info', 'Aucune biométrie disponible',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.orange,
            colorText: Colors.white);
        return;
      }
      final bool authenticated = await _localAuth.authenticate(
        localizedReason: 'Authentifiez-vous pour vous connecter',
      );
      if (authenticated) {
        _authController.login('enseignant@fst.ne', '1234');
      }
    } catch (e) {
      Get.snackbar('Erreur', 'Authentification biométrique échouée',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white);
    }
  }

  void _ouvrirCreationCompte() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CreationCompteSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment(-0.5, -0.5),
            radius: 1.5,
            colors: [
              Color(0xFF00C97A),
              Color(0xFF00855A),
              Color(0xFF005C3E),
              Color(0xFF003D29),
            ],
          ),
        ),
        child: Stack(
          children: [
            Positioned(top: -80, right: -80, child: _buildCircle(250, 0.06)),
            Positioned(top: 50, right: -30, child: _buildCircle(150, 0.05)),
            Positioned(bottom: -100, left: -80, child: _buildCircle(300, 0.05)),

            SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.only(bottom: 20),
                child: Column(
                  children: [
                    const SizedBox(height: 30),

                    // ===== LOGO =====
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          _buildCircle(200, 0.08),
                          _buildCircle(155, 0.12),
                          _buildCircle(115, 0.18),
                          Container(
                            width: 95,
                            height: 95,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.2),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ClipOval(
                              child: Padding(
                                padding: const EdgeInsets.all(10),
                                child: Image.asset(
                                  'assets/images/logo_uin.png',
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ===== TITRE =====
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: const Column(
                        children: [
                          Text(
                            'FST - UIN',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 26,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 3,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Gestion des Présences et des Pointages',
                            style: TextStyle(color: Colors.white70, fontSize: 13),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // ===== CARTE CONNEXION =====
                    SlideTransition(
                      position: _slideAnim,
                      child: FadeTransition(
                        opacity: _fadeAnim,
                        child: Container(
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          padding: const EdgeInsets.all(28),
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(32),
                            border: Border.all(
                                color: Colors.white.withValues(alpha: 0.25),
                                width: 1.5),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Connexion',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'Bienvenue sur votre espace FST-UIN',
                                style: TextStyle(
                                  color: Colors.white.withValues(alpha: 0.7),
                                  fontSize: 13,
                                ),
                              ),
                              const SizedBox(height: 24),

                              _buildWhiteField(
                                controller: _usernameController,
                                hint: "Nom d'utilisateur",
                                icon: Icons.person_outline_rounded,
                              ),
                              const SizedBox(height: 14),
                              _buildWhiteField(
                                controller: _passwordController,
                                hint: 'Mot de passe',
                                icon: Icons.lock_outline_rounded,
                                obscure: _obscurePassword,
                                suffixIcon: GestureDetector(
                                  onTap: () => setState(
                                          () => _obscurePassword = !_obscurePassword),
                                  child: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off_outlined
                                        : Icons.visibility_outlined,
                                    color: Colors.grey[400],
                                    size: 20,
                                  ),
                                ),
                              ),

                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {},
                                  child: Text(
                                    'Mot de passe oublié ?',
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.8),
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ),

                              const SizedBox(height: 8),

                              Obx(() => SizedBox(
                                width: double.infinity,
                                height: 56,
                                child: ElevatedButton(
                                  onPressed: _authController.isLoading.value
                                      ? null
                                      : () {
                                    _authController.login(
                                      _usernameController.text.trim(),
                                      _passwordController.text.trim(),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    disabledBackgroundColor:
                                    Colors.white.withValues(alpha: 0.5),
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    elevation: 0,
                                  ),
                                  child: _authController.isLoading.value
                                      ? const SizedBox(
                                    width: 24,
                                    height: 24,
                                    child: CircularProgressIndicator(
                                      color: Color(0xFF00855A),
                                      strokeWidth: 2.5,
                                    ),
                                  )
                                      : const Text(
                                    'SE CONNECTER',
                                    style: TextStyle(
                                      color: Color(0xFF00855A),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ),
                              )),

                              const SizedBox(height: 24),

                              Center(
                                child: GestureDetector(
                                  onTap: _authenticateWithBiometrics,
                                  child: Container(
                                    width: 56,
                                    height: 56,
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.15),
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.3),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: const Icon(
                                      Icons.fingerprint,
                                      size: 30,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Center(
                                child: Text(
                                  'Connexion biométrique',
                                  style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),

                    // ===== BOUTONS TEST =====
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Column(
                        children: [
                          Text(
                            'Tests rapides',
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 11,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              alignment: WrapAlignment.center,
                              children: [
                                _buildTestBtn('Étudiant', '/presences', Colors.blue),
                                _buildTestBtn('Enseignant', '/pointage', Colors.orange),
                                _buildTestBtn('Chef Dép.', '/chef-departement', Colors.purple),
                                _buildTestBtn('Superviseur', '/superviseur', Colors.teal),
                                _buildTestBtn('Doyen', '/doyen', Colors.red),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ===== CRÉER UN COMPTE =====
                    FadeTransition(
                      opacity: _fadeAnim,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    thickness: 1,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 12),
                                  child: Text(
                                    "Vous n'avez pas de compte ?",
                                    style: TextStyle(
                                      color: Colors.white.withValues(alpha: 0.6),
                                      fontSize: 12,
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Divider(
                                    color: Colors.white.withValues(alpha: 0.25),
                                    thickness: 1,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: OutlinedButton.icon(
                                onPressed: _ouvrirCreationCompte,
                                icon: const Icon(
                                  Icons.person_add_outlined,
                                  color: Colors.white,
                                  size: 20,
                                ),
                                label: const Text(
                                  'Créer un compte',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                style: OutlinedButton.styleFrom(
                                  side: BorderSide(
                                    color: Colors.white.withValues(alpha: 0.5),
                                    width: 1.5,
                                  ),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      'FST-UIN v1.0 • 2025-2026',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.35),
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWhiteField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        style: const TextStyle(color: Color(0xFF1a1a1a), fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[400], fontSize: 14),
          prefixIcon: Icon(icon, color: const Color(0xFF00855A), size: 22),
          suffixIcon: suffixIcon != null
              ? Padding(
            padding: const EdgeInsets.only(right: 12),
            child: suffixIcon,
          )
              : null,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _buildTestBtn(String label, String route, Color color) {
    return GestureDetector(
      onTap: () => Get.toNamed(route),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: color.withValues(alpha: 0.5)),
        ),
        child: Text(
          label,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }

  Widget _buildCircle(double size, double opacity) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white.withValues(alpha: opacity),
      ),
    );
  }
}

// =====================================================
// BOTTOM SHEET CRÉATION DE COMPTE
// =====================================================
class _CreationCompteSheet extends StatefulWidget {
  const _CreationCompteSheet();

  @override
  State<_CreationCompteSheet> createState() => _CreationCompteSheetState();
}

class _CreationCompteSheetState extends State<_CreationCompteSheet> {
  String _roleSelectionne = 'ETUDIANT';
  bool _isLoading = false;
  bool _obscurePassword = true;

  // ✅ Listes déroulantes
  String? _niveauSelectionne;
  String? _gradeSelectionne;

  // ✅ Niveaux Bachelor
  final List<String> _niveaux = [
    'Bachelor 1',
    'Bachelor 2',
    'Bachelor 3',
    'Bachelor 4',
  ];

  // ✅ Grades enseignant
  final List<String> _grades = [
    'Mr',
    'Mme',
    'Dr',
    'Prof',
    'Dr Prof',
  ];

  final _nomController = TextEditingController();
  final _prenomController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _telephoneController = TextEditingController();
  final _matriculeController = TextEditingController();
  final _specialiteController = TextEditingController();

  final List<Map<String, dynamic>> _roles = [
    {
      'value': 'ETUDIANT',
      'label': 'Étudiant',
      'icon': Icons.school_outlined,
      'color': Colors.blue,
    },
    {
      'value': 'ENSEIGNANT',
      'label': 'Enseignant',
      'icon': Icons.person_outlined,
      'color': const Color(0xFF00855A),
    },
    {
      'value': 'CHEF_DEPARTEMENT',
      'label': 'Chef de Département',
      'icon': Icons.supervisor_account_outlined,
      'color': Colors.purple,
    },
    {
      'value': 'SUPERVISEUR',
      'label': 'Superviseur',
      'icon': Icons.manage_accounts_outlined,
      'color': Colors.orange,
    },
  ];

  @override
  void dispose() {
    _nomController.dispose();
    _prenomController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _telephoneController.dispose();
    _matriculeController.dispose();
    _specialiteController.dispose();
    super.dispose();
  }

  Map<String, dynamic> _buildBody() {
    final base = {
      'nom': _nomController.text.trim(),
      'prenom': _prenomController.text.trim(),
      'email': _emailController.text.trim(),
      'username': _usernameController.text.trim(),
      'motDePasse': _passwordController.text.trim(),
      'telephone': _telephoneController.text.trim(),
      'role': _roleSelectionne,
    };
    if (_roleSelectionne == 'ETUDIANT') {
      return {
        ...base,
        'matricule': _matriculeController.text.trim(),
        'niveau': _niveauSelectionne ?? 'Bachelor 1',
        'statut': true,
        'departementId': 1,
      };
    } else {
      return {
        ...base,
        'grade': _gradeSelectionne ?? 'Mr',
        'specialite': _specialiteController.text.trim(),
        'statutEnseignant': 'Actif',
      };
    }
  }

  Future<void> _creerCompte() async {
    if (_nomController.text.isEmpty ||
        _prenomController.text.isEmpty ||
        _usernameController.text.isEmpty ||
        _passwordController.text.isEmpty) {
      Get.snackbar(
        'Champs manquants',
        'Veuillez remplir tous les champs obligatoires.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Vérification niveau étudiant
    if (_roleSelectionne == 'ETUDIANT' && _niveauSelectionne == null) {
      Get.snackbar(
        'Niveau manquant',
        'Veuillez sélectionner un niveau.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // ✅ Vérification grade enseignant
    if (_roleSelectionne != 'ETUDIANT' && _gradeSelectionne == null) {
      Get.snackbar(
        'Grade manquant',
        'Veuillez sélectionner un grade.',
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final endpoint =
      _roleSelectionne == 'ETUDIANT' ? '/etudiants' : '/enseignants';
      final response = await http.post(
        Uri.parse('${ApiConfig.baseUrl}$endpoint'),
        headers: ApiConfig.headers,
        body: jsonEncode(_buildBody()),
      );
      if (response.statusCode == 200 || response.statusCode == 201) {
        Get.back();
        Get.snackbar(
          'Compte créé !',
          'Vous pouvez maintenant vous connecter.',
          backgroundColor: const Color(0xFF00855A),
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
          duration: const Duration(seconds: 4),
          icon: const Icon(Icons.check_circle, color: Colors.white),
        );
      } else {
        Get.snackbar(
          'Erreur',
          'Impossible de créer le compte. Code: ${response.statusCode}',
          backgroundColor: Colors.red,
          colorText: Colors.white,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Erreur réseau',
        'Vérifiez votre connexion.',
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final roleConfig = _roles.firstWhere((r) => r['value'] == _roleSelectionne);
    final Color roleColor = roleConfig['color'] as Color;

    return Container(
      height: MediaQuery.of(context).size.height * 0.92,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Column(
        children: [
          // Handle
          Container(
            margin: const EdgeInsets.only(top: 12),
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(2),
            ),
          ),

          // Header
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 16, 24, 0),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: roleColor.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Icon(roleConfig['icon'] as IconData,
                      color: roleColor, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Créer un compte',
                          style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF003D29))),
                      Text('FST - Université Islamique du Niger',
                          style: TextStyle(color: Colors.grey, fontSize: 12)),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),

          const Divider(height: 20),

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // ===== SÉLECTION RÔLE =====
                  _buildSectionTitle('Je suis...', Icons.category_outlined),
                  const SizedBox(height: 10),

                  GridView.count(
                    crossAxisCount: 2,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    childAspectRatio: 3,
                    children: _roles.map((r) {
                      final isSelected = _roleSelectionne == r['value'];
                      final color = r['color'] as Color;
                      return GestureDetector(
                        onTap: () => setState(() {
                          _roleSelectionne = r['value'];
                          // Reset sélections quand on change de rôle
                          _niveauSelectionne = null;
                          _gradeSelectionne = null;
                        }),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? color.withValues(alpha: 0.1)
                                : Colors.grey[50],
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: isSelected ? color : Colors.grey[200]!,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(r['icon'] as IconData,
                                  color: isSelected ? color : Colors.grey,
                                  size: 18),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  r['label'] as String,
                                  style: TextStyle(
                                    color: isSelected
                                        ? color
                                        : Colors.grey[600],
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                    fontSize: 12,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // ===== INFORMATIONS PERSONNELLES =====
                  _buildSectionTitle(
                      'Informations personnelles', Icons.person_outline),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Expanded(
                        child: _buildInputField(
                          controller: _prenomController,
                          label: 'Prénom *',
                          icon: Icons.badge_outlined,
                          color: roleColor,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildInputField(
                          controller: _nomController,
                          label: 'Nom *',
                          icon: Icons.badge_outlined,
                          color: roleColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _emailController,
                    label: 'Email',
                    icon: Icons.email_outlined,
                    color: roleColor,
                    keyboard: TextInputType.emailAddress,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _telephoneController,
                    label: 'Téléphone',
                    icon: Icons.phone_outlined,
                    color: roleColor,
                    keyboard: TextInputType.phone,
                  ),

                  const SizedBox(height: 20),

                  // ===== CHAMPS ÉTUDIANT =====
                  if (_roleSelectionne == 'ETUDIANT') ...[
                    _buildSectionTitle(
                        'Informations académiques', Icons.school_outlined),
                    const SizedBox(height: 10),
                    _buildInputField(
                      controller: _matriculeController,
                      label: 'Matricule',
                      icon: Icons.numbers,
                      color: roleColor,
                    ),
                    const SizedBox(height: 12),

                    // ✅ LISTE DÉROULANTE NIVEAU
                    _buildDropdownField(
                      label: 'Niveau *',
                      icon: Icons.bar_chart,
                      color: roleColor,
                      value: _niveauSelectionne,
                      items: _niveaux,
                      onChanged: (val) =>
                          setState(() => _niveauSelectionne = val),
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ===== CHAMPS ENSEIGNANT/AUTRE =====
                  if (_roleSelectionne != 'ETUDIANT') ...[
                    _buildSectionTitle(
                        'Informations professionnelles', Icons.work_outline),
                    const SizedBox(height: 10),

                    // ✅ LISTE DÉROULANTE GRADE
                    _buildDropdownField(
                      label: 'Grade *',
                      icon: Icons.military_tech_outlined,
                      color: roleColor,
                      value: _gradeSelectionne,
                      items: _grades,
                      onChanged: (val) =>
                          setState(() => _gradeSelectionne = val),
                    ),
                    const SizedBox(height: 12),
                    _buildInputField(
                      controller: _specialiteController,
                      label: 'Spécialité',
                      icon: Icons.psychology_outlined,
                      color: roleColor,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // ===== IDENTIFIANTS =====
                  _buildSectionTitle(
                      'Identifiants de connexion', Icons.lock_outline),
                  const SizedBox(height: 10),
                  _buildInputField(
                    controller: _usernameController,
                    label: "Nom d'utilisateur *",
                    icon: Icons.person_outline,
                    color: roleColor,
                  ),
                  const SizedBox(height: 12),
                  _buildInputField(
                    controller: _passwordController,
                    label: 'Mot de passe * (min. 8 caractères)',
                    icon: Icons.lock_outline,
                    color: roleColor,
                    obscure: _obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: Colors.grey,
                        size: 20,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),

                  const SizedBox(height: 28),

                  // ===== BOUTON CRÉER =====
                  SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton.icon(
                      onPressed: _isLoading ? null : _creerCompte,
                      icon: _isLoading
                          ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Icon(Icons.check_circle_outline,
                          color: Colors.white),
                      label: Text(
                        _isLoading ? 'Création...' : 'CRÉER MON COMPTE',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: roleColor,
                        disabledBackgroundColor:
                        roleColor.withValues(alpha: 0.5),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 0,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.blue[50],
                      borderRadius: BorderRadius.circular(10),
                      border:
                      Border.all(color: Colors.blue.withValues(alpha: 0.2)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.info_outline,
                            color: Colors.blue, size: 16),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            "Après création, connectez-vous avec votre nom d'utilisateur et mot de passe.",
                            style:
                            TextStyle(color: Colors.blue[700], fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ✅ NOUVEAU : Widget liste déroulante
  Widget _buildDropdownField({
    required String label,
    required IconData icon,
    required Color color,
    required String? value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: value != null ? color.withValues(alpha: 0.5) : Colors.transparent,
          width: 1.5,
        ),
      ),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
          prefixIcon: Icon(icon, color: color, size: 20),
          filled: true,
          fillColor: const Color(0xFFF8FAFC),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: color, width: 1.5),
          ),
          contentPadding:
          const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
        hint: Text(
          'Sélectionner...',
          style: TextStyle(color: Colors.grey[400], fontSize: 13),
        ),
        items: items
            .map((item) => DropdownMenuItem(
          value: item,
          child: Text(item,
              style: const TextStyle(fontSize: 14)),
        ))
            .toList(),
        onChanged: onChanged,
        icon: Icon(Icons.keyboard_arrow_down, color: color),
        dropdownColor: Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  Widget _buildSectionTitle(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey[600]),
        const SizedBox(width: 6),
        Text(title,
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.grey[700])),
      ],
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required Color color,
    bool obscure = false,
    TextInputType? keyboard,
    Widget? suffixIcon,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboard,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey[600], fontSize: 13),
        prefixIcon: Icon(icon, color: color, size: 20),
        suffixIcon: suffixIcon,
        filled: true,
        fillColor: const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: color, width: 1.5),
        ),
        contentPadding:
        const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }
}
