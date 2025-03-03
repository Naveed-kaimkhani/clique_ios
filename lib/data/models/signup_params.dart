class SignupParams {
  final String name;
  final String email;
  final String password;
  final String confirmPassword;
  final String phone;
  final String role;
  SignupParams({
    required this.name,
    required this.email,
    required this.password,
    required this.confirmPassword,
    required this.phone,
    required this.role,
  });

  Map<String, dynamic> toJson() {
    return {
      "name": name,
      "email": email, 
      "password": password,
      "password_confirmation": confirmPassword,
      "phone": phone,
      "role": role,
    };
  }
}