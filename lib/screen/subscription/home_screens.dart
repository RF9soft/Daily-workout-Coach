import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:kettlebell/common/app_colors.dart';
import 'package:kettlebell/common/app_images.dart';
import 'package:kettlebell/screen/exercisedb/home_exercise_details_screen.dart';
import 'package:kettlebell/screen/nearby/nearby_events_Screen.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/strings.dart';
import '../../controller/body_part_controller.dart';
import '../../widget/app_drawer.dart';
import '../../widget/banner_carousel.dart';
import '../nutrition/nutrition_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final BodyPartController _bodyPartController = Get.put(BodyPartController());

  // ---- Banner Ad ---- //
  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _createBottomBannerAd(); // Banner Ad
  }

  static String get bannerAdUnitId {
    if (Platform.isAndroid) {
      return bannerAdsUnitId;
    } else if (Platform.isIOS) {
      return bannerAdsUnitId;
    } else {
      throw UnsupportedError("Unsupported platform");
    }
  }

  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }

  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose(); // Banner Ad
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: colorBg,
      appBar: AppBar(
        surfaceTintColor: Colors.transparent,
        backgroundColor: colorAppBar,
        title: const Text(
          'Daily Workout Coach',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
        leading: IconButton(
            onPressed: () {
              _scaffoldKey.currentState?.openDrawer();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            )),
        actions: [
          IconButton(
            icon: Icon(Icons.star, color: Colors.yellow),
            onPressed: () {
              _launchURL(); // Call a function to handle launching the URL
            },
          ),
        ],
        elevation: 0,
        centerTitle: true,
      ),
      drawer: const AppDrawer(),
      body: Padding(
        padding: REdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Gap(16.h),
              BannerCarousel(), // Add the banner carousel here
              Gap(16.h),
              GridView.count(
                shrinkWrap: true,
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 2.w / 2.h,
                physics: const NeverScrollableScrollPhysics(),
                children: [
                  _buildCard('Back', back, 'back'),
                  _buildCard('Cardio', abs, 'cardio'),
                  _buildCard('Chest', chest, 'chest'),
                  _buildCard('Lower Arms', lowerArm, 'lower arms'),
                  _buildCard('Lower Legs', lowerLegs, 'lower legs'),
                  _buildCard('Neck', neck, 'neck'),
                  _buildCard('Shoulders', shoulders, 'shoulders'),
                  _buildCard('Upper Arms', upperArm, 'upper arms'),
                  _buildCard('Upper Legs', upperLegs, 'upper legs'),
                  _buildCard('Waist', waist, 'waist'),
                ],
              ),
              Gap(16.h),
              GestureDetector(
                onTap: () {
                  // Navigate to the desired screen upon tap
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => NearbyEventsScreen()),
                  );
                },
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 80.h,
                  margin: EdgeInsets.symmetric(horizontal: 5.0.w),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0.r),
                    image: const DecorationImage(
                      image: AssetImage('assets/images/pattern.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Center(
                    child: Text(
                      'Nearby Events',
                      style: TextStyle(
                        fontSize: 24.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1,
                        fontFamily: 'Roboto',
                      ),
                    ),
                  ),
                ),
              ),
              Gap(16.h),
            ],
          ),
        ),
      ),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? SizedBox(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
    );
  }
  // Function to launch the Play Store URL
  _launchURL() async {
    const url = 'https://play.google.com/store/apps/details?id=com.fitness.power_pulse';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildCard(String title, String imagePath, String bodyPart) {
    return Card(
      elevation: 4,
      shadowColor: colorShadow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.r),
      ),
      child: InkWell(
        onTap: () {
          _bodyPartController.setSelectedBodyPart(bodyPart);
          Get.to(() => const HomeDetailsScreen());
        },
        child: Container(
          decoration: BoxDecoration(
            color: colorBg,
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10.r),
                  topRight: Radius.circular(10.r),
                ),
                child: Image.asset(
                  imagePath,
                  fit: BoxFit.cover,
                  height: 110.h,
                  width: double.infinity,
                ),
              ),
              Gap(6.h),
              Text(
                title,
                style: TextStyle(
                  color: colorBlack,
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
