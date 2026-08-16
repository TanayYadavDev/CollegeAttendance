class StudentProfile {
  final String name;
  final String registrationNo;
  final String programme;
  final String email;
  final String mobileNumber;
  final String dateOfBirth;
  final String? photoUrl;

  const StudentProfile({
    required this.name,
    required this.registrationNo,
    required this.programme,
    required this.email,
    required this.mobileNumber,
    required this.dateOfBirth,
    this.photoUrl,
  });
}