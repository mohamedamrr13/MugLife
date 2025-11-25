import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';

class CustomAuthAppbar extends StatelessWidget {
  final String? title;
  final TextStyle? titleStyle;
  final double topPadding;
  final bool showBackButton;
  final VoidCallback? onBackPressed;
  final List<Widget>? actions;

  const CustomAuthAppbar({
    super.key,
    this.title,
    this.titleStyle,
    this.topPadding = 80,
    this.showBackButton = false,
    this.onBackPressed,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Theme.of(context).surfaceColor,
      child: Column(
        children: [
          SizedBox(height: topPadding),
          if (showBackButton || actions != null)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  if (showBackButton)
                    IconButton(
                      onPressed:
                          onBackPressed ?? () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: context.primaryTextColor,
                        size: 24,
                      ),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    )
                  else
                    const SizedBox(width: 48),

                  const Spacer(),

                  if (actions != null)
                    ...actions!
                  else
                    const SizedBox(width: 48),
                ],
              ),
            ),

          if (showBackButton || actions != null) const SizedBox(height: 20),

          Text(
            title ?? "M u g L i f e",
            style:
                titleStyle ??
                context.textTheme.headlineMedium?.copyWith(
                  fontSize: 30,
                  fontWeight: FontWeight.w400,
                  color: context.primaryTextColor,
                  letterSpacing: title != null ? 0 : 4.0,
                ),
          ),

          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
