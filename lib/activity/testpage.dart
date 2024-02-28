import 'package:flutter/material.dart';

class testpage extends StatelessWidget {
  const testpage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('书籍列表布局测试'),
        ),
        body: Card(
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
                        'https://books.google.com/books/content?id=kcrMDwAAQBAJ&printsec=frontcover&img=1&zoom=4&source=gbs_api', // 你的图片路径
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
                            child: Container(
                              color: Colors.green,
                              child: const Align(
                                alignment: Alignment.centerLeft,
                                child: Text('上面一半'),
                              ),
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
                                  child: Container(
                                    color: Colors.orange,
                                    child: const Center(
                                      child: Text('下面一半左边'),
                                    ),
                                  ),
                                ),
                                // 第二个下面块
                                Expanded(
                                  child: Container(
                                    color: Colors.yellow,
                                    child: const Center(
                                      child: Text('下面一半右边'),
                                    ),
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
                                // 第一个下面块
                                Expanded(
                                  child: Container(
                                    color: Colors.yellow,
                                    child: const Center(
                                      child: Text('下面一半左边'),
                                    ),
                                  ),
                                ),
                                // 第二个下面块
                                Expanded(
                                  child: Container(
                                    color: Colors.orange,
                                    child: const Center(
                                      child: Text('下面一半右边'),
                                    ),
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
                                // 第一个下面块
                                Expanded(
                                  child: Container(
                                    color: Colors.orange,
                                    child: const Center(
                                      child: Text('下面一半左边'),
                                    ),
                                  ),
                                ),
                                // 第二个下面块
                                Expanded(
                                  child: Container(
                                    color: Colors.yellow,
                                    child: const Center(
                                      child: Text('下面一半右边'),
                                    ),
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
      ),
    );
  }
}
