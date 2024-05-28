import 'dart:convert';
import 'dart:typed_data';

class User {
  var id;
  var name;
  var email;
  var phone;
  var password;
  var image;
  User(this.id, this.name, this.email, this.phone, this.password,this.image);
  User.withoutId(this.name, this.email, this.phone, this.password,{this.image});
  User.login(this.email,this.password,{this.image});
  User.order(this.name,this.email,this.phone);
  static User jsonToUser(Map<String,dynamic> jsonUser){
    return User(
      jsonUser['id'],
      jsonUser['name'],
      jsonUser['email'],
      jsonUser['phone'],
      jsonUser['password'],
      jsonUser['image'],
    );
  }

}
