class Admin{

  String uid;
  String name;
  String email;
  String phone;
  String dob;
  String role;
  String profile_url;

  Admin({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.dob,
    required this.role,
    required this.profile_url
  });

  factory Admin.fromMap(Map<dynamic, dynamic> map){

    return Admin(
      uid: map['uid'] as String,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      dob: map['dob'],
      role: map['role'],
      profile_url: map['profile_url'],
    );
  }

}