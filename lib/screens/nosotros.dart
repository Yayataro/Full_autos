import 'package:flutter/material.dart';

class AboutScreen extends StatelessWidget {
  static const routeName = '/quienes';
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Quiénes somos')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: const [
            Text('Misión', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Brindar asesoría técnica y mecánica con calidad y confianza.'),
            SizedBox(height: 16),
            Text('Visión', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Ser la serviteca de referencia a nivel nacional.'),
            SizedBox(height: 16),
            Text('Trayectoria', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Más de 10 años de experiencia en el sector automotriz.'),
            SizedBox(height: 16),
            Text('Reconocimientos y alianzas', style: TextStyle(fontWeight: FontWeight.bold)),
            SizedBox(height: 6),
            Text('Certificaciones ASE, convenios con proveedores y marcas.'),
          ],
        ),
      ),
    );
  }
}
