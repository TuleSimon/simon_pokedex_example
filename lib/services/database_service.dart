import 'package:shared_preferences/shared_preferences.dart';

class DatabaseService{
  DatabaseService();

  Future<bool?> saveList(String key, List<String> list) async{
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.setStringList(key, list);
    }
    catch(e){
      return null;
    }
  }

  Future<List<String>?> getList(String key) async{
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      return prefs.getStringList(key);
    }
    catch(e){
      return null;
    }
  }
}