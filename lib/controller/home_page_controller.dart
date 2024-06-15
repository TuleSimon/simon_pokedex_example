import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:riverpod/riverpod.dart';
import 'package:simonpokedex/models/page_data.dart';
import 'package:simonpokedex/models/pokemon.dart';
import 'package:simonpokedex/services/http_service.dart';


class HomePageController extends StateNotifier<HomePageData>{

  final GetIt _getIt = GetIt.instance;
  late HttpService _httpservice;

  HomePageController(super._state){
    _httpservice = _getIt.get<HttpService>();
    _setUp();
  }

  Future<void> _setUp() async{
    loadData();
  }

  Future<void> loadData() async{
    if(state.data==null){
      Response? res = await _httpservice.get(HttpService.BASE_URL);
      if(res!=null && res.data!=null){
        PokemonListData data = PokemonListData.fromJson(res.data);
        state = state.copyWith(data: data);
      }
    }
    else{
      if(state.data?.next!=null){
          Response? res = await _httpservice.get(state.data!.next!);
          if(res!=null && res.data!=null){
            PokemonListData data = PokemonListData.fromJson(res.data);
            state = state.copyWith(data: data.copyWith(results:[
              ...?state.data?.results,
             ...?data.results
            ]));
          }
      }
    }
  }

}