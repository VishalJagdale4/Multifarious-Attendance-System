class Department{

  String did;
  String name;

  Department({
    required this.did,
    required this.name,
  });

  factory Department.fromMap(Map<dynamic, dynamic> map){

    return Department(
      did: map['did'],
      name: map['name'],
    );
  }

}