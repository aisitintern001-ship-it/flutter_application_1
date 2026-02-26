import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

import 'models/person.dart';
import 'add_person.dart';
import 'update_person.dart';
import 'people_table.dart';
import 'logout_button.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Person> _people = [
    Person('John', 'Doe', 'Male', '1990-01-01'),
    Person('Jane', 'Smith', 'Female', '1992-05-15'),
  ];

  // UI state
  final Set<Person> _selectedPeople = {}; // updated via long press
  String _searchQuery = ''; // filters table


  @override
  void initState() {
    super.initState();
    _loadPeople();
  }

  Future<void> _loadPeople() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('people');
    if (data != null) {
      final List<dynamic> decoded = jsonDecode(data);
      setState(() {
        _people = decoded.map((item) => Person.fromJson(item as Map<String, dynamic>)).toList();
      });
    } else {
      // Save initial data
      await _savePeople();
    }
  }

  void _deleteSelected() {
    if (_selectedPeople.isNotEmpty) {
      setState(() {
        _people.removeWhere((p) => _selectedPeople.contains(p));
        _selectedPeople.clear();
      });
      _savePeople();
    }
  }

  List<Person> get _filteredPeople {
    if (_searchQuery.isEmpty) return _people;
    final q = _searchQuery.toLowerCase();
    return _people.where((p) {
      return p.firstName.toLowerCase().contains(q) ||
          p.lastName.toLowerCase().contains(q) ||
          p.gender.toLowerCase().contains(q) ||
          p.dob.toLowerCase().contains(q);
    }).toList();
  }

  Future<void> _savePeople() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(_people.map((p) => p.toJson()).toList());
    prefs.setString('people', encoded);
  }

  void _showEditDialog(int index) {
    // clear any selection when editing
    _selectedPeople.clear();
    showEditPersonDialog(context, index, _people[index], (i, person) {
      setState(() {
        _people[i] = person;
      });
      _savePeople();
    });
  }

  // callback for when a row is tapped in the table. we receive the person
  // because the table may show a filtered list. locate the person in the
  // master _people list so we can edit or delete it correctly.
  void _onPersonTap(Person person) {
    final idx = _people.indexOf(person);
    if (idx != -1) {
      _showEditDialog(idx);
    }
  }

  // toggle selection on long press
  void _onPersonLongPress(Person person) {
    setState(() {
      if (_selectedPeople.contains(person)) {
        _selectedPeople.remove(person);
      } else {
        _selectedPeople.add(person);
      }
    });
  }

  void _showAddDialog() {
    showAddPersonDialog(context, (person) {
      setState(() {
        _people.add(person);
      });
      _savePeople();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        title: const Row(
          children: [
            Icon(Icons.people,  size: 16),
            SizedBox(width: 6),
            Text('People Directory',style: TextStyle(fontSize: 16)),
          ],
        ),
        elevation: 4,
        actions: const [
          LogoutButton(),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                  SizedBox(
                  width: 200,
                  child: TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search',
                      prefixIcon: Icon(Icons.search),
                    ),
                    onChanged: (v) {
                      setState(() {
                        _searchQuery = v;
                        _selectedPeople.clear(); // clear selections when filtering
                      });
                    },
                  ),
                ),

                const SizedBox(height: 40),
                 const Spacer(),
                 if (_selectedPeople.isNotEmpty) ...[
                   const SizedBox(width: 2),
                   ElevatedButton(
                     onPressed: _deleteSelected,
                     style: ElevatedButton.styleFrom(
                       backgroundColor: Colors.red,
                       foregroundColor: Colors.white,
                     ),
                     child: const Text('Delete'),
                   ),
                 ],
              ],
            ),
            const SizedBox(height: 12),
            PeopleTable(
              people: _filteredPeople,
              onRowTap: _onPersonTap,
              onRowLongPress: _onPersonLongPress,
              selectedPeople: _selectedPeople,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        tooltip: 'Add',
        child: const Icon(Icons.add),
      ),
    );
  }
}
