import 'package:flutter/material.dart';
import 'dart:math';

/// Página de Citas Programadas
/// CRUD local con diseño moderno
/// Compatible con Flutter 3.0+

class Cita {
  String id;
  String paciente;
  DateTime fechaHora;
  String motivo;
  bool confirmada;

  Cita({
    required this.id,
    required this.paciente,
    required this.fechaHora,
    required this.motivo,
    this.confirmada = false,
  });
}

class CitasProgramadasPage extends StatefulWidget {
  const CitasProgramadasPage({super.key});

  @override
  State<CitasProgramadasPage> createState() => _CitasProgramadasPageState();
}

class _CitasProgramadasPageState extends State<CitasProgramadasPage> {
  final Color primary = Colors.deepOrange;
  final List<Cita> _citas = [];
  final List<String> _pacientes = [
    "Juan Pérez",
    "Ana Gómez",
    "Carlos Torres",
    "Laura Ruiz",
  ];

  final _formKey = GlobalKey<FormState>();

  String _formatDate(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')} ${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  void _abrirFormulario({Cita? cita}) {
    final isEdit = cita != null;

    String paciente = cita?.paciente ?? _pacientes.first;
    DateTime fechaHora =
        cita?.fechaHora ?? DateTime.now().add(const Duration(hours: 1));
    final motivoCtrl = TextEditingController(text: cita?.motivo ?? "");
    bool confirmada = cita?.confirmada ?? false;

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
                        margin: const EdgeInsets.only(bottom: 18),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                    Text(
                      isEdit ? "Editar Cita" : "Programar Cita",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 16),

                    // Paciente
                    DropdownButtonFormField<String>(
                      value: paciente,
                      items: _pacientes
                          .map(
                            (p) => DropdownMenuItem(value: p, child: Text(p)),
                          )
                          .toList(),
                      onChanged: (v) => paciente = v ?? _pacientes.first,
                      decoration: _decoracionCampo("Selecciona paciente"),
                    ),
                    const SizedBox(height: 12),

                    // Fecha y hora
                    ElevatedButton.icon(
                      icon: const Icon(Icons.calendar_today),
                      label: Text("Seleccionar fecha y hora"),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[100],
                        foregroundColor: Colors.black87,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      onPressed: () async {
                        final fecha = await showDatePicker(
                          context: ctx,
                          initialDate: fechaHora,
                          firstDate: DateTime.now(),
                          lastDate: DateTime(2100),
                        );
                        if (fecha != null) {
                          final hora = await showTimePicker(
                            context: ctx,
                            initialTime: TimeOfDay.fromDateTime(fechaHora),
                          );
                          if (hora != null) {
                            setState(() {
                              fechaHora = DateTime(
                                fecha.year,
                                fecha.month,
                                fecha.day,
                                hora.hour,
                                hora.minute,
                              );
                            });
                          }
                        }
                      },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "📅 Fecha seleccionada: ${_formatDate(fechaHora)}",
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 12),

                    // Motivo
                    TextFormField(
                      controller: motivoCtrl,
                      decoration: _decoracionCampo("Motivo de la cita"),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? "Campo obligatorio"
                          : null,
                    ),
                    const SizedBox(height: 12),

                    // Confirmación
                    SwitchListTile(
                      value: confirmada,
                      onChanged: (v) => setState(() => confirmada = v),
                      title: const Text("Confirmada"),
                      activeColor: primary,
                    ),
                    const SizedBox(height: 20),

                    // Botón guardar
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;

                        if (isEdit) {
                          setState(() {
                            cita!.paciente = paciente;
                            cita.fechaHora = fechaHora;
                            cita.motivo = motivoCtrl.text.trim();
                            cita.confirmada = confirmada;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Cita actualizada")),
                          );
                        } else {
                          final nueva = Cita(
                            id: Random().nextInt(999999).toString(),
                            paciente: paciente,
                            fechaHora: fechaHora,
                            motivo: motivoCtrl.text.trim(),
                            confirmada: confirmada,
                          );
                          setState(() => _citas.add(nueva));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Cita programada")),
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
                      child: Text(isEdit ? "Guardar cambios" : "Guardar cita"),
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

  void _eliminarCita(Cita c) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar cita"),
        content: const Text("¿Deseas eliminar esta cita?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _citas.removeWhere((e) => e.id == c.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(const SnackBar(content: Text("Cita eliminada")));
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  void _toggleConfirmar(Cita c) {
    setState(() => c.confirmada = !c.confirmada);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          c.confirmada
              ? "Cita marcada como confirmada ✅"
              : "Cita marcada como pendiente ⏳",
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Citas Programadas"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _abrirFormulario(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: _citas.isEmpty
            ? _vacio()
            : ListView.builder(
                itemCount: _citas.length,
                itemBuilder: (ctx, i) {
                  final c = _citas[i];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        backgroundColor: c.confirmada
                            ? Colors.green.withOpacity(0.15)
                            : Colors.orange.withOpacity(0.15),
                        child: Icon(
                          c.confirmada
                              ? Icons.check_circle
                              : Icons.calendar_today,
                          color: c.confirmada ? Colors.green : Colors.orange,
                        ),
                      ),
                      title: Text(
                        c.paciente,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "🕓 ${_formatDate(c.fechaHora)}\nMotivo: ${c.motivo}",
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == "edit") _abrirFormulario(cita: c);
                          if (v == "delete") _eliminarCita(c);
                          if (v == "confirm") _toggleConfirmar(c);
                        },
                        itemBuilder: (ctx) => [
                          PopupMenuItem(
                            value: "confirm",
                            child: Text(
                              c.confirmada
                                  ? "Marcar como pendiente"
                                  : "Confirmar cita",
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
        Icon(Icons.calendar_month, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 14),
        const Text(
          "No hay citas programadas",
          style: TextStyle(fontSize: 17, color: Colors.black54),
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => _abrirFormulario(),
          icon: Icon(Icons.add, color: primary),
          label: const Text("Programar cita"),
        ),
      ],
    ),
  );
}
