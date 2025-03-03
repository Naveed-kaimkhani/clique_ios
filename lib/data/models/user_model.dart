class UserModel {
  final int id;
  final String name;
  final String email;
  final String role;
  final String updatedAt;
  final String createdAt;
  final String phone;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.updatedAt,
    required this.createdAt,
    required this.phone,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      role: json['role'],
      updatedAt: json['updated_at'],
      createdAt: json['created_at'],
      phone: json['phone'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "role": role,
      "updated_at": updatedAt,
      "created_at": createdAt,
      "phone": phone,
    };
  }
}
