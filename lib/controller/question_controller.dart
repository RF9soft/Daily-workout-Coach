import 'package:get/get.dart';

class QuestionController extends GetxController {
  var isFrequentSelected = true.obs;
  var frequentData = [
    {
      'question': 'How often should I exercise?',
      'answer': 'It is recommended to exercise at least 3-4 times a week for optimal health benefits. However, the frequency can vary based on individual fitness goals and levels.'
    },
    {
      'question': 'Don’t want ads?',
      'answer': 'You can upgrade to our premium version to enjoy an ad-free experience. The premium version also includes additional features and content.'
    },
    {
      'question': 'Want more workouts?',
      'answer': 'Check out our workout library for a variety of workout plans. We constantly update our library with new routines to keep your fitness journey exciting and effective.'
    },
    {
      'question': 'Want more features for events?',
      'answer': 'Our app offers a range of features to help you track and participate in fitness events. Explore the Events section for more details and stay updated with upcoming events.'
    },
  ].obs;
  var appData = [
    {
      'question': 'Can I use this app?',
      'answer': 'The answer is absolutely yes if you are in good condition. All workouts are designed by professionals. If you are a beginner, don’t skip the guidelines.'
    },
    {
      'question': 'How often should I work out?',
      'answer': 'It is recommended to work out at least 3-4 times a week for the best results. However, the frequency can vary based on your fitness goals.'
    },
    // Add more questions and answers here
  ].obs;

  void toggleTab(bool isFrequent) {
    isFrequentSelected.value = isFrequent;
  }
}
