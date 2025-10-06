import 'package:flutter/material.dart';

class CitasDoctorPage extends StatefulWidget {
  const CitasDoctorPage({super.key});

  @override
  State<CitasDoctorPage> createState() => _CitasDoctorPageState();
}

class _CitasDoctorPageState extends State<CitasDoctorPage> {
  final List<Map<String, String>> _citas = [
    {
      "paciente": "Juan Pérez",
      "fecha": "2025-10-06",
      "hora": "10:00 AM",
      "motivo": "Control de presión arterial",
    },
    {
      "paciente": "María Gómez",
      "fecha": "2025-10-08",
      "hora": "2:30 PM",
      "motivo": "Revisión postoperatoria",
    },
  ];

  void _agregarCita() {
    final TextEditingController pacienteCtrl = TextEditingController();
    final TextEditingController fechaCtrl = TextEditingController();
    final TextEditingController horaCtrl = TextEditingController();
    final TextEditingController motivoCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Agregar Nueva Cita"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: pacienteCtrl,
                decoration: const InputDecoration(
                  labelText: "Nombre del paciente",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: fechaCtrl,
                decoration: const InputDecoration(
                  labelText: "Fecha (AAAA-MM-DD)",
                  prefixIcon: Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: horaCtrl,
                decoration: const InputDecoration(
                  labelText: "Hora (ej: 2:00 PM)",
                  prefixIcon: Icon(Icons.access_time),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: motivoCtrl,
                decoration: const InputDecoration(
                  labelText: "Motivo de la cita",
                  prefixIcon: Icon(Icons.description_outlined),
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
              if (pacienteCtrl.text.isNotEmpty &&
                  fechaCtrl.text.isNotEmpty &&
                  horaCtrl.text.isNotEmpty &&
                  motivoCtrl.text.isNotEmpty) {
                setState(() {
                  _citas.add({
                    "paciente": pacienteCtrl.text,
                    "fecha": fechaCtrl.text,
                    "hora": horaCtrl.text,
                    "motivo": motivoCtrl.text,
                  });
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _eliminarCita(int index) {
    setState(() {
      _citas.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Citas Programadas"),
        backgroundColor: Colors.deepOrange,
        elevation: 2,
      ),
      body: _citas.isEmpty
          ? const Center(
              child: Text(
                "No hay citas programadas.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _citas.length,
              itemBuilder: (context, index) {
                final cita = _citas[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 4,
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.deepOrange.withOpacity(0.2),
                      child: const Icon(Icons.event, color: Colors.deepOrange),
                    ),
                    title: Text(
                      cita["paciente"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "📅 ${cita["fecha"]}  🕒 ${cita["hora"]}\n📝 ${cita["motivo"]}",
                        style: const TextStyle(height: 1.5),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(
                        Icons.delete_forever,
                        color: Colors.redAccent,
                      ),
                      onPressed: () => _eliminarCita(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepOrange,
        onPressed: _agregarCita,
        child: const Icon(Icons.add),
      ),
    );
  }
}
