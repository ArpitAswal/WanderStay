import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../../view_model/condition_provider.dart';
import '../colors/app_colors.dart';

class FormFields extends StatelessWidget {
  const FormFields(this.hint,
      {super.key, required this.label, required this.obs, required this.controller});

  final String label; // Label for the form field
  final String? hint; // Hint text for the form field
  final bool obs; // Whether the field is obscured (password field)
  final TextEditingController controller; // Text editing controller for the field

  @override
  Widget build(BuildContext context) {
    return Consumer<ConditionProvider>( // Use Consumer to rebuild when ConditionProvider changes
      builder: (BuildContext context, ConditionProvider provider, Widget? child) {
        return TextFormField(
          controller: controller, // Set the controller for the text field
          validator: (value) { // Validator function for the text field
            if (value == null || value.isEmpty) {
              return 'Please enter some text'; // Return error message if value is empty
            }
            return null; // Return null if value is valid
          },
          style: GoogleFonts.lato( // Style for the text
            color: AppColors.darkPinkColor,
            decoration: TextDecoration.none,
          ),
          cursorColor: AppColors.peachColor, // Color of the cursor
          textCapitalization: TextCapitalization.none, // Disable text capitalization
          textInputAction: obs ? TextInputAction.done : TextInputAction.next, // Set text input action based on obscurity
          obscureText: obs ? provider.passVisible : false, // Obscure text if obs is true and password visibility is toggled
          keyboardType: TextInputType.emailAddress, // Set keyboard type
          decoration: InputDecoration( // Input decoration for the text field
            border: InputBorder.none, // Remove default border
            labelText: label, // Set the label text
            labelStyle: const TextStyle( // Style for the label
              color: AppColors.blackColor,
              fontWeight: FontWeight.w600,
            ),
            hintText: hint, // Set the hint text
            hintStyle: TextStyle(color: Colors.grey.shade400), // Style for the hint text
            prefixIcon: (hint != null) // Set prefix icon if hint is not null
                ? Icon(obs ? Icons.password_outlined : Icons.email_outlined)
                : null,
            suffixIcon: obs // Set suffix icon for password visibility toggle if obs is true
                ? InkWell(
              onTap: provider.togglePassword, // Toggle password visibility on tap
              child: Icon(
                provider.passVisible // Show/hide visibility icon based on state
                    ? Icons.visibility
                    : Icons.visibility_off,
                color: AppColors.darkPinkColor,
              ),
            )
                : null,
            enabledBorder: OutlineInputBorder( // Border when the field is enabled
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blackColor),
            ),
            focusedBorder: OutlineInputBorder( // Border when the field is focused
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.peachColor),
            ),
            focusedErrorBorder: OutlineInputBorder( // Border when the field is focused and has an error
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.redColor),
            ),
            errorBorder: OutlineInputBorder( // Border when the field has an error
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.redColor),
            ),
            disabledBorder: OutlineInputBorder( // Border when the field is disabled
              borderRadius: BorderRadius.circular(8),
              borderSide: const BorderSide(color: AppColors.blackColor),
            ),
          ),
        );
      },
    );
  }
}
