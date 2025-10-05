import 'package:flutter/material.dart';
import 'dart:math';

/// Página de Comentarios (Chat simple)
/// Paciente y médico pueden enviar mensajes, ver historial y eliminar.
/// Compatible con Flutter 3.0+
/// Diseño limpio, moderno y adaptable.

class Mensaje {
  String id;
  String texto;
  bool esDoctor;
  DateTime fecha;

  Mensaje({
    required this.id,
    required this.texto,
    required this.esDoctor,
    DateTime? fecha,
  }) : fecha = fecha ?? DateTime.now();
}

class ComentariosPage extends StatefulWidget {
  const ComentariosPage({super.key});

  @override
  State<ComentariosPage> createState() => _ComentariosPageState();
}

class _ComentariosPageState extends State<ComentariosPage> {
  final List<Mensaje> _mensajes = [];
  final TextEditingController _msgController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _esDoctor = false; // cambiar para simular rol (true = doctor)
  final Color primary = Colors.deepOrange;

  void _enviarMensaje() {
    final texto = _msgController.text.trim();
    if (texto.isEmpty) return;

    final nuevo = Mensaje(
      id: Random().nextInt(999999).toString(),
      texto: texto,
      esDoctor: _esDoctor,
    );
    setState(() {
      _mensajes.add(nuevo);
      _msgController.clear();
    });

    // Mover scroll al final
    Future.delayed(const Duration(milliseconds: 100), () {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent + 60,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  void _eliminarMensaje(Mensaje m) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Eliminar mensaje"),
        content: const Text("¿Deseas eliminar este mensaje?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancelar"),
          ),
          TextButton(
            onPressed: () {
              setState(() => _mensajes.removeWhere((x) => x.id == m.id));
              Navigator.pop(ctx);
            },
            child: const Text("Eliminar"),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime d) =>
      "${d.hour.toString().padLeft(2, '0')}:${d.minute.toString().padLeft(2, '0')}";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: AppBar(
        backgroundColor: primary,
        title: Row(
          children: [
            const Icon(Icons.chat_bubble_outline, size: 24),
            const SizedBox(width: 8),
            Text(_esDoctor ? "Chat con Paciente" : "Chat con Médico"),
          ],
        ),
        actions: [
          IconButton(
            tooltip: "Cambiar rol (simulación)",
            icon: const Icon(Icons.switch_account),
            onPressed: () {
              setState(() => _esDoctor = !_esDoctor);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    _esDoctor
                        ? "Modo Doctor activado"
                        : "Modo Paciente activado",
                  ),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _mensajes.isEmpty
                ? _vacio()
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    itemCount: _mensajes.length,
                    itemBuilder: (ctx, i) {
                      final m = _mensajes[i];
                      return Align(
                        alignment: m.esDoctor
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: GestureDetector(
                          onLongPress: () => _eliminarMensaje(m),
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            padding: const EdgeInsets.all(12),
                            constraints: const BoxConstraints(maxWidth: 280),
                            decoration: BoxDecoration(
                              color: m.esDoctor
                                  ? primary.withOpacity(0.9)
                                  : Colors.grey[200],
                              borderRadius: BorderRadius.only(
                                topLeft: const Radius.circular(16),
                                topRight: const Radius.circular(16),
                                bottomLeft: Radius.circular(
                                  m.esDoctor ? 16 : 0,
                                ), // burbuja invertida
                                bottomRight: Radius.circular(
                                  m.esDoctor ? 0 : 16,
                                ), // burbuja invertida
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 3,
                                  offset: const Offset(0, 1),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  m.texto,
                                  style: TextStyle(
                                    color: m.esDoctor
                                        ? Colors.white
                                        : Colors.black87,
                                    fontSize: 15,
                                    height: 1.4,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  _formatTime(m.fecha),
                                  style: TextStyle(
                                    color: m.esDoctor
                                        ? Colors.white70
                                        : Colors.grey[600],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
          _campoMensaje(),
        ],
      ),
    );
  }

  Widget _campoMensaje() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _msgController,
                textInputAction: TextInputAction.send,
                onSubmitted: (_) => _enviarMensaje(),
                decoration: InputDecoration(
                  hintText: "Escribe un mensaje...",
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            CircleAvatar(
              radius: 24,
              backgroundColor: primary,
              child: IconButton(
                icon: const Icon(Icons.send, color: Colors.white),
                onPressed: _enviarMensaje,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _vacio() => Center(
    child: Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.chat_outlined, size: 80, color: Colors.grey[400]),
          const SizedBox(height: 14),
          const Text(
            "Aún no hay mensajes",
            style: TextStyle(fontSize: 17, color: Colors.black54),
          ),
          const SizedBox(height: 8),
          Text(
            "Escribe el primer mensaje para iniciar la conversación.",
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.grey[600]),
          ),
        ],
      ),
    ),
  );
}
