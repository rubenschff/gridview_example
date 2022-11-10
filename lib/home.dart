import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late Future<List> listaFotos;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    listaFotos = pegarFotos();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Grid View"),
      ),
      body: FutureBuilder<List>(
        future: listaFotos,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 10,
                    childAspectRatio: 2),
                itemCount: snapshot.data!.length,
                itemBuilder: (context, index) {
                  return Container(
                    padding: EdgeInsets.all(8),
                    color: Colors.red,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(snapshot.data![index]['id'].toString()),
                        //Text(snapshot.data![index]['title'].toString())
                      ],
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return const Center(
              child: Text("Erro ao carregar as imagens"),
            );
          }
          return const Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }

  Future<List> pegarFotos() async {
    var url = Uri.parse('https://jsonplaceholder.typicode.com/photos');
    var response = await http.get(url);

    if (response.statusCode == 200) {
      return json.decode(response.body).map((foto) => foto).toList();
    }
    throw Exception("Erro ao carregar fotos");
  }
}
