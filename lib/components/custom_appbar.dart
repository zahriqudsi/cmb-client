// import 'package:flutter/material.dart';

// class CustomAppBar extends StatelessWidget {
//   final IconData leftIcon;
//   final IconData rightIcon;
//   final String title;
//   const CustomAppBar({
//     Key? key,
//     required this.leftIcon,
//     required this.rightIcon,
//     required this.title,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       padding: const EdgeInsets.only(
//         top: 40,
//         left: 25,
//         right: 25,
//       ),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           GestureDetector(
//             onTap: () {},
//             child: _buildleftIcon(leftIcon),
//           ),
//           _buildTitle(title),
//           GestureDetector(
//             onTap: () {
//               // print("Hello");
//             },
//             child: _buildrightIcon(rightIcon),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildrightIcon(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//       decoration: const BoxDecoration(
//         shape: BoxShape.circle,
//         color: Colors.orange,
//       ),
//       child: Icon(icon),
//     );
//   }

//   Widget _buildleftIcon(IconData icon) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//       // decoration: const BoxDecoration(
//       //   shape: BoxShape.circle,
//       //   color: Colors.blue,
//       // ),
//       child: Icon(
//         icon,
//         size: 35,
//       ),
//     );
//   }

//   Widget _buildTitle(String title) {
//     return Container(
//       padding: const EdgeInsets.fromLTRB(8, 8, 8, 8),
//       // decoration: BoxDecoration(
//       //   shape: BoxShape.circle,
//       //   color: Colors.blue,
//       // ),
//       child: Text(
//         title,
//         style: const TextStyle(
//           fontSize: 25,
//           fontWeight: FontWeight.w500,
//           color: Colors.white,
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';

class CustomAppbar extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
        size.width / 2, size.height, size.width, size.height - 80);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}
