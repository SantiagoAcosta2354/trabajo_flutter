import 'package:flutter/material.dart';
import 'user_data.dart';
import 'login.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Estás seguro de que deseas cerrar sesión?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Cierra confirmación
              showDialog(
                context: context,
                builder: (ctx2) => AlertDialog(
                  title: const Text("Sesión Cerrada"),
                  content: const Text("Tu sesión se cerró correctamente."),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(ctx2).pop();
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginPage()),
                          (route) => false,
                        );
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ),
              );
            },
            child: const Text("Sí"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Barra superior
            Container(
              color: Colors.orange,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.account_circle, size: 40),
                    onSelected: (value) {
                      if (value == "datos") {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const UserDataPage()),
                        );
                      } else if (value == "logout") {
                        _cerrarSesion(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "datos",
                        child: Text("Datos Usuario"),
                      ),
                      const PopupMenuItem(
                        value: "logout",
                        child: Text("Cerrar Sesión"),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Título
            const Icon(Icons.account_circle, size: 80),
            const Text(
              "Paciente",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Opciones principales
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(24),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildOption(Icons.medication, "Medicamentos"),
                  _buildOption(Icons.chat, "Comentarios"),
                  _buildOption(Icons.history, "Historial de toma"),
                  _buildOption(Icons.alarm, "Recordatorios"),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOption(IconData icon, String text) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 40),
            const SizedBox(height: 8),
            Text(text, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
