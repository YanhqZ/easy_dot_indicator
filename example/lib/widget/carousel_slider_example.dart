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
                  color: Theme.of(context).colorScheme.secondaryContainer,
                  child: Text(
                    'CarouselSlider:Item$index',
                    style: TextStyle(
                      fontSize: 24,
                      color: Theme.of(context).colorScheme.onSecondaryContainer,
                    ),
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
                dotConfig: EasyDotIndicatorCustomConfig(
                  big: const DotStyle(size: Size.square(14)),
                  middle: const DotStyle(size: Size.square(10)),
                  small: const DotStyle(size: Size.square(6)),
                  activeColor: Theme.of(context).colorScheme.onSecondaryContainer,
                  inactiveColor: Theme.of(context).colorScheme.onSecondaryContainer.withOpacity(0.4),
                )),
          ),
        ],
      ),
    );
  }
}
