import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomWhiteButton extends StatefulWidget {
  final String buttonTitle;
  final void Function()? onTap;

  const CustomWhiteButton({super.key, this.onTap, required this.buttonTitle});

  @override
  State<CustomWhiteButton> createState() => _CustomWhiteButtonState();
}

class _CustomWhiteButtonState extends State<CustomWhiteButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0, // Subtle lift-up effect
          duration: const Duration(milliseconds: 200), // Smooth animation
          curve: Curves.easeOutQuad, // Natural ease-out transition
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 15),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.lightGreyColor4),
              color: AppColors.whiteColor,
              boxShadow:
                  _isHovered
                      ? [
                        BoxShadow(
                          color: Colors.black.withValues(
                            alpha: 0.1,
                          ), // Light shadow
                          blurRadius: 6,
                          spreadRadius: 1,
                          offset: const Offset(0, 3),
                        ),
                      ]
                      : [],
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/icons/back_icon_black.png',
                    fit: BoxFit.contain,
                    width: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.buttonTitle,
                    style: AppTextstyles.authFieldHeadings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
