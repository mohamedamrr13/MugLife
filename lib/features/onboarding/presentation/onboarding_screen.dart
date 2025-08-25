import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/utils/theme/app_theme.dart';
import 'package:flutter/material.dart';

class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.bgScaffoldColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Row(
                children: [
                  SizedBox(width: 24),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 80),
                      Text(
                        "Time for a",
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        "Drink",
                        textAlign: TextAlign.start,
                        style: TextStyle(
                          fontSize: 34,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffF66372),
                          fontFamily: 'Pacifico',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Spacer(),
              Image.asset("assets/images/treeImg.png", height: 190),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 20),
            child: Text(
              "The one-stop to find amazing drink mixes and food for any occassion.",
              style: TextStyle(color: Color(0xff010101), fontSize: 17),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SizedBox(
              width: 170,
              height: 70,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xff1E2742),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) {
                        return HomeScreen();
                      },
                    ),
                  );
                },
                child: Center(
                  child: Row(
                    children: [
                      Text(
                        "Get Started",
                        style: TextStyle(color: Colors.white, fontSize: 17),
                      ),
                      SizedBox(width: 6),
                      Icon(
                        Icons.arrow_forward_ios_rounded,
                        color: AppTheme.white,
                        size: 15,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Stack(
                children: [
                  Image.asset(
                    "assets/images/splashDrink.png",
                    width: 500,

                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    left: 0,
                    right: 0,
                    bottom: 10,
                    child: Image.asset(
                      "assets/images/drinkOnboarding.png",
                      width: 600,
                      height: 600,
                      fit: BoxFit.contain,
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
