import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/question_controller.dart';

class QuestionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final QuestionController questionController = Get.put(QuestionController());

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        title: Text('Common Questions'),
      ),
      body: Column(
        children: [
          // Tabs
          Container(
            color: Colors.white,
            padding: EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => questionController.toggleTab(true),
                    child: Obx(() => Container(
                      decoration: BoxDecoration(
                        color: questionController.isFrequentSelected.value
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'Frequent',
                          style: TextStyle(
                              color: questionController
                                  .isFrequentSelected.value
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    )),
                  ),
                ),
                SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () => questionController.toggleTab(false),
                    child: Obx(() => Container(
                      decoration: BoxDecoration(
                        color: !questionController.isFrequentSelected.value
                            ? Colors.blue
                            : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: EdgeInsets.symmetric(vertical: 16),
                      child: Center(
                        child: Text(
                          'App',
                          style: TextStyle(
                              color: !questionController
                                  .isFrequentSelected.value
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ),
                    )),
                  ),
                ),
              ],
            ),
          ),
          // Tab Content
          Expanded(
            child: Obx(() => questionController.isFrequentSelected.value
                ? ListView.builder(
              itemCount: questionController.frequentData.length,
              itemBuilder: (context, index) {
                var data = questionController.frequentData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white70,

                    elevation: 0,
                    child: ExpansionTile(
                      title: Text(data['question']!),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(data['answer']!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
                : ListView.builder(
              itemCount: questionController.appData.length,
              itemBuilder: (context, index) {
                var data = questionController.appData[index];
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    color: Colors.white70,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    elevation: 0,
                    child: ExpansionTile(
                      title: Text(data['question']!),
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(data['answer']!),
                        ),
                      ],
                    ),
                  ),
                );
              },
            )),
          ),
        ],
      ),
    );
  }
}
