import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:wander_stay/view/login_screen.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

import '../utils/colors/app_colors.dart';
import '../utils/widgets/image_network.dart';
import '../utils/widgets/info_card.dart';

class AccountScreen extends StatelessWidget {
  const AccountScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the screen size.
    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by notches or system UI.
        child: SingleChildScrollView( // Allows the content to scroll if it overflows.
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center, // Centers content vertically.
              crossAxisAlignment: CrossAxisAlignment.center, // Centers content horizontally.
              children: [
                // Animated text using TextLiquidFill.
                TextLiquidFill(
                  text: 'Welcome',
                  waveColor: AppColors.redAccentColor, // Color of the wave.
                  textAlign: TextAlign.center, // Text alignment.
                  loadDuration: const Duration(seconds: 3), // Duration for loading animation.
                  waveDuration: const Duration(seconds: 3), // Duration for wave animation.
                  boxBackgroundColor: AppColors.whiteColor, // Background color of the text box.
                  loadUntil: 0.8, // Percentage until the text is fully filled.
                  textStyle: GoogleFonts.alkatra( // Text style using Google Fonts.
                    fontSize: 60.0,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 60.0, // Height of the text box.
                  boxWidth: size.width * 0.65, // Width of the text box.
                ),
                // Similar TextLiquidFill widgets for "To" and "WanderStay".
                TextLiquidFill(
                  text: 'To',
                  waveColor: AppColors.redAccentColor,
                  textAlign: TextAlign.center,
                  loadDuration: const Duration(seconds: 3),
                  waveDuration: const Duration(seconds: 3),
                  boxBackgroundColor: AppColors.whiteColor,
                  loadUntil: 0.8,
                  textStyle: GoogleFonts.alkatra(
                    fontSize: 40.0,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 40.0,
                  boxWidth: 60.0,
                ),
                TextLiquidFill(
                  text: 'WanderStay',
                  waveColor: AppColors.redAccentColor,
                  textAlign: TextAlign.center,
                  loadDuration: const Duration(seconds: 3),
                  waveDuration: const Duration(seconds: 3),
                  boxBackgroundColor: AppColors.whiteColor,
                  loadUntil: 0.8,
                  textStyle: GoogleFonts.alkatra(
                    fontSize: 60.0,
                    height: 1.0,
                    fontWeight: FontWeight.bold,
                  ),
                  boxHeight: 65.0,
                  boxWidth: size.width * 0.9,
                ),
                SizedBox(
                  height: size.height * 0.015, // Spacing.
                ),
                // Card with information about WanderStay.
                Transform( // Skews the card.
                  alignment: FractionalOffset.center,
                  transform: Matrix4.skewX(-0.2),
                  child: Card(
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24).copyWith(
                          topLeft: Radius.zero, // Makes top-left corner square.
                          bottomRight: Radius.zero, // Makes bottom-right corner square.
                        ),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.whiteColor)),
                    shadowColor: AppColors.blackColor,
                    elevation: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        mainAxisSize: MainAxisSize.max, // Occupy maximum width.
                        children: [
                          Expanded( // Expands the column to fill available space.
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    "WanderStay your place",
                                    style:
                                    Theme.of(context).textTheme.titleMedium, // Text style.
                                  ),
                                  Text(
                                    "It's simple to get set up and start earning.",
                                    style:
                                    Theme.of(context).textTheme.bodyMedium, // Text style.
                                  )
                                ]),
                          ),
                          // Image on the right side of the card.
                          ClipRRect( // Clips the image to the rounded corners.
                              borderRadius: BorderRadius.circular(24).copyWith(
                                topLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              child: const SizedBox(
                                width: 140,
                                height: 100,
                                child: ImageNetwork(null, // Placeholder for the image.
                                    src:
                                    "https://static.vecteezy.com/system/resources/previews/034/950/530/non_2x/ai-generated-small-house-with-flowers-on-transparent-background-image-png.png",
                                    errorIcon: Icon( // Icon to display if image loading fails.
                                        Icons.image_not_supported_rounded)),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: size.height * 0.015,
                ),
                // Button to navigate to the LoginScreen.
                SizedBox(
                    width: size.width,
                    child: ElevatedButton(
                        onPressed: () {
                          // Navigation to LoginScreen with custom transition.
                          Navigator.push(
                            context,
                            PageRouteBuilder(
                              pageBuilder:
                                  (context, animation, secondaryAnimation) =>
                              const LoginScreen(), // The screen to navigate to.
                              transitionDuration:
                              const Duration(milliseconds: 600), // Transition duration.
                              reverseTransitionDuration:
                              const Duration(milliseconds: 600), // Reverse transition duration.
                              transitionsBuilder: (context, animation,
                                  secondaryAnimation, child) {
                                // Custom slide transition.
                                const begin = Offset(1.0, 0.0); // Start position off-screen to the right.
                                const end = Offset.zero; // End position on-screen.
                                const curve = Curves.easeInOut; // Transition curve.

                                var tween = Tween(begin: begin, end: end)
                                    .chain(CurveTween(curve: curve));

                                return SlideTransition( // Slide transition widget.
                                  position: animation.drive(tween), // Animate the position.
                                  child: child, // The child widget (LoginScreen).
                                );
                              },
                            ),
                          );
                        },
                        child: const Text("Continue"))),
                SizedBox(height: size.height * 0.02),
                // Text describing the benefits of using the app.
                const Text(
                  'Get exclusive deals, save your favorite destinations, and personalize your travel planning.',
                  softWrap: true, // Allows text to wrap to the next line.
                  textAlign: TextAlign.start,
                  style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: size.height * 0.03),
                InfoCard(Icons.lock_outline, "Privacy and Sharing",
                    tap: () => callOnTap), // InfoCard for Privacy and Sharing.
                InfoCard(Icons.menu_book_outlined, "Terms of Service",
                    tap: () => callOnTap), // InfoCard for Terms of Service.
                InfoCard(Icons.privacy_tip_outlined, "Privacy Policy",
                    tap: () => callOnTap), // InfoCard for Privacy Policy.
              ],
            ),
          ),
        ),
      ),
    );
  }

  void callOnTap() {
    // Placeholder function for InfoCard taps.
  }
}
