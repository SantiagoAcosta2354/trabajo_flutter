import 'package:flutter/material.dart';
import 'dart:math';

/// Página: Historial de Toma de Medicamentos
/// Permite registrar, editar y eliminar tomas.
/// Diseñada para ser coherente con el estilo del proyecto.

class Toma {
  String id;
  String medicamento;
  DateTime fechaHora;
  bool tomado;
  String? notas;

  Toma({
    required this.id,
    required this.medicamento,
    required this.fechaHora,
    this.tomado = false,
    this.notas,
  });
}

class HistorialTomaPage extends StatefulWidget {
  const HistorialTomaPage({super.key});

  @override
  State<HistorialTomaPage> createState() => _HistorialTomaPageState();
}

class _HistorialTomaPageState extends State<HistorialTomaPage> {
  final Color primary = Colors.deepOrange;
  final _formKey = GlobalKey<FormState>();
  final List<Toma> _tomas = [];

  // Mock de medicamentos para elegir
  final List<String> _medicamentos = [
    "Paracetamol",
    "Ibuprofeno",
    "Amoxicilina",
    "Omeprazol",
  ];

  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";
  }

  void _abrirFormulario({Toma? toma}) {
    final isEdit = toma != null;
    String medicamento = toma?.medicamento ?? _medicamentos.first;
    DateTime fechaHora = toma?.fechaHora ?? DateTime.now();
    bool tomado = toma?.tomado ?? false;
    final notasCtrl = TextEditingController(text: toma?.notas ?? "");

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom,
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Center(
                      child: Container(
                        width: 60,
                        height: 6,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      isEdit ? "Editar registro" : "Registrar toma",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Medicamento
                    DropdownButtonFormField<String>(
                      value: medicamento,
                      items: _medicamentos
                          .map(
                            (m) => DropdownMenuItem(value: m, child: Text(m)),
                          )
                          .toList(),
                      onChanged: (v) => medicamento = v ?? _medicamentos.first,
                      decoration: _decoracionCampo("Medicamento"),
                    ),
                    const SizedBox(height: 12),

                    // Fecha y hora
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () async {
                              final pickedDate = await showDatePicker(
                                context: ctx,
                                initialDate: fechaHora,
                                firstDate: DateTime(2020),
                                lastDate: DateTime(2100),
                              );
                              if (pickedDate != null) {
                                final pickedTime = await showTimePicker(
                                  context: ctx,
                                  initialTime: TimeOfDay.fromDateTime(
                                    fechaHora,
                                  ),
                                );
                                if (pickedTime != null) {
                                  setState(() {
                                    fechaHora = DateTime(
                                      pickedDate.year,
                                      pickedDate.month,
                                      pickedDate.day,
                                      pickedTime.hour,
                                      pickedTime.minute,
                                    );
                                  });
                                }
                              }
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.grey[100],
                              foregroundColor: Colors.black87,
                              elevation: 0,
                            ),
                            icon: const Icon(Icons.access_time),
                            label: Text(_formatDate(fechaHora)),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // Tomado sí/no
                    SwitchListTile(
                      title: const Text("¿Tomado?"),
                      value: tomado,
                      activeColor: primary,
                      onChanged: (v) => setState(() => tomado = v),
                    ),
                    const SizedBox(height: 12),

                    // Notas
                    TextFormField(
                      controller: notasCtrl,
                      decoration: _decoracionCampo("Notas (opcional)"),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 20),

                    // Botón guardar
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        if (isEdit) {
                          setState(() {
                            toma!.medicamento = medicamento;
                            toma.fechaHora = fechaHora;
                            toma.tomado = tomado;
                            toma.notas = notasCtrl.text.trim();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Registro actualizado"),
                            ),
                          );
                        } else {
                          final nueva = Toma(
                            id: Random().nextInt(999999).toString(),
                            medicamento: medicamento,
                            fechaHora: fechaHora,
                            tomado: tomado,
                            notas: notasCtrl.text.trim().isEmpty
                                ? null
                                : notasCtrl.text.trim(),
                          );
                          setState(() => _tomas.add(nueva));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Toma registrada")),
                          );
                        }

                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        isEdit ? "Guardar cambios" : "Guardar registro",
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  InputDecoration _decoracionCampo(String label) => InputDecoration(
    labelText: label,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );

  void _eliminarToma(Toma t) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar registro"),
        content: const Text(
          "¿Seguro que deseas eliminar este registro de toma?",
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _tomas.removeWhere((e) => e.id == t.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Registro eliminado")),
              );
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  void _toggleTomado(Toma t) {
    setState(() => t.tomado = !t.tomado);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          t.tomado ? "Marcado como tomado ✅" : "Marcado como pendiente ⏳",
        ),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Historial de Toma"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: _tomas.isEmpty
            ? _vacio()
            : ListView.builder(
                itemCount: _tomas.length,
                itemBuilder: (ctx, i) {
                  final t = _tomas[i];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: t.tomado
                            ? Colors.green.withOpacity(0.15)
                            : Colors.red.withOpacity(0.15),
                        child: Icon(
                          t.tomado ? Icons.check : Icons.access_time,
                          color: t.tomado ? Colors.green : Colors.redAccent,
                        ),
                      ),
                      title: Text(
                        t.medicamento,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "${_formatDate(t.fechaHora)}"
                          "${t.notas != null ? "\nNota: ${t.notas}" : ""}",
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == "edit") _abrirFormulario(toma: t);
                          if (v == "delete") _eliminarToma(t);
                          if (v == "toggle") _toggleTomado(t);
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: "toggle",
                            child: Text(
                              t.tomado
                                  ? "Marcar como pendiente"
                                  : "Marcar como tomado",
                            ),
                          ),
                          const PopupMenuItem(
                            value: "edit",
                            child: Text("Editar"),
                          ),
                          const PopupMenuItem(
                            value: "delete",
                            child: Text("Eliminar"),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      ),
    );
  }

  Widget _vacio() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.history, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 14),
        const Text(
          "Aún no tienes registros de toma",
          style: TextStyle(fontSize: 17, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => _abrirFormulario(),
          icon: Icon(Icons.add, color: primary),
          label: const Text("Registrar primera toma"),
        ),
      ],
    ),
  );
}
