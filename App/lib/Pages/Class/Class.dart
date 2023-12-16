class Class{

  String cid;
  String name;

  Class({
    required this.cid,
    required this.name,
  });

  factory Class.fromMap(Map<dynamic, dynamic> map){

    return Class(
      cid: map['cid'],
      name: map['name'],
    );
  }

}