import 'package:flutter/material.dart';
import '../models/medicine_model.dart';

class MedicineTile extends StatelessWidget {
  final Medicine medicine;
  final VoidCallback onEdit;

  const MedicineTile({
    super.key,
    required this.medicine,
    required this.onEdit,
  });

  String _formatTime(BuildContext context, int hour, int minute) {
    final time = TimeOfDay(hour: hour, minute: minute);
    return time.format(context);
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading: const Icon(Icons.medication, color: Colors.teal),
        title: Text(
          medicine.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text('Dose: ${medicine.dose}'),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _formatTime(context, medicine.hour, medicine.minute),
              style: const TextStyle(
                color: Colors.orange,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.teal),
              onPressed: onEdit,
            ),
          ],
        ),
      ),
    );
  }
}
