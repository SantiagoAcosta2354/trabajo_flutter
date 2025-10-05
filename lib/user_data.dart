import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class UserDataPage extends StatefulWidget {
  const UserDataPage({super.key});

  @override
  State<UserDataPage> createState() => _UserDataPageState();
}

class _UserDataPageState extends State<UserDataPage> {
  final Color primary = Colors.deepOrange;
  final _formKey = GlobalKey<FormState>();

  File? _fotoPerfil;
  final _picker = ImagePicker();

  final TextEditingController _nombreCtrl = TextEditingController(
    text: "Juan Pérez",
  );
  final TextEditingController _correoCtrl = TextEditingController(
    text: "paciente@example.com",
  );
  final TextEditingController _telefonoCtrl = TextEditingController(
    text: "3001234567",
  );
  final TextEditingController _direccionCtrl = TextEditingController(
    text: "Calle 10 #45-32",
  );
  final TextEditingController _edadCtrl = TextEditingController(text: "28");
  final TextEditingController _epsCtrl = TextEditingController(
    text: "Sanitas EPS",
  );

  Future<void> _seleccionarFoto() async {
    final imagen = await _picker.pickImage(source: ImageSource.gallery);
    if (imagen != null) {
      setState(() => _fotoPerfil = File(imagen.path));
    }
  }

  void _guardarCambios() {
    if (_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("✅ Datos actualizados correctamente")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7F9),
      appBar: AppBar(
        backgroundColor: primary,
        title: const Text("Datos del Usuario"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              // 📸 Foto de perfil
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[300],
                    backgroundImage: _fotoPerfil != null
                        ? FileImage(_fotoPerfil!)
                        : null,
                    child: _fotoPerfil == null
                        ? const Icon(
                            Icons.person,
                            size: 60,
                            color: Colors.white,
                          )
                        : null,
                  ),
                  FloatingActionButton.small(
                    onPressed: _seleccionarFoto,
                    backgroundColor: primary,
                    child: const Icon(Icons.camera_alt, color: Colors.white),
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // 🧾 Campos de datos personales
              _campoTexto("Nombre completo", _nombreCtrl, Icons.person),
              const SizedBox(height: 12),
              _campoTexto(
                "Correo electrónico",
                _correoCtrl,
                Icons.email,
                tipo: TextInputType.emailAddress,
              ),
              const SizedBox(height: 12),
              _campoTexto(
                "Teléfono",
                _telefonoCtrl,
                Icons.phone,
                tipo: TextInputType.phone,
              ),
              const SizedBox(height: 12),
              _campoTexto("Dirección", _direccionCtrl, Icons.home),
              const SizedBox(height: 12),
              _campoTexto(
                "Edad",
                _edadCtrl,
                Icons.calendar_today,
                tipo: TextInputType.number,
              ),
              const SizedBox(height: 12),
              _campoTexto("EPS", _epsCtrl, Icons.local_hospital),
              const SizedBox(height: 24),

              // 💾 Botón de guardar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: _guardarCambios,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  icon: const Icon(Icons.save),
                  label: const Text(
                    "Guardar Cambios",
                    style: TextStyle(fontSize: 18),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _campoTexto(
    String label,
    TextEditingController ctrl,
    IconData icon, {
    TextInputType tipo = TextInputType.text,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: tipo,
      validator: (v) =>
          v == null || v.trim().isEmpty ? "Campo obligatorio" : null,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: primary),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
