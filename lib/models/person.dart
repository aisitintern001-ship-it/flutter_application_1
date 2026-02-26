class Person {
  final String firstName;
  final String lastName;
  final String gender;
  final String dob;

  Person(this.firstName, this.lastName, this.gender, this.dob);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is Person &&
        other.firstName == firstName &&
        other.lastName == lastName &&
        other.gender == gender &&
        other.dob == dob;
  }

  @override
  int get hashCode =>
      firstName.hashCode ^
      lastName.hashCode ^
      gender.hashCode ^
      dob.hashCode;

  Map<String, dynamic> toJson() => {
        'first_name': firstName,
        'last_name': lastName,
        'gender': gender,
        'date_of_birth': dob,
      };

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        json['first_name'] as String? ?? '',
        json['last_name'] as String? ?? '',
        json['gender'] as String? ?? '',
        json['date_of_birth'] as String? ?? '',
      );
}
