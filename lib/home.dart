import 'package:flutter/material.dart';
import 'user_data.dart';
import 'login.dart';
import 'medicamentos_page.dart';
import 'comentarios_page.dart';
import 'historial_toma_page.dart';
import 'recordatorios_page.dart';

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
              Navigator.of(ctx).pop();
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
                            builder: (context) => const LoginPage(),
                          ),
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
      backgroundColor: const Color(0xFFF9F9F9),
      body: SafeArea(
        child: Column(
          children: [
            // 🔶 Barra superior moderna
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.orange, Color(0xFFFFA726)],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Inicio",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: const CircleAvatar(
                      radius: 22,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person, color: Colors.orange),
                    ),
                    onSelected: (value) {
                      if (value == "datos") {
                        Navigator.push(
                          context,
                          _crearRuta(const UserDataPage()),
                        );
                      } else if (value == "logout") {
                        _cerrarSesion(context);
                      }
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(
                        value: "datos",
                        child: Text("Datos de Usuario"),
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

            const SizedBox(height: 25),

            // 👤 Título con ícono
            const Icon(Icons.account_circle, size: 90, color: Colors.orange),
            const SizedBox(height: 8),
            const Text(
              "Paciente",
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // 🧭 Menú principal en cuadrícula
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                padding: const EdgeInsets.all(24),
                children: [
                  _buildOption(
                    Icons.medication,
                    "Medicamentos",
                    Colors.teal,
                    () => Navigator.push(
                      context,
                      _crearRuta(const MedicamentosPage()),
                    ),
                  ),
                  _buildOption(
                    Icons.chat_bubble_outline,
                    "Comentarios",
                    Colors.indigo,
                    () => Navigator.push(
                      context,
                      _crearRuta(const ComentariosPage()),
                    ),
                  ),
                  _buildOption(
                    Icons.history,
                    "Historial",
                    Colors.purple,
                    () => Navigator.push(
                      context,
                      _crearRuta(const HistorialTomaPage()),
                    ),
                  ),
                  _buildOption(
                    Icons.alarm,
                    "Recordatorios",
                    Colors.deepOrange,
                    () => Navigator.push(
                      context,
                      _crearRuta(const RecordatoriosPage()),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 📦 Tarjetas del menú principal
  Widget _buildOption(
    IconData icon,
    String text,
    Color color,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Ink(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [color.withOpacity(0.85), color.withOpacity(0.6)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: color.withOpacity(0.3),
              blurRadius: 8,
              offset: const Offset(2, 4),
            ),
          ],
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: Colors.white, size: 48),
              const SizedBox(height: 10),
              Text(
                text,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // 🌀 Animación de transición personalizada
  Route _crearRuta(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.easeInOut;
        final tween = Tween(
          begin: begin,
          end: end,
        ).chain(CurveTween(curve: curve));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }
}
