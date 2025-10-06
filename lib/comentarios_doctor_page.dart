import 'package:flutter/material.dart';

class ComentariosDoctorPage extends StatefulWidget {
  const ComentariosDoctorPage({super.key});

  @override
  State<ComentariosDoctorPage> createState() => _ComentariosDoctorPageState();
}

class _ComentariosDoctorPageState extends State<ComentariosDoctorPage> {
  final List<Map<String, String>> comentarios = [
    {
      "paciente": "Juan Pérez",
      "comentario": "Revisar presión arterial en la próxima cita.",
      "fecha": "2025-10-04",
    },
    {
      "paciente": "María Gómez",
      "comentario": "Mantener dieta baja en sodio durante 15 días.",
      "fecha": "2025-10-03",
    },
  ];

  final TextEditingController _pacienteController = TextEditingController();
  final TextEditingController _comentarioController = TextEditingController();

  void _agregarComentario() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Agregar Comentario"),
        content: SingleChildScrollView(
          child: Column(
            children: [
              TextField(
                controller: _pacienteController,
                decoration: const InputDecoration(
                  labelText: "Nombre del paciente",
                  prefixIcon: Icon(Icons.person_outline),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _comentarioController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Comentario u observación",
                  prefixIcon: Icon(Icons.edit_note),
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
              if (_pacienteController.text.isNotEmpty &&
                  _comentarioController.text.isNotEmpty) {
                setState(() {
                  comentarios.insert(0, {
                    "paciente": _pacienteController.text,
                    "comentario": _comentarioController.text,
                    "fecha":
                        "${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}",
                  });
                });
                _pacienteController.clear();
                _comentarioController.clear();
                Navigator.pop(ctx);
              }
            },
            child: const Text("Guardar"),
          ),
        ],
      ),
    );
  }

  void _eliminarComentario(int index) {
    setState(() {
      comentarios.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        title: const Text("Comentarios del Doctor"),
        backgroundColor: Colors.indigo,
        elevation: 2,
      ),
      body: comentarios.isEmpty
          ? const Center(
              child: Text(
                "No hay comentarios registrados.",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: comentarios.length,
              itemBuilder: (context, index) {
                final comentario = comentarios[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 3,
                  child: ListTile(
                    leading: const CircleAvatar(
                      backgroundColor: Colors.indigo,
                      child: Icon(Icons.person, color: Colors.white),
                    ),
                    title: Text(
                      comentario["paciente"]!,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Padding(
                      padding: const EdgeInsets.only(top: 6.0),
                      child: Text(
                        "${comentario["comentario"]}\n📅 ${comentario["fecha"]}",
                        style: const TextStyle(height: 1.4),
                      ),
                    ),
                    isThreeLine: true,
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_forever, color: Colors.red),
                      onPressed: () => _eliminarComentario(index),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.indigo,
        onPressed: _agregarComentario,
        child: const Icon(Icons.add_comment),
      ),
    );
  }
}
