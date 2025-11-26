import 'package:drinks_app/core/utils/theme/theme_cubit.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleButton extends StatelessWidget {
  final double? size;
  final Color? backgroundColor;
  final Color? iconColor;

  const ThemeToggleButton({
    super.key,
    this.size,
    this.backgroundColor,
    this.iconColor,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();

        return Container(
          width: size ?? 48,
          height: size ?? 48,
          decoration: BoxDecoration(
            color: backgroundColor ?? context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.dividerColor, width: 1),
          ),
          child: IconButton(
            onPressed: () => themeCubit.toggleTheme(),
            icon: Icon(
              themeCubit.getThemeIcon(),
              color: iconColor ?? context.primaryTextColor,
            ),
            tooltip: themeCubit.getThemeLabel(),
          ),
        );
      },
    );
  }
}
