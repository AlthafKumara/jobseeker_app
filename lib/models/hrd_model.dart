class HrdModel {
  final String name;
  final String address;
  final String phone;
  final String description;
  final String logo;

  HrdModel({
    required this.name,
    required this.address,
    required this.phone,
    required this.description,
    required this.logo,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "address": address,
      "phone": phone,
      "description": description,
      "logo": logo,
    };
  }

  factory HrdModel.fromJson(Map<String, dynamic> json) {
    return HrdModel(
      name: json["name"] ?? "",
      address: json["address"] ?? "",
      phone: json["phone"] ?? "",
      description: json["description"] ?? "",
      logo: json["logo"] ?? "",
    );
  }
}
