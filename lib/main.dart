import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:pokedex/pokemonDetails.dart';

void main() {
  runApp(MyApp());
}

class Pokemon {
  //final int id;
  final String name;
  final String Url;

  Pokemon({required this.name, required this.Url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(
      //id: json['id'],
      Url: json['url'],
      name: json['name'].toUpperCase(),
    );
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokedex App',
      home: PokedexScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class PokedexScreen extends StatefulWidget {
  @override
  _PokedexScreenState createState() => _PokedexScreenState();
}

class _PokedexScreenState extends State<PokedexScreen> {
  late List<Pokemon> pokemonList = [];

  @override
  void initState() {
    super.initState();
    fetchPokemonData();
  }

  Future<void> fetchPokemonData() async {
    final response = await http.get(Uri.parse('https://pokeapi.co/api/v2/pokemon?limit=151'));
    final decodedResponse = json.decode(response.body);
    print(decodedResponse);

    setState(() {
      pokemonList = (decodedResponse['results'] as List)
          .map((json) => Pokemon.fromJson(json))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Pokedex'),
        ),
        body: pokemonList.isEmpty
            ? Center(
          child: CircularProgressIndicator(),
        )
            : ListView.builder(
            itemCount: pokemonList.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                        onTap: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(builder: (BuildContext) => PokemonDetails())
              );
                        },
              child:ListTile(
                  title: Text(pokemonList[index].name),
                  //leading: Image.network(pokemonList[index].imageUrl),
                )
    );
    }));
  }
}