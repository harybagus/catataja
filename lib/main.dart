import 'package:catataja/pages/login_page.dart';
import 'package:catataja/themes/dark_mode.dart';
import 'package:catataja/themes/light_mode.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const LoginPage(),
      theme: darkMode,
    );
  }
}
