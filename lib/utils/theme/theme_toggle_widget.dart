import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'theme_cubit.dart';
import 'theme_extensions.dart';

class ThemeToggleWidget extends StatelessWidget {
  final bool showLabel;
  final EdgeInsetsGeometry? padding;
  final double? iconSize;

  const ThemeToggleWidget({
    super.key,
    this.showLabel = true,
    this.padding,
    this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();

        return InkWell(
          onTap: () => themeCubit.toggleTheme(),
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding:
                padding ??
                const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  themeCubit.getThemeIcon(),
                  color: context.primaryTextColor,
                  size: iconSize ?? 24,
                ),
                if (showLabel) ...[
                  const SizedBox(width: 12),
                  Text(
                    themeCubit.getThemeLabel(),
                    style: context.textTheme.bodyMedium?.copyWith(
                      color: context.primaryTextColor,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

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

class ThemeSegmentedControl extends StatelessWidget {
  const ThemeSegmentedControl({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeCubit, ThemeState>(
      builder: (context, state) {
        final themeCubit = context.read<ThemeCubit>();

        return Container(
          decoration: BoxDecoration(
            color: context.surfaceColor,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: context.dividerColor, width: 1),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildSegment(
                context,
                ThemeState.light,
                Icons.light_mode,
                'Light',
                state == ThemeState.light,
                () => themeCubit.emit(ThemeState.light),
              ),
              _buildSegment(
                context,
                ThemeState.dark,
                Icons.dark_mode,
                'Dark',
                state == ThemeState.dark,
                () => themeCubit.emit(ThemeState.dark),
              ),
              _buildSegment(
                context,
                ThemeState.system,
                Icons.brightness_auto,
                'Auto',
                state == ThemeState.system,
                () => themeCubit.emit(ThemeState.system),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildSegment(
    BuildContext context,
    ThemeState themeState,
    IconData icon,
    String label,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected ? context.primaryColor.withOpacity(0.1) : null,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color:
                    isSelected
                        ? context.primaryColor
                        : context.secondaryTextColor,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: context.textTheme.bodySmall?.copyWith(
                  color:
                      isSelected
                          ? context.primaryColor
                          : context.secondaryTextColor,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
