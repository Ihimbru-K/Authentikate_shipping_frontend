import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../utils/constants.dart';

class DashboardCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final double height = MediaQuery.of(context).size.height;
    final double width = MediaQuery.of(context).size.width;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150.h,
        width: 150.0.w,
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Constants.backgroundColor,
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: Colors.grey[300]!, width: 1.0),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 2,
              blurRadius: 5,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 30.0.r, color: Colors.blueAccent),
            SizedBox(height: 8.0.h),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
            ),
          ],
        ),
      ),
    );
  }
}














// import 'package:flutter/material.dart';
// import '../utils/constants.dart';
//
// class DashboardCard extends StatelessWidget {
//   final IconData icon;
//   final String title;
//   final VoidCallback onTap;
//
//   const DashboardCard({
//     super.key,
//     required this.icon,
//     required this.title,
//     required this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: 150.0,
//         height: 150.0,
//         padding: const EdgeInsets.all(12.0),
//         decoration: BoxDecoration(
//           color: Constants.backgroundColor,
//           borderRadius: BorderRadius.circular(12.0),
//           border: Border.all(color: Colors.grey[300]!, width: 1.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.grey.withOpacity(0.2),
//               spreadRadius: 2,
//               blurRadius: 5,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(icon, size: 30.0, color: Colors.black),
//             const SizedBox(height: 8.0),
//             Text(
//               title,
//               textAlign: TextAlign.center,
//               style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.w500),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }