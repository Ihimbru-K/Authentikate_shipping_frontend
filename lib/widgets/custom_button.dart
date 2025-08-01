import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final double? width;

  const CustomButton({
    super.key,
    required this.text,
    this.onPressed,
    this.backgroundColor = Colors.blue,
    this.textColor = Colors.white,
    this.borderColor = Colors.transparent,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width ?? double.infinity,
      height: 48.h, // Adjusted to match UI height
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: onPressed != null ? backgroundColor : Colors.grey,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.r), // Match UI radius
            side: BorderSide(color: borderColor, width: 1),
          ),
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 10.h),
        ),
        child: Text(
          text,
          style: TextStyle(
            color: textColor,
            fontSize: 16.sp, // Adjusted for UI text size
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}















// import 'package:flutter/material.dart';
// import 'package:flutter_screenutil/flutter_screenutil.dart';
//
// class CustomButton extends StatelessWidget {
//   final String text;
//   final VoidCallback onPressed;
//   final Color backgroundColor;
//   final Color textColor;
//   final Color borderColor;
//   final double? width;
//
//   const CustomButton({
//     Key? key,
//     required this.text,
//     required this.onPressed,
//     this.backgroundColor = Colors.blue,
//     this.textColor = Colors.white,
//     this.borderColor = Colors.transparent,
//     this.width,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width ?? double.infinity,
//       height: 40.h,
//       child: ElevatedButton(
//         onPressed: onPressed,
//         style: ElevatedButton.styleFrom(
//           backgroundColor: backgroundColor,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12),
//             side: BorderSide(color: borderColor, width: 1),
//           ),
//           padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.h),
//         ),
//         child: Text(
//           text,
//           style: TextStyle(
//             color: textColor,
//             fontSize: 14.sp,
//             fontWeight: FontWeight.w600,
//           ),
//         ),
//       ),
//     );
//   }
// }
