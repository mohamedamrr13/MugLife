import 'package:drinks_app/core/utils/theme/theme_cubit.dart';
import 'package:drinks_app/core/utils/theme/theme_extensions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
