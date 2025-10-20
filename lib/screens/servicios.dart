import 'package:flutter/material.dart';

class ServicioScreen extends StatefulWidget {
  const ServicioScreen({super.key});
  @override
  State<ServicioScreen> createState() => _ServicioScreenState();
}

class _ServicioScreenState extends State<ServicioScreen> {
  // --- Mock de datos (luego puedes mover a JSON/local) ---
  final Map<String, Map<String, dynamic>> servicios = {
    'Cambio de aceite': {
      'desc': 'Reemplazo de aceite y filtro, chequeo rápido de fluidos.',
      'incluye': 'Aceite 5W-30, filtro estándar, revisión visual.',
      'eta': '45 min',
      'subtotal': 19.98,
      'adiciones': 0.00,
      'iva': 2.00,
      'tecnicos': [
        {
          'nombre': 'Carlos Ruiz',
          'cap': 'Lubricación, filtros, diagnóstico básico',
          'foto': null,
        },
        {
          'nombre': 'Laura Pérez',
          'cap': 'Cambio aceite sintético, multi-marca',
          'foto': null,
        },
      ],
    },
    'Alineación y balanceo': {
      'desc': 'Ajuste de ángulos y balanceo dinámico de ruedas.',
      'incluye': 'Alineación 3D, balanceo 4 ruedas, prueba en ruta.',
      'eta': '1 h 20 min',
      'subtotal': 32.50,
      'adiciones': 0.00,
      'iva': 3.90,
      'tecnicos': [
        {
          'nombre': 'Miguel Soto',
          'cap': 'Suspensión, dirección, balanceo preciso',
          'foto': null,
        },
        {
          'nombre': 'Ana Gómez',
          'cap': 'Geometría, calibración 3D',
          'foto': null,
        },
      ],
    },
    'Calibración de llantas': {
      'desc': 'Ajuste de presión y revisión de estado de llantas.',
      'incluye': 'Calibración por especificación, inspección visual.',
      'eta': '20 min',
      'subtotal': 5.00,
      'adiciones': 0.00,
      'iva': 0.60,
      'tecnicos': [
        {
          'nombre': 'Julián Díaz',
          'cap': 'Llantas, válvulas, reparación menor',
          'foto': null,
        },
        {
          'nombre': 'Sofia Ríos',
          'cap': 'Calibración precisa y revisión',
          'foto': null,
        },
      ],
    },
  };

  late String _seleccion = 'Cambio de aceite';
  final Map<int, DateTime?> _fechasTecnico = {}; // fecha por técnico (índice)

  @override
  Widget build(BuildContext context) {
    final data = servicios[_seleccion]!;
    final tecnicos = (data['tecnicos'] as List);

    final subtotal = (data['subtotal'] as num).toDouble();
    final adiciones = (data['adiciones'] as num).toDouble();
    final iva = (data['iva'] as num).toDouble();
    final total = subtotal + adiciones + iva;

    return Scaffold(
      appBar: AppBar(
        title: DropdownButtonHideUnderline(
          child: DropdownButton<String>(
            value: _seleccion,
            icon: const Icon(Icons.keyboard_arrow_down),
            items: servicios.keys
                .map((k) => DropdownMenuItem(value: k, child: Text(k)))
                .toList(),
            onChanged: (v) => setState(() => _seleccion = v!),
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _label('DESCRIPCIÓN'),
          _fieldText(data['desc']),
          const SizedBox(height: 12),
          _label('INCLUYE'),
          _fieldText(data['incluye']),
          const SizedBox(height: 12),
          _label('TIEMPO ESTIMADO'),
          _fieldText(data['eta']),
          const SizedBox(height: 16),

          _labelRow('TÉCNICOS', extras: const ['Capacidades', 'Disponibilidad']),
          const SizedBox(height: 8),

          // Lista de técnicos
          ...List.generate(tecnicos.length, (i) {
            final t = tecnicos[i] as Map<String, dynamic>;
            final fecha = _fechasTecnico[i];
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const CircleAvatar(
                    radius: 22,
                    backgroundColor: Colors.black12,
                    // si tienes foto en assets, usa Image.asset en foregroundImage
                    child: Icon(Icons.person, color: Colors.black54),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: _box(),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(t['nombre'], style: const TextStyle(fontWeight: FontWeight.w600)),
                          const SizedBox(height: 6),
                          Text(t['cap'], style: const TextStyle(color: Colors.black54)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () async {
                      final picked = await showDatePicker(
                        context: context,
                        initialDate: fecha ?? DateTime.now(),
                        firstDate: DateTime.now(),
                        lastDate: DateTime.now().add(const Duration(days: 120)),
                      );
                      if (picked != null) setState(() => _fechasTecnico[i] = picked);
                    },
                    child: Text(
                      fecha == null
                          ? 'Seleccione fecha'
                          : '${fecha.day}/${fecha.month}/${fecha.year}',
                    ),
                  ),
                ],
              ),
            );
          }),

          const Divider(height: 24),
          _priceRow('Subtotal', subtotal),
          _priceRow('Adiciones', adiciones, freeWhenZero: true),
          _priceRow('IVA', iva),
          const SizedBox(height: 6),
          _priceRow('Total', total, bold: true),
          const SizedBox(height: 16),

          SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: () {
                // TODO: acción de contacto (tel/whatsapp/mail)
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Contacto (demo)')),
                );
              },
              child: const Text('Contactar'),
            ),
          ),
        ],
      ),
    );
  }

  // ---- helpers UI ----
  Widget _label(String t) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Text(t, style: const TextStyle(fontSize: 12, color: Colors.black54)),
  );

  Widget _fieldText(String v) => Container(
    padding: const EdgeInsets.all(12),
    decoration: _box(),
    child: Text(v),
  );

  BoxDecoration _box() => BoxDecoration(
    color: const Color(0xFFEFEFEF),
    borderRadius: BorderRadius.circular(6),
  );

  Widget _labelRow(String left, {List<String>? extras}) {
    return Row(
      children: [
        Expanded(child: Text(left, style: const TextStyle(fontSize: 12, color: Colors.black54))),
        if (extras != null && extras.length >= 2) ...[
          Expanded(child: Text(extras[0], textAlign: TextAlign.center, style: const TextStyle(fontSize: 12, color: Colors.black54))),
          Expanded(child: Text(extras[1], textAlign: TextAlign.right, style: const TextStyle(fontSize: 12, color: Colors.black54))),
        ],
      ],
    );
  }

  Widget _priceRow(String label, double value, {bool bold = false, bool freeWhenZero = false}) {
    final style = TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.w400);
    final text = freeWhenZero && value == 0 ? 'Free' : '\$${value.toStringAsFixed(2)}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(child: Text(label, style: style)),
          Text(text, style: style),
        ],
      ),
    );
  }
}
