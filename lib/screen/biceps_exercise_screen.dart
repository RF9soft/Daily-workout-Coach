import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:http/http.dart' as http;
import 'package:kettlebell/network/ApiHeaders.dart';
import 'dart:convert';

import '../common/app_colors.dart';
import '../common/strings.dart';
import '../network/ApiHeaders2.dart';

class BicepsExerciseScreen extends StatefulWidget {
  const BicepsExerciseScreen({super.key});

  @override
  _BicepsExerciseScreenState createState() => _BicepsExerciseScreenState();
}

class _BicepsExerciseScreenState extends State<BicepsExerciseScreen> {
  String capitalize(String s) => s[0].toUpperCase() + s.substring(1);
  String selectedMuscle = 'biceps';
  List<dynamic> exercises = [];

  Future<void> fetchExercises() async {
    final response = await http.get(
      Uri.parse(
          'https://exercises-by-api-ninjas.p.rapidapi.com/v1/exercises?muscle=$selectedMuscle'),
      headers: ApiHeaders2.getHeaders(),
    );

    if (response.statusCode == 200) {
      setState(() {
        exercises = json.decode(response.body);
      });
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  NativeAd? nativeAd;
  RxBool isAdLoaded = false.obs;

  @override
  void initState() {
    super.initState();
    fetchExercises();
    loadAd();
  }

  loadAd() {
    nativeAd = NativeAd(
        adUnitId: nativeAdsUnitId,
        listener: NativeAdListener(
          onAdLoaded: (ad) {
            isAdLoaded.value = true;
            log("Ad Loaded");
          },
          onAdFailedToLoad: (ad, error) {
            isAdLoaded.value = false;
          },
        ),
        request: const AdRequest(),
        nativeTemplateStyle:
            NativeTemplateStyle(templateType: TemplateType.small));
    nativeAd!.load();
  }

  @override
  void dispose() {
    nativeAd?.dispose();
    super.dispose();
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
          'Muscle Exercises',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 2.h),
          Obx(
            () => Container(
              child: isAdLoaded.value
                  ? ConstrainedBox(
                      constraints: const BoxConstraints(
                        maxHeight: 100,
                        minHeight: 100,
                      ),
                      child: AdWidget(ad: nativeAd!))
                  : const SizedBox(),
            ),
          ),
          Gap(8.h),
          Padding(
            padding: REdgeInsets.only(left: 16, right: 16, bottom: 16),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: colorContainerBg,
                border: Border.all(
                  color: colorBorder,
                  width: 1.w,
                ),
                borderRadius: BorderRadius.circular(10.r),
              ),
              child: Padding(
                padding: REdgeInsets.symmetric(horizontal: 16),
                child: DropdownButton<String>(
                  value: selectedMuscle,
                  underline: Container(),
                  iconEnabledColor: colorPrimary,
                  isExpanded: true,
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedMuscle = newValue!;
                      fetchExercises();
                    });
                  },
                  items: <String>[
                    'abdominal',
                    'abductors',
                    'adductors',
                    'biceps',
                    'calves',
                    'chest',
                    'forearms',
                    'gluts',
                    'hamstrings',
                    'lats',
                    'lower back',
                    'middle back',
                    'neck',
                    'quadriceps',
                    'traps',
                    'triceps',
                  ].map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(capitalize(value),
                          style: const TextStyle(
                            color: colorBlack,
                          )),
                    );
                  }).toList(),
                ),
              ),
            ),
          ),
          Expanded(
            child: exercises.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : ListView.builder(
                    itemCount: exercises.length,
                    padding: REdgeInsets.only(left: 16, right: 16),
                    itemBuilder: (BuildContext context, int index) {
                      var exercise = exercises[index];
                      return Container(
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
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              exercise['name'],
                              style: TextStyle(
                                fontSize: 14.sp,
                                color: colorBlack,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Gap(8.h),
                            Text(
                              exercise['instructions'],
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                fontSize: 12.sp,
                                color: colorBlack,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
