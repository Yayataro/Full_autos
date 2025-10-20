import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import '../models/contact_info.dart';

class QuickContact extends StatelessWidget {
  final ContactInfo data;
  final VoidCallback? onOpenLocations; // para abrir pantalla de Contacto

  const QuickContact({super.key, required this.data, this.onOpenLocations});

  Future<void> _safeLaunch(BuildContext ctx, Uri uri) async {
    try {
      final ok = await canLaunchUrl(uri);
      if (ok) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        ScaffoldMessenger.of(ctx).showSnackBar(
          const SnackBar(content: Text('No se pudo abrir el enlace.')),
        );
      }
    } catch (_) {
      ScaffoldMessenger.of(ctx).showSnackBar(
        const SnackBar(content: Text('Error al abrir el enlace.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasPhone  = (data.phone ?? '').trim().isNotEmpty;
    final hasWa     = (data.whatsapp ?? '').trim().isNotEmpty;
    final hasMail   = (data.email ?? '').trim().isNotEmpty;
    final hasCities = data.cities.isNotEmpty;

    Widget btn({
      required Widget iconWidget,
      required String label,
      required VoidCallback? onTap,
      bool enabled = true,
    }) {
      final btnColor = enabled ? Theme.of(context).colorScheme.primary : Colors.grey;
      return Expanded(
        child: InkWell(
          onTap: enabled ? onTap : null,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 12),
            constraints: const BoxConstraints(minHeight: 48),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Theme.of(context).colorScheme.surface,
              border: Border.all(color: btnColor.withOpacity(0.4)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconTheme(data: IconThemeData(color: btnColor), child: iconWidget),
                const SizedBox(height: 6),
                Text(
                  label,
                  style: TextStyle(
                    color: enabled ? Colors.black87 : Colors.black45,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Card(
      elevation: 1,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Contacto Rápido', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                // Llamar
                btn(
                  iconWidget: const Icon(Icons.call),
                  label: 'Llamar',
                  enabled: hasPhone,
                  onTap: () => _safeLaunch(context, Uri.parse('tel:${data.phone}')),
                ),
                const SizedBox(width: 8),
                // WhatsApp (FontAwesome)
                btn(
                  iconWidget: const FaIcon(FontAwesomeIcons.whatsapp),
                  label: 'WhatsApp',
                  enabled: hasWa,
                  onTap: () {
                    final phone = data.whatsapp!.replaceAll('+', '').replaceAll(' ', '');
                    _safeLaunch(context, Uri.parse('https://wa.me/$phone'));
                  },
                ),
              ],
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                // Email
                btn(
                  iconWidget: const Icon(Icons.email),
                  label: 'Email',
                  enabled: hasMail,
                  onTap: () => _safeLaunch(context, Uri.parse('mailto:${data.email}')),
                ),
                const SizedBox(width: 8),
                // Ubicaciones
                btn(
                  iconWidget: const Icon(Icons.location_on),
                  label: 'Ubicaciones',
                  enabled: hasCities && onOpenLocations != null,
                  onTap: onOpenLocations,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

