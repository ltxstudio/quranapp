import 'dart:convert';
import 'package:flutter/services.dart';

class Readable {
  static var QuranData;

  static Future<void> readJson() async {
    final String response =
        await rootBundle.loadString('assets/jsons/quran_bn.json');
    final data = await json.decode(response);

    QuranData = data;
  }
}
