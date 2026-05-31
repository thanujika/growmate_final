class AppUser {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String cropType;
  final String region;

  AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.cropType,
    required this.region,
  });

  // ✅ ADD THIS
  AppUser copyWith({
    int? id,
    String? name,
    String? email,
    String? phone,
    String? cropType,
    String? region,
  }) {
    return AppUser(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      cropType: cropType ?? this.cropType,
      region: region ?? this.region,
    );
  }
}