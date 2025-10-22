class Society {
  final String id;
  final String name;
  final String address;
  final String phone;
  final String dateOfBirth;
  final String gender;
  final String profilePhoto;
  final bool isProfileComplete;

  Society({
    required this.id,
    required this.name,
    required this.address,
    required this.phone,
    required this.dateOfBirth,
    required this.gender,
    required this.profilePhoto,
    required this.isProfileComplete,
  });

  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      address: json['address'] ?? '',
      phone: json['phone'] ?? '',
      dateOfBirth: json['date_of_birth'] ?? '',
      gender: json['gender'] ?? '',
      profilePhoto: json['profile_photo'] ?? '',
      isProfileComplete: json['isProfileComplete'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'address': address,
      'phone': phone,
      'date_of_birth': dateOfBirth,
      'gender': gender,
      'profile_photo': profilePhoto,
    };
  }
}
