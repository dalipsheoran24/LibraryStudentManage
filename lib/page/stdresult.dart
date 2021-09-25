import 'dart:core';
import 'dart:core';
import 'dart:io';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:library_information/dbhelper_widget/dbhelper.dart';
import 'package:library_information/model/database_model.dart';
import 'package:library_information/model/route_widget.dart';
import 'package:step_progress_indicator/step_progress_indicator.dart';
import 'home_page.dart';
class StdResult extends StatefulWidget {
  @override
  _StdResultState createState() => _StdResultState();
}

class _StdResultState extends State<StdResult> {
  ScrollController scrollController = ScrollController();
  List<StudentInformation> list = [];
  DatabaseHelper dbHelper = DatabaseHelper();
  String value = "";
  int currentTime = DateTime.now().millisecondsSinceEpoch;




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
      floatingActionButton: FloatingActionButton(
        onPressed: ()async{
          await Navigator.push(context, MaterialPageRoute(
              builder: (context)=>HomePage()));
          list = await dbHelper.fetchData();
          setState((){});
        },
        child: Icon(Icons.edit),
      ),
      appBar: AppBar(
        title: Text(
          'Library Information'
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
            controller: scrollController,
            shrinkWrap: true,
            itemCount: list.length,
            itemBuilder: (context, index) {
              StudentInformation stdInfo = list[index];
              return GestureDetector(
                onLongPress: () async {
                  AwesomeDialog(
                    context: context,
                    dialogType: DialogType.INFO,
                    animType: AnimType.BOTTOMSLIDE,
                    title: 'Delete',
                    desc: 'Delete this list',
                    btnCancelOnPress: () {},
                    btnOkOnPress: () async {StudentInformation info = list[index];
                    await dbHelper.deleteRecord(info.id);
                    list =  await dbHelper.fetchData() ;
                    setState(() {});},
                  )..show();
                },
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.grey,
                        borderRadius: BorderRadius.circular(8)
                      ),
                      child: ListTile(
                        title:Row(
                            children: [
                              Text("Name:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(width: 37),
                              Text(stdInfo.name,
                                style: TextStyle(
                                  fontSize: 20,
                                ),
                              )
                            ]),
                        subtitle: Column(
                          children: [
                            Row(children: [
                              Text("Address:",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black
                                ),
                              ),
                              SizedBox(width: 16),
                              Text(stdInfo.address,
                                style: TextStyle(
                                  fontSize: 20,
                                    color: Colors.black
                                ),
                              )
                            ]),
                            Row(
                                children: [
                                  Text("MobileNo:",
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.black
                                    ),
                                  ),
                                  SizedBox(width: 8),
                                  Text(stdInfo.mobile,
                                    style: TextStyle(
                                      fontSize: 20,
                                        color: Colors.black
                                    ),
                                  ),

                                ]),
                            Container(
                              height: 30,
                              width: 30,
                              child: Text(
                                getDifference(currentTime).toString(),

                              ),
                            )
                          ],
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                image: FileImage(File(stdInfo.imagePath)
                                ),
                                fit: BoxFit.fill,
                              )
                          ),
                        ),
                      ),
                    ),
                    StepProgressIndicator(
                      totalSteps: 30,
                      currentStep:getDifference(currentTime),
                      selectedColor: Colors.green,
                      unselectedColor: Colors.red,
                    ),
                    SizedBox(height: 16,)
                  ],
                ),
                onTap: () {
                  Navigator.pushNamed(context, Routes.SECOND,
                      arguments: list[index]);
                },
              );


            },

        ),
      ),
    );
  }
  int getDifference(int oldTime) {
    int currentTime = DateTime.now().millisecondsSinceEpoch;
    DateTime oldTimeDate = DateTime.fromMillisecondsSinceEpoch(oldTime);
    DateTime newTimeDate = DateTime.fromMillisecondsSinceEpoch(currentTime);
    int diff = newTimeDate.difference(oldTimeDate).inDays+1;

    DateFormat df = new DateFormat('dd-MMM-yyyy hh:mm a');
    print(df.format(oldTimeDate));

    return diff;
  }
}
