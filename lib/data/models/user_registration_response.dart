

// import 'dart:convert';

// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:get_storage/get_storage.dart';

// class UserRegistrationResponse {
//   final String message;
//   final User user;
//   final CometChatUser cometChatUser;
//   final String token;

//   UserRegistrationResponse({
//     required this.message,
//     required this.user,
//     required this.cometChatUser,
//     required this.token,
//   });

//   factory UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
//     print("kyaa masla hy yrrrr");
//     return UserRegistrationResponse(
//       message: json['message'],
//       user: User.fromJson(json['user']),
//       cometChatUser: CometChatUser.fromJson(json['cometChatUser']),
//       token: json['token'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'message': message,
//       'user': user.toJson(),
//       'cometChatUser': cometChatUser.toJson(),
//       'token': token,
//     };
//   }
// }

// class User {
//   final String name;
//   final String email;
//   final int phone;
//   final String role;
//   final String updatedAt;
//   final String createdAt;
//   final int id;

//   User({
//     required this.name,
//     required this.email,
//     required this.phone,
//     required this.role,
//     required this.updatedAt,
//     required this.createdAt,
//     required this.id,
//   });

//   factory User.fromJson(Map<String, dynamic> json) {
//     return User(
//       name: json['name'],
//       email: json['email'],
//       phone: json['phone'],
//       role: json['role'],
//       updatedAt: json['updated_at'],
//       createdAt: json['created_at'],
//       id: json['id'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'name': name,
//       'email': email,
//       'phone': phone,
//       'role': role,
//       'updated_at': updatedAt,
//       'created_at': createdAt,
//       'id': id,
//     };
//   }
// }

// class CometChatUser {
//   final String uid;
//   final String name;
//   final String link;
//   final String avatar;
//   final Metadata metadata;
//   final String status;
//   final String role;
//   final int createdAt;
//   final String authToken;

//   CometChatUser({
//     required this.uid,
//     required this.name,
//     required this.link,
//     required this.avatar,
//     required this.metadata,
//     required this.status,
//     required this.role,
//     required this.createdAt,
//     required this.authToken,
//   });

//   factory CometChatUser.fromJson(Map<String, dynamic> json) {
//     return CometChatUser(
//       uid: json['uid'],
//       name: json['name'],
//       link: json['link'],
//       avatar: json['avatar'],
//       metadata: Metadata.fromJson(json['metadata']),
//       status: json['status'],
//       role: json['role'],
//       createdAt: json['createdAt'],
//       authToken: json['authToken'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'uid': uid,
//       'name': name,
//       'link': link,
//       'avatar': avatar,
//       'metadata': metadata.toJson(),
//       'status': status,
//       'role': role,
//       'createdAt': createdAt,
//       'authToken': authToken,
//     };
//   }
// }

// class Metadata {
//   final PrivateMetadata private;

//   Metadata({required this.private});

//   factory Metadata.fromJson(Map<String, dynamic> json) {
//     return Metadata(
//       private: PrivateMetadata.fromJson(json['@private']),
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       '@private': private.toJson(),
//     };
//   }
// }

// class PrivateMetadata {
//   final String email;
//   final int contactNumber;

//   PrivateMetadata({required this.email, required this.contactNumber});

//   factory PrivateMetadata.fromJson(Map<String, dynamic> json) {
//     return PrivateMetadata(
//       email: json['email'],
//       contactNumber: json['contactNumber'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     return {
//       'email': email,
//       'contactNumber': contactNumber,
//     };
//   }
// }

// UserRegistrationResponse UserRegistrationResponseFromJson(String str) => UserRegistrationResponse.fromJson(json.decode(str));
// String UserRegistrationResponseToJson(UserRegistrationResponse data) => json.encode(data.toJson());




class UserRegistrationResponse {
  String? message;
  User? user;
  CometChatUser? cometChatUser;
  String? token;

  UserRegistrationResponse({this.message, this.user, this.cometChatUser, this.token});

  UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    // user = json['user'] != null ? new User.fromJson(json['user']) : null;
    // cometChatUser = json['cometChatUser'] != null
    //     ?  CometChatUser.fromJson(json['cometChatUser'])
    //     : null;
    token = json['token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['message'] = this.message;
    if (this.user != null) {
      data['user'] = this.user!.toJson();
    }
    if (this.cometChatUser != null) {
      data['cometChatUser'] = this.cometChatUser!.toJson();
    }
    data['token'] = this.token;
    return data;
  }
}

class User {
  String? name;
  String? email;
  int? phone;
  String? role;
  String? updatedAt;
  String? createdAt;
  int? id;

  User(
      {this.name,
      this.email,
      this.phone,
      this.role,
      this.updatedAt,
      this.createdAt,
      this.id});

  User.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    email = json['email'];
    phone = json['phone'];
    role = json['role'];
    updatedAt = json['updated_at'];
    createdAt = json['created_at'];
    id = json['id'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['role'] = this.role;
    data['updated_at'] = this.updatedAt;
    data['created_at'] = this.createdAt;
    data['id'] = this.id;
    return data;
  }
}

class CometChatUser {
  String? uid;
  String? name;
  String? link;
  String? avatar;
  Metadata? metadata;
  String? status;
  String? role;
  int? createdAt;
  String? authToken;

  CometChatUser(
      {this.uid,
      this.name,
      this.link,
      this.avatar,
      this.metadata,
      this.status,
      this.role,
      this.createdAt,
      this.authToken});

  CometChatUser.fromJson(Map<String, dynamic> json) {
    uid = json['uid'];
    name = json['name'];
    link = json['link'];
    avatar = json['avatar'];
    metadata = json['metadata'] != null
        ? new Metadata.fromJson(json['metadata'])
        : null;
    status = json['status'];
    role = json['role'];
    createdAt = json['createdAt'];
    authToken = json['authToken'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['uid'] = this.uid;
    data['name'] = this.name;
    data['link'] = this.link;
    data['avatar'] = this.avatar;
    if (this.metadata != null) {
      data['metadata'] = this.metadata!.toJson();
    }
    data['status'] = this.status;
    data['role'] = this.role;
    data['createdAt'] = this.createdAt;
    data['authToken'] = this.authToken;
    return data;
  }
}

class Metadata {
  Private? private;

  Metadata({this.private});

  Metadata.fromJson(Map<String, dynamic> json) {
    private = json['@private'] != null
        ? new Private.fromJson(json['@private'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.private != null) {
      data['@private'] = this.private!.toJson();
    }
    return data;
  }
}

class Private {
  String? email;
  int? contactNumber;

  Private({this.email, this.contactNumber});

  Private.fromJson(Map<String, dynamic> json) {
    email = json['email'];
    contactNumber = json['contactNumber'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['email'] = this.email;
    data['contactNumber'] = this.contactNumber;
    return data;
  }
}