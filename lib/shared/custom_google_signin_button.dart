import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:tasknexus/core/config/app_textstyles.dart';

class CustomGoogleSigninButton extends StatefulWidget {
  final void Function()? onTap;

  const CustomGoogleSigninButton({super.key, this.onTap});

  @override
  State<CustomGoogleSigninButton> createState() =>
      _CustomGoogleSigninButtonState();
}

class _CustomGoogleSigninButtonState extends State<CustomGoogleSigninButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedScale(
          scale: _isHovered ? 1.05 : 1.0, // Slight pop-up effect
          duration: const Duration(milliseconds: 200), // Smooth animation
          curve: Curves.easeOutQuad, // Gentle transition
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
                          ), // Subtle shadow
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
                    'assets/icons/google_logo_nobg.png',
                    fit: BoxFit.contain,
                    width: 22,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Sign In With Google',
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
