import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomAuthTextfield extends StatelessWidget {
  final bool passwordField;
  final String hintText;
  const CustomAuthTextfield({
    super.key,
    this.passwordField = false,
    required this.hintText,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 18, top: 2, bottom: 2, right: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(14),
        color: AppColors.lightGreyColor2,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Expanded(
            child: TextFormField(
              style: AppTextstyles.textField,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: hintText,
                hintStyle: AppTextstyles.textFieldHint,
              ),
            ),
          ),
          passwordField
              ? Padding(
                padding: const EdgeInsets.only(left: 10),
                child: Icon(
                  size: 22,
                  Icons.remove_red_eye_outlined,
                  color: AppColors.lightGreyColor3,
                ),
              )
              : SizedBox(),
        ],
      ),
    );
  }
}
