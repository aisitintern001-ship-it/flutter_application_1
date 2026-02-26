class Person {
  final String id;
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;

  // id is optional, required for update/delete but not shown in UI
  Person(
    this.firstName,
    this.lastName,
    this.gender,
    this.dob, [
    this.id = '',
  ]);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.id == id &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.dob == dob;
  }

  @override
  int get hashCode =>
      id.hashCode ^
      firstName.hashCode ^
      lastName.hashCode ^
      gender.hashCode ^
      dob.hashCode;

  Map<String, dynamic> toJson() {
    final m = <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'gender': gender,
      'date_of_birth': dob,
    };
    if (id.isNotEmpty) m['id'] = id;
    return m;
  }

  @override
  String toString() => '$firstName $lastName';

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        json['first_name'] as String? ?? '',
        json['last_name'] as String? ?? '',
        json['gender'] as String? ?? '',
        json['date_of_birth'] as String? ?? '',
        json['id'] as String? ?? '',
      );
      
}
