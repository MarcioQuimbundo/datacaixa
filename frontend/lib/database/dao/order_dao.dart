import 'package:datacaixa/common/database_strings.dart';
import 'package:datacaixa/database/dao/dao_helper.dart';
import 'package:datacaixa/models/order.dart';
import 'package:datacaixa/models/table.dart';
import 'package:sqflite/sqlite_api.dart';

class OrderDao implements DaoHelper {
  Database db;
  OrderDao(this.db);

  OrderDao.createTable(Database database){
    createTable(database);
  }

  @override
  void createTable(Database database) async {
    await database.execute(
      "CREATE TABLE $orderTable "
            "($identifier INTEGER PRIMARY KEY AUTOINCREMENT, "
            "$hotelId INTEGER, "
            "$orderId INTEGER UNIQUE, "
            "$pdvId INTEGER, "
            "$userId INTEGER, "
            "$tableId INTEGER, "
            "$clientId INTEGER, "
            "$employeeId INTEGER, "
            "$openingDate TEXT, "
            "$closingDate TEXT, "
            "$totalValue REAL, "
            "$people INTEGER, "
            "$status TEXT, "
            "$tableStatus TEXT, "
            "$comment TEXT, "
            "$deliverer INTEGER, "
            "$deliveryStatus TEXT, "
            "$deliveryDate TEXT, "
            "$deliveryTime TEXT, "
            "$type TEXT) "
    );
    print("CREATE ORDER TABLE");
  }

  @override
  Future get(id) async {
    try {
      List<Map> maps = await db.query(orderTable,
          columns: [
            identifier,
            hotelId,
            orderId,
            pdvId,
            userId,
            tableId,
            clientId,
            employeeId,
            openingDate,
            closingDate,
            totalValue,
            people,
            status,
            tableStatus,
            comment,
            deliverer,
            deliveryStatus,
            deliveryDate,
            deliveryTime,
            type
          ],
          where: '$orderId = ?',
          whereArgs: [id]);
      if (maps.length > 0) {
        return Order.fromMap(maps.first);
      }
    } catch(_){
      return null;
    }
  }

  @override
  Future<List> getAll() async {
      List<Map> maps = await db.query(orderTable,
          columns: [
            identifier,
            hotelId,
            orderId,
            pdvId,
            userId,
            tableId,
            clientId,
            employeeId,
            openingDate,
            closingDate,
            totalValue,
            people,
            status,
            tableStatus,
            comment,
            deliverer,
            deliveryStatus,
            deliveryDate,
            deliveryTime,
            type
          ]);
      if (maps.length > 0) {
        return maps.map((map) => Order.fromMap(map)).toList();
      }
    return [];
  }

  @override
  insert(item) async {
    if(item is Order){
      try {
        item.identifier = await db.insert(orderTable, item.toMap());
        return item;
      } catch(_){
        await update(item);
      }
    }
  }

  @override
  insertAll(List items) async {
    if(items is List<Order>){
      for(Order item in items){
        await insert(item);
      }
    }
  }

  @override
  update(item) async {
    if(item is Order){
      try {
        await db.update(orderTable, item.toMap(), where: '$orderId = ?', whereArgs: [item.orderId]);
      } catch(_){}
    }
  }

  @override
  void remove(item) async {
    if(item is Order){
      await db.delete(orderTable, where: '$identifier = ?', whereArgs: [item.identifier]);
    }
  }

  @override
  void removeAll(List items) {
    // TODO: implement removeAll
  }

  @override
  removeNoneExisting(List newItems) async {
    if(newItems is List<Table>){
      List<int> ids = newItems.map((t) => t.hasOrder ? t.orderId : negative).toList();
      try {
        int orderids = await db.delete(
          orderTable,
          where: '$orderId NOT IN (${ids.join(', ')})',
        );
        print("ORDERS DELETED $orderids");
        int itemsids = await db.delete(
          orderItemsTable,
          where: '$orderId NOT IN (${ids.join(', ')})',
        );
        print("ITEMS DELETED $itemsids");
      } catch(_){}
    }
  }

  removeNoneExistingOrder(Order order) {
    // TODO: implement removeNoneExisting
    throw UnimplementedError();
  }
}