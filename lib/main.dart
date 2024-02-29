import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kettlebell/screen/HomeScreen.dart';
import 'package:kettlebell/screen/SplashScreen.dart';
import 'package:kettlebell/screen/exercisedb/ExerciseScreen.dart';
import 'package:provider/provider.dart';
import 'common/AppColors.dart';
import 'common/AppRoutes.dart';

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
          return GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'PowerPulse',
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
            ],
          );
        });
  }
}
