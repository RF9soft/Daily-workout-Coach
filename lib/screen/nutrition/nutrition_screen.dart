import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../common/app_colors.dart';
import '../../network/nutrition_service.dart';
import '../subscription/subscription_screen.dart';


class NutritionScreen extends StatefulWidget {
  const NutritionScreen({super.key});

  

  @override
  _NutritionScreenState createState() => _NutritionScreenState();
}

class _NutritionScreenState extends State<NutritionScreen> {
  String _searchQuery = '';
  List<dynamic> _searchResults = [];
  int _pageNumber = 1;

  @override
  void initState() {
    super.initState();
    _search();
    //_checkSubscriptionStatus();
  }
  Future<void> _checkSubscriptionStatus() async {
    final prefs = await SharedPreferences.getInstance();
    final isSubscribed = prefs.getBool('isSubscribed') ?? false;
    if (isSubscribed) {
      _search();
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const SubscriptionScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: colorBg,
        surfaceTintColor: Colors.transparent,
        title: const Text('Nutrition Information'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              onSubmitted: (value) {
                setState(() {
                  _searchQuery = value;
                  _pageNumber = 1;
                  _search();
                });
              },
              decoration: const InputDecoration(
                hintText: 'Search for nutrition information',
              ),
            ),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: _searchResults.length,
              itemBuilder: (context, index) {
                var result = _searchResults[index];
                return Card(
                  color: Colors.white,
                  elevation: 1.0,
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    title: Text(result['title']),
                    subtitle: Text(result['snippet']),
                    onTap: () {
                      _launchURL(result['link']);
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _search() async {
    // Concatenate "nutrition" to the search query if it is not already present
    String query = _searchQuery.toLowerCase();
    if (!query.contains('nutrition')) {
      query += ' nutrition';
    }

    List<dynamic> results =
    await NutritionService.searchNutrition(query, _pageNumber);
    setState(() {
      _searchResults.addAll(results);
    });
  }

  Future<void> _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
