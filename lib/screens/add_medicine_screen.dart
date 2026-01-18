import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../widgets/constants.dart';

class AddMedicineScreen extends StatefulWidget {
  const AddMedicineScreen({super.key});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  final _nameController = TextEditingController();
  final _doseController = TextEditingController();

  TimeOfDay? _selectedTime;

  @override
  void dispose() {
    _nameController.dispose();
    _doseController.dispose();
    super.dispose();
  }

  Future<void> _pickTime(BuildContext context) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );

    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveMedicine() async {
    if (!_formKey.currentState!.validate() ||
        _selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill all fields'),
        ),
      );
      return;
    }

    final medicine = Medicine(
      name: _nameController.text.trim(),
      dose: _doseController.text.trim(),
      hour: _selectedTime!.hour,
      minute: _selectedTime!.minute,
    );

    await context
        .read<MedicineProvider>()
        .addMedicine(medicine);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Medicine'),
      ),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Medicine Name',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter medicine name';
                  }
                  return null;
                },
              ),

              AppConstants.verticalSpacing,

              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(
                  labelText: 'Dose',
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Enter dose';
                  }
                  return null;
                },
              ),

              AppConstants.verticalSpacing,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime == null
                        ? 'No time selected'
                        : _selectedTime!.format(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                  TextButton(
                    onPressed: () => _pickTime(context),
                    child: const Text('Pick Time'),
                  ),
                ],
              ),

              const Spacer(),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _saveMedicine,
                  child: const Text('Save Medicine'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
