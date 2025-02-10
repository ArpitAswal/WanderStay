import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/view_model/condition_provider.dart';

import '../utils/colors/app_colors.dart';
import '../utils/widgets/form_fields.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late TextEditingController _passwordController; // Controller for the password text field.
  late TextEditingController _emailController; // Controller for the email text field.
  late ConditionProvider provider; // Instance of the ConditionProvider for state management.

  final _formKey = GlobalKey<FormState>(); // Key for the form to validate inputs.

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController(); // Initialize the password controller.
    _emailController = TextEditingController(); // Initialize the email controller.
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose(); // Dispose of the password controller to prevent memory leaks.
    _emailController.dispose(); // Dispose of the email controller to prevent memory leaks.
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the screen size.

    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by notches or system UI.
        child: PopScope( // Handles the back button press.
          canPop: false, // Prevents default back button behavior.
          onPopInvokedWithResult: (bool didPope, Object? result) async {
            if (didPope) {
              return; // Do nothing if already popped.
            }
            Navigator.pop(context); // Manually pop the screen.
          },
          child: SingleChildScrollView( // Allows content to scroll if it overflows.
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Selector<ConditionProvider, bool>( // Rebuilds when isLoading in ConditionProvider changes.
                  selector: (_, provider) {
                    this.provider = provider; // Store the provider instance.
                    return provider.isLoading; // Return the isLoading value to rebuild the widget.
                  },
                  builder: (BuildContext context, bool loading, Widget? child) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start, // Align children to the start (left).
                      mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (top).
                      children: [
                        Text(
                          'Log in or Sign up',
                          textAlign: TextAlign.start,
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(fontSize: 24),
                        ),
                        SizedBox(height: size.height * 0.03),
                        Form( // Form for email and password input.
                            key: _formKey, // Assign the form key.
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                FormFields( // Custom widget for form fields (email).
                                    label: "User Email",
                                    "xxx@gmail.com",
                                    obs: false, // Not obscured.
                                    controller: _emailController), // Assign the email controller.
                                SizedBox(height: size.height * 0.03), // Spacing.
                                FormFields( // Custom widget for form fields (password).
                                    label: "User Password",
                                    "8 character of password",
                                    obs: true, // Obscured.
                                    controller: _passwordController), // Assign the password controller.
                              ],
                            )),
                        SizedBox(height: size.height * 0.01),
                        RichText( // Text with a clickable link.
                          text: TextSpan(
                            text:
                            "We'll call or text you to conform your number. Standard message and data rates apply.  ",
                            style: Theme.of(context).textTheme.bodySmall, // Style for the regular text.
                            children: const [
                              TextSpan(
                                text: "Privacy Policy",
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                  decoration: TextDecoration.underline, // Underline the link.
                                ),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.03),
                        ElevatedButton( // Continue button.
                          onPressed: () {
                            // Validate the form.
                            if (_formKey.currentState!.validate()) {
                              // If the form is valid, proceed with login.
                              provider.setBtnType(BtnType.email); // Set the button type to email.
                              provider
                                  .emailAuth( // Call the email authentication function.
                                  email: _emailController.text,
                                  pass: _passwordController.text)
                                  .then((value) {
                                _emailController.text = ""; // Clear the email field.
                                _passwordController.text = ""; // Clear the password field.
                              });
                            }
                          },
                          style: ElevatedButton.styleFrom( // Style the button.
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                                side: const BorderSide(
                                    color: AppColors.whiteColor, width: 2.0),
                              )),
                          child: loading && provider.btnType == BtnType.email // Show loading indicator if loading and email btn is tapped.
                              ? const SizedBox(
                            height: 48,
                            width: 30,
                            child: CircularProgressIndicator(
                                color: AppColors.whiteColor),
                          )
                              : const Text('Continue')
                        ),
                        SizedBox(height: size.height * 0.02),
                        Row( // Separator with "OR" text.
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            const Expanded(
                              child: Divider(
                                color: AppColors.peachColor,
                                thickness: 1.0,
                                indent: 8.0,
                                endIndent: 12.0,
                              ),
                            ),
                            Text(
                              "OR",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleSmall
                                  ?.copyWith(color: AppColors.blackColor),
                            ),
                            const Expanded(
                              child: Divider(
                                color: AppColors.peachColor,
                                thickness: 1.0,
                                indent: 12.0,
                                endIndent: 8.0,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: size.height * 0.02),
                        // Social login buttons.
                        _socialButton( // Google login button.
                            'Continue with Google',
                            "asset/images/google.png",
                            Colors.orange,
                            size,
                            func: provider.googleAuth, // Authentication function.
                            loading: provider.isLoading, // Loading state.
                            btn: BtnType.google), // Button type.
                        SizedBox(height: size.height * 0.02),
                        _socialButton( // Facebook login button.
                            'Continue with Facebook',
                            "asset/images/facebook.png",
                            Colors.blue,
                            size,
                            func: provider.facebookAuth, // Authentication function.
                            loading: provider.isLoading, // Loading state.
                            btn: BtnType.facebook), // Button type.
                      ],
                    );
                  }),
            ),
          ),
        ),
      ),
    );
  }

  Widget _socialButton(String text, String assetPath, Color iconColor, Size size,
      {required bool loading, required BtnType btn, required Future<void> Function(AuthCallback callback) func}) {
    return InkWell( // Makes the button tappable.
      onTap: () async {
        provider.setBtnType(btn); // Sets the current button type (Google or Facebook). This helps manage the loading indicator to visible on which btn.
        await func((success, errorMessage) { // Calls the provided authentication function (googleAuth or facebookAuth).
          if (success) {
            Navigator.pop(context); // Navigates back from the LoginScreen if authentication is successful.  Context is used immediately within the callback.
          }
        });
      },
      child: Container(
        height: 48,
        width: size.width,
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8.0),
        decoration: BoxDecoration( // Styling for the button.
            color: Theme.of(context).scaffoldBackgroundColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppColors.blackColor),
            boxShadow: const [ // Shadow.
              BoxShadow(
                  color: AppColors.blackColor,
                  spreadRadius: 0.01,
                  blurRadius: 3.0)
            ]),
        child: loading && provider.btnType == btn // Show loading indicator if loading and the correct button type is active.
            ? const Center(
          child: SizedBox(
            height: 48,
            width: 24,
            child: CircularProgressIndicator(color: AppColors.darkPinkColor), // Loading indicator.
          ),
        )
            : Row( // Row for icon and text.
          mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left).
          mainAxisSize: MainAxisSize.max, // Occupy maximum width.
          crossAxisAlignment: CrossAxisAlignment.center, // Center children vertically.
          children: [
            Flexible(
              flex: 1,
              fit: FlexFit.tight,
              child: Image.asset(
                assetPath,
                alignment: Alignment.center,
                filterQuality: FilterQuality.high,
                fit: BoxFit.contain,
              )
            ),
            SizedBox(width: size.width * 0.1),
            Flexible(
              flex: 5,
              fit: FlexFit.tight,
              child: Text(
                text,
                style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                    color: AppColors.blackColor),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
