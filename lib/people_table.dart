import 'package:flutter/material.dart';
import 'models/person.dart';

class PeopleTable extends StatelessWidget {
  const PeopleTable({
    super.key,
    required this.people,
    required this.onRowTap,
    required this.selectedPeople,
    required this.onRowLongPress,
    this.fontSize = 14.0,
  });

  final List<Person> people;
  // returns tapped person, home page will figure index
  final void Function(Person) onRowTap;
  // selection set used to render checkboxes/highlighting
  final Set<Person> selectedPeople;
  // invoked when row is long‑pressed
  final void Function(Person) onRowLongPress;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        return SingleChildScrollView(
          // vertical scrolling only if needed
          child: FittedBox(
            fit: BoxFit.fitWidth,
            alignment: Alignment.topLeft,
            child: DataTable(
              columnSpacing: 18,
              dataTextStyle: TextStyle(fontSize: 15),
              columns: const [
                DataColumn(label: Text('First name', style: TextStyle(fontSize: 15))),
                DataColumn(label: Text('Last name', style: TextStyle(fontSize : 15))),
                DataColumn(label: Text('Gender', style: TextStyle(fontSize : 15))),
                DataColumn(label: Text('Date Of Birth', style: TextStyle(fontSize  : 15))),
              ],
              rows: people
                  .asMap()
                  .entries
                  .map(
                    (entry) {
                      final p = entry.value;
                      final isSelected = selectedPeople.contains(p);
                      final selectionMode = selectedPeople.isNotEmpty;
                      return DataRow(
                        selected: isSelected,
                        cells: [
                          DataCell(
                            GestureDetector(
                              onTap: () => onRowTap(p),
                              onLongPress: () => onRowLongPress(p),
                              child: Row(
                                children: [
                                  if (selectionMode)
                                    SizedBox(
                                      width: 24,
                                      height: 24,
                                      child: Checkbox(
                                        value: isSelected,
                                        onChanged: (_) => onRowLongPress(p),
                                      ),
                                    ),
                                  Text(p.firstName),
                                ],
                              ),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => onRowTap(p),
                              onLongPress: () => onRowLongPress(p),
                              child: Text(p.lastName),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => onRowTap(p),
                              onLongPress: () => onRowLongPress(p),
                              child: Text(p.gender),
                            ),
                          ),
                          DataCell(
                            GestureDetector(
                              onTap: () => onRowTap(p),
                              onLongPress: () => onRowLongPress(p),
                              child: Text(p.dob),
                            ),
                          ),
                        ],
                      );
                    },
                  )
                  .toList(),
            ),
          ),
        );
      },
    );
  }
}
