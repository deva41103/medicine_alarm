import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/medicine_model.dart';
import '../providers/medicine_provider.dart';
import '../widgets/constants.dart';

class AddMedicineScreen extends StatefulWidget {
  final Medicine? medicine;
  const AddMedicineScreen({super.key, this.medicine});

  @override
  State<AddMedicineScreen> createState() => _AddMedicineScreenState();
}

class _AddMedicineScreenState extends State<AddMedicineScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _doseController;

  TimeOfDay? _selectedTime;
  final List<int> _selectedDays = [];

  final Map<int, String> weekDays = {
    1: 'Mon',
    2: 'Tue',
    3: 'Wed',
    4: 'Thu',
    5: 'Fri',
    6: 'Sat',
    7: 'Sun',
  };

  @override
  void initState() {
    super.initState();

    _nameController =
        TextEditingController(text: widget.medicine?.name ?? '');
    _doseController =
        TextEditingController(text: widget.medicine?.dose ?? '');

    if (widget.medicine != null) {
      _selectedTime = TimeOfDay(
        hour: widget.medicine!.hour,
        minute: widget.medicine!.minute,
      );
      _selectedDays.addAll(widget.medicine!.days);
    }
  }

  Future<void> _saveMedicine() async {
    if (!_formKey.currentState!.validate() ||
        _selectedTime == null ||
        _selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Select time and at least one day')),
      );
      return;
    }

    final medicine = Medicine(
      id: widget.medicine?.id,
      name: _nameController.text.trim(),
      dose: _doseController.text.trim(),
      hour: _selectedTime!.hour,
      minute: _selectedTime!.minute,
      days: _selectedDays,
    );

    final provider = context.read<MedicineProvider>();

    widget.medicine == null
        ? await provider.addMedicine(medicine)
        : await provider.updateMedicine(medicine);

    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.medicine != null;

    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Medicine' : 'Add Medicine')),
      body: Padding(
        padding: AppConstants.screenPadding,
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _nameController,
                decoration: const InputDecoration(labelText: 'Medicine Name'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              AppConstants.verticalSpacing,
              TextFormField(
                controller: _doseController,
                decoration: const InputDecoration(labelText: 'Dose'),
                validator: (v) =>
                v == null || v.isEmpty ? 'Required' : null,
              ),
              AppConstants.verticalSpacing,

              Wrap(
                spacing: 8,
                children: weekDays.entries.map((e) {
                  final selected = _selectedDays.contains(e.key);
                  return ChoiceChip(
                    label: Text(e.value),
                    selected: selected,
                    onSelected: (val) {
                      setState(() {
                        val
                            ? _selectedDays.add(e.key)
                            : _selectedDays.remove(e.key);
                      });
                    },
                  );
                }).toList(),
              ),

              AppConstants.verticalSpacing,

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    _selectedTime == null
                        ? 'No time selected'
                        : _selectedTime!.format(context),
                  ),
                  TextButton(
                    onPressed: () async {
                      final t = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (t != null) setState(() => _selectedTime = t);
                    },
                    child: const Text('Pick Time'),
                  ),
                ],
              ),

              const Spacer(),
              ElevatedButton(
                onPressed: _saveMedicine,
                child: Text(isEdit ? 'Update' : 'Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
