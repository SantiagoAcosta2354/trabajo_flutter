import 'package:flutter/material.dart';
import '../widgets/custom_input.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFfbc2eb), Color(0xFFa6c1ee)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "logo",
                    child: Image.asset("assets/logo.png", height: 120),
                  ),
                  const SizedBox(height: 25),
                  Text(
                    "Crear cuenta",
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.purple.shade800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "Regístrate para comenzar",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(height: 30),

                  // Tarjeta blanca
                  Container(
                    padding: const EdgeInsets.all(25),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(25),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        const CustomInput(
                          hintText: "Nombre completo",
                          icon: Icons.person_outline,
                        ),
                        const SizedBox(height: 16),
                        const CustomInput(
                          hintText: "Correo electrónico",
                          icon: Icons.email_outlined,
                        ),
                        const SizedBox(height: 16),
                        const CustomInput(
                          hintText: "Contraseña",
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 16),
                        const CustomInput(
                          hintText: "Confirmar contraseña",
                          icon: Icons.lock_outline,
                        ),
                        const SizedBox(height: 25),

                        // Botón de registro
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              backgroundColor: Colors.purple,
                              foregroundColor: Colors.white,
                              elevation: 6,
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, '/home');
                            },
                            child: const Text(
                              "Registrarse",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Enlace al login
                        TextButton(
                          onPressed: () {
                            Navigator.pushNamed(context, '/login');
                          },
                          child: const Text(
                            "¿Ya tienes cuenta? Inicia sesión",
                            style: TextStyle(color: Colors.black54),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
