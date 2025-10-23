import 'package:flutter/material.dart';

class NabBarIcon extends StatelessWidget {
  const NabBarIcon({
    super.key,
    required this.iconData,
    required this.pageIndex,
    this.onPressed,
  });
  final IconData iconData;
  final int pageIndex;
  final void Function()? onPressed;
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TextButton(
        style: ButtonStyle(
          shape: WidgetStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadiusGeometry.circular(12),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Icon(iconData, size: 24),
      ),
    );
  }
}
