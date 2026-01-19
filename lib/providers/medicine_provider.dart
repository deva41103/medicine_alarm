import 'package:flutter/material.dart';

import '../db/medicine_database.dart';
import '../models/medicine_model.dart';
import '../services/notification_service.dart';

class MedicineProvider extends ChangeNotifier {
  final List<Medicine> _medicines = [];

  List<Medicine> get medicines => List.unmodifiable(_medicines);

  Future<void> loadMedicines() async {
    final data = await MedicineDatabase.instance.getMedicines();
    _medicines
      ..clear()
      ..addAll(data);
    _sortByTime();
    notifyListeners();
  }

  Future<void> addMedicine(Medicine medicine) async {
    final id = await MedicineDatabase.instance.insertMedicine(medicine);
    final medicineWithId = medicine.copyWith(id: id);

    // ✅ CALL WEEKLY SCHEDULER
    await _scheduleMedicine(medicineWithId);

    await loadMedicines();
  }

  Future<void> updateMedicine(Medicine medicine) async {
    await MedicineDatabase.instance.updateMedicine(medicine);

    // ✅ CANCEL OLD DAYS
    await NotificationService().cancelAllForMedicine(medicine.id!);

    // ✅ RESCHEDULE
    await _scheduleMedicine(medicine);

    await loadMedicines();
  }

  Future<void> deleteMedicine(int id) async {
    await NotificationService().cancelAllForMedicine(id);
    await MedicineDatabase.instance.deleteMedicine(id);
    await loadMedicines();
  }

  void _sortByTime() {
    _medicines.sort((a, b) {
      final aMinutes = a.hour * 60 + a.minute;
      final bMinutes = b.hour * 60 + b.minute;
      return aMinutes.compareTo(bMinutes);
    });
  }

  Future<void> _scheduleMedicine(Medicine medicine) async {
    for (final day in medicine.days) {
      await NotificationService().scheduleWeekly(
        id: medicine.id!,
        title: '💊 Medicine Reminder',
        body: 'Time to take ${medicine.name} (${medicine.dose})',
        weekday: day,
        hour: medicine.hour,
        minute: medicine.minute,
      );
    }
  }
}
