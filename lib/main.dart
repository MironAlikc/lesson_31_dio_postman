import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  String image = 'https://images.dog.ceo/breeds/malinois/n02105162_7751.jpg';

  String? errorText;
  @override
  void initState() {
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            errorText == null
                ? Image.network(image)
                : Text(errorText.toString())
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          getData();
        },
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> getData() async {
    final Dio dio = Dio();
    try {
      final Response response = await dio.get(
        "https://dog.ceo/api/breeds/image/random",
      );
      final DogsModel model = DogsModel.fromJson(response.data);
      image = model.message ??
          'https://images.dog.ceo/breeds/malinois/n02105162_7751.jpg';
      setState(() {});

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(model.status ?? 'NULL'),
        ),
      );
    } catch (e) {
      errorText = e.toString();
      setState(() {});
    }
  }
}

class DogsModel {
  String? message;
  String? status;

  DogsModel({this.message, this.status});

  DogsModel.fromJson(Map<String, dynamic> json) {
    message = json['message'];
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['message'] = message;
    data['status'] = status;
    return data;
  }
}
