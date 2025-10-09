import 'dart:convert';

class Society {
  final String? id;
  final String? name;
  final String? address;
  final String? phone;
  final DateTime? dateOfBirth;
  final String? gender;
  final String? profilePicture;
  final bool? isProfileComplete;
  final String? userId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  Society({
    this.id,
    this.name,
    this.address,
    this.phone,
    this.dateOfBirth,
    this.gender,
    this.profilePicture,
    this.isProfileComplete,
    this.userId,
    this.createdAt,
    this.updatedAt,
  });

  /// Factory untuk membuat object dari JSON (response API)
  factory Society.fromJson(Map<String, dynamic> json) {
    return Society(
      id: json['_id'],
      name: json['name'],
      address: json['address'],
      phone: json['phone'],
      dateOfBirth: json['date_of_birth'] != null
          ? DateTime.tryParse(json['date_of_birth'])
          : null,
      gender: json['gender'],
      profilePicture: json['profile_picture'] ?? '',
      isProfileComplete: json['isProfileComplete'] ?? false,
      userId: json['user'],
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'])
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.tryParse(json['updatedAt'])
          : null,
    );
  }

  /// Convert ke JSON (misalnya untuk dikirim ke server)
  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "phone": phone,
      "date_of_birth":
          dateOfBirth != null ? dateOfBirth!.toIso8601String() : null,
      "gender": gender,
      "profile_picture": profilePicture,
    };
  }

  /// Untuk mempermudah parsing dari String JSON langsung
  static Society fromJsonString(String jsonString) {
    return Society.fromJson(json.decode(jsonString));
  }

  /// Untuk menampilkan debug info
  @override
  String toString() {
    return 'Society(name: $name, address: $address, phone: $phone, gender: $gender, complete: $isProfileComplete)';
  }
}
