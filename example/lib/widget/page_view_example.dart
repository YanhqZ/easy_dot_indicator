import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:flutter/material.dart';

class PageViewExample extends StatefulWidget {
  const PageViewExample({super.key});

  @override
  State<PageViewExample> createState() => _PageViewExampleState();
}

class _PageViewExampleState extends State<PageViewExample> {
  EasyDotIndicatorController indicatorController = EasyDotIndicatorController();

  @override
  Widget build(BuildContext context) {
    return SizedBox(
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
                  'PageView:Item$index',
                  style: const TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
              itemCount: 10,
              onPageChanged: (index) {
                indicatorController.updateIndex(index);
              },
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
    );
  }
}
