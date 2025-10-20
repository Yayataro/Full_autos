import 'package:flutter/material.dart';

class ApplicantsScreen extends StatefulWidget {
  static const routeName = '/aspirantes';
  const ApplicantsScreen({super.key});

  @override
  State<ApplicantsScreen> createState() => _ApplicantsScreenState();
}

class _ApplicantsScreenState extends State<ApplicantsScreen> {
  final _formKey = GlobalKey<FormState>();
  final nameCtrl = TextEditingController();
  final emailCtrl = TextEditingController();
  final phoneCtrl = TextEditingController();
  final cityCtrl = TextEditingController();
  final expCtrl = TextEditingController();
  final certsCtrl = TextEditingController();
  final cvCtrl = TextEditingController();

  @override
  void dispose() {
    nameCtrl.dispose(); emailCtrl.dispose(); phoneCtrl.dispose(); cityCtrl.dispose(); expCtrl.dispose(); certsCtrl.dispose(); cvCtrl.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState?.validate() ?? false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Postulación enviada (mock)')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Aspirantes')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre *', border: OutlineInputBorder()), validator: (v)=> (v==null||v.isEmpty)?'Requerido':null),
              const SizedBox(height: 10),
              TextFormField(controller: emailCtrl, decoration: const InputDecoration(labelText: 'Email *', border: OutlineInputBorder()), validator: (v)=> (v==null||!v.contains('@'))?'Email inválido':null),
              const SizedBox(height: 10),
              TextFormField(controller: phoneCtrl, decoration: const InputDecoration(labelText: 'Teléfono', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: cityCtrl, decoration: const InputDecoration(labelText: 'Ciudad', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: expCtrl, decoration: const InputDecoration(labelText: 'Años de experiencia', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: certsCtrl, decoration: const InputDecoration(labelText: 'Certificaciones', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextFormField(controller: cvCtrl, minLines: 2, maxLines: 3, decoration: const InputDecoration(labelText: 'Nota / enlace a CV', border: OutlineInputBorder())),
              const SizedBox(height: 16),
              SizedBox(width: double.infinity, child: FilledButton(onPressed: _submit, child: const Text('Enviar postulación'))),
            ],
          ),
        ),
      ),
    );
  }
}
