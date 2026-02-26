import 'package:flutter/material.dart';
import 'models/person.dart';

Future<void> showEditPersonDialog(
    BuildContext context,
    int index,
    Person person,
    void Function(int, Person) onSave) async {
  final first = TextEditingController(text: person.firstName);
  final last = TextEditingController(text: person.lastName);
  String selectedGender = person.gender;
  final dob = TextEditingController(text: person.dob);

  await showDialog(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (context, setDialogState) => AlertDialog(
        title: const Text('Edit Person'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: first,
                decoration: InputDecoration(
                  labelText: 'First name',
                  prefixIcon: const Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: last,
                decoration: InputDecoration(
                  labelText: 'Last name',
                  prefixIcon: const Icon(Icons.person),
                ),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: selectedGender,
                decoration: InputDecoration(
                  labelText: 'Gender',
                  prefixIcon: const Icon(Icons.wc),
                ),
                items: const [
                  DropdownMenuItem(value: 'Male', child: Text('Male')),
                  DropdownMenuItem(value: 'Female', child: Text('Female')),
                ],
                onChanged: (value) {
                  setDialogState(() {
                    selectedGender = value ?? person.gender;
                  });
                },
              ),
              const SizedBox(height: 12),
              TextField(
                controller: dob,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'Date of birth',
                  prefixIcon: const Icon(Icons.calendar_today),
                  hintText: 'Select a date',
                ),
                onTap: () async {
                  final picked = await showDatePicker(
                    context: context,
                    initialDate: DateTime.tryParse(person.dob) ?? DateTime.now(),
                    firstDate: DateTime(1900),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dob.text =
                        '${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              onSave(
                  index,
                  Person(
                    first.text,
                    last.text,
                    selectedGender,
                    dob.text,
                  ));
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ),
  );
}
