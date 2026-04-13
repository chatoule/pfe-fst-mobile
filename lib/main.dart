import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'screens/login_screen.dart';
import 'screens/presence_screen.dart';
import 'screens/pointage_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/etudiant/espace_etudiant_screen.dart';
import 'screens/chef_departement/chef_departement_screen.dart';
import 'screens/superviseur/superviseur_screen.dart';
import 'screens/secretaire/secretaire_screen.dart';
import 'screens/enseignant/fiche_pointage_screen.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'controllers/auth_controller.dart';
import 'screens/doyen/doyen_screen.dart';
import 'screens/superviseur/confirmation_seances_screen.dart';
import 'screens/chef_departement/validation_seances_screen.dart';
import 'controllers/shared_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeDateFormatting('fr_FR', null);
  Get.put(AuthController());
  Get.put(SharedController());
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Gestion Presences FST - UIN',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: '/splash',
      getPages: [
        GetPage(name: '/splash', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginScreen()),
        GetPage(name: '/presences', page: () => EspaceEtudiantScreen()),
        GetPage(name: '/pointage', page: () => PointageScreen()),
        GetPage(name: '/dashboard', page: () => DashboardScreen()),
        GetPage(name: '/superviseur', page: () => SuperviseurScreen()),
        GetPage(name: '/chef-departement', page: () => ChefDepartementScreen()),
        GetPage(name: '/secretaire', page: () => SecretaireScreen()),
        GetPage(name: '/fiche-pointage', page: () => FichePointageScreen(cours: {})),
        GetPage(name: '/doyen', page: () => DoyenScreen()),
        GetPage(name: '/confirmation-seances', page: () => ConfirmationSeancesScreen()),
        GetPage(name: '/validation-seances', page: () => ValidationSeancesScreen()),
      ],
    );
  }
}