import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:get_it/get_it.dart';
import 'package:simonpokedex/services/database_service.dart';

class FavouriteItemsProvider extends StateNotifier<List<String>> {

  FavouriteItemsProvider(super._state) {
    _setup();
  }

  final DatabaseService service = GetIt.instance.get<DatabaseService>();

  final String FAVOURITE_LIST_KEY = "favourite_list";

  Future<void> _setup() async {
    state = await service.getList(FAVOURITE_LIST_KEY)??[];
  }

  void addFavourite(String url){
    state = [...state,url];
    service.saveList(FAVOURITE_LIST_KEY, state);
  }

  void removeFavourite(String url){
    state = state.where((item) => item!= url).toList();
    service.saveList(FAVOURITE_LIST_KEY, state);
  }
}

final favouriteItemsProvider = StateNotifierProvider<FavouriteItemsProvider,List<String>>((ref) => FavouriteItemsProvider([]) );