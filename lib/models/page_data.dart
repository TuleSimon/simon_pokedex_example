import 'package:flutter/cupertino.dart';
import 'package:simonpokedex/extensions/ExtensionFunctions.dart';

import 'pokemon.dart';

class HomePageData {
  PokemonListData? data;

  HomePageData({
    required this.data,
  });

  HomePageData.initial() : data = null;

  HomePageData copyWith({PokemonListData? data}) {
    return HomePageData(
      data: data ?? this.data,
    );
  }


}
