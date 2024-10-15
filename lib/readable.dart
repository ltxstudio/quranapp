// lib/readable.dart
import 'dart:convert';
import 'package:flutter/services.dart';

class Readable {
  static Map<String, dynamic>? QuranData;

  static Future<void> readJson() async {
    try {
      final String response =
          await rootBundle.loadString('assets/quran_bn.json');
      final data = jsonDecode(response);

      QuranData = data;
    } catch (e) {
      print('Error reading JSON: $e');
    }
  }
}
