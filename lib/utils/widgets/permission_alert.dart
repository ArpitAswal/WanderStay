import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

import '../colors/app_colors.dart';

class LocationAlert extends StatelessWidget {
  const LocationAlert({super.key, required this.status, required this.msg});

  final String status; // The title of the alert message (e.g., "Location Permission Denied").
  final String msg;   // The detailed message of the alert (e.g., "Enable your device location...").

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the screen size.

    return Card( // Use a Card widget to create a visually distinct alert.
      elevation: 6, // Set the elevation of the card (shadow).
      shadowColor: AppColors.blackColor, // Set the shadow color.
      color: AppColors.whiteColor, // Set the background color of the card.
      margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Set margins around the card.
      shape: RoundedRectangleBorder( // Set the shape of the card with rounded corners.
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Container( // Container to hold the content within the card.
        width: size.width, // Set the width to the screen width.
        height: size.height * 0.12, // Set the height to 12% of the screen height.
        margin: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 12.0), // Set margins within the container.
        child: Row( // Use a Row to arrange the content horizontally.
          mainAxisAlignment: MainAxisAlignment.start, // Align content to the start of the row.
          crossAxisAlignment: CrossAxisAlignment.start, // Align content to the top of the row.
          mainAxisSize: MainAxisSize.min, // Minimize the size of the row.
          children: [
            Icon( // Display a location off icon.
              Icons.location_off_rounded,
              color: AppColors.redColor, // Set the icon color to red.
              size: size.height * .04, // Set the icon size to 4% of the screen height.
            ),
            Expanded( // Use Expanded to allow the text to take up available space.
              child: Padding( // Add padding around the text.
                padding: const EdgeInsets.only(left: 4.0, right: 0.0),
                child: Column( // Use a Column to arrange the text vertically.
                  mainAxisAlignment: MainAxisAlignment.start, // Align text to the top of the column.
                  crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start of the column.
                  children: [
                    Text( // Display the status message.
                      status,
                      style: const TextStyle(
                          color: AppColors.blackColor, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2.0), // Add a small vertical space.
                    Text( // Display the detailed message.
                      msg,
                      softWrap: true, // Allow text to wrap to the next line.
                      textAlign: TextAlign.start, // Align text to the start.
                      style: const TextStyle(
                          color: Colors.black45, fontWeight: FontWeight.w300),
                    )
                  ],
                ),
              ),
            ),
            SizedBox( // Use a SizedBox to control the size of the button.
              height: 40,
              width: size.width * 0.2, // Set the button width to 20% of the screen width.
              child: ElevatedButton( // Display an "Enable" button.
                child: const Center( // Center the text within the button.
                  child: Text(
                    'Enable',
                  ),
                ),
                onPressed: () { // Handle the button press.
                  Geolocator.openLocationSettings().whenComplete( // Open device location settings.
                      Navigator.of(context).pop // Close the alert after opening settings.
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}