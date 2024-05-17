import 'dart:io';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../controllers/user_controller.dart';
import '../models/user.dart';
import '../controllers/auth.dart';


class EditProfile extends StatefulWidget {
  const EditProfile({super.key});

  @override
  State<EditProfile> createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<User> u;
  var nameC = TextEditingController();
  var emailC = TextEditingController();
  var phoneC = TextEditingController();
  var passwordC = TextEditingController();
  String imageData = "";

  @override
  void initState() {
    super.initState();
    u = UserController.getUserById(UserController.userId);
    u.then((user) {
      nameC.text = user.name;
      emailC.text = user.email;
      phoneC.text = user.phone;
      passwordC.text = user.password;
      id = user.id;
      if (user.image != "") {
        print("kkkkk" + user.image);
        imageData = user.image;
        setState(() {

        });
      }
    });
  }

  final _formKey = GlobalKey<FormState>();
  var nom;
  var email;
  var phone;
  var password;
  var id;
  File? _image;

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      }
    });
  }

  ImageProvider<Object> _getAvatarImage(File? image) {
    if (image != null) {
      return FileImage(image);
    } else if (imageData != "") {
      print('yee');
      print(imageData);
      return NetworkImage(
        imageData,
        headers: {
          "Cookie": 'session_id=${AuthController.sessionID}',
        },
      );
    } else {
      return AssetImage("assets/defaultupp.png");
    }
  }

  bool isEmail(String input) => EmailValidator.validate(input);

  bool isPhone(String input) {
    RegExp regex = RegExp(r'^(06|05|07)');
    RegExp digitRegex = RegExp(r'^\d+$');
    if (input.length == 10) {
      if (regex.hasMatch(input) && digitRegex.hasMatch(input)) {
        return true;
      }
    }
    return false;
  }

  bool isValidateNom(String input) {
    RegExp alphaRegex = RegExp(r'^[a-zA-Z]+$');
    if (alphaRegex.hasMatch(input)) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    print(AuthController.sessionID);

    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          centerTitle: true,
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.green,
          title: Text(
            textAlign: TextAlign.center,
            'Editer le profil',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
        body: SingleChildScrollView(
            child: Container(
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            SizedBox(height: 13),
            Center(
              child: Stack(children: [
                Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.green.shade200,
                      // Choose your desired border color
                      width: 2, // Choose the width of the border
                    ),
                  ),
                  child: CircleAvatar(
                    radius: 70,
                    backgroundImage:_getAvatarImage(_image)
                  ),
                ),
                Positioned(
                    top: 92,
                    left: 100,
                    child: Center(
                      child: CircleAvatar(
                          backgroundColor: Colors.green[400],
                          child: IconButton(
                            iconSize: 20,
                            onPressed: getImage,
                            padding: EdgeInsets.zero,
                            icon: Icon(
                              Icons.camera_alt_outlined,
                              color: Colors.white,
                            ),
                          )),
                    )),
              ]),
            ),
            Form(
                key: _formKey,
                child: Container(
                  color: Colors.white,
                  padding: EdgeInsets.all(25),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Nom :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: nameC,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champs est obligatoire';
                              } else if (!isValidateNom(value)) {
                                return 'Veuillez entrer valid nom';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              nom = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Email :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: emailC,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(),
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champs est obligatoire';
                              } else if (!isEmail(value)) {
                                return 'Veuillez entrer valid email';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              email = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Numéro de Téléphone :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: phoneC,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champs est requis';
                              } else if (!isPhone(value)) {
                                return 'invalid numero de telephone';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              phone = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Mot de passe :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: TextFormField(
                            controller: passwordC,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              focusedErrorBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.red,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(20)),
                              errorBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.red.shade100,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champs est requis';
                              }
                              password = value;
                              return null;
                            },
                            onSaved: (value) {
                              password = value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 58,
                        ),
                        Container(
                          height: 48,
                          child: ElevatedButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  User updatedUser = User(
                                      id, nom, email, phone, password, null);

                                  if (_image != null) {
                                    updatedUser.image = _image;
                                  }

                                  bool success =
                                      await UserController.updateUser(
                                          updatedUser);

                                  if (success) {
                                    print('User updated successfully');
                                    Navigator.pushNamed(context, '/profile');
                                  } else {
                                    print('Failed to update user');
                                  }
                                }
                              },
                              child: Text(
                                'Modifier',
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green.shade600,
                              )),
                        ),
                      ]),
                ))
          ]),
        )));
  }
}
