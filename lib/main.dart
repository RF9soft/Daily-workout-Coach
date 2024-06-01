import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kettlebell/screen/home_screens.dart';
import 'package:kettlebell/screen/nutrition/news_page_screen.dart';
import 'package:kettlebell/screen/nutrition/nutrition_screen.dart';
import 'package:kettlebell/screen/splash_screen.dart';
import 'package:kettlebell/screen/exercisedb/exercise_screen.dart';
import 'common/app_colors.dart';
import 'common/AppRoutes.dart';
import 'controller/news_controller.dart';  // Import the NewsController

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(360, 690),
        minTextAdapt: true,
        splitScreenMode: true,
        // Use builder only if you need to use library outside ScreenUtilInit context
        builder: (_, child) {
          // Initialize NewsController
          Get.put(NewsController());

          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Daily Workout',
            initialRoute: AppRoutes.splash,
            theme: ThemeData(
              colorScheme: ColorScheme.fromSeed(seedColor: colorAppBar),
              useMaterial3: true,
            ),
            getPages: [
              GetPage(
                name: AppRoutes.splash,
                page: () => const SplashScreen(),
              ),
              GetPage(
                name: AppRoutes.home,
                page: () => const HomeScreen(),
              ),
              GetPage(
                name: AppRoutes.exercise,
                page: () => const ExerciseScreen(),
              ),
              GetPage(
                name: AppRoutes.news,
                page: () => NewsPage(),  // Add a new route for the news screen
              ),
              GetPage(
                name: AppRoutes.premium,
                page: () => NutritionScreen(),  // Add a new route for the news screen
              ),
            ],
          );
        });
  }
}
