import 'package:flutter/material.dart';

import '../db/medicine_database.dart';
import '../models/medicine_model.dart';
import '../services/notification_service.dart';

class MedicineProvider extends ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => List.unmodifiable(_medicines);

  /// Load medicines from SQLite and sort by time
  Future<void> loadMedicines() async {
    final data = await MedicineDatabase.instance.getMedicines();

    _medicines
      ..clear()
      ..addAll(data);

    _sortByTime();
    notifyListeners();
  }

  /// Add a new medicine, save to DB, and schedule notification
  Future<void> addMedicine(Medicine medicine) async {
    // ✅ 1. INSERT and CAPTURE ID
    final int id =
    await MedicineDatabase.instance.insertMedicine(medicine);

    // ✅ 2. Create medicine WITH ID
    final Medicine medicineWithId =
    medicine.copyWith(id: id);

    // ✅ 3. Schedule notification using REAL ID
    await _scheduleMedicineNotification(medicineWithId);

    // Reload list
    await loadMedicines();
  }

  /// Optional: delete medicine
  Future<void> deleteMedicine(int id) async {
    await MedicineDatabase.instance.deleteMedicine(id);
    await NotificationService().cancelNotification(id);
    await loadMedicines();
  }

  void _sortByTime() {
    _medicines.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  Future<void> _scheduleMedicineNotification(Medicine medicine) async {
    final now = DateTime.now();

    DateTime scheduledTime = DateTime(
      now.year,
      now.month,
      now.day,
      medicine.hour,
      medicine.minute,
    );

    if (scheduledTime.isBefore(now)) {
      scheduledTime = scheduledTime.add(const Duration(days: 1));
    }

    await NotificationService().scheduleNotification(
      id: medicine.id!,
      title: '💊 Medicine Reminder',
      body: 'Time to take ${medicine.name} (${medicine.dose})',
      scheduledDate: scheduledTime,
    );
  }
}
