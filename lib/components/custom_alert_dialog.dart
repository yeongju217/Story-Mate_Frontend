import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:storymate/components/theme.dart';

class CustomAlertDialog extends StatelessWidget {
  final String question;

  const CustomAlertDialog({
    super.key,
    required this.question,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: AppTheme.backgroundColor,
      title: Text(
        question,
        style: TextStyle(
          color: Colors.black,
          fontSize: 20.sp,
          fontFamily: 'Jua',
          fontWeight: FontWeight.w400,
          height: 1.40.h,
          letterSpacing: -0.23.w,
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(
            '아니오',
            style: TextStyle(
              color: Colors.grey,
              fontSize: 17.sp,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 1.40.h,
              letterSpacing: -0.23.w,
            ),
          ),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(
            '예',
            style: TextStyle(
              color: AppTheme.primaryColor,
              fontSize: 17.sp,
              fontFamily: 'Jua',
              fontWeight: FontWeight.w400,
              height: 1.40.h,
              letterSpacing: -0.23.w,
            ),
          ),
        ),
      ],
    );
  }
}
