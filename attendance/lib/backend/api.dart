import 'dart:async';
import 'dart:convert';
import 'package:attendance/backend/attendance.dart';
import 'package:attendance/backend/user.dart';
import 'package:http/http.dart' as http;

/// class that can execute api calls
class API {
  /// constructor
  API() {
    _client = http.Client();
  }

  Map<String, String> _buildHeaders(String token) =>
    <String, String>{
      'x-token':  token,
      'Content-Type': 'application/json'
    };
  
  http.Request _buildRequest(
    String url,
    String token,
    [String body = '']
  ) =>
    http.Request('POST', Uri.parse(url))
    ..headers.addAll(_buildHeaders(token))
    ..body = body
    ..followRedirects = false;

  static const String _baseUrl = 'https://attendance-app-api.herokuapp.com/';
  //static const String _baseUrl = 'http://localhost:3000/';
  http.Client _client;

  /// call verify endpoint that changes user info if provided
  Future<String> setUserInfo(User user, String token) async {
    const String url = '${_baseUrl}verify';
    final http.Request request =
      _buildRequest(url, token, user.requestBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call sessionleave endpoint that changes the attendance to left
  Future<String> leaveSession(Attendance attendance, String token) async {
    const String url = '${_baseUrl}sessionleave';
    final http.Request request =
      _buildRequest(url, token, attendance.leaveRequestBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call newSession endpoint that adds new attendance
  Future<String> addSession(Attendance attendance, String token) async {
    const String url = '${_baseUrl}newSession';
    final http.Request request =
      _buildRequest(url, token, attendance.requestBody());
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call getInfo endpoint that graps user info
  Future<String> getInfo(String token) async {
    const String url = '${_baseUrl}getInfo';
    final http.Request request =
      _buildRequest(url, token);
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }

  /// call getAttendance endpoint to get an attendance
  Future<String> getAttendance(String token, String key) async {
    const String url = '${_baseUrl}getAttendance';
    final http.Request request =
      _buildRequest(url, token, json.encode(<String, dynamic>{'key':key}));
    final http.StreamedResponse response = await _client.send(request);
    final int statusCode = response.statusCode;
    final String responseData =
      await response.stream.transform(utf8.decoder).join();
    if(statusCode == 200) {
      return responseData;
    }
    throw Exception('status code is not 200\n$responseData');
  }
  
}