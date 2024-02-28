import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

const url =
    'https://www.googleapis.com/books/v1/volumes?q=%E3%81%BE%E3%82%93%E3%81%8C%E3%82%BF%E3%82%A4%E3%83%A0%E3%81%8D%E3%82%89%E3%82%89';

class BookFinderPage extends StatelessWidget {
  const BookFinderPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: _fetchPotterBooks(),
          builder: (context, AsyncSnapshot<List<Book>> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                print(
                    'An error occurred in the FutureBuilder: ${snapshot.error}');
                return Center(child: Text('Error: ${snapshot.error}'));
              } else {
                return ListView(
                    children: snapshot.data!.map((b) => BookTile(b)).toList());
              }
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Card(
        child: SizedBox(
            width: 300,
            height: 100,
            child: ListTile(
              leading: Image.network(book.thumbnailUrl),
              title: Text(
                  overflow: TextOverflow.ellipsis,
                  book.title,
                  style: const TextStyle(fontSize: 15)),
              subtitle: Text(book.author, style: const TextStyle(fontSize: 12)),
              onTap: () => _navigateToDetailsPage(book, context),
            )));
  }
}

List<Book> _fetchBooks() {
  return List.generate(100,
      (i) => Book(title: 'Book $i', author: 'Author $i', thumbnailUrl: ''));
}

Future<List<Book>> _fetchPotterBooks() async {
  final res = await http.get(Uri.parse(url));
  if (res.statusCode == 200) {
    return _parseBookJson(res.body);
  } else {
    throw Exception('Error: ${res.statusCode}');
  }
}

//解析书籍列表的json
List<Book> _parseBookJson(String jsonStr) {
  final jsonMap = json.decode(jsonStr);
  final jsonList = (jsonMap['items'] as List);

  return jsonList.map((jsonBook) {
    final volumeInfo = jsonBook['volumeInfo'];

    final title = volumeInfo?['title'];
    final authors = volumeInfo?['authors'] != null
        ? (volumeInfo?['authors'] as List<dynamic>)
            .map((author) => author.toString())
            .toList()
        : null;

    // 防止无封面报错
    final thumbnailUrl = volumeInfo?['imageLinks']?['thumbnail'] ??
        'https://misaka.sakurakoi.top/assets/image/no_img.webp';

    return Book(
      title: title ?? '未知标题',
      author: authors != null ? authors.join(', ') : '未知作者',
      thumbnailUrl: thumbnailUrl,
    );
  }).toList();
}

class Book {
  final String title;
  final String author;
  final String thumbnailUrl;

  Book({required this.title, required this.author, required this.thumbnailUrl});
}

void _navigateToDetailsPage(Book book, BuildContext context) {
  Navigator.of(context).push(MaterialPageRoute(
    builder: (context) => BookDetailsPage(book),
  ));
}

class BookDetailsPage extends StatelessWidget {
  final Book book;

  const BookDetailsPage(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: Padding(
        padding: const EdgeInsets.all(80.0),
        child: BookDetails(book),
      ),
    );
  }
}

class BookDetails extends StatelessWidget {
  final Book book;

  const BookDetails(this.book, {super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Image.network(book.thumbnailUrl),
          const SizedBox(height: 50.0),
          Text(book.title),
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Text(book.author,
                style: const TextStyle(fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
