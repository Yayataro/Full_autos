import 'package:flutter/material.dart';
import 'contacto.dart';                 // ContactoScreen
import 'detalledeltecnico.dart';       // Detalledecreen

class TechniciansScreen extends StatefulWidget {
  const TechniciansScreen({super.key});
  static const routeName = '/technicians';

  @override
  State<TechniciansScreen> createState() => _TechniciansScreenState();
}

class _TechniciansScreenState extends State<TechniciansScreen> {
  final _cities = const ['Bogotá', 'Medellín', 'Barranquilla', 'Cali'];
  String _city = 'Bogotá';
  final _listController = ScrollController();

  @override
  void dispose() {
    _listController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Filtrado por ciudad
    final techs = _kTechnicians.where((t) => t.city == _city).toList();
    final favs = techs.where((t) => t.favorite).take(3).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Full Autos S.A'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        controller: _listController,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('Nuestros Técnicos',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
            const SizedBox(height: 12),

            // Chips de ciudades
            Wrap(
              spacing: 8, runSpacing: 8,
              children: _cities.map((c) {
                final selected = _city == c;
                return ChoiceChip(
                  label: Text(c),
                  selected: selected,
                  onSelected: (_) => setState(() => _city = c),
                  selectedColor: Colors.black,
                  labelStyle: TextStyle(color: selected ? Colors.white : Colors.black87),
                );
              }).toList(),
            ),

            const SizedBox(height: 16),

            // ====== Favoritos ======
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Técnicos favoritos', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                TextButton(
                  onPressed: () {
                    // “Ver todos” → baja hasta la lista
                    _listController.animateTo(
                      _listController.position.maxScrollExtent,
                      duration: const Duration(milliseconds: 400),
                      curve: Curves.easeOut,
                    );
                  },
                  child: const Text('Ver todos'),
                ),
              ],
            ),
            const SizedBox(height: 8),

            if (favs.isEmpty)
              const Text('No hay favoritos en esta ciudad.', style: TextStyle(color: Colors.black54))
            else
              SizedBox(
                height: 120,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: favs.length,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, i) {
                    final t = favs[i];
                    return _FavoriteCard(
                      tech: t,
                      onTap: () => _openDetail(context, t),
                      onContact: () => Navigator.push(
                        context, MaterialPageRoute(builder: (_) => const ContactScreen()),
                      ),
                    );
                  },
                ),
              ),

            const SizedBox(height: 20),
            const Divider(height: 24),

            // ====== Lista completa ======
            const Row(
              children: [
                Expanded(child: Text('Técnicos', style: TextStyle(fontWeight: FontWeight.w700))),
                Expanded(child: Text('Trayectoria', style: TextStyle(fontWeight: FontWeight.w700))),
              ],
            ),
            const SizedBox(height: 8),

            ListView.separated(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: techs.length,
              separatorBuilder: (_, __) => const Divider(height: 16),
              itemBuilder: (_, i) {
                final t = techs[i];
                return InkWell(
                  onTap: () => _openDetail(context, t),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Foto
                      _Avatar(photo: t.photo),
                      const SizedBox(width: 12),
                      // Nombre + ciudad
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(t.name, style: const TextStyle(fontWeight: FontWeight.w600)),
                            Text(t.city, style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                      // Resumen trayectoria
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('${t.exp} años de experiencia'),
                            if (t.certs.isNotEmpty)
                              Text('Cert: ${t.certs.first}', style: const TextStyle(color: Colors.black54)),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: 1,
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home_outlined), label: ''),
          NavigationDestination(icon: Icon(Icons.search), label: ''),
          NavigationDestination(icon: Icon(Icons.receipt_long), label: ''),
          NavigationDestination(icon: Icon(Icons.more_horiz), label: ''),
        ],
      ),
    );
  }

  void _openDetail(BuildContext context, Technician t) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => TechnicianDetailScreen(technician: t)),
    );
  }
}

// ====== Widgets auxiliares ======
class _FavoriteCard extends StatelessWidget {
  final Technician tech;
  final VoidCallback onTap;
  final VoidCallback onContact;
  const _FavoriteCard({required this.tech, required this.onTap, required this.onContact});

  @override
  Widget build(BuildContext context) {
    return Material(
      elevation: 1,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          width: 220,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Theme.of(context).colorScheme.surface,
          ),
          child: Row(
            children: [
              _Avatar(photo: tech.photo, size: 52),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(children: [
                      Icon(Icons.star, size: 16, color: Colors.amber),
                      SizedBox(width: 4),
                      Text('Favorito', style: TextStyle(fontSize: 12)),
                    ]),
                    Text(tech.name, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600)),
                    Text(tech.city, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 6),
                    SizedBox(
                      height: 32,
                      child: OutlinedButton(
                        onPressed: onContact,
                        child: const Text('Contactar'),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Avatar extends StatelessWidget {
  final String? photo;
  final double size;
  const _Avatar({this.photo, this.size = 56});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: size / 2,
      backgroundColor: Colors.black12,
      backgroundImage: (photo != null && photo!.isNotEmpty) ? AssetImage(photo!) : null,
      child: (photo == null || photo!.isEmpty)
          ? Icon(Icons.engineering, size: size * 0.6, color: Colors.black54)
          : null,
    );
  }
}

// ====== Modelo + datos ======
class Technician {
  final String name;
  final String city;
  final int exp;                   // años de experiencia
  final List<String> certs;        // certificaciones
  final String? photo;             // ruta de asset opcional
  final bool favorite;

  const Technician({
    required this.name,
    required this.city,
    required this.exp,
    required this.certs,
    this.photo,
    this.favorite = false,
  });
}

// tener presente que despues debo colocar las fotos assets/images/ y declararlas en pubspec.yaml.
const _kTechnicians = <Technician>[
  Technician(
    name: 'Andrés Pérez',
    city: 'Bogotá',
    exp: 8,
    certs: ['Suspensión', 'Frenos ABS'],
    photo: '', // 'assets/images/tec1.png',
    favorite: true,
  ),
  Technician(
    name: 'María Gómez',
    city: 'Bogotá',
    exp: 5,
    certs: ['Alineación y balanceo'],
    photo: '', // 'assets/images/tec2.png',
    favorite: true,
  ),
  Technician(
    name: 'Carlos Díaz',
    city: 'Bogotá',
    exp: 10,
    certs: ['Inyección electrónica'],
    photo: '',
  ),
  Technician(
    name: 'Julia Restrepo',
    city: 'Medellín',
    exp: 7,
    certs: ['Llantas y rines'],
    photo: '',
    favorite: true,
  ),
  Technician(
    name: 'Santiago Villa',
    city: 'Medellín',
    exp: 4,
    certs: ['Cambio de aceite'],
    photo: '',
  ),
  Technician(
    name: 'Laura Patiño',
    city: 'Barranquilla',
    exp: 6,
    certs: ['Aire acondicionado'],
    photo: '',
    favorite: true,
  ),
  Technician(
    name: 'Jorge Navarro',
    city: 'Barranquilla',
    exp: 9,
    certs: ['Transmisión'],
    photo: '',
  ),
  Technician(
    name: 'Paola Ríos',
    city: 'Cali',
    exp: 3,
    certs: ['Baterías'],
    photo: '',
    favorite: true,
  ),
  Technician(
    name: 'Felipe Quintero',
    city: 'Cali',
    exp: 11,
    certs: ['Diagnóstico computarizado'],
    photo: '',
  ),
];
