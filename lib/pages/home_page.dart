import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:simonpokedex/controller/home_page_controller.dart';
import 'package:simonpokedex/extensions/ExtensionFunctions.dart';
import 'package:simonpokedex/models/page_data.dart';
import 'package:simonpokedex/models/pokemon.dart';
import 'package:simonpokedex/providers/favourite_items_providers.dart';
import 'package:simonpokedex/widgets/pokemon_cards.dart';
import 'package:simonpokedex/widgets/pokemon_list_tile.dart';

final _homePageControllerProvider = StateNotifierProvider<
    HomePageController,
    HomePageData>((ref) => HomePageController(HomePageData.initial()));

class MyHomePage extends ConsumerStatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  ConsumerState<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends ConsumerState<MyHomePage> {

  late HomePageData _homePageData;
  late HomePageController _homePageController;
  late List<String> _favourites;

  final ScrollController _allPokenmonListController = ScrollController();

  @override
  void initState() {
    _allPokenmonListController.addListener(scrollListener);
    super.initState();
  }

  void scrollListener() {
    debugPrint(_allPokenmonListController.offset.toString());
    debugPrint(_allPokenmonListController.position.maxScrollExtent.toString());
    if (_allPokenmonListController.offset >=
        _allPokenmonListController.position.maxScrollExtent * 1 &&
        !_allPokenmonListController.position.outOfRange) {
      debugPrint("Reached End of list");
      _homePageController.loadData();
    }
  }

  @override
  void dispose() {
    _allPokenmonListController.removeListener(scrollListener);
    _allPokenmonListController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _homePageController = ref.watch(_homePageControllerProvider.notifier);
    _homePageData = ref.watch(_homePageControllerProvider);
    _favourites = ref.watch(favouriteItemsProvider);

    return Scaffold(body: _buildUi(context));
  }

  Widget _buildUi(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Container(
          width: context.getDeviceWidth(),
          padding:
          EdgeInsets.symmetric(horizontal: context.getDeviceWidth() * 0.02),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _favouritePokemonList(context),
              _allPokemonList(context)],
          ),
        ),
      ),
    );
  }

  Widget _favouritePokemonList(BuildContext context) {
    return SizedBox(
      width: context.getDeviceWidth(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Favourites", style: TextStyle(fontSize: 25)),
          SizedBox(
              height: context.getDeviceHeight() * 0.50,
              width: context.getDeviceWidth(),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  if(_favourites.isEmpty) const Text("No favourite Pokemon")
                  else
                    SizedBox(
                      height: context.getDeviceHeight() * 0.48,
                      child: GridView.builder(
                        scrollDirection:Axis.horizontal ,
                          shrinkWrap: false,
                          itemCount: _favourites.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                          ), itemBuilder: (context, index) {
                        return PokemonCards(pokemonURL: _favourites[index]);
                      }),
                    ),
                ],
              )
          )
        ],
      ),
    );
  }

  Widget _allPokemonList(BuildContext context) {
    return SizedBox(
      width: context.getDeviceWidth(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("All Pokemons", style: TextStyle(fontSize: 25)),
          SizedBox(
            height: context.getDeviceHeight() * 0.60,
            child: ListView.builder(
                controller: _allPokenmonListController,
                itemCount: _homePageData.data?.results?.length ?? 0,
                itemBuilder: (context, index) {
                  PokemonListResult pokemon = _homePageData.data!
                      .results![index];
                  return PokemonListTile(
                    pokemonURL: pokemon.url ?? "",
                  );
                }),
          )
        ],
      ),
    );
  }
}
