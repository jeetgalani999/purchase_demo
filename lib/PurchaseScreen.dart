import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:in_app_purchase/in_app_purchase.dart';
import 'package:in_app_purchase_android/billing_client_wrappers.dart';
import 'package:in_app_purchase_android/in_app_purchase_android.dart';

import 'CommonWidget/ProgressLoader.dart';
import 'CommonWidget/shared_pref.dart';

class PurchaseScreen extends StatefulWidget {
  const PurchaseScreen({Key? key}) : super(key: key);

  @override
  State<PurchaseScreen> createState() => _PurchaseScreenState();
}

List<String> _kProductIds = [];

class _PurchaseScreenState extends State<PurchaseScreen> {
  bool isSelected = false;
  String monthlyTemp = "";
  var price = "0.0";
  var price1 = "0.0";
  var label = "";
  var label1 = "";
  StreamSubscription<List<PurchaseDetails>>? _subscription;
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initStoreInfo();
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
  }

  List<ProductDetails> products = <ProductDetails>[];
  Map<String, PurchaseDetails>? purchases;
  List<PurchaseDetails> _purchases = <PurchaseDetails>[];

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

  @override
  void dispose() {
    _subscription!.cancel();
    super.dispose();
  }

  // late ProgressLoader pl;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          decoration: const BoxDecoration(
            color: Color(0xFF00adc2),
            // image: DecorationImage(
            //     image: AssetImage('assets/images/bot.png'), fit: BoxFit.cover),
          ),
          child: Column(
            children: [
              // InkWell(
              //   onTap: () {
              //     Navigator.pop(context);
              //   },
              //   child: Container(
              //     alignment: Alignment.topLeft,
              //     height: 60,
              //     child: Padding(
              //       padding: const EdgeInsets.all(15),
              //       child: Image.asset(
              //         'assets/images/ic_close.png',
              //       ),
              //     ),
              //   ),
              // ),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(
                          height: 45,
                        ),
                        const Text(
                          'Get Full Access to BrainPower',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: Colors.white,
                            // foreground: Paint()..shader = linearGradient,
                            fontWeight: FontWeight.w700,
                            fontSize: 35,
                          ),
                        ),
                        /*const SizedBox(
                          height: 50,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_tick.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Unlimited chat with GPT AI',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_tick.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Write texts & posts',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_tick.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Revolutionary Al Assistant',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 8,
                        ),
                        Row(
                          children: [
                            Image.asset(
                              'assets/images/ic_tick.png',
                              height: 30,
                              width: 30,
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            const Text(
                              'Enjoy Uninterrupted Experience',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w700,
                                fontSize: 18,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 40,
                        ),*/
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                monthlyTemp = "Monthly";

                                isSelected = true;
                              });
                              await getPurchase();
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: monthlyTemp != "Monthly"
                                          ? Colors.transparent
                                          : Colors.white),
                                  color: Colors.black.withAlpha(70),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colors.white,
                                            ),
                                            child: Radio(
                                              value: "Monthly",
                                              groupValue: monthlyTemp,
                                              activeColor: Colors.white,
                                              onChanged: (value) async {
                                                setState(() {
                                                  monthlyTemp =
                                                      value.toString();
                                                  isSelected = false;
                                                });
                                                await getPurchase();
                                              },
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                label,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                              const Center(
                                                  child: Text(
                                                'Pay for full month',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Text(price,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 18,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10.0),
                          child: InkWell(
                            onTap: () async {
                              setState(() {
                                monthlyTemp = "Yearly";
                                isSelected = false;
                              });
                              await getPurchase();
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: monthlyTemp != "Yearly"
                                          ? Colors.transparent
                                          : Colors.white),
                                  color: Colors.black.withAlpha(70),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Row(
                                        children: [
                                          Theme(
                                            data: ThemeData(
                                              unselectedWidgetColor:
                                                  Colors.white,
                                            ),
                                            child: Radio(
                                              value: "Yearly",
                                              activeColor: Colors.white,
                                              groupValue: monthlyTemp,
                                              onChanged: (value) async {
                                                setState(() {
                                                  monthlyTemp =
                                                      value.toString();
                                                  isSelected = false;
                                                });
                                                await getPurchase();
                                              },
                                            ),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Center(
                                                  child: Text(
                                                label1,
                                                style: const TextStyle(
                                                    fontWeight: FontWeight.w600,
                                                    fontSize: 15,
                                                    color: Colors.white),
                                              )),
                                              const Center(
                                                  child: Text(
                                                'Pay for full Year',
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w400,
                                                    fontSize: 10,
                                                    color: Colors.white),
                                              )),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                      flex: 0,
                                      child: Text(price1,
                                          style: const TextStyle(
                                              fontWeight: FontWeight.w700,
                                              fontSize: 20,
                                              color: Colors.white)),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              InkWell(
                                onTap: () async {
                                  // var uri = Uri.parse("http://www.viprak.com/terms/");
                                  //
                                  // await launchUrl(
                                  //     uri
                                  // );
                                },
                                child: const Text(
                                  "Terms and Conditions",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: Colors.white),
                                ),
                              ),
                              SpUtil.getBool(SpConstUtil.isPurchase) == false
                                  ? InkWell(
                                      onTap: () async {
                                        // var uri = Uri.parse("http://www.viprak.com/privacy-policy-2/");
                                        //
                                        // await launchUrl(
                                        //     uri
                                        // );
                                      },
                                      child: const Text(
                                        "Privacy Policy",
                                        style: TextStyle(
                                            decoration:
                                                TextDecoration.underline,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600,
                                            color: Colors.white),
                                      ),
                                    )
                                  : Container()
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 25,
                        ),
                        InkWell(
                          onTap: () async {
                            await getPurchase();
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10)),
                            height: 50,
                            child: const Center(
                              child: Text(
                                'Purchase Now',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00adc2),
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        InkWell(
                          onTap: () async {
                            // await pl.show();

                            setState(() {
                              purchasePending = false;
                            });
                            await InAppPurchase.instance.restorePurchases();

                            Future.delayed(Duration(seconds: 20), () async {
                              // await pl.hide();
                              SpUtil.putBool(SpConstUtil.isPurchase, true);
                            });
                          },
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10)),
                            height: 50,
                            child: const Center(
                              child: Text(
                                'Restore Purchase',
                                style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15,
                        ),
                        Platform.isIOS
                            ? Column(
                                children: const [
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(
                                        left: 10.0, right: 10.0),
                                    child: Text(
                                      "If you choose to unlock the app’s content by purchasing the subscription, payment will be charged to your iTunes account, and your account will be charged for renewal within 24-hours prior to the end of the current period. Auto-renewal may be turned off at any time by going to your settings in the iTunes Store after purchase. The subscription price starts at '\$6.99 USD per month & '\$49.99 per year. Prices are in U.S. dollars, may vary in countries other than the U.S., and are subject to change without notice. No cancellation of the current subscription is allowed during the active subscription period.",
                                      style: TextStyle(
                                        color: Colors.white,
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 10.0,
                                  ),
                                ],
                              )
                            : Container()
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  late PurchaseParam purchaseParam;
  bool purchasePending = true;
  ProductDetails? productDetails;

  Future<void> getPurchase() async {
    print("object object");
    setState(() {
      purchasePending = false;
    });
    // if (isSelected) {
    if (isSelected) {
      productDetails = products[0];
    } else {
      productDetails = products[1];
    }

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
    await SpUtil.putBool(SpConstUtil.isPurchase, true);
  }

  GooglePlayPurchaseDetails? _getOldSubscription(
      ProductDetails productDetails, Map<String, PurchaseDetails> purchases) {
    GooglePlayPurchaseDetails? oldSubscription;
    return oldSubscription;
  }

// Future<void> _listenToPurchaseUpdated(
//     List<PurchaseDetails> purchaseDetailsList) async {
//   print("Here ");
//   for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
//     print(" purchaseDetails.status==>  ${purchaseDetails.status}");
//     // debugger();
//     if (purchaseDetails.status == PurchaseStatus.canceled) {
//       await pl.hide();
//       setState(() {
//         purchasePending = true;
//       });
//       if (purchaseDetails.pendingCompletePurchase) {
//         await _inAppPurchase.completePurchase(purchaseDetails);
//       }
//       return;
//     } else {
//       if (purchaseDetails.status == PurchaseStatus.pending) {
//         // if (purchaseDetails.pendingCompletePurchase) {
//         //   await _inAppPurchase.completePurchase(purchaseDetails);
//         // }
//         return;
//       } else {
//         if (purchaseDetails.status == PurchaseStatus.error) {
//           // handleError(purchaseDetails.error!);
//           if (purchaseDetails.error!.message ==
//               "BillingResponse.itemAlreadyOwned") {
//             //
//             final bool valid = await _verifyPurchase(purchaseDetails);
//             if (valid) {
//               await SpUtil.putBool(SpConstUtil.isPurchase, true);
//               // Future.delayed(const Duration(seconds: 1)).then((value) async {
//               //   await pl.hide();
//               //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//               //     builder: (context) {
//               //       return HomeScreen();
//               //     },
//               //   ), (route) => false);
//               // });
//
//               // deliverProduct(purchaseDetails);
//             } else {
//               setState(() {
//                 purchasePending = true;
//               });
//               // _handleInvalidPurchase(purchaseDetails);
//             }
//             return;
//           }
//           setState(() {
//             purchasePending = true;
//           });
//           await pl.hide();
//           return;
//         } else if (purchaseDetails.status == PurchaseStatus.purchased ||
//             purchaseDetails.status == PurchaseStatus.restored) {
//           final bool valid = await _verifyPurchase(purchaseDetails);
//           if (valid) {
//             await SpUtil.putBool(SpConstUtil.isPurchase, true);
//             // Future.delayed(const Duration(seconds: 1)).then((value) async {
//             //   Navigator.pushAndRemoveUntil(context, MaterialPageRoute(
//             //     builder: (context) {
//             //       return HomeScreen();
//             //     },
//             //   ), (route) => false);
//             // });
//
//             // deliverProduct(purchaseDetails);
//           } else {
//             setState(() {
//               purchasePending = true;
//             });
//             // _handleInvalidPurchase(purchaseDetails);
//           }
//           await pl.hide();
//           return;
//         } else {
//           setState(() {
//             purchasePending = true;
//           });
//           await pl.hide();
//           // all(purchaseDetails);
//           //return;
//         }
//       }
//
//       // if (Platform.isAndroid) {
//       //   //if (!_kAutoConsume && purchaseDetails.productID == _kConsumableId) {
//       //     final InAppPurchaseAndroidPlatformAddition androidAddition =
//       //     _inAppPurchase.getPlatformAddition<
//       //         InAppPurchaseAndroidPlatformAddition>();
//       //     await androidAddition.consumePurchase(purchaseDetails);
//       //   //}
//       // }
//       // if (purchaseDetails.pendingCompletePurchase) {
//       //   await _inAppPurchase.completePurchase(purchaseDetails);
//       // }
//     }
//   }
// }
//
//   Future<bool> _verifyPurchase(PurchaseDetails purchaseDetails) async {
//     if (Platform.isAndroid) {
//       print(purchaseDetails);
//       print(purchaseDetails.status);
//       print(purchaseDetails.pendingCompletePurchase);
//       print(purchaseDetails.verificationData);
//       print("here server verifications");
//       print(purchaseDetails.verificationData.serverVerificationData);
//       print(purchaseDetails.verificationData.localVerificationData);
//       await _inAppPurchase.completePurchase(purchaseDetails);
//     }
//     return Future<bool>.value(true);
//   }
}
