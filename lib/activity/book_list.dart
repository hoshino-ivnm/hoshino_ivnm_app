import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../components/text/icon_text.dart';

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
                debugPrint(
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
      child: InkWell(
        splashColor: Colors.pink[100],
        onTap: () {
          _navigateToDetailsPage(book, context);
        },
        child: SizedBox(
          height: 150,
          child: Container(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // 左边一半
                AspectRatio(
                  aspectRatio: 650 / 920, // 图片的宽高比
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(14.0),
                    child: Image.network(
                      book.thumbnailUrl,
                      // 你的图片路径
                      fit: BoxFit.contain, // 保持比例并且尽量填满
                    ),
                  ),
                ),
                // 文字部分
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(10, 0, 0, 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // 标题
                        Expanded(
                          flex: 2,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(book.title),
                          ),
                        ),
                        // 其余部分(作者，日期，状态啥的)
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 第一个下面块
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.person,
                                          text: book.author)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.date_range,
                                          text: "最早入库时间：2023/10/10")),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.date_range,
                                          text: "最后一本出库时间：2023/10/10")),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.qr_code,
                                          text: "识别码：${book.isbn}")),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Expanded(
                          flex: 1,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // 第一个下面块
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.storage, text: "总数：10")),
                                ),
                              ),
                              // 第二个下面块
                              Expanded(
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: ClipRect(
                                      child: IconText(
                                          icon: Icons.output, text: "出库数：10")),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

List<Book> _fetchBooks() {
  return List.generate(
      100,
      (i) => Book(
          title: 'Book $i', author: 'Author $i', thumbnailUrl: '', isbn: ''));
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
    final isbn = volumeInfo?['industryIdentifiers'] != null &&
            volumeInfo['industryIdentifiers'].length > 1
        ? (volumeInfo['industryIdentifiers'][1]?['identifier'] ?? '无法查找到isbn')
        : (volumeInfo['industryIdentifiers'][0]?['identifier'] ?? '无法查找到isbn');

    // 防止无封面报错
    final thumbnailUrl = volumeInfo?['imageLinks']?['thumbnail'] ??
        'https://misaka.sakurakoi.top/assets/image/no_img.webp';

    return Book(
        title: title ?? '未知标题',
        author: authors != null ? authors.join(', ') : '未知作者',
        thumbnailUrl: thumbnailUrl,
        isbn: isbn);
  }).toList();
}

class Book {
  final String title;
  final String author;
  final String isbn;
  final String thumbnailUrl;

  Book(
      {required this.title,
      required this.author,
      required this.thumbnailUrl,
      required this.isbn});
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
