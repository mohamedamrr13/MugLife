import 'package:drinks_app/features/cart/presentation/cart_screen.dart';
import 'package:drinks_app/features/home/presentation/screens/home_screen.dart';
import 'package:drinks_app/features/settings/presentation.dart';
import 'package:flutter/material.dart';

class CustomPageNavigationBar extends StatefulWidget {
  const CustomPageNavigationBar({super.key});

  @override
  State<CustomPageNavigationBar> createState() =>
      _CustomPageNavigationBarState();
}

class _CustomPageNavigationBarState extends State<CustomPageNavigationBar> {
  int currentIndex = 0; //

  final List<Widget> pages = [
    HomeScreen(),

    AccountScreen(),
    CartScreen(),

    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return Scaffold(
      body: pages[currentIndex],
      bottomNavigationBar: Container(
        height: 70,
        decoration: BoxDecoration(color: colorScheme.primary.withAlpha(100)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(width: 5),
            _buildNavIcon(
              currentIndex == 0 ? Icons.home : Icons.home_outlined,
              0,
            ),
            _buildNavIcon(
              currentIndex == 1 ? Icons.person : Icons.person_outline,
              1,
            ),
            _buildNavIcon(
              currentIndex == 2
                  ? Icons.shopping_bag
                  : Icons.shopping_bag_outlined,
              2,
            ),
            _buildNavIcon(
              currentIndex == 3 ? Icons.settings : Icons.settings_outlined,
              3,
            ),
            SizedBox(width: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(IconData iconData, int pageIndex) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
          ),
        ),
        onPressed: () {
          setState(() {
            currentIndex = pageIndex;
          });
        },
        child: Icon(iconData, size: 24),
      ),
    );
  }
}

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        automaticallyImplyLeading: false,
      ),
      body: const Center(child: Text('Account Screen')),
    );
  }
}
