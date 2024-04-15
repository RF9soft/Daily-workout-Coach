import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shimmer/shimmer.dart';

import '../../common/app_colors.dart';
import '../../common/strings.dart';
import '../../network/ApiService.dart';
import 'exercise_details_screen.dart';

class ExerciseScreen extends StatefulWidget {
  const ExerciseScreen({super.key});

  @override
  _ExerciseScreenState createState() => _ExerciseScreenState();
}

class _ExerciseScreenState extends State<ExerciseScreen> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  final ApiService _apiService = ApiService();
  List<Map<String, dynamic>> exercises = [];
  int currentPage = 1;

  // ---- Interstitial Ad ---- //
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;

  @override
  void initState() {
    super.initState();
    fetchData(currentPage);
    createInterstitial(); // Interstitial Ad
  }

  Future<void> fetchData(int page) async {
    try {
      List<Map<String, dynamic>> data =
          await _apiService.fetchExercisesByPage(page);
      setState(() {
        exercises.addAll(data);
        currentPage++;
      });
    } catch (e) {
      print('Error: $e');
      // Handle error, show error message, etc.
    }
  }

  Future<void> loadMoreData() async {
    await fetchData(currentPage);
  }

  // ---- Interstitial Ad functions----
  static const AdRequest request = AdRequest(
    keywords: <String>['foo', 'bar'],
    contentUrl: 'http://foo.com/bar.html',
    nonPersonalizedAds: true,
  );

  // ---- Interstitial Ad functions---- //
  void createInterstitial() {
    InterstitialAd.load(
      adUnitId:
          Platform.isAndroid ? interstitialAdUnitId : interstitialAdUnitId,
      request: request,
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          print("Ad Loaded");
          interstitialAd = ad;
          _numInterstitialLoadAttempts = 0;
        },
        onAdFailedToLoad: (LoadAdError error) {
          print("Ad Failed to Load");
          interstitialAd = null;
          _numInterstitialLoadAttempts += 1;
          if (_numInterstitialLoadAttempts < 3) {
            createInterstitial();
          }
        },
      ),
    );
  }

  void _showInterstitialAd() {
    if (interstitialAd == null) {
      print('Warning: attempt to show interstitialAd before loaded.');
      return;
    }
    interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (InterstitialAd ad) =>
          print('ad onAdShowedFullScreenContent.'),
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        print('$ad onAdDismissedFullScreenContent.');
        ad.dispose();
        createInterstitial();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        print('$ad onAdFailedToShowFullScreenContent: $error');
        ad.dispose();
        createInterstitial();
      },
    );

    interstitialAd!.setImmersiveMode(true);
    interstitialAd!.show(
        //     onUserEarnedReward: (AdWithoutView ad, RewardItem reward) {
        //   print('$ad with reward $RewardItem(${reward.amount}, ${reward.type})');
        // }
        );
    interstitialAd = null;
  }

  @override
  void dispose() {
    super.dispose();
    interstitialAd?.dispose(); // Interstitial Ad
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorBg,
      appBar: AppBar(
        backgroundColor: colorAppBar,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Get.back();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
        titleSpacing: -1,
        title: const Text(
          'Exercise Screen',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent) {
            // User has reached the end of the list, load more data
            loadMoreData();
          }
          return true;
        },
        child: ListView.builder(
          itemCount: exercises.length + 1, // Add 1 for the loading indicator
          padding: REdgeInsets.only(left: 16, right: 16, top: 16),
          itemBuilder: (context, index) {
            if (index < exercises.length) {
              var exercise = exercises[index];
              return InkWell(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onTap: () {
                  _showInterstitialAd();
                  // Navigate to ExerciseDetailsScreen when a card is tapped
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ExerciseDetailsScreen(
                        name: exercise['name'],
                        gifUrl: exercise['gifUrl'],
                        secondaryMuscles:
                            List<String>.from(exercise['secondaryMuscles']),
                        instructions:
                            List<String>.from(exercise['instructions']),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: REdgeInsets.all(16),
                  margin: REdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: colorContainerBg,
                    borderRadius: BorderRadius.circular(10.r),
                    border: Border.all(
                      color: colorBorder,
                      width: 1.w,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8.r),
                        child: Image.network(
                          exercise['gifUrl'],
                          height: 80.h,
                          width: 80.w,
                          fit: BoxFit.cover,
                        ),
                      ),
                      Gap(16.w),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                            width: 185.w,
                            child: Text(
                              capitalize(exercise['name']),
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Gap(6.h),
                          Text(
                            'Target: ${capitalize(exercise['target'])}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colorBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Gap(4.h),
                          Text(
                            'Body Part: ${capitalize(exercise['bodyPart'])}',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: colorBlack,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              );
            } else {
              // Loading indicator (shimmer effect)
              return Shimmer.fromColors(
                baseColor: Colors.grey[300] ??
                    Colors.grey, // Use default color if null
                highlightColor: Colors.grey[100] ?? Colors.white,
                child: Padding(
                  padding: EdgeInsets.all(10.w),
                  child: Card(
                    color: const Color(0xFFFFFFFF),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      side:
                          const BorderSide(color: Color(0xEFFFEFFF), width: 1),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(20.w),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            width: double.infinity,
                            height: 18.sp, // Set height for shimmer effect
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            height: 14.sp, // Set height for shimmer effect
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: double.infinity,
                            height: 14.sp, // Set height for shimmer effect
                            color: Colors.white,
                          ),
                          SizedBox(height: 10.h),
                          Container(
                            width: 100.w, // Set width for shimmer effect
                            height: 100.h, // Set height for shimmer effect
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}
