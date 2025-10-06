import 'package:flutter/material.dart';

class InfoPacientePage extends StatefulWidget {
  final String nombre;

  const InfoPacientePage({super.key, required this.nombre});

  @override
  State<InfoPacientePage> createState() => _InfoPacientePageState();
}

class _InfoPacientePageState extends State<InfoPacientePage> {
  final TextEditingController _observacionesController =
      TextEditingController();

  String diagnostico = "Hipertensión controlada";
  String tratamiento = "Medicamento A, cada 8 horas";
  String ultimaVisita = "2025-09-25";
  String proximaCita = "2025-10-15";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F7F7),
      appBar: AppBar(
        title: Text("Información de ${widget.nombre}"),
        backgroundColor: Colors.teal,
        elevation: 2,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              _editarDatos(context);
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 👤 Información general
            Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.teal,
                    child: Icon(Icons.person, size: 60, color: Colors.white),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    widget.nombre,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Paciente general",
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            _buildInfoTile(
              Icons.local_hospital,
              "Diagnóstico actual",
              diagnostico,
              Colors.redAccent,
            ),
            _buildInfoTile(
              Icons.medication,
              "Tratamiento actual",
              tratamiento,
              Colors.blueAccent,
            ),
            _buildInfoTile(
              Icons.calendar_today,
              "Última visita",
              ultimaVisita,
              Colors.orangeAccent,
            ),
            _buildInfoTile(
              Icons.access_time,
              "Próxima cita",
              proximaCita,
              Colors.green,
            ),

            const SizedBox(height: 30),
            const Text(
              "Observaciones del médico:",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),
            const SizedBox(height: 10),

            TextField(
              controller: _observacionesController,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: "Agrega observaciones adicionales...",
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Observaciones guardadas correctamente"),
                    ),
                  );
                  _observacionesController.clear();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                icon: const Icon(Icons.save, color: Colors.white),
                label: const Text(
                  "Guardar Observaciones",
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoTile(
    IconData icon,
    String title,
    String value,
    Color color,
  ) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8),
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withOpacity(0.2),
          child: Icon(icon, color: color),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        subtitle: Text(value),
      ),
    );
  }

  void _editarDatos(BuildContext context) {
    TextEditingController diagnosticoCtrl = TextEditingController(
      text: diagnostico,
    );
    TextEditingController tratamientoCtrl = TextEditingController(
      text: tratamiento,
    );
    TextEditingController citaCtrl = TextEditingController(text: proximaCita);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Editar información médica"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: diagnosticoCtrl,
                decoration: const InputDecoration(
                  labelText: "Diagnóstico actual",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: tratamientoCtrl,
                decoration: const InputDecoration(
                  labelText: "Tratamiento actual",
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: citaCtrl,
                decoration: const InputDecoration(
                  labelText: "Próxima cita (AAAA-MM-DD)",
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          ElevatedButton(
            onPressed: () {
              setState(() {
                diagnostico = diagnosticoCtrl.text;
                tratamiento = tratamientoCtrl.text;
                proximaCita = citaCtrl.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }
}
