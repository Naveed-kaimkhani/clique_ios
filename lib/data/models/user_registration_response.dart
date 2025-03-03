import 'package:clique/data/models/comet_chat_user.dart';
import 'package:clique/data/models/user_model.dart';

class UserRegistrationResponse {
  final UserModel user;
  final CometChatUser cometChatUser;
  final String token;
  final String? message;
  final UserModel? data;

  UserRegistrationResponse({
    required this.user,
    required this.cometChatUser,
    required this.token,
    this.message,
    this.data,
  });

  factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    return UserRegistrationResponse(
      user: UserModel.fromJson(json['user']),
      cometChatUser: CometChatUser.fromJson(json['cometChatUser']),
      // token: json['token'],
      token: "token",
      // message: json['message'],
      message: "message",
      // data: json['data'] != null ? UserModel.fromJson(json['data']) : null,
      data: UserModel.fromJson(json['data']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "user": user.toJson(),
      "cometChatUser": cometChatUser.toJson(),
      "token": token,
    };
  }
}
