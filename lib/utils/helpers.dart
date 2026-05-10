import 'package:intl/intl.dart';

class AppHelpers {
  static String getNomJour(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat('EEEE', 'fr_FR').format(d).capitalize();
    } catch (e) {
      const jours = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
      try {
        final d = DateTime.parse(date);
        return jours[d.weekday - 1];
      } catch (_) { return 'Inconnu'; }
    }
  }

  static String formaterDate(String date) {
    try {
      final d = DateTime.parse(date);
      return DateFormat('dd/MM/yyyy').format(d);
    } catch (e) { return date; }
  }

  static String getMois(int mois) {
    const moisList = ['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'];
    return moisList[mois - 1];
  }

  static int calculerNbHeures(String heureDebut, String heureFin) {
    try {
      final h1 = int.parse(heureDebut.split(RegExp(r'[h:]'))[0]);
      final h2 = int.parse(heureFin.split(RegExp(r'[h:]'))[0]);
      return h2 - h1;
    } catch (e) { return 2; }
  }
}

extension StringExtension on String {
  String capitalize() => "${this[0].toUpperCase()}${substring(1)}";
}
