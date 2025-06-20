import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String? hint;
  final bool enabled;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged; // Add onChanged parameter

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.hint,
    this.enabled = true,
    this.onTap,
    this.onChanged, // Include in constructor
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
        SizedBox(height: 8.h),
        TextField(
          controller: controller,
          enabled: enabled,
          onTap: onTap,
          onChanged: onChanged, // Pass onChanged to TextField
          decoration: InputDecoration(
            hintText: hint,
            filled: true,
            fillColor: Colors.grey[200],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
              borderSide: BorderSide.none,
            ),
            contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
          ),
          style: TextStyle(fontSize: 14.sp),
        ),
      ],
    );
  }
}



























// import 'package:flutter/material.dart';








// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
//
// class CustomTextField extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final String? hint;
//   final bool enabled;
//   final VoidCallback? onTap;
//
//   const CustomTextField({
//     super.key,
//     required this.controller,
//     required this.label,
//     this.hint,
//     this.enabled = true,
//     this.onTap,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(label, style: TextStyle(fontSize: 14.sp, color: Colors.grey[600])),
//         SizedBox(height: 8.h),
//         TextField(
//           controller: controller,
//           enabled: enabled,
//           onTap: onTap,
//           decoration: InputDecoration(
//             hintText: hint,
//             filled: true,
//             fillColor: Colors.grey[200],
//             border: OutlineInputBorder(
//               borderRadius: BorderRadius.circular(12.r),
//               borderSide: BorderSide.none,
//             ),
//             contentPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
//           ),
//           style: TextStyle(fontSize: 14.sp),
//         ),
//       ],
//     );
//   }
// }