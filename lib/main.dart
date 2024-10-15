import 'package:flutter/material.dart';
import 'package:alquranbd/readable.dart';
import 'package:alquranbd/screens/ayat.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Readable.readJson();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Quran BD',
      home: Ayat(surahNumber: 1, ayatNumber: 1),
    );
  }
}
