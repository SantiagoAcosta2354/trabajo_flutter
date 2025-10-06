import 'package:flutter/material.dart';
import 'login.dart';
import 'user_data.dart';
import 'citas_programadas_page.dart';
import 'comentarios_page.dart';

class HomeDoctorPage extends StatelessWidget {
  const HomeDoctorPage({super.key});

  void _cerrarSesion(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Cerrar Sesión"),
        content: const Text("¿Deseas cerrar tu sesión actual?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
              );
            },
            child: const Text("Cerrar Sesión"),
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
            // 🔶 Barra superior
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
                    "Panel del Médico",
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
                      if (value == "perfil") {
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
                        value: "perfil",
                        child: Text("Perfil del Médico"),
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

            // 🩺 Encabezado
            const Icon(
              Icons.local_hospital,
              size: 90,
              color: Colors.deepOrange,
            ),
            const SizedBox(height: 10),
            const Text(
              "Dr. Santiago Acosta",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const Text(
              "Médico General",
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),

            const SizedBox(height: 30),

            // 🔹 Menú principal del médico
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                padding: const EdgeInsets.all(24),
                children: [
                  _buildOption(Icons.people, "Pacientes", Colors.teal, () {
                    Navigator.push(
                      context,
                      _crearRuta(const GestionPacientesPage()),
                    );
                  }),
                  _buildOption(
                    Icons.calendar_month,
                    "Citas Programadas",
                    Colors.purple,
                    () {
                      Navigator.push(
                        context,
                        _crearRuta(const CitasProgramadasPage()),
                      );
                    },
                  ),
                  _buildOption(Icons.chat, "Comentarios", Colors.indigo, () {
                    Navigator.push(
                      context,
                      _crearRuta(const ComentariosPage()),
                    );
                  }),
                  _buildOption(Icons.bar_chart, "Reportes", Colors.orange, () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Sección de reportes en desarrollo"),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Tarjetas del menú
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

  // Transición animada
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

// 📋 Página de gestión de pacientes (placeholder, se crea enseguida)
class GestionPacientesPage extends StatelessWidget {
  const GestionPacientesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Gestión de Pacientes"),
        backgroundColor: Colors.teal,
      ),
      body: const Center(
        child: Text(
          "Aquí irá la lista de pacientes asignados al médico.",
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
