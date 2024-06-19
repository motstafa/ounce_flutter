
class UserModel {
  String? name;
  String? email;
  String? username;
  String? profilePhotoUrl;
  String? token;
  BigInt? role;

  UserModel({
    this.name,
    this.email,
    this.username,
    this.profilePhotoUrl,
    this.token,
    this.role
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      name: json['name'],
      email: json['email'],
      username: json['username'],
      profilePhotoUrl: json['profile_photo_url'],
      token: json['token'],
      role: json['role']
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'email': email,
      'username': username,
      'profile_photo_url': profilePhotoUrl,
      'token': token,
      'role':role
    };
  }
}
