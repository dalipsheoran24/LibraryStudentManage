import 'dart:io';
import 'package:flutter/material.dart';
import 'package:library_information/dbhelper_widget/dbhelper.dart';
import 'package:library_information/model/database_model.dart';
import 'package:library_information/page/stdresult.dart';
import 'package:image_picker/image_picker.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ScrollController scrollController = ScrollController();
  TextEditingController nameController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController mobController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController feesController = TextEditingController();

  List<StudentInformation> list = [];
  DatabaseHelper dbHelper = DatabaseHelper();
  String value = "";
  String imagePath;
  String idImagePath;
  String dates;
  int listTime;


  Future getImage() async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile images =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.pickImage(source: ImageSource.camera);
    imagePath = images.path;
  }

  Future getIdImage() async {
    // ignore: invalid_use_of_visible_for_testing_member
    PickedFile idImage =
    // ignore: invalid_use_of_visible_for_testing_member
    await ImagePicker.platform.pickImage(source: ImageSource.camera);
    idImagePath = idImage.path;
  }

  @override
  void initState() {
    super.initState();
    init();
  }

  Future init() async {
    await dbHelper.init();
    list = await dbHelper.fetchData();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Information'),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  controller: nameController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'Enter name'),
                ),
                TextField(
                  controller: addressController,
                  keyboardType: TextInputType.name,
                  decoration: InputDecoration(hintText: 'Enter address'),
                ),
                TextField(
                  controller: mobController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(hintText: 'Enter MobileNo.'),
                ),
                TextField(
                  controller: feesController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(hintText: 'Fees'),
                ),
                TextField(
                  controller: dateController,
                  keyboardType: TextInputType.datetime,
                  decoration: InputDecoration(hintText: 'Enter date'),
                ),


                SizedBox(
                  height: 30,
                ),
                Row(
                  children: [
                    ElevatedButton(
                        child: Text('Submit Data'),
                        onPressed: () async {
                          String name = nameController.text;
                          String address = addressController.text;
                          String mobile = mobController.text;
                          String fees = feesController.text;
                          String date = dateController.text;

                          //

                              {
                            if (imagePath != null && idImagePath != null) {
                              StudentInformation stdInfo = StudentInformation(
                                name: name,
                                address: address,
                                mobile: mobile,
                                fees: fees,
                                date: date,
                                imagePath: imagePath,
                                idImagePath: idImagePath,
                              );

                              await dbHelper.insertData(stdInfo);
                              nameController.text = "";
                              addressController.text = "";
                              mobController.text = "";
                              feesController.text = "";
                              dateController.text = "";
                              print(value);
                              Navigator.pop(context);
                            }
                            // Navigator.push(
                            //     context,
                            //     MaterialPageRoute(
                            //         builder: (context) => StdResult()));
                          } //else {
                          //Image not selected
                        }
                      // },
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: getImage,
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_rounded),
                          Text('Image')
                        ],
                      ),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    ElevatedButton(
                      onPressed: getIdImage,
                      child: Row(
                        children: [
                          Icon(Icons.camera_alt_rounded),
                          Text('Id Image')
                        ],
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }
}
