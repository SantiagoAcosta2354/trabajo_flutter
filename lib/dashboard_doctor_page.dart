import 'package:flutter/material.dart';
import 'citas_doctor_page.dart';
import 'comentarios_doctor_page.dart';
import 'info_paciente_page.dart';

class DashboardDoctorPage extends StatelessWidget {
  const DashboardDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        elevation: 2,
        title: const Text(
          "Panel de Control Médico",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // 👋 Bienvenida
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [
                Text(
                  "¡Buenos días, Doctor!",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                Icon(Icons.waving_hand_rounded, color: Colors.orange, size: 32),
              ],
            ),
            const SizedBox(height: 20),

            // 📈 Tarjetas resumen
            GridView.count(
              crossAxisCount: 2,
              crossAxisSpacing: 14,
              mainAxisSpacing: 14,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildStatCard(
                  title: "Pacientes activos",
                  value: "12",
                  icon: Icons.people,
                  color: Colors.blueAccent,
                ),
                _buildStatCard(
                  title: "Citas hoy",
                  value: "4",
                  icon: Icons.event_available,
                  color: Colors.deepOrange,
                ),
                _buildStatCard(
                  title: "Alertas",
                  value: "2",
                  icon: Icons.warning_amber_rounded,
                  color: Colors.redAccent,
                ),
                _buildStatCard(
                  title: "Comentarios",
                  value: "7",
                  icon: Icons.chat_bubble_outline,
                  color: Colors.indigo,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // ⚡ Accesos rápidos
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Accesos rápidos",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Colors.black87,
                ),
              ),
            ),
            const SizedBox(height: 15),

            _buildQuickAccess(
              context,
              icon: Icons.event_note,
              title: "Ver citas programadas",
              color: Colors.deepOrange,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CitasDoctorPage(),
                  ),
                );
              },
            ),
            _buildQuickAccess(
              context,
              icon: Icons.chat,
              title: "Ver comentarios médicos",
              color: Colors.indigo,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ComentariosDoctorPage(),
                  ),
                );
              },
            ),
            _buildQuickAccess(
              context,
              icon: Icons.account_circle,
              title: "Información de un paciente",
              color: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        const InfoPacientePage(nombre: "Paciente Ejemplo"),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.9), color.withOpacity(0.7)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              value,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              title,
              style: const TextStyle(color: Colors.white70, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickAccess(
    BuildContext context, {
    required IconData icon,
    required String title,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black12.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.15),
          child: Icon(icon, color: color, size: 26),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.w600)),
        trailing: const Icon(Icons.arrow_forward_ios, size: 16),
        onTap: onTap,
      ),
    );
  }
}
