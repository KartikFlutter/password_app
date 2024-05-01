import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextFormField extends StatelessWidget {
  TextInputType? keyboardType;
  TextEditingController controller;
  Widget? suffixIcon;
  Widget? prefixIcon;
  bool? obscureText;
  String? hintText;
  int? maxLength;
  String? Function(String?)? validator;
  Function(String)? onChanged;
  CustomTextFormField(
      {Key? key,
      this.keyboardType,
      required this.controller,
      this.prefixIcon,
      this.validator,
      this.hintText,
      this.obscureText,
      this.onChanged,
      this.maxLength,
      this.suffixIcon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: obscureText ?? false,
      validator: validator,
      keyboardType: keyboardType,
      controller: controller,
      maxLength: maxLength,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        hintText: hintText,
        counterText: "",
        suffixIcon: suffixIcon,
        hintStyle: TextStyle(
            color: Colors.black12,
            fontWeight: FontWeight.w400,
            fontSize: 14.sp),
        contentPadding: EdgeInsets.symmetric(horizontal: 10.w),
        fillColor: Colors.grey.shade200,
        filled: true,
        border: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.white,
          ),
          borderRadius: BorderRadius.circular(10.r),
        ),
      ),
      onChanged: onChanged,
    );
  }
}
