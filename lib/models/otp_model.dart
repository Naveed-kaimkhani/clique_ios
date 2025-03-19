class OTPRequestModel {
  String email;
  String otp;

  OTPRequestModel({required this.email, required this.otp});

  Map<String, dynamic> toJson() {
    return {"email": email, "otp": otp};
  }
}

class OTPResponseModel {
  final bool success;
  final String message;

  OTPResponseModel({required this.success, required this.message});

  factory OTPResponseModel.fromJson(Map<String, dynamic> json) {
    return OTPResponseModel(
      success: json["success"] ?? false,
      message: json["message"] ?? "Unknown response",
    );
  }
}
