import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart'; // Add this import for launching URLs
import '../../controller/news_controller.dart';

class NewsPage extends StatelessWidget {
  final NewsController _newsController = Get.put(NewsController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: Colors.white,
        title: const Text('News'),
      ),
      body: Obx(() {
        if (_newsController.isLoading.value && _newsController.newsList.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        return NotificationListener<ScrollNotification>(
          onNotification: (ScrollNotification scrollInfo) {
            if (!_newsController.isLoading.value &&
                scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
              _newsController.fetchNews();
              return true;
            }
            return false;
          },
          child: ListView.builder(
            itemCount: _newsController.newsList.length,
            itemBuilder: (context, index) {
              if (index == _newsController.newsList.length - 1 &&
                  _newsController.isLoading.value) {
                return const Center(child: CircularProgressIndicator());
              }

              final article = _newsController.newsList[index];
              return GestureDetector(
                onTap: () async {
                  final url = article['link'];
                  if (await canLaunch(url)) {
                    await launch(url);
                  } else {
                    throw 'Could not launch $url';
                  }
                },
                child: Card(
                  elevation: 0.0,
                  color: Colors.brown[200],
                  margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Image.network(article['imageUrl']),
                        const SizedBox(height: 10),
                        Text(
                          article['title'],
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          article['snippet'],
                          style: const TextStyle(fontSize: 14),
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              article['source'].toString().toLowerCase(),
                              style: const TextStyle(fontSize: 12),
                            ),
                            Text(
                              article['date'],
                              style: const TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        );
      }),
    );
  }
}
