import 'package:drinks_app/features/home/presentation/screens/widgets/home_screen_body.dart';
import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:drinks_app/utils/theme/theme_toggle_widget.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBgColor,
      drawer: Drawer(
        backgroundColor: Theme.of(context).scaffoldBgColor,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            spacing: 40,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 60),
              // Theme toggle in drawer
              const ThemeToggleListTile(title: 'Theme'),
              Divider(color: context.dividerColor),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(width: 17),

                  Icon(Icons.logout, size: 26, color: context.primaryTextColor),
                  const SizedBox(width: 12),
                  Text(
                    "Logout",
                    style: context.textTheme.titleMedium?.copyWith(
                      color: context.primaryTextColor,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        scrolledUnderElevation: 5,
        backgroundColor: context.backgroundColor,
        iconTheme: IconThemeData(color: context.primaryTextColor),
        centerTitle: true,
        title: Text(
          "M u g L i f e",
          style: context.textTheme.headlineSmall?.copyWith(
            color: context.primaryTextColor,
            fontWeight: FontWeight.w400,
          ),
        ),
        actions: [
          Icon(
            Icons.shopping_cart_checkout,
            color: context.primaryTextColor,
            size: 28,
          ),
          // const SizedBox(width: 8),
          // const ThemeToggleButton(size: 40),
          const SizedBox(width: 20),
        ],
      ),
      body: const HomeScreenBody(),
    );
  }
}
