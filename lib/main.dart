import 'package:flutter/material.dart';
import 'theme.dart';
import 'home_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'IKE Connect | CCTV & Smart Security Systems',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.themeData,
      home: const HomePage(),
    );
  }
}
