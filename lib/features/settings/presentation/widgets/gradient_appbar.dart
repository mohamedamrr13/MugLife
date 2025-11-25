import 'package:drinks_app/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class GradientAppBar extends StatelessWidget {
  final String title;
  final double expandedHeight;
  final Widget? flexibleSpaceContent;

  const GradientAppBar({
    super.key,
    required this.title,
    this.expandedHeight = 80,
    this.flexibleSpaceContent,
  });

  @override
  Widget build(BuildContext context) {
    return SliverAppBar(
      expandedHeight: expandedHeight,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              context.primaryColor,
              context.primaryColor.withOpacity(0.8),
            ],
          ),
        ),
        child:
            flexibleSpaceContent ??
            FlexibleSpaceBar(
              centerTitle: true,
              title: Text(
                title,
                style: context.textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
      ),
    );
  }
}
