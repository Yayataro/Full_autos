import 'package:flutter/material.dart';
import 'tecnicos.dart';

class TechnicianDetailScreen extends StatefulWidget {
  static const routeName = '/tecnico_detalle';
  final Technician technician;
  const TechnicianDetailScreen({super.key, required this.technician});

  @override
  State<TechnicianDetailScreen> createState() => _TechnicianDetailScreenState();
}

class _TechnicianDetailScreenState extends State<TechnicianDetailScreen> {
  bool favorite = false;

  @override
  Widget build(BuildContext context) {
    final t = widget.technician;
    return Scaffold(
      appBar: AppBar(title: Text(t.name)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const CircleAvatar(radius: 36, child: Icon(Icons.engineering, size: 32)),
              const SizedBox(width: 16),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(t.name, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
                Text('${t.city} · ${t.exp}'),
              ])),
              IconButton(
                icon: Icon(favorite ? Icons.star : Icons.star_border, color: Colors.amber),
                onPressed: () => setState(() => favorite = !favorite),
                tooltip: 'Marcar favorito',
              )
            ]),
            const SizedBox(height: 16),
            const Text('Certificaciones', style: TextStyle(fontWeight: FontWeight.w600)),
            const SizedBox(height: 6),
            Wrap(spacing: 8, children: t.certs.map((c) => Chip(label: Text(c))).toList()),
            const Spacer(),
            Row(
              children: [
                Expanded(child: OutlinedButton(onPressed: () {}, child: const Text('Servicios que atiende'))),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(onPressed: () {}, child: const Text('Contactar'))),
              ],
            )
          ],
        ),
      ),
    );
  }
}
