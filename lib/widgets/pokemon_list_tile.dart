import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:simonpokedex/models/pokemon.dart';
import 'package:simonpokedex/providers/favourite_items_providers.dart';
import 'package:simonpokedex/providers/pokemon_data_providers.dart';
import 'package:skeletonizer/skeletonizer.dart';

class PokemonListTile extends ConsumerStatefulWidget{

  final String pokemonURL;

  const PokemonListTile({super.key, required this.pokemonURL});

  @override
  ConsumerState<PokemonListTile> createState() => _PokemonListTileState();
}

class _PokemonListTileState extends ConsumerState<PokemonListTile> {

  late FavouriteItemsProvider _favouriteItemsProvider;
  late List<String> _favouritePokemons;

  @override
  Widget build(BuildContext context) {

    final pokemon = ref.watch(pokeomonDataprovider(widget.pokemonURL));

    _favouriteItemsProvider = ref.watch(favouriteItemsProvider.notifier);
    _favouritePokemons = ref.watch(favouriteItemsProvider);

    return pokemon.when(data:(data)=>  _tile(context,false,data), error: _error, loading: (){
      return _tile(context,true,null);
    });
  }

  Widget _tile(BuildContext context,
      bool isLoading,
      Pokemon? pokemon){
    return Skeletonizer(
      enabled: isLoading,
      child: ListTile(
        leading: pokemon!=null?CircleAvatar(
          backgroundImage: NetworkImage(pokemon.sprites!.frontDefault!),
        ):CircleAvatar(),
        title: Text(pokemon!=null?pokemon.name!:"Loading name"),
        subtitle: Text("Has ${pokemon?.moves?.length??"0"} moves"),
        trailing: IconButton(
          onPressed: (){
            if(_favouritePokemons.contains(widget.pokemonURL)){
              _favouriteItemsProvider.removeFavourite(widget.pokemonURL);
            }
            else{
              _favouriteItemsProvider.addFavourite(widget.pokemonURL);
            }
          },
          icon: _favouritePokemons.contains(widget.pokemonURL)?Icon(Icons.favorite,color: Colors.red,):Icon(Icons.favorite_border),
        ),
      ),
    );
  }

  Widget _error(object,stack){
    return Text("Error ${stack}");
  }

}