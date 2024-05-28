
class City{
  int id;
  String name;
  int region_id;
  City(this.id,this.name,this.region_id);
  static City jsonToCity(Map<String,dynamic> jsonCity){
    return City(
      jsonCity['id'],
      jsonCity['name'],
      jsonCity['region_id']
    );
  }
}