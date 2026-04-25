class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? phoneNumber;
  final String? gender;
  final String? avatar;
  final bool? isActive;
  final bool? isVerified;
  final String? role;
  final String? createdAt;
  final String? updatedAt;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.phoneNumber,
    this.gender,
    this.avatar,
    this.isActive,
    this.isVerified,
    this.role,
    this.createdAt,
    this.updatedAt,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['_id']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phoneNumber: json['phoneNumber']?.toString(),
      gender: json['gender']?.toString(),
      avatar: json['avatar']?.toString(),
      isActive: json['isActive'] as bool?,
      isVerified: json['isVerified'] as bool?,
      role: json['role']?.toString(),
      createdAt: json['createdAt']?.toString(),
      updatedAt: json['updatedAt']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'email': email,
      'phoneNumber': phoneNumber,
      'gender': gender,
      'avatar': avatar,
      'isActive': isActive,
      'isVerified': isVerified,
      'role': role,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }
}