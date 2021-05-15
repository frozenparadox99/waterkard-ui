import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:waterkard/ui/pages/choose_user_type_page.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({Key key}) : super(key: key);

  @override
  _OnboardingPageState createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  var pages = [
    PageViewModel(
        title: "Add Your Stock Jar",
        body:
        "Through this app you can manage your inventory with ease",
        image: Center(
          child: Image.asset("assets/waterkard.png", height: 175.0),
        ),
        footer: Image.asset(
          'assets/onboarding-image-3.jpg',
          height: 100.0,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          pageColor: Color(0xFFFFFFFF),
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
          imagePadding: EdgeInsets.zero,
        )),
    PageViewModel(
        title: "Title of the second page",
        body:
        "Here you can write the description of the page, to explain someting...",
        image: Center(
          child: Image.asset("assets/onboarding-image-2.jpg", height: 175.0),
        ),
        footer: Image.asset(
          'assets/waterkard.png',
          height: 100.0,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          pageColor: Color(0xFFFFFFFF),
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
          imagePadding: EdgeInsets.zero,
        )),
    PageViewModel(
        title: "Title of the third page",
        body:
        "Here you can write the description of the page, to explain someting...",
        image: Center(
          child: Image.asset("assets/onboarding-image-4.png", height: 175.0),
        ),
        footer: Image.asset(
          'assets/waterkard.png',
          height: 100.0,
          fit: BoxFit.cover,
        ),
        decoration: PageDecoration(
          pageColor: Color(0xFFFFFFFF),
          bodyTextStyle: TextStyle(color: Colors.black, fontSize: 16),
          titleTextStyle: TextStyle(color: Colors.black, fontSize: 24),
          imagePadding: EdgeInsets.zero,
        )),
  ];
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      body: IntroductionScreen(

        pages: pages,
        onDone: () {
          // When done button is press
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChooseUserTypePage()));
        },
        onSkip: () {
          // You can also override onSkip callback
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChooseUserTypePage()));
        },
        showSkipButton: true,
        skip: const Text('Skip',style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        next: Icon(
          Icons.arrow_right,
          color: Colors.black,
          size: 30.0,
        ),
        done: Text("Done",
            style: TextStyle(fontWeight: FontWeight.w600, color: Colors.black)),
        dotsDecorator: DotsDecorator(
            size: Size.square(10.0),
            activeSize: Size(20.0, 10.0),
            activeColor: Colors.deepOrange,
            color: Colors.black26,
            spacing: EdgeInsets.symmetric(horizontal: 3.0),
            activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0))),
      ),
    );
  }
}
