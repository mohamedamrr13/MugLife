import 'package:drinks_app/core/utils/theme/theme_cubit.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ThemeToggleListTile extends StatelessWidget {
  final String? title;
  final String? subtitle;
  final Widget? leading;

  const ThemeToggleListTile({
    super.key,
    this.title,
    this.subtitle,
    this.leading,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();

        return ListTile(
          leading:
              leading ??
              Icon(themeCubit.getThemeIcon(), color: context.primaryTextColor),
          title: Text(
            title ?? 'Theme',
            style: context.textTheme.bodyLarge?.copyWith(
              color: context.primaryTextColor,
            ),
          ),

          trailing: Text(
            themeCubit.getThemeLabel(),
            style: context.textTheme.bodyMedium?.copyWith(
              color: context.secondaryTextColor,
            ),
          ),
          onTap: () => themeCubit.toggleTheme(),
        );
      },
    );
  }
}
