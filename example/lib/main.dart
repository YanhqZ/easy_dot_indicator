import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:example/widget/custom_dot_example.dart';
import 'package:flutter/material.dart';

import 'widget/carousel_slider_example.dart';
import 'widget/page_view_example.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const DemoPage(),
    );
  }
}

class DemoPage extends StatefulWidget {
  const DemoPage({super.key});

  @override
  State<DemoPage> createState() => _DemoPageState();
}

class _DemoPageState extends State<DemoPage> {
  EasyDotIndicatorController indicatorController = EasyDotIndicatorController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EasyDotIndicator Demo'),
      ),
      body: const SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: PageViewExample(),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CarouselSliderExample(),
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.center,
              child: CustomDotExample(),
            ),
          ],
        ),
      ),
    );
  }
}
