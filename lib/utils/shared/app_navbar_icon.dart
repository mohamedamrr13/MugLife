// import 'package:drinks_app/utils/theme/theme_extensions.dart';
// import 'package:flutter/material.dart';

// class NabBarIcon extends StatelessWidget {
//   const NabBarIcon({
//     super.key,
//     required this.iconData,
//     required this.pageIndex,
//     required this.isSelected,
//     this.onPressed,
//   });

//   final IconData iconData;
//   final int pageIndex;
//   final bool isSelected;
//   final void Function()? onPressed;

//   @override
//   Widget build(BuildContext context) {
//     return Expanded(
//       child: InkWell(
//         onTap: onPressed,
//         borderRadius: BorderRadius.circular(16),
//         splashColor: context.primaryColor.withOpacity(0.1),
//         highlightColor: context.primaryColor.withOpacity(0.05),
//         child: Container(
//           padding: const EdgeInsets.symmetric(vertical: 12),
//           child: Column(
//             mainAxisSize: MainAxisSize.min,
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeInOut,
//                 padding: const EdgeInsets.all(8),
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: isSelected
//                       ? context.primaryColor.withOpacity(0.12)
//                       : Colors.transparent,
//                 ),
//                 child: Icon(
//                   iconData,
//                   size: 26,
//                   color: isSelected
//                       ? context.primaryColor
//                       : context.secondaryTextColor.withOpacity(0.6),
//                 ),
//               ),
//               const SizedBox(height: 2),
//               AnimatedContainer(
//                 duration: const Duration(milliseconds: 200),
//                 curve: Curves.easeInOut,
//                 width: isSelected ? 4 : 0,
//                 height: 4,
//                 decoration: BoxDecoration(
//                   shape: BoxShape.circle,
//                   color: context.primaryColor,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
