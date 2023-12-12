import 'package:eqms_test/style/color_guide.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class ServiceIntroduction extends StatefulWidget {
  const ServiceIntroduction({Key? key}) : super(key: key);

  @override
  ServiceIntroductionState createState() => ServiceIntroductionState();
}

class ServiceIntroductionState extends State<ServiceIntroduction> {
  final List<String> images = [
    'images/Intro1.png',
    'images/Intro2.png',
    'images/Intro3.png',
    'images/Intro4.png',
    'images/Intro5.png',
  ];
  int selectedIndex = 0;
  final CarouselController carouselController = CarouselController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0.0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('서비스 소개',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black)),
        backgroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Expanded(
            flex: 2,
            child: CarouselSlider(
              carouselController: carouselController,
              items: images
                  .map((item) => Image.asset(item, fit: BoxFit.fitWidth))
                  .toList(),
              options: CarouselOptions(
                enlargeCenterPage: true,
                height: double.infinity,
                aspectRatio: 16 / 9,
                viewportFraction: 1.2,
                autoPlay: true,
                onPageChanged: (index, reason) {
                  setState(() {
                    selectedIndex = index;
                  });
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: AnimatedSmoothIndicator(
              activeIndex: selectedIndex,
              count: images.length,
              effect: const WormEffect(
                activeDotColor: primaryOrange,
                dotColor: mediumGray,
                dotHeight: 10,
                dotWidth: 10,
              ),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(20),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(
                    child: Image(
                      image: AssetImage('images/초연결융합기술연구소로고세로.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  SizedBox(width: 20),
                  Expanded(
                    child: Image(
                      height: 100,
                      image: AssetImage('images/LOGO.png'),
                      fit: BoxFit.fitHeight,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
