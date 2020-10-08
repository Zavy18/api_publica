import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() {
  runApp(MyApp());
}

Future<List> fetchGeneros() async {
  final response = await http.get('https://binaryjazz.us/wp-json/genrenator/v1/genre/25/');
  if (response.statusCode == 200) {
    return json.decode(response.body);
  } else {
    throw Exception('Failed to load album');
  }
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Music',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Generos Musicales'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Future<List> futureAlbum;

  @override
  void initState() {
    super.initState();
    futureAlbum = fetchGeneros();
    
  }

  void updateForencast(){
    futureAlbum = fetchGeneros();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Center(
            child: FutureBuilder<List>(
              future: futureAlbum,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15.0),
                        child: SizedBox(
                          height: 50,
                          child: Text("Generos musicales!",
                          style: TextStyle(color: Colors.red),)
                          )
                      ),
                      Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Column( children: [
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(snapshot.data[0]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(snapshot.data[1]),
                          ),
                          Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: Text(snapshot.data[2]),
                          ),
                       
                        ],
                        ),
                      ),
                      
                    ],
                    mainAxisAlignment: MainAxisAlignment.start,
                  );
                } else if (snapshot.hasError) {
                  return Text("${snapshot.error}");
                }
                return CircularProgressIndicator();
              },
            )
        ),
      ),
    );
  }
}
