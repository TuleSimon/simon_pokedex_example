import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simonpokedex/extensions/ExtensionFunctions.dart';
import 'package:simonpokedex/models/pokemon.dart';
import 'package:simonpokedex/providers/favourite_items_providers.dart';
import 'package:simonpokedex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonCards extends ConsumerStatefulWidget {
  final String pokemonURL;

  const PokemonCards({super.key, required this.pokemonURL});

  @override
  ConsumerState<PokemonCards> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends ConsumerState<PokemonCards> {
  late FavouriteItemsProvider _favouriteItemsProvider;

  @override
  Widget build(BuildContext context) {
    final pokemon = ref.watch(pokeomonDataprovider(widget.pokemonURL));

    _favouriteItemsProvider = ref.watch(favouriteItemsProvider.notifier);

    return pokemon.when(
        data: (data) => _tile(context, false, data),
        error: _error,
        loading: () {
          return _tile(context, true, null);
        });
  }

  Widget _tile(BuildContext context, bool isLoading, Pokemon? pokemon) {
    return Skeletonizer(
      enabled: isLoading,
      child: Container(
        margin: EdgeInsets.symmetric(
          horizontal: context.getDeviceWidth() * 0.03,
          vertical: context.getDeviceWidth() * 0.031,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: context.getDeviceWidth() * 0.03,
          vertical: context.getDeviceWidth() * 0.031,
        ),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                spreadRadius: 2,
                blurRadius: 10,
              )
            ],
            color: isLoading ? null : Theme.of(context).primaryColor),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    pokemon?.name?.toUpperCase() ?? "Pokemon",
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  Text("#${pokemon?.id}",
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold))
                ],
              ),
              Expanded(
                  child: pokemon != null
                      ? CircleAvatar(
                          radius: context.getDeviceHeight() * 0.05,
                          backgroundImage:
                              NetworkImage(pokemon.sprites!.frontDefault!),
                        )
                      : const CircleAvatar()),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("${pokemon?.moves?.length} Moves",
                      style: const TextStyle(
                        color: Colors.white,
                      )),
                  GestureDetector(
                      onTap: (){
                        _favouriteItemsProvider.removeFavourite(widget.pokemonURL);
                      },
                      child: const Icon(Icons.favorite,color: Colors.red,)),
                ],
              ),
            ]),
      ),
    );
  }

  Widget _error(object, stack) {
    return Text("Error ${stack}");
  }
}
