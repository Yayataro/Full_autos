import 'package:flutter/material.dart';
import '../data/contact_repository.dart';
import '../models/contact_info.dart';
import '../widgets/quick_contact.dart';

class ContactScreen extends StatefulWidget {
  static const routeName = '/contacto';
  const ContactScreen({super.key});

  @override
  State<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends State<ContactScreen> {
  late Future<ContactInfo> _future;

  @override
  void initState() {
    super.initState();
    _future = ContactRepository.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacto')),
      body: FutureBuilder<ContactInfo>(
        future: _future,
        builder: (context, snap) {
          if (snap.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (!snap.hasData) {
            return const Center(child: Text('No fue posible cargar el contacto.'));
          }
          final data = snap.data!;
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                QuickContact(
                  data: data,
                  onOpenLocations: () {}, // aquí ya estamos en Contacto
                ),
                const SizedBox(height: 16),
                const Text('Ciudades donde estamos:',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...data.cities.map((c) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.location_city),
                  title: Text(c),
                )),
              ],
            ),
          );
        },
      ),
    );
  }
}
