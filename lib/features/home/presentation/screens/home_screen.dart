import 'package:drinks_app/features/home/presentation/screens/widgets/home_screen_body.dart';
import 'package:drinks_app/utils/colors/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgScaffoldColor,
      drawer: Drawer(
        backgroundColor: AppColors.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 40,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              SizedBox(height: 60),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(CupertinoIcons.profile_circled, size: 26),
                  SizedBox(width: 12),
                  Text("P r o f i l e", style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.arrow_outward_rounded, size: 26),
                  SizedBox(width: 12),
                  Text("O r d e r s", style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.settings, size: 26),
                  SizedBox(width: 12),
                  Text("S e t t i n g s", style: TextStyle(fontSize: 20)),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(Icons.logout, size: 26),
                  SizedBox(width: 12),
                  Text("L o g o u t", style: TextStyle(fontSize: 20)),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation: 5,
        backgroundColor: AppColors.bgScaffoldColor,

        centerTitle: true,
        title: Text(
          "M u g L i f e",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
        ),
        actions: [
          const Icon(
            Icons.shopping_cart_checkout,
            color: AppColors.black,
            size: 28,
          ),

          SizedBox(width: 20),
        ],
      ),
      body: HomeScreenBody(),
    );
  }
}
