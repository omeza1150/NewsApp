import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'news_design.dart';

Future<List<dynamic>> fetchNews() async {
  final response = await http.get(Uri.parse(
      'https://newsapi.org/v2/everything?q=apple&from=2023-09-18&to=2023-09-18&sortBy=popularity&apiKey=6af198dd11a845dc947b150790f79a63'));
  if (response.statusCode == 200) {
    final jsonData = jsonDecode(response.body);
    return jsonData['articles'];
  } else {
    throw Exception('Failed to load news');
  }
}

void main() {
  runApp(NewsApp());
}

class NewsApp extends StatefulWidget {
  @override
  _NewsAppState createState() => _NewsAppState();
}

class _NewsAppState extends State<NewsApp> {
  late Future<List<dynamic>> futureNews;

  @override
  void initState() {
    super.initState();
    futureNews = fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'ข่าวสารต่างประเทศ',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        body: Center(
          child: FutureBuilder<List<dynamic>>(
            future: futureNews,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                  itemCount: snapshot.data!.length,
                  itemBuilder: (context, index) {
                    return NewsCard(
                      author: snapshot.data![index]['author'],
                      imageUrl: snapshot.data![index]['urlToImage'],
                      title: snapshot.data![index]['title'],
                      description: snapshot.data![index]['description'],
                    );
                  },
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
