import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:flutter/material.dart';

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
  final PageController _pageController = PageController();
  EasyDotIndicatorController indicatorController = EasyDotIndicatorController();

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      indicatorController.updateIndex(_pageController.page!.toInt());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('EasyDotIndicator Demo'),
      ),
      body: Center(
        child: SizedBox(
          width: 300,
          height: 200,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Positioned.fill(
                child: PageView.builder(
                  itemBuilder: (_, index) => Container(
                    alignment: Alignment.center,
                    color: index.isEven ? Colors.blue : Colors.red,
                    child: Text(
                      'Page $index',
                      style: const TextStyle(fontSize: 32, color: Colors.white),
                    ),
                  ),
                  controller: _pageController,
                  itemCount: 10,
                ),
              ),
              Positioned(
                bottom: 10,
                child: EasyDotIndicator(
                  visibleNum: 5,
                  count: 10,
                  controller: indicatorController,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          _pageController.nextPage(
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        },
        tooltip: 'Next',
        child: const Icon(Icons.navigate_next_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
