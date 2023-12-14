import 'dart:ffi';
import 'dart:io';

import 'package:bill_app/models/bill_model.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBAdmin {
  Database? _myDatabase;

  //patron singleton
  static final DBAdmin _instance = DBAdmin._();

  DBAdmin._();

  factory DBAdmin() {
    return _instance;
  }

  Future<Database?> _checkDatabase() async {
    if (_myDatabase == null) {
      _myDatabase = await initDatabase();
    }
    return _myDatabase;

    // myDatabase ??= await initDatabase();
  }

  Future<Database> initDatabase() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String pathDatabase = join(directory.path, "BillsDB.db");
    print(pathDatabase);
    return await openDatabase(
      pathDatabase,
      version: 1,
      onCreate: (Database db, int version) {
        db.execute("""CREATE TABLE BILL(
                  id INTEGER PRIMARY KEY AUTOINCREMENT,
                  product TEXT,
                  price INT,
                  datetime TEXT,
                  type TEXT,
                  monto REAL,
                  cantidad REAL
               )""");
      },
    );
  }

  //CRUD
  //OBTENER GASTOS
  Future<List<Map>> obtenerGastos() async {
    Database? db = await _checkDatabase();
    //List data = await db!.query("BILL");

    // obtener data y filtrar por sentencia SQL
    // List data = await db!
    //     .rawQuery("SELECT id, product, price, type FROM BILL WHERE type='Lt.' ");

    // obtener data y filtrar por funcion
    List<Map<String, dynamic>> data = await db!.query(
      "BILL",
      columns: ["id", "product", "price", "type"],
      // where: "type='Lt.'",
    );

    print(data);
    return data;
  }

  Future<List<BillModel>> getBills() async {
    Database? db = await _checkDatabase();
    List<Map<String, dynamic>> data = await db!.query(
      "BILL",
      columns: [
        "id",
        "product",
        "price",
        "type",
      ],
    );

    List<BillModel> bills = data.map((e) => BillModel.fromJson(e)).toList();
    return bills;
  }

  //INSERTAR GASTO
  //insertarGasto(Map<String, dynamic> data) async {

  Future<int> insertarGasto(BillModel data) async {
    Database? db = await _checkDatabase();
    int res = await db!.insert("BILL", data.toJson());
    print(res);
    return res;
  }

  //ACTUALIZAR GASTO
  Future<void> updBill(BillModel bill) async {
    Database? db = await _checkDatabase();
    await db!.update(
        "BILL",
        {
          "product": bill.product,
          "price": bill.price.toString(),
          "type": bill.type,
        },
        where: "id = ${bill.id}");
  }

  //ELIMINAR GASTO
  Future<void> delBill(int id) async {
    Database? db = await _checkDatabase();
    await db!
        .delete(
      "BILL",
      where: "id = $id",
    )
        .then((value) {
      print(value);
    });
  }
}
