import 'package:flutter/material.dart';

import 'login.dart';
import 'home.dart';          
import 'home_doctor.dart';  
import 'register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MedicApp());
}

class MedicApp extends StatelessWidget {
  const MedicApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MedicApp',
      theme: ThemeData(primarySwatch: Colors.teal),
      home: const AuthWrapper(),
      routes: {
        '/login': (context) => const LoginPage(),
        '/home': (context) => const HomePage(),
        '/doctor': (context) => const HomeDoctorPage(),
        '/register': (context) => const RegisterScreen(),
      },
    );
  }
}

// 🔹 AuthWrapper simula usuario logueado
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  // Cambiar estos valores para simular usuario logueado
  final bool isLoggedIn = false;       // true para entrar directo
  final String userRole = "doctor";    // "doctor" o "patient"

  @override
  Widget build(BuildContext context) {
    if (!isLoggedIn) {
      return const LoginPage();
    }

    if (userRole == "doctor") {
      return const HomeDoctorPage();
    } else {
      return const HomePage();
    }
  }
}
