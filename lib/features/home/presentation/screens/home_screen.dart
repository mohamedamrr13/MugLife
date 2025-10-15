import 'package:drinks_app/features/home/presentation/screens/widgets/custom_drawer.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/home_custom_appbar.dart';
import 'package:drinks_app/features/home/presentation/screens/widgets/home_screen_body.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.surfaceColor,
      extendBodyBehindAppBar: true,
      drawer: CustomDrawer(),
      appBar: CustomAppBar(),
      body: const HomeScreenBody(),
    );
  }
}

