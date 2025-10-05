import 'package:flutter/material.dart';
import 'dart:math';

/// Página de Recordatorios (CRUD local)
/// - Crear, editar, eliminar recordatorios
/// - Selección de medicamento, días de la semana, frecuencia, fechas
/// - Confirmaciones y toasts/snackbars
///
/// Integración: Navigator.push(context, MaterialPageRoute(builder: (_) => RecordatoriosPage()));

class Reminder {
  String id;
  String medication;
  List<int> daysOfWeek; // 1 = Lun ... 7 = Dom
  int frequency; // número
  String frequencyUnit; // 'Horas', 'Días', 'Semanas'
  DateTime startDate;
  DateTime? endDate;
  DateTime createdAt;

  Reminder({
    required this.id,
    required this.medication,
    required this.daysOfWeek,
    required this.frequency,
    required this.frequencyUnit,
    required this.startDate,
    this.endDate,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();
}

class RecordatoriosPage extends StatefulWidget {
  const RecordatoriosPage({super.key});

  @override
  State<RecordatoriosPage> createState() => _RecordatoriosPageState();
}

class _RecordatoriosPageState extends State<RecordatoriosPage> {
  // Mock de medicamentos (puedes cargar desde DB)
  final List<String> _medicamentos = [
    'Paracetamol',
    'Ibuprofeno',
    'Amoxicilina',
    'Metformina',
    'Omeprazol',
  ];

  // Lista de recordatorios en memoria
  final List<Reminder> _reminders = [];

  // Helper para form
  final _formKey = GlobalKey<FormState>();

  // Colores / tema local
  final Color primary = Colors.deepOrange;
  final Color cardBg = Colors.white;

  // Utils
  String _formatDate(DateTime d) {
    return "${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}";
  }

  // Abrir modal para crear o editar
  void _openReminderForm({Reminder? reminder}) {
    final isEditing = reminder != null;

    // Form fields
    String selectedMed = reminder?.medication ?? _medicamentos.first;
    List<int> selectedDays = List.from(reminder?.daysOfWeek ?? []);
    final frequencyController = TextEditingController(
      text: reminder?.frequency.toString() ?? '1',
    );
    String frequencyUnit = reminder?.frequencyUnit ?? 'Horas';
    DateTime startDate = reminder?.startDate ?? DateTime.now();
    DateTime? endDate = reminder?.endDate;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.85,
          maxChildSize: 0.95,
          minChildSize: 0.45,
          builder: (_, controller) {
            return Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 14),
              child: SingleChildScrollView(
                controller: controller,
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Container(
                          width: 60,
                          height: 6,
                          margin: const EdgeInsets.only(bottom: 14),
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
                      Text(
                        isEditing
                            ? 'Editar Recordatorio'
                            : 'Crear Recordatorio',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),

                      // Medicamento (Dropdown)
                      const Text(
                        'Elige el medicamento',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      DropdownButtonFormField<String>(
                        value: selectedMed,
                        items: _medicamentos.map((m) {
                          return DropdownMenuItem(value: m, child: Text(m));
                        }).toList(),
                        onChanged: (v) =>
                            selectedMed = v ?? _medicamentos.first,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 14,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),

                      // Días de la semana (chips)
                      const Text(
                        'Días de la semana',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Wrap(
                        spacing: 8,
                        children: List.generate(7, (i) {
                          final dayLabel = [
                            'L',
                            'M',
                            'M',
                            'J',
                            'V',
                            'S',
                            'D',
                          ][i];
                          final fullName = [
                            'Lunes',
                            'Martes',
                            'Miércoles',
                            'Jueves',
                            'Viernes',
                            'Sábado',
                            'Domingo',
                          ][i];
                          final dayNum = i + 1;
                          final selected = selectedDays.contains(dayNum);
                          return ChoiceChip(
                            label: Text(dayLabel),
                            selected: selected,
                            onSelected: (sel) {
                              setState(() {
                                if (sel) {
                                  selectedDays.add(dayNum);
                                } else {
                                  selectedDays.remove(dayNum);
                                }
                              });
                            },
                            selectedColor: primary.withOpacity(0.9),
                            backgroundColor: Colors.grey[200],
                            labelStyle: TextStyle(
                              color: selected ? Colors.white : Colors.black,
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 12),

                      // Frecuencia
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: TextFormField(
                              controller: frequencyController,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                labelText: "Cada cuánto",
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                              validator: (v) {
                                if (v == null || v.trim().isEmpty)
                                  return 'Ingresa frecuencia';
                                final n = int.tryParse(v.trim());
                                if (n == null || n <= 0)
                                  return 'Valor inválido';
                                return null;
                              },
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 2,
                            child: DropdownButtonFormField<String>(
                              value: frequencyUnit,
                              items: ['Horas', 'Días', 'Semanas']
                                  .map(
                                    (u) => DropdownMenuItem(
                                      value: u,
                                      child: Text(u),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (v) => frequencyUnit = v ?? 'Horas',
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 14,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Fechas
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Desde',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[100],
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: ctx,
                                      initialDate: startDate,
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() => startDate = picked);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(_formatDate(startDate)),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'Hasta (opcional)',
                                  style: TextStyle(fontWeight: FontWeight.w600),
                                ),
                                const SizedBox(height: 6),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.grey[100],
                                    foregroundColor: Colors.black87,
                                    elevation: 0,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  onPressed: () async {
                                    final picked = await showDatePicker(
                                      context: ctx,
                                      initialDate:
                                          endDate ??
                                          DateTime.now().add(
                                            const Duration(days: 7),
                                          ),
                                      firstDate: DateTime(2020),
                                      lastDate: DateTime(2100),
                                    );
                                    if (picked != null) {
                                      setState(() => endDate = picked);
                                    }
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                      vertical: 12,
                                    ),
                                    child: Text(
                                      endDate != null
                                          ? _formatDate(endDate!)
                                          : 'No definido',
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Acciones: Cancelar / Guardar
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: () {
                                Navigator.of(ctx).pop();
                              },
                              style: OutlinedButton.styleFrom(
                                side: BorderSide(color: Colors.grey.shade300),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                              ),
                              child: const Text(
                                'Descartar',
                                style: TextStyle(color: Colors.black54),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: () {
                                // Validar
                                if (_formKey.currentState != null &&
                                    !_formKey.currentState!.validate()) {
                                  return;
                                }
                                if (selectedDays.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text(
                                        'Selecciona al menos un día',
                                      ),
                                    ),
                                  );
                                  return;
                                }

                                // Guardar o editar
                                final freq =
                                    int.tryParse(
                                      frequencyController.text.trim(),
                                    ) ??
                                    1;
                                if (isEditing) {
                                  setState(() {
                                    reminder!.medication = selectedMed;
                                    reminder.daysOfWeek = List.from(
                                      selectedDays,
                                    );
                                    reminder.frequency = freq;
                                    reminder.frequencyUnit = frequencyUnit;
                                    reminder.startDate = startDate;
                                    reminder.endDate = endDate;
                                  });
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recordatorio actualizado'),
                                    ),
                                  );
                                } else {
                                  final newReminder = Reminder(
                                    id: Random().nextInt(1 << 32).toString(),
                                    medication: selectedMed,
                                    daysOfWeek: List.from(selectedDays),
                                    frequency: freq,
                                    frequencyUnit: frequencyUnit,
                                    startDate: startDate,
                                    endDate: endDate,
                                  );
                                  setState(() => _reminders.add(newReminder));
                                  Navigator.of(ctx).pop();
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Recordatorio creado'),
                                    ),
                                  );
                                }
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: primary,
                                padding: const EdgeInsets.symmetric(
                                  vertical: 14,
                                ),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: Text(
                                isEditing
                                    ? 'Guardar cambios'
                                    : 'Crear recordatorio',
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  // Confirm delete
  Future<void> _confirmDelete(Reminder r) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Eliminar recordatorio'),
        content: const Text(
          '¿Estás seguro/a de que deseas eliminar este recordatorio?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: const Text('No'),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: const Text('Sí'),
          ),
        ],
      ),
    );
    if (ok == true) {
      setState(() => _reminders.removeWhere((e) => e.id == r.id));
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Recordatorio eliminado')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text('Recordatorios'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () => _openReminderForm(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: primary,
        child: const Icon(Icons.add),
        onPressed: () => _openReminderForm(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(14),
        child: _reminders.isEmpty
            ? _emptyState()
            : ListView.builder(
                itemCount: _reminders.length,
                itemBuilder: (context, index) {
                  final r = _reminders[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                    child: ListTile(
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      leading: CircleAvatar(
                        backgroundColor: primary.withOpacity(0.15),
                        child: Icon(Icons.medication, color: primary),
                      ),
                      title: Text(
                        r.medication,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "${_daysLabel(r.daysOfWeek)} · Cada ${r.frequency} ${r.frequencyUnit.toLowerCase()} · Desde ${_formatDate(r.startDate)}" +
                            (r.endDate != null
                                ? " · Hasta ${_formatDate(r.endDate!)}"
                                : ""),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (v) {
                          if (v == 'edit') {
                            _openReminderForm(reminder: r);
                          } else if (v == 'delete') {
                            _confirmDelete(r);
                          }
                        },
                        itemBuilder: (ctx) => [
                          const PopupMenuItem(
                            value: 'edit',
                            child: Text('Editar'),
                          ),
                          const PopupMenuItem(
                            value: 'delete',
                            child: Text('Eliminar'),
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

  Widget _emptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.alarm_add_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 12),
          const Text(
            'Aún no tienes recordatorios',
            style: TextStyle(fontSize: 18, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          TextButton.icon(
            onPressed: () => _openReminderForm(),
            icon: Icon(Icons.add, color: primary),
            label: const Text('Crear mi primer recordatorio'),
          ),
        ],
      ),
    );
  }

  String _daysLabel(List<int> days) {
    if (days.isEmpty) return 'Sin días';
    final names = ['Lun', 'Mar', 'Mié', 'Jue', 'Vie', 'Sáb', 'Dom'];
    final selected = days.map((d) => names[d - 1]).toList();
    return selected.join(', ');
  }
}
