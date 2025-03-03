import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomBlackButton extends StatefulWidget {
  final String buttonTitle;
  final void Function()? onTap;
  final bool isLoading;

  const CustomBlackButton({
    super.key,
    required this.buttonTitle,
    this.onTap,
    this.isLoading = false,
  });

  @override
  State<CustomBlackButton> createState() => _CustomBlackButtonState();
}

class _CustomBlackButtonState extends State<CustomBlackButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0, 
          duration: const Duration(milliseconds: 200), 
          curve: Curves.easeOutQuad, 
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              color: AppColors.blackColor,
              boxShadow:
                  _isHovered
                      ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.3),
                          blurRadius: 6, 
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child:
                  widget.isLoading
                      ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: AppColors.whiteColor,
                          strokeWidth: 3,
                        ),
                      )
                      : Text(
                        widget.buttonTitle,
                        style: AppTextstyles.authFieldHeadings.copyWith(
                          color: AppColors.whiteColor,
                        ),
                      ),
            ),
          ),
        ),
      ),
    );
  }
}
