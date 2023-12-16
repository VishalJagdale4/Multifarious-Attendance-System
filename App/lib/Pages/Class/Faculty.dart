class Faculty{

  String uid;
  String name;
  String email;
  String phone;
  String department;
  String fid;
  bool status;
  String dob;
  String profile_url;

  Faculty({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.department,
    required this.fid,
    required this.status,
    required this.dob,
    required this.profile_url,
  });

  factory Faculty.fromMap(Map<dynamic, dynamic> map){

    bool status;
    map['status'] == 'true'?status = true: status = false;

    return Faculty(
      uid: map['uid'] as String,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      department: map['department'],
      fid: map['fid'],
      status: status,
      dob: map['dob'],
      profile_url: map['profile_url'],
    );
  }

}