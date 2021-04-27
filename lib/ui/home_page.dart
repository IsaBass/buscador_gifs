import 'dart:convert';
//import 'dart:html';

import 'package:app05_bucador_gifs/ui/gif_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:share/share.dart';
import 'package:transparent_image/transparent_image.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _search;
  int _offset = 0;
  String imgLogo =
      'https://developers.giphy.com/static/img/dev-logo-lg.7404c00322a8.gif';
  String urlBase =
      'https://api.giphy.com/v1/gifs/trending?api_key=r08kFftXVG17roWUlkaaHWNfCSd7J2YP';
  String urlBaseSearch =
      'https://api.giphy.com/v1/gifs/search?api_key=r08kFftXVG17roWUlkaaHWNfCSd7J2YP';

  Future<Map> _getGifs() async {
    http.Response response;

    if (_search == null || _search.isEmpty)
      response = await http.get(urlBase + '&limit=20&rating=G');
    else
      response = await http.get(
          '$urlBaseSearch&q=$_search&limit=19&offset=$_offset&rating=G&lang=en');

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();

    //_getGifs().then((map) {
    //  print(map);
    //});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Image.network(imgLogo),
        centerTitle: true,
      ),
      backgroundColor: Colors.black,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 400),
            child: Container(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                decoration: InputDecoration(
                  labelText: 'Pesquise Aqui',
                  labelStyle: TextStyle(color: Colors.white, fontSize: 18.0),
                  border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white)),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.yellowAccent)),
                ),
                style: TextStyle(color: Colors.white, fontSize: 25.0),
                textAlign: TextAlign.center,
                onSubmitted: (text) {
                  setState(() {
                    _search = text;
                    _offset = 0;
                  });
                },
              ),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: _getGifs(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.waiting:
                  case ConnectionState.none:
                    return ciculinhoCarregando();
                  default:
                    if (snapshot.hasError)
                      return Text("Erro ao carregar...",
                          style: TextStyle(color: Colors.red, fontSize: 28.0));
                    else
                      return ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 450),
                        child: _createGifTable(context, snapshot),
                      );
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  int _getCount(List data) {
    if (_search == null || _search.isEmpty) {
      return data.length;
    } else {
      return data.length + 1;
    }
  }

  Widget _createGifTable(BuildContext context, AsyncSnapshot snapshot) {
    return GridView.builder(
        padding: EdgeInsets.all(10.0),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 10.0,
          mainAxisSpacing: 10.0,
        ),
        itemCount: _getCount(snapshot.data["data"]),
        itemBuilder: (context, index) {
          if ((_search == null || _search.isEmpty) ||
              index < snapshot.data["data"].length)
            return _quadradoDoGif(snapshot, index, context);
          else
            return quadroBtnCarregarMais();
        });
  }

  Widget _quadradoDoGif(
      AsyncSnapshot snapshot, int index, BuildContext context) {
    return GestureDetector(
      child: FadeInImage.memoryNetwork(
        placeholder: kTransparentImage,
        image: snapshot.data["data"][index]["images"]["fixed_height"]["url"],
        height: 300.0,
        fit: BoxFit.cover,
      ),
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GifPage(snapshot.data["data"][index])));
      },
      onLongPress: () {
        Share.share(
            snapshot.data["data"][index]["images"]["fixed_height"]["url"]);
      },
    );
  }

  Widget quadroBtnCarregarMais() {
    return Container(
      child: GestureDetector(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(Icons.add, color: Colors.white, size: 70.0),
            Text("Carregar mais...",
                style: TextStyle(color: Colors.white, fontSize: 20.0)),
          ],
        ),
        onTap: () {
          setState(() {
            _offset += 19;
          });
        },
      ),
    );
  }
}

Widget ciculinhoCarregando() {
  return Container(
    width: 200.0,
    height: 200.0,
    alignment: Alignment.center,
    child: CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(Colors.red),
      strokeWidth: 5.0,
    ),
  );
}
