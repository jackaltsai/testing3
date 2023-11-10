import 'package:flutter/material.dart';
import 'dart:async';
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Testing'),
        ),
        body: const SafeArea(
            child: MyHomePage(title: 'Testing')
        ),
      ),
      debugShowCheckedModeBanner: false,
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
  late Future<String> _imageURL;

  @override
  void initState() {
    super.initState();
    _imageURL = fetchImageURL();
  }

  Future<String> fetchImageURL() async {
    await Future.delayed(const Duration(seconds: 2));
    final response = await http.get(Uri.parse('https://example.com/api/image'));
    if (response.statusCode == 200) {
      return response.body;
    } else {
      throw Exception('Failed to load image URL');
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FutureBuilder<String>(
        future: _imageURL,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Text("Loading");
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Image.network(snapshot.data!);
          }
        },
        ),
      ),
    );
  }
}
