import 'package:flutter/material.dart';
import 'dart:math';

/// Página de Medicamentos
/// CRUD local con UI moderna
/// Campos: nombre, dosis, frecuencia, vía de administración, observaciones

class Medicamento {
  String id;
  String nombre;
  String dosis;
  String frecuencia;
  String via;
  String? observaciones;
  DateTime creado;

  Medicamento({
    required this.id,
    required this.nombre,
    required this.dosis,
    required this.frecuencia,
    required this.via,
    this.observaciones,
    DateTime? creado,
  }) : creado = creado ?? DateTime.now();
}

class MedicamentosPage extends StatefulWidget {
  const MedicamentosPage({super.key});

  @override
  State<MedicamentosPage> createState() => _MedicamentosPageState();
}

class _MedicamentosPageState extends State<MedicamentosPage> {
  final List<Medicamento> _meds = [];

  final Color primary = Colors.deepOrange;
  final _formKey = GlobalKey<FormState>();

  // Abrir formulario (crear / editar)
  void _openForm({Medicamento? med}) {
    final isEdit = med != null;
    final nameCtrl = TextEditingController(text: med?.nombre ?? '');
    final doseCtrl = TextEditingController(text: med?.dosis ?? '');
    final freqCtrl = TextEditingController(text: med?.frecuencia ?? '');
    String via = med?.via ?? 'Oral';
    final obsCtrl = TextEditingController(text: med?.observaciones ?? '');

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
                      isEdit ? "Editar medicamento" : "Agregar medicamento",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: primary,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: nameCtrl,
                      decoration: _fieldDecoration("Nombre del medicamento"),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: doseCtrl,
                      decoration: _fieldDecoration("Dosis (ej. 500 mg)"),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: freqCtrl,
                      decoration: _fieldDecoration(
                        "Frecuencia (ej. cada 8 horas)",
                      ),
                      validator: (v) => v == null || v.trim().isEmpty
                          ? 'Campo obligatorio'
                          : null,
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: via,
                      items:
                          [
                                'Oral',
                                'Intravenosa',
                                'Intramuscular',
                                'Tópica',
                                'Sublingual',
                              ]
                              .map(
                                (v) =>
                                    DropdownMenuItem(value: v, child: Text(v)),
                              )
                              .toList(),
                      onChanged: (v) => via = v ?? 'Oral',
                      decoration: _fieldDecoration("Vía de administración"),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: obsCtrl,
                      decoration: _fieldDecoration("Observaciones (opcional)"),
                      maxLines: 2,
                    ),
                    const SizedBox(height: 18),
                    ElevatedButton(
                      onPressed: () {
                        if (!_formKey.currentState!.validate()) return;
                        if (isEdit) {
                          setState(() {
                            med!.nombre = nameCtrl.text.trim();
                            med.dosis = doseCtrl.text.trim();
                            med.frecuencia = freqCtrl.text.trim();
                            med.via = via;
                            med.observaciones = obsCtrl.text.trim();
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Medicamento actualizado"),
                            ),
                          );
                        } else {
                          final nuevo = Medicamento(
                            id: Random().nextInt(999999).toString(),
                            nombre: nameCtrl.text.trim(),
                            dosis: doseCtrl.text.trim(),
                            frecuencia: freqCtrl.text.trim(),
                            via: via,
                            observaciones: obsCtrl.text.trim().isEmpty
                                ? null
                                : obsCtrl.text.trim(),
                          );
                          setState(() => _meds.add(nuevo));
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Medicamento agregado"),
                            ),
                          );
                        }
                        Navigator.pop(ctx);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: primary,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(isEdit ? "Guardar cambios" : "Guardar"),
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

  InputDecoration _fieldDecoration(String hint) => InputDecoration(
    labelText: hint,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
  );

  void _confirmDelete(Medicamento med) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar medicamento"),
        content: const Text("¿Seguro que deseas eliminar este medicamento?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _meds.removeWhere((e) => e.id == med.id));
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text("Medicamento eliminado")),
              );
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  String _fecha(DateTime d) =>
      "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Medicamentos"),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        onPressed: () => _openForm(),
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: _meds.isEmpty
            ? _emptyState()
            : ListView.builder(
                itemCount: _meds.length,
                itemBuilder: (ctx, i) {
                  final m = _meds[i];
                  return Card(
                    elevation: 2,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(14),
                      leading: CircleAvatar(
                        radius: 28,
                        backgroundColor: primary.withOpacity(0.15),
                        child: const Icon(
                          Icons.medical_information,
                          color: Colors.deepOrange,
                          size: 28,
                        ),
                      ),
                      title: Text(
                        m.nombre,
                        style: const TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text(
                          "${m.dosis} · ${m.frecuencia}\nVía: ${m.via}"
                          "${m.observaciones != null ? "\nObs: ${m.observaciones}" : ""}",
                          style: const TextStyle(height: 1.4),
                        ),
                      ),
                      isThreeLine: true,
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == "edit") _openForm(med: m);
                          if (v == "delete") _confirmDelete(m);
                        },
                        itemBuilder: (ctx) => const [
                          PopupMenuItem(value: "edit", child: Text("Editar")),
                          PopupMenuItem(
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

  Widget _emptyState() => Center(
    child: Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.medication_outlined, size: 80, color: Colors.grey[400]),
        const SizedBox(height: 14),
        const Text(
          "Aún no tienes medicamentos registrados",
          style: TextStyle(fontSize: 17, color: Colors.black54),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10),
        TextButton.icon(
          onPressed: () => _openForm(),
          icon: Icon(Icons.add, color: primary),
          label: const Text("Agregar medicamento"),
        ),
      ],
    ),
  );
}
