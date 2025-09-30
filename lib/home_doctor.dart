import 'package:flutter/material.dart';

class HomeDoctorPage extends StatelessWidget {
  const HomeDoctorPage({super.key});

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
                children: const [
                  Icon(Icons.account_circle, size: 40),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Imagen y título
            Image.asset("assets/logo.png", height: 100), // 👨‍⚕️ usa tu imagen de doctor
            const Text(
              "Médico",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 30),

            // Lista de pacientes
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                padding: const EdgeInsets.all(24),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _buildPaciente("Paciente 1"),
                  _buildPaciente("Paciente 2"),
                  _buildPaciente("Paciente 3"),
                  _buildPaciente("Paciente 4"),
                ],
              ),
            ),

            // Botones de acciones
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      // Navegar a información
                    },
                    child: const Text("Ver información"),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange),
                    onPressed: () {
                      // Navegar a citas programadas
                    },
                    child: const Text("Ver citas programadas"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaciente(String nombre) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[300],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.person, size: 40),
            const SizedBox(height: 8),
            Text(nombre, style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
