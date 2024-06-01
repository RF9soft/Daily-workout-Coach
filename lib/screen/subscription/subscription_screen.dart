import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:kettlebell/screen/home_screens.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SubscriptionScreen extends StatefulWidget {
  const SubscriptionScreen({Key? key}) : super(key: key);

  @override
  State<SubscriptionScreen> createState() => _SubscriptionScreenState();
}

class _SubscriptionScreenState extends State<SubscriptionScreen> {
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<dynamic> _streamSubscription;
  List<ProductDetails> _products = [];
  final Set<String> _kProductIds = {"work_pro", "amplifyabhi_pro"};

  @override
  void initState() {
    super.initState();
    final purchaseUpdated = _inAppPurchase.purchaseStream;
    _streamSubscription = purchaseUpdated.listen((purchaseDetailsList) {
      _listenToPurchase(purchaseDetailsList);
    }, onDone: () {
      _streamSubscription.cancel();
    }, onError: (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error")),
      );
    });
    _initStore();
  }

  @override
  void dispose() {
    _streamSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () {
           Get.back();
          },
        ),

      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.all(16.0),
            child:

            Column(
              children: [
                Text(
                  "Premium Offer from us",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 20,color: Colors.blue,fontWeight: FontWeight.w600),
                ),
                Gap(8.0),
                Text(
                  " Exclusive events, ad-free experience) available through subscription",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16),
                ),
              ],
            ),
          ),
          _products.isEmpty
              ? const CircularProgressIndicator() // Show loading indicator if products are not loaded
              : Image.asset(
            'assets/images/worka.png', // Replace with your actual asset image path
            height: 200,
          ),
          const SizedBox(height: 20),
          _products.isEmpty
              ? const CircularProgressIndicator()
              : ElevatedButton(
            onPressed: _buy,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0066FF), // Button color
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8), // 8 dp radius
              ),
              elevation: 0, // No elevation
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 80, vertical: 20),
              child: Text(
                "Pay",
                style: TextStyle(fontSize: 16,color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _initStore() async {
    final ProductDetailsResponse response = await _inAppPurchase.queryProductDetails(_kProductIds);
    if (response.error == null) {
      setState(() {
        _products = response.productDetails;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(response.error!.message)),
      );
    }
  }

  void _listenToPurchase(List<PurchaseDetails> purchaseDetailsList) async {
    for (final purchaseDetails in purchaseDetailsList) {
      if (purchaseDetails.status == PurchaseStatus.pending) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Pending")),
        );
      } else if (purchaseDetails.status == PurchaseStatus.error) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Error")),
        );
      } else if (purchaseDetails.status == PurchaseStatus.purchased) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Purchased")),
        );
        final prefs = await SharedPreferences.getInstance();
        await prefs.setBool('isSubscribed', true);
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  void _buy() {
    if (_products.isNotEmpty) {
      final purchaseParam = PurchaseParam(productDetails: _products[0]);
      _inAppPurchase.buyConsumable(purchaseParam: purchaseParam);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No products available")),
      );
    }
  }
}