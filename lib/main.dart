import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:v2x_app/screens/welcome_screen.dart';
import 'package:v2x_app/screens/bottom_bar.dart';
import 'package:v2x_app/theme/theme.dart';

void main() {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(statusBarColor: Colors.transparent),
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: lightMode,
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(),
        '/home': (context) => const BottomBarScreen(), // second part
      },
    );
  }
}
