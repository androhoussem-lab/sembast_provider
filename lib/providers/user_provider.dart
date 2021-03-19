import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:sembast/sembast.dart';
import 'package:sembast/sembast_io.dart';
import 'package:sembast_example/database/appdatabase.dart';
import 'package:sembast_example/model/user.dart';

class UserProvider extends ChangeNotifier {

  static const String USER_STORE_NAME = 'users';
  final _userStore = intMapStoreFactory.store(USER_STORE_NAME);
  List<User> _users = [];

  Future<Database> get _db async => await AppDatabase.instance.database;

  Future insert(User user) async {
    await _userStore.add(await _db, user.toMap());
    await getAllSortedByName();
  }

  Future update(int id,User user) async{
    final finder = Finder(filter: Filter.byKey(id));
    await _userStore.update(await _db, user.toMap() , finder: finder);
    await getAllSortedByName();
  }

  Future delete(User user) async{
    final finder = Finder(filter: Filter.byKey(user.id));
    await _userStore.delete(await _db , finder: finder);
    await getAllSortedByName();
  }

  getAllSortedByName() async{
    final finder = Finder(sortOrders: [
      SortOrder('name'),
    ]);

    final recordSnapshots = await _userStore.find(await _db , finder: finder);

    List<User> users =  recordSnapshots.map((snapshot){
      final user = User.fromMap(snapshot.value);
      user.id = snapshot.key;
      return user;
    }).toList();
    this._users = users;
    notifyListeners();
    return users;

  }

  Future<List<User>> search(String query) async{
   final finder = Finder(filter: Filter.equals('name', query));
   final recordSnapshots  = await _userStore.find(await _db , finder: finder);

   List<User> users =  recordSnapshots.map((snapshot){
     final user = User.fromMap(snapshot.value);
     user.id = snapshot.key;
     return user;
   }).toList();
   this._users = users;
   notifyListeners();
   return users;
  }
  List<User> get usersList => this._users;








}