import 'package:dio/dio.dart';
import 'package:flutter/rendering.dart';

class HttpService{
  HttpService();
  final _dio = Dio();

  Future<Response?> get(String path) async {
    try{
      Response? response = await _dio.get(path);
      return response;
    }
    catch( e){
      debugPrint(e.toString());
    }
    return null;
  }

  static const BASE_URL = "https://pokeapi.co/api/v2/pokemon?limit=20&offset=0";

}