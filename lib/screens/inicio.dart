import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

// Pantallas
import 'servicios.dart';
import 'tecnicos.dart';
import 'aspirantes.dart';
import 'tareas.dart';
import 'nosotros.dart';
import 'contacto.dart';

// Datos / modelos / widget
import '../data/contact_repository.dart';
import '../models/contact_info.dart';
import '../widgets/quick_contact.dart';

class InicioScreen extends StatelessWidget {
  const InicioScreen({super.key});
  static const routeName = '/inicio';

  static const String _url = 'https://www.fullautos.com';
  Future<void> _openUrl() async =>
      launchUrl(Uri.parse(_url), mode: LaunchMode.externalApplication);

  @override
  Widget build(BuildContext context) {
    final items = <_HomeItem>[
      _HomeItem('Servicios', Icons.build, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ServicioScreen()))),
      _HomeItem('Técnicos', Icons.engineering, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TechniciansScreen()))),
      _HomeItem('Aspirantes', Icons.person, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ApplicantsScreen()))),
      _HomeItem('Tareas', Icons.construction, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const TasksScreen()))),
      _HomeItem('Quiénes somos', Icons.groups, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const AboutScreen()))),
      _HomeItem('Contacto', Icons.contact_phone, () =>
          Navigator.push(context, MaterialPageRoute(builder: (_) => const ContactScreen()))),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Autos SAS'),
        actions: const [
          Icon(Icons.notifications_none), SizedBox(width: 8),
          Icon(Icons.more_horiz), SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Logo + encabezado
            Center(
              child: Image.asset('assets/images/logo.png', height: 120, fit: BoxFit.contain),
            ),
            const SizedBox(height: 12),
            const Text('Bienvenido a la Serviteca',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Todo para auto',
                style: TextStyle(fontSize: 14, color: Colors.black54)),
            const SizedBox(height: 6),
            InkWell(
              onTap: _openUrl,
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.link, size: 18, color: Colors.indigo),
                  SizedBox(width: 6),
                  Text('www.fullautos.com',
                      style: TextStyle(color: Colors.indigo, decoration: TextDecoration.underline)),
                ],
              ),
            ),

            const Divider(height: 24),

            // Grid de módulos
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisExtent: 140,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
              ),
              itemBuilder: (_, i) =>
                  _HomeCard(label: items[i].label, icon: items[i].icon, onTap: items[i].onTap),
            ),

            const SizedBox(height: 24),

            // ---- Widget: Contacto Rápido (lee assets/data/contact.json) ----
            const Text('Contacto rápido',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            const SizedBox(height: 8),

            FutureBuilder<ContactInfo>(
              future: ContactRepository.load(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return const SizedBox.shrink();
                }
                if (!snapshot.hasData) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    child: Text(
                      'No fue posible cargar el contacto.',
                      style: TextStyle(color: Theme.of(context).colorScheme.error),
                    ),
                  );
                }
                return QuickContact(
                  data: snapshot.data!, // <- API correcta
                  onOpenLocations: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ContactScreen()),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ======= Helpers de Home =======
class _HomeItem {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  _HomeItem(this.label, this.icon, this.onTap);
}

class _HomeCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final VoidCallback onTap;
  const _HomeCard({required this.label, required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Theme.of(context).colorScheme.surface,
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 46, color: Theme.of(context).colorScheme.primary),
              const SizedBox(height: 12),
              Text(label, textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
            ],
          ),
        ),
      ),
    );
  }
}
