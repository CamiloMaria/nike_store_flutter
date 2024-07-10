import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:nike_store/models/cart.dart';
import 'package:nike_store/pages/intro_page.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  Platform.isAndroid
      ? await Firebase.initializeApp(
          options: const FirebaseOptions(
          apiKey: "AIzaSyAlrP0T6c9JjJc-CMLzfz1_ZpWu37sZj94",
          appId: "1:1005142002439:android:b3c9120bbe95ed5d2953a2",
          messagingSenderId: "1005142002439",
          projectId: "nike-store-b323e",
          storageBucket: "gs://nike-store-b323e.appspot.com",
        ))
      : await Firebase.initializeApp();

  runApp(ChangeNotifierProvider<Cart>(
      create: (context) => Cart(), child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: IntroPage(),
    );
  }
}
