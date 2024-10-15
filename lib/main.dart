// lib/main.dart
import 'package:flutter/material.dart';
import 'package:alquranbd/apptheme.dart';
import 'package:alquranbd/readable.dart';
import 'package:alquranbd/routes.dart';
import 'package:alquranbd/screens/homepage.dart';
import 'package:url_strategy/url_strategy.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setPathUrlStrategy();
  try {
    await Readable.readJson();
  } catch (e) {
    print('Error reading JSON: $e');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Al Quran BD',
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const HomePage(),
      debugShowCheckedModeBanner: false,
      onGenerateRoute: RouteGenerator.generateRoute,
      initialRoute: RoutesName.home,
    );
  }
}
