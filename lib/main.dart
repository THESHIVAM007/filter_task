import 'package:filter_task/leadspage.dart';
import 'package:filter_task/loginpage.dart';
import 'package:flutter/material.dart';
 // Your home screen after login

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'CRM App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginPage(),
        '/home': (context) =>  const LeadTable(token: "",),  // Define the home screen after successful login
      },
    );
  }
}
