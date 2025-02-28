import 'package:flutter/material.dart';
import 'package:tasknexus/core/config/app_colors.dart';
import 'package:google_fonts/google_fonts.dart';

class ScreenLogin extends StatelessWidget {
  const ScreenLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.sizeOf(context).width;
    final screenHeight = MediaQuery.sizeOf(context).height;
    return Scaffold(
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                child: Image.asset(
                  'assets/images/login_background_image.png',
                  fit: BoxFit.cover,
                  width: double.infinity,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(
              vertical: 35,
              horizontal: screenWidth * 0.1,
            ),
            child: Container(
              height: double.infinity,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.whiteColor,
                borderRadius: BorderRadius.circular(35),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.asset(
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                            'assets/images/login_background_image_2.jpg',
                          ),
                        ),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Container(
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.blackColor.withValues(
                                alpha: 0.1,
                              ),
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 35,
                            horizontal: 30,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                'ALIGN. ACCOMPLISH. ASCEND.',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w500,
                                  letterSpacing: 2,
                                  fontSize: 10,
                                  color: AppColors.whiteColor,
                                ),
                              ),
                              Spacer(),
                              Text(
                                'Focus\nProductivity\nAchieve More',
                                style: GoogleFonts.playfairDisplay(
                                  fontWeight: FontWeight.w500,
                                  fontSize: 50,
                                  color: AppColors.whiteColor,
                                  height: 1.05,
                                  letterSpacing: 0,
                                ),
                              ),
                              SizedBox(height: 18),
                              Text(
                                "You can achieve great things by planning ahead and staying focused.\nStay organized, work smart, and keep moving forward.",
                                style: GoogleFonts.manrope(
                                  height: 1.65,
                                  fontWeight: FontWeight.w100,
                                  letterSpacing: 1,
                                  fontSize: 14,
                                  color: AppColors.lightGreyColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  //! FORM SECTION
                  Expanded(
                    child: SizedBox(
                      height: double.infinity,
                      width: double.infinity,
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: screenWidth * 0.04,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                'TASKNEXUS',
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 0.2,
                                  fontSize: 12,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.13),
                            Center(
                              child: Text(
                                'Welcome Back',
                                style: GoogleFonts.playfairDisplay(
                                  letterSpacing: 0,
                                  fontWeight: FontWeight.w500,
                                  fontSize: 50,
                                  color: AppColors.blackColor,
                                  height: 1.05,
                                ),
                              ),
                            ),
                            SizedBox(height: 8),
                            Center(
                              child: Text(
                                "Enter your email and password to access your account",
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  wordSpacing: 2,
                                  fontSize: 12.5,
                                  color: AppColors.blackColor,
                                ),
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.038),
                            //! EMAIL SECTION
                            Text(
                              "Email",
                              style: GoogleFonts.manrope(
                                fontWeight: FontWeight.w800,
                                letterSpacing: 0.2,
                                fontSize: 16,
                                color: AppColors.blackColor,
                              ),
                            ),
                            SizedBox(height: 10),
                            Container(
                              padding: EdgeInsets.only(left: 18),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(14),
                                color: const Color.fromARGB(255, 241, 241, 241),
                              ),
                              child: TextFormField(
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  letterSpacing: 0.2,
                                  fontSize: 16.5,
                                  color: AppColors.blackColor,
                                ),
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter your email',
                                  hintStyle: GoogleFonts.manrope(
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 0.2,
                                    fontSize: 15,
                                    color: AppColors.lightGreyColor3,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
