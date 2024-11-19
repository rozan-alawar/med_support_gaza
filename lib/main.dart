import 'package:flutter/material.dart';
import 'package:med_support_gaza/app/routes/app_pages.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Med Support Gaza',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
        initialRoute: AppPages.INITIAL,
      // getPages: AppPages.routes,
     
      home: Scaffold(),
    );
  }
}
