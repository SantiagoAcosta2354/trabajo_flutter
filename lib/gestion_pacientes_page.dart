import 'package:flutter/material.dart';
import 'comentarios_page.dart';
import 'citas_programadas_page.dart';
import 'historial_toma_page.dart';

class GestionPacientesPage extends StatelessWidget {
  const GestionPacientesPage({super.key});

  final List<Map<String, String>> pacientes = const [
    {
      "nombre": "Juan Pérez",
      "foto": "assets/paciente1.png",
      "estado": "En tratamiento",
    },
    {
      "nombre": "María Gómez",
      "foto": "assets/paciente2.png",
      "estado": "Control mensual",
    },
    {
      "nombre": "Carlos Ramírez",
      "foto": "assets/paciente3.png",
      "estado": "Alta médica",
    },
    {
      "nombre": "Laura Torres",
      "foto": "assets/paciente4.png",
      "estado": "Revisión próxima",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9F9F9),
      appBar: AppBar(
        title: const Text("Gestión de Pacientes"),
        backgroundColor: Colors.teal,
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: pacientes.length,
        itemBuilder: (context, index) {
          final paciente = pacientes[index];
          return _buildPacienteCard(context, paciente);
        },
      ),
    );
  }

  Widget _buildPacienteCard(
    BuildContext context,
    Map<String, String> paciente,
  ) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 4,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: CircleAvatar(
          radius: 28,
          backgroundImage: AssetImage(paciente["foto"]!),
        ),
        title: Text(
          paciente["nombre"]!,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        subtitle: Text(
          paciente["estado"]!,
          style: const TextStyle(color: Colors.grey),
        ),
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert),
          onSelected: (value) {
            if (value == "ver_historial") {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const HistorialTomaPage(fromDoctor: true),
                ),
              );
            } else if (value == "mensajes") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const ComentariosPage()),
              );
            } else if (value == "citas") {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const CitasProgramadasPage()),
              );
            }
          },
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: "ver_historial",
              child: Text("Ver historial"),
            ),
            const PopupMenuItem(
              value: "mensajes",
              child: Text("Enviar mensaje"),
            ),
            const PopupMenuItem(value: "citas", child: Text("Ver citas")),
          ],
        ),
      ),
    );
  }
}
