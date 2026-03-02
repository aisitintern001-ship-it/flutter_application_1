import 'package:flutter/material.dart';
import 'package:flutter_application_1/widget/status_pill.dart';
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
  final void Function(Person) onRowTap;
  final Set<Person> selectedPeople;
  final void Function(Person) onRowLongPress;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    // Count status types
    final approvedCount = people.where((p) => p.status == StatusType.approved).length;
    final pendingCount = people.where((p) => p.status == StatusType.pending).length;
    final declinedCount = people.where((p) => p.status == StatusType.declined).length;

    return LayoutBuilder(
      builder: (context, constraints) {
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0, left: 4.0),
              child: Row(
                children: [
                  StatusPill(status: StatusType.approved, count: approvedCount, fontSize: fontSize),
                  const SizedBox(width: 12),
                  StatusPill(status: StatusType.pending, count: pendingCount, fontSize: fontSize),
                  const SizedBox(width: 12),
                  StatusPill(status: StatusType.declined, count: declinedCount, fontSize: fontSize),
                ],
              ),
            ),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: ConstrainedBox(
                constraints: BoxConstraints(minWidth: constraints.maxWidth),
                child: DataTable(
                  columnSpacing: 18,
                  dataTextStyle: TextStyle(fontSize: fontSize),
                  columns: [
                    DataColumn(
                      label: Text(
                        'First name',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Last name',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Gender',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Date Of Birth',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
                    DataColumn(
                      label: Text(
                        'Status',
                        style: TextStyle(fontSize: fontSize),
                      ),
                    ),
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
                              DataCell(
                                StatusPill(status: p.status, fontSize: fontSize),
                              ),
                            ],
                          );
                        },
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
