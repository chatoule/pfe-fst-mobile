// lib/screens/superviseur/tabs/historique_tab.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../controllers/shared_controller.dart';

class HistoriqueTab extends StatefulWidget {
  const HistoriqueTab({super.key});

  @override
  State<HistoriqueTab> createState() => _HistoriqueTabState();
}

class _HistoriqueTabState extends State<HistoriqueTab> {
  final SharedController _shared = Get.find<SharedController>();
  DateTime? _startDate;
  DateTime? _endDate;

  Future<void> _selectDateRange() async {
    final DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2023),
      lastDate: DateTime(2030),
      initialDateRange: _startDate != null && _endDate != null
          ? DateTimeRange(start: _startDate!, end: _endDate!)
          : null,
      builder: (context, child) => Theme(
        data: Theme.of(context).copyWith(
          colorScheme: const ColorScheme.light(
            primary: Color(0xFF00855A),
            onPrimary: Colors.white,
            onSurface: Color(0xFF003D29),
          ),
        ),
        child: child!,
      ),
    );
    if (picked != null) {
      setState(() {
        _startDate = picked.start;
        _endDate = picked.end;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final pointages =
      _shared.fichesPointage.where((f) {
        final isCorrectStatut =
            f['confirmerSuperviseur'] == true ||
                f['statut'] == 'REJETE';
        if (!isCorrectStatut) return false;

        if (_startDate != null && _endDate != null) {
          try {
            final dateSeance =
            DateTime.parse(f['dateSeance']);
            return dateSeance.isAfter(
                _startDate!.subtract(
                    const Duration(days: 1))) &&
                dateSeance.isBefore(
                    _endDate!.add(const Duration(days: 1)));
          } catch (_) {
            return true;
          }
        }
        return true;
      }).toList();

      return Column(
        children: [
          // Filtre date
          _buildDateFilter(),

          // Stats header
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  colors: [Color(0xFF00855A), Color(0xFF003D29)]),
            ),
            child: Row(
              children: [
                _buildStatBadge(
                    'Total', '${pointages.length}', Colors.white),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Confirmés',
                    '${pointages.where((h) => h['statut'] != 'REJETE').length}',
                    Colors.greenAccent),
                const SizedBox(width: 8),
                _buildStatBadge(
                    'Rejetés',
                    '${pointages.where((h) => h['statut'] == 'REJETE').length}',
                    Colors.redAccent),
              ],
            ),
          ),

          // Liste
          Expanded(
            child: pointages.isEmpty
                ? const Center(
                child: Text('Aucun historique disponible',
                    style: TextStyle(color: Colors.grey)))
                : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: pointages.length,
              itemBuilder: (context, index) =>
                  _buildHistoriqueCard(pointages[index]),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildDateFilter() {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: 16, vertical: 8),
      color: Colors.white,
      child: Row(
        children: [
          const Icon(Icons.date_range,
              size: 18, color: Color(0xFF00855A)),
          const SizedBox(width: 8),
          Expanded(
            child: InkWell(
              onTap: _selectDateRange,
              child: Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  _startDate == null
                      ? 'Filtrer par période'
                      : '${DateFormat('dd/MM/yyyy').format(_startDate!)} - ${DateFormat('dd/MM/yyyy').format(_endDate!)}',
                  style: TextStyle(
                    fontSize: 13,
                    color: _startDate == null
                        ? Colors.grey[600]
                        : const Color(0xFF003D29),
                    fontWeight: _startDate == null
                        ? FontWeight.normal
                        : FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
          if (_startDate != null)
            IconButton(
              icon: const Icon(Icons.clear,
                  size: 18, color: Colors.red),
              onPressed: () => setState(() {
                _startDate = null;
                _endDate = null;
              }),
            ),
        ],
      ),
    );
  }

  Widget _buildHistoriqueCard(Map<String, dynamic> h) {
    final isRejete = h['statut'] == 'REJETE';
    final couleur =
    isRejete ? Colors.red : const Color(0xFF00855A);
    final icon =
    isRejete ? Icons.cancel : Icons.check_circle;

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
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        leading: Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: couleur.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: couleur, size: 22),
        ),
        title: Text(
          isRejete ? 'Pointage Rejeté' : 'Pointage Confirmé',
          style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 14,
              color: Color(0xFF003D29)),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 2),
            Text(
              '${h['matiere'] ?? 'Module'} - ${h['enseignantNom'] ?? 'Inconnu'}',
              style: const TextStyle(
                  color: Color(0xFF00855A),
                  fontSize: 12,
                  fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 2),
            Row(
              children: [
                const Icon(Icons.access_time,
                    size: 11, color: Colors.grey),
                const SizedBox(width: 3),
                Text(h['dateSeance'] ?? '',
                    style: const TextStyle(
                        color: Colors.grey, fontSize: 11)),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatBadge(
      String label, String valeur, Color couleur) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          children: [
            FittedBox(
              fit: BoxFit.scaleDown,
              child: Text(valeur,
                  style: TextStyle(
                      color: couleur,
                      fontSize: 18,
                      fontWeight: FontWeight.bold)),
            ),
            Text(label,
                style: const TextStyle(
                    color: Colors.white70, fontSize: 10)),
          ],
        ),
      ),
    );
  }
}
