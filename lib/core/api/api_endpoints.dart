class ApiEndpoints {
  static const String baseUrl = "https://dev.moutfits.com/api/v1";
  static const String register = "$baseUrl/register";
  
  static const String verifyOtp = "$baseUrl/otp/verify";
  
  static const String sendOtp = "$baseUrl/send";
  static const String login = "$baseUrl/login";
  static const String joinGroup = "$baseUrl/cometchat/groups/join";
  static const String getGroups = "$baseUrl/cometchat/groups";
  static const String getInfluencers = "$baseUrl/user";
  // static const String sendMessage = "$baseUrl/cometchat/groups/send-message";
  // https://269435d754e8fd97.api-us.cometchat.io/v3/messages
  // https://dev.moutfits.com/api/v1/user

  static const String sendMessage = "https://269435d754e8fd97.api-us.cometchat.io/v3/messages";
 static const String getGroupMembers = "$baseUrl/cometchat/groups";
 static String groupMessages(String groupId) =>
      "$baseUrl/cometchat/groups/$groupId/messages";

 static final String updateApi = "https://dev.moutfits.com/api/v1/user/update?_method=PUT";
//  static const String getGroupMembers = "$baseUrl/cometchat/groups/g2/members";
}
