import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../common/AppRoutes.dart';
import '../../common/app_colors.dart';
import '../../common/app_images.dart';
import '../../common/style.dart';
import '../../utils/app_open_ad_manager.dart'; // Import the file where AppText style is defined

class SplashScreen extends StatelessWidget {
  final OpenAdManager openAdManager;
  const SplashScreen({Key? key,required this.openAdManager});

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context);
    openAdManager.showAdIfAvailable();

    Future.delayed(const Duration(seconds: 3), () {
      Get.offNamed(AppRoutes.home);
    });
    return Scaffold(
      backgroundColor: buttonColor,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Full-screen width image
            SizedBox(
              width: 1.sw,
              height: 0.65.sh,
              child: Image.asset(
                splashImage,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 24.h),

            // Centered text
            Text(
              'Best workouts for you',
              style: AppTextStyles.heading.copyWith(
                color: Colors.amber,
              ),
            ),
            SizedBox(height: 0.025.sh),

            // Text below the main heading
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.1.sw),
              child: Text(
                'You will have everything you need to reach your personal fitness goals - for free!',
                textAlign: TextAlign.center,
                style: AppTextStyles.subheading.copyWith(
                  color: hintColor,
                ),
              ),
            ),
            SizedBox(height: 0.08.sh),

            // Additional Widgets...
          ],
        ),
      ),
    );
  }
}
