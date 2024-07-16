import 'package:carousel_slider/carousel_slider.dart';
import 'package:easy_dot_indicator/easy_dot_indicator.dart';
import 'package:flutter/material.dart';

class CarouselSliderExample extends StatefulWidget {
  const CarouselSliderExample({super.key});

  @override
  State<CarouselSliderExample> createState() => _CarouselSliderExampleState();
}

class _CarouselSliderExampleState extends State<CarouselSliderExample> {
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
            child: CarouselSlider(
              items: List.generate(
                10,
                (index) => Container(
                  alignment: Alignment.center,
                  color: Colors.grey,
                  child: Text(
                    'CarouselSlider:Item$index',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              options: CarouselOptions(
                viewportFraction: 1,
                onPageChanged: (index, _) {
                  indicatorController.updateIndex(index);
                },
              ),
            ),
          ),
          Positioned(
            bottom: 10,
            child: EasyDotIndicator(
                visibleNum: 5,
                count: 10,
                controller: indicatorController,
                dotConfig: const EasyDotIndicatorCustomConfig(
                  big: DotStyle(size: Size.square(14)),
                  middle: DotStyle(size: Size.square(10)),
                  small: DotStyle(size: Size.square(6)),
                  activeColor: Color(0xFF000000),
                  inactiveColor: Color(0xFF757575),
                )),
          ),
        ],
      ),
    );
  }
}
