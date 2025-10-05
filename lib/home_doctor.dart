import 'package:flutter/material.dart';

class HomeDoctorPage extends StatelessWidget {
  const HomeDoctorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final pacientes = ["Paciente 1", "Paciente 2", "Paciente 3", "Paciente 4"];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      body: SafeArea(
        child: Column(
          children: [
            // 🔸 Encabezado con gradiente
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFA726), Color(0xFFFF7043)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 8,
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
                  IconButton(
                    icon: const Icon(
                      Icons.account_circle,
                      color: Colors.white,
                      size: 40,
                    ),
                    onPressed: () {
                      // Ir a perfil del doctor
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // 🧑‍⚕️ Info del doctor
            Column(
              children: [
                CircleAvatar(
                  radius: 45,
                  backgroundImage: const AssetImage(
                    "assets/doctor.png",
                  ), // tu imagen local
                  backgroundColor: Colors.grey[300],
                ),
                const SizedBox(height: 10),
                const Text(
                  "Dr. Juan Pérez",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
                const Text(
                  "Médico General",
                  style: TextStyle(color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 25),

            // 🧍‍♂️ Lista de pacientes
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: pacientes.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final paciente = pacientes[index];
                  return InkWell(
                    onTap: () {
                      // Navegar a detalles del paciente
                    },
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.person,
                            size: 50,
                            color: Colors.orange,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            paciente,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            // 🔹 Botones inferiores
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
              color: Colors.white,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildActionButton(
                    icon: Icons.info_outline,
                    label: "Ver información",
                    onPressed: () {
                      // acción info
                    },
                  ),
                  _buildActionButton(
                    icon: Icons.calendar_today,
                    label: "Citas programadas",
                    onPressed: () {
                      // acción citas
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔸 Botón de acción inferior
  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required VoidCallback onPressed,
  }) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, color: Colors.white),
      label: Text(label),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        elevation: 4,
      ),
    );
  }
}
