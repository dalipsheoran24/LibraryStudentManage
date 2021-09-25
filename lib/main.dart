import 'package:flutter/material.dart';
import 'package:library_information/page/home_page.dart';
import 'package:library_information/page/stdresult.dart';
import 'package:library_information/page/sudent_profile.dart';

import 'model/route_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false,

      initialRoute: Routes.HOME,
      routes: {
        Routes.HOME: (context) => StdResult(),
        Routes.SECOND: (context) => StudentProfile(),

      },
    );
  }
}

