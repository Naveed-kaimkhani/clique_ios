

class UserRegistrationResponse {
  String? message;
  User? user;
  CometChatUser? cometChatUser;
  String? token;

  UserRegistrationResponse({this.message, this.user, this.cometChatUser, this.token});

  UserRegistrationResponse.fromJson(Map<String, dynamic> json) {
    message = json['message'];
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