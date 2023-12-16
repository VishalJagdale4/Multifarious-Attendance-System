class Student{

  String uid;
  String name;
  String email;
  String phone;
  String prn;
  String program;
  String branch;
  String semister;
  String batch;
  String year;
  bool status;
  String sap_id;
  String dob;
  String profile_url;

  Student({
    required this.uid,
    required this.name,
    required this.email,
    required this.phone,
    required this.prn,
    required this.program,
    required this.branch,
    required this.semister,
    required this.batch,
    required this.year,
    required this.status,
    required this.dob,
    required this.sap_id,
    required this.profile_url,
  });

  factory Student.fromMap(Map<dynamic, dynamic> map){

    bool status;
    map['status'] == 'true'?status = true: status = false;

    return Student(
      uid: map['uid'] as String,
      name: map['name'],
      email: map['email'],
      phone: map['phone'],
      prn: map['prn'],
      program: map['program'],
      branch: map['branch'],
      semister: map['semister'],
      batch: map['batch'],
      year: map['year'],
      status: status,
      dob: map['dob'],
      sap_id: map['sap_id'],
      profile_url: map['profile_url'],
    );
  }
}