import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ShippingAppBar extends StatelessWidget {
  const ShippingAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      automaticallyImplyLeading: true,
      expandedHeight: 100,
      collapsedHeight: 130,
      floating: true,
      stretch: false,
      pinned: false,
      backgroundColor: Colors.transparent,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness:
            context.isDark ? Brightness.light : Brightness.dark,
      ),

      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.isDark
                  ? Colors.white.withOpacity(0.3)
                  : Colors.white.withOpacity(0.8),
              context.isDark
                  ? Colors.white.withOpacity(0.05)
                  : Colors.white.withOpacity(0.4),
            ],
          ),
          borderRadius: BorderRadius.circular(15),
          border: Border.all(
            color:
                context.isDark
                    ? Colors.white.withOpacity(0.2)
                    : Colors.white.withOpacity(0.6),
            width: 1.5,
          ),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back_ios_new_rounded,
              color: context.primaryTextColor,
              size: 20,
            ),
            onPressed: () => Navigator.pop(context),
          ),
        ),
      ),

      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.isDark
                  ? Colors.black.withOpacity(0.5)
                  : Colors.white.withOpacity(0.9),
              context.isDark
                  ? Colors.black.withOpacity(0.7)
                  : Colors.white.withOpacity(0.5),
              Colors.transparent,
            ],
            stops: const [0.0, 0.7, 1.0],
          ),
        ),
        child: ClipRRect(
          child: Container(
            decoration: BoxDecoration(
              color:
                  context.isDark
                      ? Colors.white.withOpacity(0.05)
                      : Colors.white.withOpacity(0.3),
              border: Border(
                bottom: BorderSide(
                  color:
                      context.isDark
                          ? Colors.white.withOpacity(0.1)
                          : context.primaryColor.withOpacity(0.15),
                  width: 0.5,
                ),
              ),
            ),
            child: FlexibleSpaceBar(
              expandedTitleScale: 1,
              titlePadding: EdgeInsets.only(left: 60, bottom: 32),
              title: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Shipping Details',
                    style: context.textTheme.titleLarge?.copyWith(
                      fontSize: 36,
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Enter your delivery information',
                    style: context.textTheme.bodySmall?.copyWith(
                      color: context.secondaryTextColor,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
