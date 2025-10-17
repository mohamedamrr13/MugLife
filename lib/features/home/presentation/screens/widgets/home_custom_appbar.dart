import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:liquid_glass_renderer/liquid_glass_renderer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
        statusBarBrightness:
            context.isDark ? Brightness.dark : Brightness.light,
      ),
      elevation: 0,
      scrolledUnderElevation: 0,
      backgroundColor: Colors.transparent,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primaryColor.withOpacity(0.1),
              context.surfaceColor.withOpacity(0.95),
            ],
          ),
        ),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color: context.surfaceColor.withOpacity(0.8),
              border: Border(
                bottom: BorderSide(
                  color: context.primaryColor.withOpacity(0.2),
                  width: 0.5,
                ),
              ),
            ),
          ),
        ),
      ),
      leading: Builder(
        builder:
            (context) => IconButton(
              icon: Icon(
                Icons.menu_rounded,
                color: context.primaryTextColor,
                size: 24,
              ),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
      ),
      centerTitle: true,
      title: Text(
        "MugLife",
        style: context.textTheme.headlineSmall?.copyWith(
          color: context.primaryTextColor,
          fontWeight: FontWeight.w600,
          letterSpacing: 5,
        ),
      ),
    );
  }
}
