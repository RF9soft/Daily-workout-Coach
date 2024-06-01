import 'dart:convert';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import '../../common/app_colors.dart';
import '../../common/strings.dart';
import '../../controller/body_part_controller.dart';
import '../../network/ApiHeaders.dart';
import '../../widget/shimmer_loading_effect.dart';
import 'exercise_details_screen.dart';

class HomeDetailsScreen extends StatefulWidget {
  const HomeDetailsScreen({super.key});

  @override
  _HomeDetailsScreenState createState() => _HomeDetailsScreenState();
}

class _HomeDetailsScreenState extends State<HomeDetailsScreen> {
  final BodyPartController _bodyPartController = Get.find();
  List<Map<String, dynamic>> exercises = [];
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  final box = GetStorage(); // Initialize GetStorage
  // ---- Interstitial Ad ---- //
  InterstitialAd? interstitialAd;
  int _numInterstitialLoadAttempts = 0;



  @override
  void initState() {
    super.initState();
    String selectedBodyPart = _bodyPartController.selectedBodyPart.value;
    List<dynamic>? cachedData =
        box.read<List<dynamic>>('exercises_$selectedBodyPart');
    if (cachedData != null && cachedData.isNotEmpty) {
      exercises = cachedData.cast<Map<String, dynamic>>();
    } else {
      fetchExercises(); // Fetch if no cached data available
    }
    createInterstitial(); // Interstitial Ad

  }


  Future<void> fetchExercises() async {
    String selectedBodyPart = _bodyPartController.selectedBodyPart.value;
    try {
      final response = await http.get(
        Uri.parse(
            'https://exercisedb.p.rapidapi.com/exercises/bodyPart/$selectedBodyPart'),
        headers: ApiHeaders.getHeaders(),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);

        // Cache fetched exercises with GIF URLs using GetStorage
        box.write(
            'exercises_$selectedBodyPart', data); // Use category in the key

        setState(() {
          exercises = data.cast<Map<String, dynamic>>();
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      print('Error: $e');
      // Handle error, show error message, etc.
    }
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
          'Home Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: exercises.isNotEmpty
          ? ListView.builder(
              itemCount: exercises.length,
              padding: REdgeInsets.only(left: 16, right: 16, top: 16),
              itemBuilder: (context, index) {
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
                  child: Padding(
                    padding: REdgeInsets.only(bottom: 16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: colorContainerBg,
                        borderRadius: BorderRadius.circular(10.r),
                        border: Border.all(
                          color: colorBorder,
                          width: 1.w,
                        ),
                      ),
                      child: Row(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(10.r),
                              bottomLeft: Radius.circular(10.r),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: exercise['gifUrl'],
                              height: 90.h,
                              width: 90.w,
                              fit: BoxFit.cover,
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error), // Widget to show on error
                            ),
                          ),
                          Gap(16.w),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 200.w,
                                child: Text(
                                  capitalize(exercise['name']),
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.w600,
                                    color: colorBlack,
                                  ),
                                ),
                              ),
                              Gap(8.h),
                              Text('Target: ${capitalize(exercise['target'])}'),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            )
          : const ShimmerLoadingEffect(), // Display shimmer loading effect while data is being fetched
      
    );
  }
}
