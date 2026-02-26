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
        'firstName': firstName,
        'lastName': lastName,
        'gender': gender,
        'dob': dob,
      };

  factory Person.fromJson(Map<String, dynamic> json) => Person(
        json['firstName'] as String,
        json['lastName'] as String,
        json['gender'] as String,
        json['dob'] as String,
      );
}
