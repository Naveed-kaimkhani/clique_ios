class UploadVideoResponse {
  final bool success;
  final String message;

  UploadVideoResponse({required this.success, required this.message});

  factory UploadVideoResponse.fromJson(Map<String, dynamic> json) {
    return UploadVideoResponse(
      success: json['success'] ?? false,
      message: json['message'] ?? 'Unknown error',
    );
  }
}
