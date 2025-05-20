class UserModel {
  final String uid;
  final String name;
  final String email;
  final String address;
  final String phone;
  final DateTime createdAt;
  final bool isPremium;

  UserModel({
    required this.uid,
    required this.name,
    required this.email,
    required this.address,
    required this.phone,
    required this.createdAt,
    this.isPremium = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'address': address,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      'isPremium': isPremium,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['uid'],
      name: map['name'],
      email: map['email'],
      address: map['address'] ?? '',
      phone: map['phone'] ?? '',
      createdAt: DateTime.parse(map['createdAt']),
      isPremium: map['isPremium'] ?? false,
    );
  }
}
