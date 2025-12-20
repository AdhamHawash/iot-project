import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String baseUrl = "https://facebook-bahaa.onrender.com";

Future<List<dynamic>> getInstructors() async {
  final url = "$baseUrl/instructors";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['instructors'];
  } else {
    throw Exception('Failed to load instructors');
  }
}

Future<List<dynamic>> getSections() async {
  final url = "$baseUrl/section";
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['sections'];
  } else {
    throw Exception('Failed to load instructors');
  }
}

Future<bool> sendCode({required String instructorId}) async {
  final url = "$baseUrl/auth/sendCode";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"instructorId": instructorId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);

      print(data['message']);
      return true;
    } else {
      final error = jsonDecode(response.body);
      print("Error: ${error['message']}");
      return false;
    }
  } catch (e) {
    print("Exception: $e");
    return false;
  }
}

Future<bool> verifyCode({
  required String instructorId,
  required String code,
}) async {
  final url = "$baseUrl/auth/VerifyCode";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"instructorId": instructorId, "code": code}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      print(data['message']);
      return true;
    } else {
      final error = jsonDecode(response.body);
      print("Error: ${error['message']}");
      return false;
    }
  } catch (e) {
    print("Exception: $e");
    return false;
  }
}

Future<List<dynamic>> getSection({
  required String sectionId,
  required String instructorId,
}) async {
  final url = "$baseUrl/section/getSection";

  final response = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: jsonEncode({"sectionId": sectionId, "instructorId": instructorId}),
  );

  if (response.statusCode == 200) {
    final data = jsonDecode(response.body);
    return data['section'];
  } else {
    final error = jsonDecode(response.body);
    throw Exception(error['message'] ?? 'Failed to load student history');
  }
}

Future<bool> runSensor({required bool stats}) async {
  final url = "$baseUrl/runSensor";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"sensorState": stats}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      // Optionally log error
      final error = jsonDecode(response.body);
      debugPrint("API Error: ${error['message'] ?? 'Unknown error'}");
      return false;
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return false;
  }
}

Future<Map<String, dynamic>> studentHistory({
  required String studentId,
  required String instructorId,
}) async {
  final url = "$baseUrl/students/studentHistory";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"studentId": studentId, "instructorId": instructorId}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // ✅ نرجع كل البيانات كما هي
      return {
        "student": data['student'] ?? {},
        "activeHistory": data['activeHistory'] ?? [],
        "message": data['message'] ?? '',
      };
    } else {
      final error = jsonDecode(response.body);
      debugPrint("API Error: ${error['message'] ?? 'Unknown error'}");
      return {
        "student": {},
        "activeHistory": [],
        "message": error['message'] ?? 'Failed to fetch data',
      };
    }
  } catch (e) {
    debugPrint("Exception: $e");
    return {
      "student": {},
      "activeHistory": [],
      "message": "Exception occurred: $e",
    };
  }
}
