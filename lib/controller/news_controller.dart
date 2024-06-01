import 'package:get/get.dart';
import '../network/news_service.dart';

class NewsController extends GetxController {
  var isLoading = false.obs;
  var newsList = <dynamic>[].obs;
  var currentPage = 1.obs;
  var hasMore = true.obs;

  final NewsService _newsService = NewsService();

  @override
  void onInit() {
    fetchNews();
    super.onInit();
  }

  void fetchNews() async {
    if (isLoading.value || !hasMore.value) return;

    isLoading.value = true;

    try {
      final List<dynamic> newArticles = await _newsService.fetchNews("meal plans and nutritional guidance", currentPage.value);
      if (newArticles.isEmpty) {
        hasMore.value = false;
      } else {
        newsList.addAll(newArticles);
        currentPage.value++;
      }
    } catch (e) {
      // Handle error
    } finally {
      isLoading.value = false;
    }
  }
}
