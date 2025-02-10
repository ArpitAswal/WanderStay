import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/service/firebase_auth_service.dart';
import 'package:wander_stay/service/shared_preference_service.dart';
import 'package:wander_stay/utils/widgets/form_fields.dart';
import 'package:wander_stay/utils/widgets/image_network.dart';

import '../utils/colors/app_colors.dart';
import '../utils/widgets/info_card.dart';
import '../view_model/condition_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late GlobalKey infoKey; // Key for the form in the info dialog.
  late TextEditingController emailController; // Controller for email input in the info dialog.
  late TextEditingController nameController; // Controller for name input in the info dialog.
  late ConditionProvider provider; // Instance of ConditionProvider for state management.

  @override
  void initState() {
    super.initState();
    infoKey = GlobalKey<FormState>(); // Initialize the form key.
    emailController = TextEditingController(); // Initialize email controller.
    nameController = TextEditingController(); // Initialize name controller.
  }

  @override
  void dispose() {
    super.dispose();
    emailController.dispose(); // Dispose of email controller to prevent memory leaks.
    nameController.dispose(); // Dispose of name controller to prevent memory leaks.
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size.
    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by notches, etc.
        child: SingleChildScrollView( // Allows scrolling if content overflows.
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0), // Padding around content.
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // Align children to the top.
              crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left.
              children: [
                Row( // Row for "Profile" title and notification icon.
                  mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them apart.
                  children: [
                    Text("Profile",
                        style: GoogleFonts.alkatra( // Using Google Fonts for styling.
                            fontSize: 28, fontWeight: FontWeight.bold)),
                    const Icon(
                      Icons.notifications_outlined,
                      size: 28,
                    )
                  ],
                ),
                Padding(
                    padding: const EdgeInsets.symmetric(vertical: 12.0),
                    child: Selector<ConditionProvider, Map<String, dynamic>>( // Rebuilds when user info changes.
                        selector: (_, provider) {
                          this.provider = provider; // Store provider instance.
                          return provider.saveInfo; // Return user info.
                        },
                        builder: (BuildContext context,
                            Map<String, dynamic> saveInfo, Widget? child) {
                          final info = saveInfo.isEmpty // Get user info or empty map if none.
                              ? {}
                              : saveInfo.values.elementAt(0);
                          return Row( // Row for profile picture, name, email, and update button.
                            crossAxisAlignment: CrossAxisAlignment.center, // Center vertically.
                            children: [
                              Container( // Container for profile picture.
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration( // Styling for profile picture border.
                                    borderRadius: BorderRadius.circular(90),
                                    border: Border.all(
                                        color: AppColors.peachColor,
                                        width: 2.0),
                                  ),
                                  child: ClipRRect( // Clip image to circular shape.
                                      borderRadius: BorderRadius.circular(90),
                                      child: ImageNetwork(null, // Placeholder for image.
                                          src: info['photoURL'] ?? "", // Image URL.
                                          errorIcon: const Icon( // Icon if image fails to load.
                                            Icons.person,
                                            size: 36,
                                          )))),
                              SizedBox(width: size.width * 0.05),
                              Expanded( // Expand to fill available space.
                                child: Column( // Column for name and email.
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text( // User name.
                                        info['displayName'] ?? "Unknown",
                                        style: GoogleFonts.alkatra(
                                            fontSize: 20,
                                            fontWeight: FontWeight.w500),
                                      ),
                                      Text( // User email.
                                        info['email'] ?? "no email register",
                                        style: GoogleFonts.alkatra(
                                            fontSize: 16,
                                            color: Colors.black54,
                                            fontWeight: FontWeight.w500),
                                      )
                                    ]),
                              ),
                              (info['email'] == null || info['email'] == "") // Show update button if no email.
                                  ? SizedBox(
                                width: size.width * 0.25,
                                child: ElevatedButton(
                                    onPressed: () {
                                      emailController.text = // Pre-fill email in dialog.
                                      info['email'] ?? "";
                                      nameController.text = // Pre-fill name in dialog.
                                      info['displayName'] ?? "";
                                      showDialog( // Show info update dialog.
                                          barrierDismissible: false, // Prevent dismiss outside.
                                          context: context,
                                          builder:
                                              (BuildContext context) {
                                            return infoDialogBox( // Build the dialog.
                                                provider: provider);
                                          });
                                    },
                                    child: const Center(
                                        child: Text("update"))),
                              )
                                  : const SizedBox.shrink() // Empty if email exists.
                            ],
                          );
                        })),
                Transform( // Skew the card.
                  alignment: FractionalOffset.center,
                  transform: Matrix4.skewX(-0.2),
                  child: Card( // WanderStay info card.
                    margin: const EdgeInsets.symmetric(vertical: 12.0),
                    color: Theme.of(context).scaffoldBackgroundColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24).copyWith(
                          topLeft: Radius.zero,
                          bottomRight: Radius.zero,
                        ),
                        side: const BorderSide(
                            width: 1.5, color: AppColors.whiteColor)),
                    shadowColor: AppColors.blackColor,
                    elevation: 16.0,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 16.0),
                      child: Row( // Row for card content.
                        mainAxisAlignment: MainAxisAlignment.spaceAround, // Space evenly.
                        mainAxisSize: MainAxisSize.max, // Max width.
                        children: [
                          Expanded( // Expand column to fill space.
                            child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text( // Title.
                                    "WanderStay your place",
                                    style:
                                    Theme.of(context).textTheme.titleMedium,
                                  ),
                                  Text( // Subtitle.
                                    "It's simple to get set up and start earning.",
                                    style:
                                    Theme.of(context).textTheme.bodyMedium,
                                  )
                                ]),
                          ),
                          ClipRRect( // Clip image to rounded corners.
                              borderRadius: BorderRadius.circular(24).copyWith(
                                topLeft: Radius.zero,
                                bottomRight: Radius.zero,
                              ),
                              child: const SizedBox( // Image box.
                                width: 140,
                                height: 100,
                                child: ImageNetwork(null, // Placeholder.
                                    src:
                                    "https://static.vecteezy.com/system/resources/previews/034/950/530/non_2x/ai-generated-small-house-with-flowers-on-transparent-background-image-png.png",
                                    errorIcon: Icon(
                                        Icons.image_not_supported_rounded)),
                              ))
                        ],
                      ),
                    ),
                  ),
                ),

                Text("Settings",
                    style: GoogleFonts.alkatra(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.015), // Spacing.
                InfoCard(Icons.person_2_outlined, "Personal Information",
                    tap: () => callOnTap),
                InfoCard(Icons.security, "Security",
                    tap: () => callOnTap),
                InfoCard(Icons.payments_outlined, "Payments and Payouts",
                    tap: () => callOnTap),
                InfoCard(Icons.settings_outlined, "Accessibility",
                    tap: () => callOnTap),
                InfoCard(Icons.lock_outline, "Privacy and Sharing",
                    tap: () => callOnTap),
                SizedBox(height: size.height * 0.015),
                Text("Support",
                    style: GoogleFonts.alkatra(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.015),
                InfoCard(Icons.help_outline, "Visit the Help Center",
                    tap: () => callOnTap),
                InfoCard(Icons.health_and_safety_outlined,
                    "Get help with a safer issue",
                    tap: () => callOnTap),
                InfoCard(Icons.edit_outlined, "Give us feedback",
                    tap: () => callOnTap),
                SizedBox(height: size.height * 0.015),
                Text("Legal",
                    style: GoogleFonts.alkatra(
                        fontSize: 28, fontWeight: FontWeight.bold)),
                SizedBox(height: size.height * 0.015), // Spacing.
                InfoCard(Icons.menu_book_outlined, "Terms of Service",
                    tap: () => callOnTap),
                InfoCard(Icons.privacy_tip_outlined, "Privacy Policy",
                    tap: () => callOnTap),
                InfoCard(Icons.source_outlined, "Open source licenses",
                    tap: () => callOnTap),
                SizedBox(height: size.height * 0.015),
                InfoCard(Icons.logout_outlined, "Sign Out", // Sign out info card.
                    tap: () => FirebaseAuthServices().signOut()), // Sign out functionality.
              ],
            ),
          ),
        ),
      ),
    );
  }

  void callOnTap() {
    // Placeholder function for handling taps on InfoCards (Personal Information, Security, etc.).
    // You'll need to implement the specific logic for each card here.
  }

  Widget infoDialogBox({required ConditionProvider provider}) {
    return Dialog( // Dialog for updating user info.
        child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black,
                  offset: Offset(6, 6),
                  spreadRadius: 2,
                  blurStyle: BlurStyle.solid,
                ),
              ],
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0), // Padding inside.
            child: Form( // Form for email and name input.
                key: infoKey, // Key for form validation.
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start, // Align to top.
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to left.
                    mainAxisSize: MainAxisSize.min, // Minimize size.
                    children: [
                      const Row( // Row for title and close button.
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them apart.
                        crossAxisAlignment: CrossAxisAlignment.center, // Center vertically.
                        mainAxisSize: MainAxisSize.max, // Max width.
                        children: [
                          Text( // Dialog title.
                            "Add Your Info",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.w600),
                          ),
                          Align( // Close button.
                            alignment: Alignment.topRight,
                            child: CloseButton(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      FormFields(null, // Email input.
                          label: "Email ID",
                          obs: false,
                          controller: emailController),
                      const SizedBox(height: 16),
                      FormFields(null, // Name input.
                          label: "Display Name",
                          obs: false,
                          controller: nameController),
                      const SizedBox(height: 16),
                      ElevatedButton(
                          onPressed: () {
                            SharedPreferenceService() // Update user info in shared preferences.
                                .updateUserInfo(
                                email: emailController.text,
                                displayName: nameController.text, (success, errorMessage) {
                              if (success) {
                                provider.getUserInfo(emailController.text); // Refresh user info.
                                emailController.text = ""; // Clear input fields.
                                nameController.text = "";
                                Navigator.of(context).pop(); // Close the dialog.
                              }
                            });
                          },
                          child: const Text("save")),
                      const SizedBox(height: 16),
                    ]))));
  }
}
