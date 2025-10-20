import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../models/contact_info.dart';

class ContactRepository {
  static Future<ContactInfo> load() async {
    final raw = await rootBundle.loadString('assets/data/contact.json');
    return ContactInfo.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }
}
