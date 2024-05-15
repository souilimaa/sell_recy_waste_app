import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sell_waste_recy_app/controllers/categoryController.dart';

import 'models/category.dart';
import 'models/product.dart';

class AddProduct extends StatefulWidget {
  const AddProduct({super.key});

  @override
  State<AddProduct> createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  File? _image;
  String imageRquiredError='';
  final _formKey = GlobalKey<FormState>();
  var description;
  var name;
  Category? _selectedCategory; // Change the type to Category

  List<Category> list = []; // Initialize the list to empty initially

  @override
  void initState() {
    super.initState();
    fetchCategories(); // Call function to fetch categories when widget initializes
  }

  // Function to fetch categories asynchronously
  Future<void> fetchCategories() async {
    final categories =
        await CategoryController.getCategories(); // Get categories from server
    setState(() {
      list = categories; // Update the list with category names
      _selectedCategory =
          list.isNotEmpty ? list[0] : null; // Set the initial selected category
    });
  }

  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
        imageRquiredError='';
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text(
              'Ajouter un Produit',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          backgroundColor: Colors.green,
        ),
        body: SingleChildScrollView(
            child: Container(
          margin: EdgeInsets.only(bottom: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 280,
                  height: 200,
                  margin: EdgeInsets.fromLTRB(20, 20, 20, 0),
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.green,
                        width: 1.5,
                        style: BorderStyle.solid,
                      ),
                      borderRadius: BorderRadius.circular(40)),
                  child: Column(
                    children: [
                      _image == null
                          ? Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            height: 150,
                            width: 150,
                            child: Center(
                                child:
                                GestureDetector(
                                  onTap: () {
                                    print('Image pressed');
                                    getImage();
                                  },
                                  child:Image.asset("assets/addProductIcon.png"),

                                )
                            ),
                          ),
                          Text(
                            'Appuyez pour ajouter l\'image de votre produit',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.green,
                            ),
                          )
                        ],
                      )
                          :
                          Container(
                            width: 280,
                            height: 197,

                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(40),
                              child: Image.file(
                                _image!,
                                fit: BoxFit.cover, // Ensure the image covers the entire container
                              ),
                            ),
                          ),



                    ],
                  ),
                ),
              ),
              Center(
                child: Text(
                  imageRquiredError,
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(20, 15, 20, 0),
                child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Nom du Produit :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextFormField(
                            decoration: InputDecoration(
                              hintText: 'Entrer le nom du produit',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(7)),
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
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            validator: (value) {
                               if (value == null || value.isEmpty) {
                               return 'Ce champs est obligatoire';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              name=value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Description du Produit :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: TextFormField(
                            maxLines: 4, // Allows multiline input
                            keyboardType: TextInputType.multiline,
                            decoration: InputDecoration(
                              hintText: 'Entrer Description De Votre Produit',
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 15),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                  color: Colors.green.shade100,
                                ),
                                borderRadius: BorderRadius.circular(7),
                              ),
                              focusedBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: Colors.green,
                                    width: 2,
                                  ),
                                  borderRadius: BorderRadius.circular(7)),
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
                                borderRadius: BorderRadius.circular(7),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Ce champs est obligatoire';
                              }
                              return null;
                            },
                            onSaved: (value) {
                              description=value;
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          'Catégorie du produit :',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Container(
                          child: FormField<Category>(
                            builder: (FormFieldState<Category> state) {
                              return DropdownButton<Category>(
                                value: _selectedCategory,
                                icon: const Icon(
                                    Icons.keyboard_arrow_down,
                                  color: Colors.green,

                                ),
                                underline: Container( // Change color of underline
                                  height: 1,
                                  color: Colors.green[100], // Change color here
                                ),
                                items: list.map((Category item) {
                                  return DropdownMenuItem<Category>(
                                    value: item,
                                    child:Text(item.name),

                                  );
                                }).toList(),

                                onChanged: (Category? newValue) {
                                  setState(() {
                                    _selectedCategory = newValue;
                                  });
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(
                          height: 25,
                        ),
                        Container(
                          width: 300,
                          height: 45,
                          child: ElevatedButton(

                            onPressed: () {
                              if(_image==null){
                                print('tegghdhhjdjhdkhd634535');
                                setState(() {
                                  imageRquiredError='Veuillez ajouter l\'image de produit';

                                });
                              }
                                 if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  Navigator.pushNamed(
                                    context,
                                    '/addProductNext',
                                    arguments: Product.withoutId(name, description,_selectedCategory?.id,_image,null,null,null),
                                  );
                                }
                                  },
                            child: Text(
                              'Suivant',
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green.shade600,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5)
                              ),
                            ),
                            ),
                          ),

                      ],
                    )),
              ),
            ],
          ),
        )));
  }
}
