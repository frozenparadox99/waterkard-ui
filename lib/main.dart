import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:waterkard/ui/pages/onboarding_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        appBarTheme: AppBarTheme(
          color: Color(0xFF5F6AF8),
        ),
      ),
      home: OnboardingPage(),
    );
  }
}


