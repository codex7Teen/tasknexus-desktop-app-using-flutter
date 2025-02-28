import 'package:flutter/material.dart';
import 'package:tasknexus/features/auth/presentation/screens/login_screen.dart';

//! ENTRY POINT
void main() {
  runApp(const MyApp());
}

//! ROOT WIDGET
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'TASKNEXUS', home: ScreenLogin());
  }
}
