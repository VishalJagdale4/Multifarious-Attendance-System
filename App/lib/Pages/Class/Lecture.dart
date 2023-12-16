class Lecture{

  String name;
  String duration;
  List<String> present;

  Lecture({
    required this.name,
    required this.duration,
    required this.present,
  });

  factory Lecture.fromMap(Map<dynamic, dynamic> map){

    List<String> addToList(Map<dynamic, dynamic> list){
      List<String> prsnt = [];
      list.forEach((key, value) {prsnt.add(key);});
      return prsnt;
    }

    return Lecture(
    name: map['name'],
    duration: map['duration'],
    present: addToList(map['present']),
    );
  }
}