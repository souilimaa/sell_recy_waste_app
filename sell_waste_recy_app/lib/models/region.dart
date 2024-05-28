class Region{
  int id;
  String name;
  Region(this.id,this.name);
  static Region jsonToRegion(Map<String,dynamic> jsonRegion){
    return Region(
      jsonRegion['id'],
      jsonRegion['name'],
    );
  }
}