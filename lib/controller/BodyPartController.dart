import 'package:get/get.dart';

class BodyPartController extends GetxController {
  RxString selectedBodyPart = ''.obs;

  void setSelectedBodyPart(String bodyPart) {
    selectedBodyPart.value = bodyPart;
  }
}
