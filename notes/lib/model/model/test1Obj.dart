class test1Obj{

  int id;
  String name;

  test1Obj(this.id, this.name);
  Map<String, dynamic> toMap(){

    var map =  <String, dynamic>{
      'id' : id,
      'name':name,
    };
    return map;
}
  test1Obj.fromMap(Map<String, dynamic> map){

    id = map['id'];
    name = map['name'];

  }
  

}