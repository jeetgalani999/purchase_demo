import 'package:flutter/material.dart';
import 'package:purchase_demo/PurchaseScreen.dart';
import 'CommonWidget/shared_pref.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SpUtil.getInstance();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const PurchaseScreen(),
    );
  }
}
