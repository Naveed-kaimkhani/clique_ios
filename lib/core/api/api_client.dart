import 'dart:developer';

import 'package:clique/controller/user_controller.dart';
import 'package:clique/routes/routes_name.dart';
import 'package:clique/utils/utils.dart';
import 'package:clique/view_model/discover_viewmodel.dart';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../api/api_endpoints.dart';
import 'package:awesome_snackbar_content/awesome_snackbar_content.dart';
class ApiClient extends GetxService {
  final String baseUrl = ApiEndpoints.baseUrl;
   Future<http.Response> post({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await http.post(Uri.parse(url),headers: headers, body: body);
  }

//    Future<http.Response> verifyOtp({
//     required String url,
//     // Map<String, String>? headers,
//     Object? body,
//   }) async {
//     return await http.post(Uri.parse('https://dev.moutfits.com/api/v1/otp/verify'),
//      body: jsonEncode({
//   "phone": "3103443527",
//   "otp": "123456"
//  }),
// );
//   }

   Future<http.Response> verifyOtp({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    return await http.post(Uri.parse('https://dev.moutfits.com/api/v1/otp/verify'),
     body: body,
     headers: headers,
);
  }

   Future<http.Response> sendOtp({
    required String url,
    Map<String, String>? headers,
    Object? body,
  }) async {
    log(url);
    return await http.post(Uri.parse("https://dev.moutfits.com/api/v1/otp/send"),
     body: body,
     headers: headers,
);
  }

Future<dynamic> getGroup(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(endpoint), headers: headers);

    return response;
  }

  Future<dynamic> get(String endpoint, {Map<String, String>? headers}) async {
    final response = await http.get(Uri.parse(endpoint), headers: headers);
    return _handleResponse(response);
  }
  static Future<http.Response> getMessages({
    required String url,
    Map<String, String>? headers,
  }) async {
    return await http.get(Uri.parse(url), headers: headers);
  }

//  Future<http.Response> getInfluencersApi({
//   required String url,
//   Map<String, String>? params, // Add params instead of headers
//    Map<String, String>? headers,
// }) async {
//   // Create a URI with query parameters
//   Uri uri = Uri.parse(url,headers: headers).replace(queryParameters: params);

//   // Make the GET request
//   return await http.get(uri);
// }
Future<http.Response> getInfluencersApi({
  required String url,
  Map<String, String>? params,
  String? authToken, // Make authToken nullable
}) async {
  Uri uri = Uri.parse(url).replace(queryParameters: params);

  Map<String, String> headers = {
    "Content-Type": "application/json", // Always include this header
  };

  // Add auth token to headers if provided
  if (authToken != null) {
    headers["Authorization"] = "Bearer $authToken";
  }

  return await http.get(uri, headers: headers);
}

  static Future<http.Response> fetchMessages({
    required String url,
    Map<String, String>? headers,
  }) async {
    return await http.get(Uri.parse(url), headers: headers);
  }

  Future<dynamic> loginUser(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = jsonDecode(response.body);
      final String token = responseData["token"];
      final String userName = responseData["user"]["name"];
      final int userId = responseData["user"]["id"];
      
      final String role = responseData["user"]["role"];
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('token', token);
      await prefs.setString('userName', userName);
      await prefs.setString('role', role);
      await prefs.setInt('uid', userId);
    await  UserController().loadUserSession();
      final UserController userController = Get.put(UserController());
    log(userController.token.value);
  final DiscoverViewModel _viewModel = Get.put(DiscoverViewModel());
    Get.toNamed(RouteName.homeScreen,);
  // Get.to(()=> HomeScreen(), transition: Transition.zoom);
      
//       Get.put(UserController());
//  Get.put(DiscoverViewModel());
      return responseData;
    }
    return _handleResponse(response);
  }

  // Future<dynamic> post(String endpoint,
  //     {Map<String, String>? headers, dynamic body}) async {
  //   final response = await http.post(Uri.parse(endpoint),
  //       headers: headers, body: jsonEncode(body));
 
  //   return _handleResponse(response);
  // }
    Future<void> signUpApi(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(body));
        log(response.statusCode.toString());
                 if (response.statusCode == 201 || response.statusCode==200) {
                        Get.offAllNamed(RouteName.loginScreen);
                        // log("signup success");
    }
    return _handleResponse(response);
  }


    Future<dynamic> joinGroupApi(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.post(Uri.parse(endpoint),
        headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }
  //  Future<dynamic> fetchGroupMembersApi(String endpoint,
  //     {Map<String, String>? headers, dynamic body}) async {
  //   final response = await http.post(Uri.parse(endpoint),
  //       headers: headers, body: jsonEncode(body));
  //   return _handleResponse(response);
  // }
  Future<dynamic> put(String endpoint,
      {Map<String, String>? headers, dynamic body}) async {
    final response = await http.put(Uri.parse('$baseUrl$endpoint'),
        headers: headers, body: jsonEncode(body));
    return _handleResponse(response);
  }

  Future<dynamic> delete(String endpoint,
      {Map<String, String>? headers}) async {
    final response =
        await http.delete(Uri.parse('$baseUrl$endpoint'), headers: headers);
    return _handleResponse(response);
  }

  dynamic _handleResponse(http.Response response) async {
  
    switch (response.statusCode) {
      case 200:
      
        return jsonDecode(response.body);
      case 201:
        return jsonDecode(response.body);
      case 400:
      case 401:
      case 403:
      case 422:
      case 404:
      case 500:
      
        Utils.showCustomSnackBar("Error", Utils.mapErrorMessage(response.body),ContentType.failure );
        // throw Exception('Error: ${response.body},');
      default:
      
        Utils.showCustomSnackBar("Error", Utils.mapErrorMessage(response.body),ContentType.failure );
        // throw Exception('Unexpected error occurred');
    }
  }
}
