import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

List<String> _kProductIds = [];

class _HomeScreenState extends State<HomeScreen> {
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void initState() {
    _kProductIds = [];
    if (Platform.isAndroid) {
      _kProductIds.add('monthly_plan');
      _kProductIds.add('yearly_plan');
    } else {
      _kProductIds.add('ChatGtpMonthlyPlan');
      _kProductIds.add('ChatGtpYearlyPlan');
    }
    final Stream<List<PurchaseDetails>> purchaseUpdated =
        InAppPurchase.instance.purchaseStream;
    _subscription = purchaseUpdated
        .listen((List<PurchaseDetails>? purchaseDetailsList) {}, onDone: () {
      _subscription!.cancel();
    }, onError: (error) {
      // handle error here.
    });
    initStoreInfo();
    super.initState();
  }

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  List<ProductDetails> products = <ProductDetails>[];
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];
  String label = "0.0";
  String label1 = "0.0";

  Future<void> initStoreInfo() async {
    final bool isAvailable = await _inAppPurchase.isAvailable();
    if (!isAvailable) {
      setState(() {
        products = <ProductDetails>[];
        _purchases = <PurchaseDetails>[];
      });
      return;
    }
    final ProductDetailsResponse productDetailResponse =
        await _inAppPurchase.queryProductDetails(_kProductIds.toSet());
    if (mounted) {
      setState(() {
        products = productDetailResponse.productDetails;
        if (Platform.isAndroid) {
          label =
              "${products[0].rawPrice} ${products[0].currencyCode}\n${products[0].id.toString() == "monthly_plan" ? "Monthly" : "Yearly"}";
          label1 =
              "${products[1].rawPrice} ${products[1].currencyCode}\n${products[1].id.toString() == "monthly_plan" ? "Monthly" : "Yearly"}";
        } else {
          label =
              "${products[0].rawPrice} ${products[0].currencyCode}\n${products[0].id.toString() == "ChatGtpMonthlyPlan" ? "Monthly" : "Yearly \n Free Trial"}";
          label1 =
              "${products[1].rawPrice} ${products[1].currencyCode}\n${products[1].id.toString() == "ChatGtpMonthlyPlan" ? "Monthly" : "Yearly \n Free Trial"}";
        }
      });
    }
    purchases = Map<String, PurchaseDetails>.fromEntries(
        _purchases.map((PurchaseDetails purchase) {
      return MapEntry<String, PurchaseDetails>(purchase.productID, purchase);
    }));
  }

  bool purchasePending = true;

  //
  // Future<void> _listenToPurchaseUpdated(
  //     List<PurchaseDetails> purchaseDetailsList) async {
  //   print("here");
  //   for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
  //     print(" purchaseDetails.status==>  ${purchaseDetails.status}");
  //     if (purchaseDetails.status == PurchaseStatus.canceled) {
  //       setState(() {
  //         purchasePending = true;
  //       });
  //       if (purchaseDetails.pendingCompletePurchase) {
  //         await _inAppPurchase.completePurchase(purchaseDetails);
  //       }
  //       return;
  //     } else {
  //       if (purchaseDetails.status == PurchaseStatus.pending) {
  //         return;
  //       } else {
  //         if (purchaseDetails.status == PurchaseStatus.error) {
  //           if (purchaseDetails.error!.message ==
  //               "BillingResponse.itemAlreadyOwned") {
  //             final bool valid = await _verifyPurchase(purchaseDetails);
  //             if (valid) {
  //               await SpUtil.putBool(SpConstUtil.isPurchase, true);
  //               Future.delayed(const Duration(seconds: 1)).then((value) async {
  //                 Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
  //                   builder: (context) {
  //                     return const PurchaseDoneScreen();
  //                   },
  //                 ), (route) => false);
  //               });
  //             } else {
  //               setState(() {
  //                 purchasePending = true;
  //               });
  //             }
  //             return;
  //           }
  //           setState(() {
  //             purchasePending = true;
  //           });
  //           return;
  //         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
  //             purchaseDetails.status == PurchaseStatus.restored) {}
  //       }
  //     }
  //   }
  // }
  //
  // Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
  //   if (Platform.isAndroid) {
  //     print(purchaseDetails);
  //     print(purchaseDetails.status);
  //     print(purchaseDetails.pendingCompletePurchase);
  //     print(purchaseDetails.verificationData);
  //     print("here server verifications");
  //     print(purchaseDetails.verificationData.serverVerificationData);
  //     print(purchaseDetails.verificationData.localVerificationData);
  //     await _inAppPurchase.completePurchase(purchaseDetails);
  //   }
  //   return Future<bool>.value(true);
  // }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Purchase Demo",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: SafeArea(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    getPurchase();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 8,
                            color: Color.fromRGBO(0, 0, 0, 0.50),
                          )
                        ],
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: Center(
                        child: Text(
                      label,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                ),
              ),
              Expanded(
                child: GestureDetector(
                  onTap: () {
                    getPurchase();
                  },
                  child: Container(
                    margin: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                        boxShadow: const [
                          BoxShadow(
                            offset: Offset(2, 2),
                            blurRadius: 8,
                            color: Color.fromRGBO(0, 0, 0, 0.50),
                          )
                        ],
                        color: Colors.blue[900],
                        borderRadius: BorderRadius.circular(10)),
                    height: 50,
                    child: Center(
                        child: Text(
                      label1,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold, color: Colors.white),
                    )),
                  ),
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: () {
              getPurchase();
            },
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                  boxShadow: const [
                    BoxShadow(
                      offset: Offset(2, 2),
                      blurRadius: 8,
                      color: Color.fromRGBO(0, 0, 0, 0.50),
                    )
                  ],
                  color: Colors.blue[900],
                  borderRadius: BorderRadius.circular(10)),
              height: 50,
              child: const Center(
                  child: Text(
                "Purchase",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
              )),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              margin: const EdgeInsets.all(10),
              decoration: BoxDecoration(boxShadow: const [
                BoxShadow(
                  offset: Offset(2, 2),
                  blurRadius: 8,
                  color: Color.fromRGBO(0, 0, 0, 0.50),
                )
              ], color: Colors.white, borderRadius: BorderRadius.circular(10)),
              height: 50,
              child: const Center(
                  child: Text(
                "Restore",
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              )),
            ),
          ),
        ],
      )),
    );
  }

  late PurchaseParam purchaseParam;
  Map<String, PurchaseDetails>? purchases;
  ProductDetails? productDetails;
  bool isSelected = false;

  Future<void> getPurchase() async {
    print("object object");
    setState(() {
      purchasePending = false;
    });
    if (isSelected) {
      productDetails = products[0];
    } else {
      productDetails = products[1];
    }
    print("${products[0].price}");
    if (Platform.isAndroid) {
      final GooglePlayPurchaseDetails? oldSubscription =
          _getOldSubscription(productDetails!, purchases!);
      print("Here ...");
      purchaseParam = GooglePlayPurchaseParam(
          productDetails: productDetails!,
          applicationUserName: null,
          changeSubscriptionParam: (oldSubscription != null)
              ? ChangeSubscriptionParam(
                  oldPurchaseDetails: oldSubscription,
                  prorationMode: ProrationMode.immediateWithTimeProration,
                )
              : null);
    } else {
      purchaseParam = PurchaseParam(
        productDetails: productDetails!,
        applicationUserName: null,
      );
    }

    _inAppPurchase.buyNonConsumable(purchaseParam: purchaseParam);
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    return oldSubscription;
  }
}
