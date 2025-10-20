class ContactInfo {
  final String? phone;
  final String? whatsapp;
  final String? email;
  final List<String> cities;

  ContactInfo({this.phone, this.whatsapp, this.email, required this.cities});

  factory ContactInfo.fromJson(Map<String, dynamic> j) => ContactInfo(
    phone: j['phone'] as String?,
    whatsapp: j['whatsapp'] as String?,
    email: j['email'] as String?,
    cities: (j['cities'] as List?)?.map((e) => e.toString()).toList() ?? [],
  );
}
