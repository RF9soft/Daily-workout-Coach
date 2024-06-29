import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kettlebell/screen/nutrition/news_page_screen.dart';
import 'package:kettlebell/screen/nutrition/nutrition_screen.dart';
import 'package:kettlebell/screen/exercisedb/exercise_screen.dart';
import 'package:kettlebell/screen/subscription/home_screens.dart';
import 'package:kettlebell/screen/subscription/splash_screen.dart';
import 'package:kettlebell/utils/app_open_ad_manager.dart';
import 'common/app_colors.dart';
import 'common/AppRoutes.dart';
import 'controller/news_controller.dart';  // Import the NewsController

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(statusBarColor: Colors.transparent));
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  final OpenAdManager openAdManager = OpenAdManager();
  openAdManager.loadAd();

  runApp(MyApp(openAdManager: openAdManager));
}

class MyApp extends StatelessWidget {
  final OpenAdManager openAdManager;

  const MyApp({super.key, required this.openAdManager});

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
                page: () => SplashScreen(openAdManager: openAdManager),
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
                page: () => const NutritionScreen(),  // Add a new route for the news screen
              ),
            ],
          );
        });
  }
}
