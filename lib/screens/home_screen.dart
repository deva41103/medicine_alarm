import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/medicine_provider.dart';
import '../widgets/medicine_tile.dart';
import '../widgets/constants.dart';
import 'add_medicine_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<MedicineProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Medicine Reminder'),
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: provider.medicines.isEmpty
            ? const Center(
          child: Text(
            AppConstants.emptyListMessage,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey,
            ),
          ),
        )
            : ListView.builder(
          itemCount: provider.medicines.length,
          itemBuilder: (context, index) {
            final medicine = provider.medicines[index];
            return MedicineTile(medicine: medicine);
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => const AddMedicineScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
