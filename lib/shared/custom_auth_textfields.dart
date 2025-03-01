import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomAuthTextfield extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final bool isPasswordVisible;
  final VoidCallback? toggleVisibility;
  final bool obscureText;
  final String? Function(String?)? validator;

  const CustomAuthTextfield({
    super.key,
    required this.hintText,
    this.controller,
    this.isPasswordVisible = false,
    this.toggleVisibility,
    this.obscureText = false,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, top: 2, bottom: 2, right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.lightGreyColor2,
      ),
      child: TextFormField(
        maxLength: 30,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: validator,
        obscureText: obscureText,
        controller: controller,
        style: AppTextstyles.textField,
        decoration: InputDecoration(
          counterText: '',
          border: InputBorder.none,
          hintText: hintText,
          hintStyle: AppTextstyles.textFieldHint,
          suffixIcon:
              toggleVisibility != null
                  ? GestureDetector(
                    onTap: toggleVisibility,
                    child: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off_sharp
                          : Icons.visibility,
                      color: AppColors.lightGreyColor3,
                    ),
                  )
                  : null,
        ),
      ),
    );
  }
}
