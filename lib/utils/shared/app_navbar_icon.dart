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
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(16)),
            ),
          ),
        ),
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Icon(iconData, size: 24),
        ),
      ),
    );
  }
}
