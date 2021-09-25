
import 'package:library_information/model/database_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Database database;
  String tableName = "std";
  StudentInformation stdinfo;

  Future init() async {
    var databasePath = await getDatabasesPath();
    String path = join(databasePath, "userdbs.db");

    database = await openDatabase(path, version: 1,
        onCreate: (Database db, int version) async {
          await db.execute(
              'create table $tableName (id integer primary key autoincrement,name text, address text, mobile text, fees text,date text, imagePath text, idImagePath text,time integer)');
          print('Table Created');
        });
  }

  Future insertData(StudentInformation studentDetail) async {
    await database.transaction((txn) async {
      await txn.rawInsert(
          'insert into $tableName (name,address,mobile,fees,date,imagePath,idImagePath) values (?,?,?,?,?,?,?)',
          [
            studentDetail.name,
            studentDetail.address,
            studentDetail.mobile,
            studentDetail.fees,
            studentDetail.date,
            studentDetail.imagePath,
            studentDetail.idImagePath,
          ]);
      print("Data Inserted ......");
    });
  }

  Future<List<StudentInformation>> fetchData() async {
    List<StudentInformation> studentInformationList = [];
    await database.transaction((txn) async {
      List<Map> mapList = await txn.rawQuery("select * from $tableName");
      print("Data is:  ...... ");
      mapList.forEach((map) {
        int id = map["id"];
        String name = map['name'];
        String address = map["address"];
        String mobile = map['mobile'];
        String fees = map['fees'];
        String date = map['date'];
        String imagePath = map['imagePath'];
        String idImagePath = map['idImagePath'];
        StudentInformation stdInfo = StudentInformation(id: id,name: name,address: address,mobile: mobile,fees: fees,date: date,imagePath: imagePath ,idImagePath: idImagePath);
        studentInformationList.add(stdInfo);
      });
    });
    return studentInformationList;
  }

  Future deleteRecord(int id) async {
    await database.transaction((txn) async {
      await txn.rawDelete('delete from $tableName where id= ?', [id]);
      print("");
    });
  }
  //"delete from tableName where topic = "abc"

  void closeDb() {
    database.close();
  }
}