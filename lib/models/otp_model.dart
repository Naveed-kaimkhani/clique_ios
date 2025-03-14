class OTPRequestModel {
  String phone;
  String otp;

  OTPRequestModel({required this.phone, required this.otp});

  Map<String, dynamic> toJson() {
    return {"phone": phone, "otp": otp};
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
