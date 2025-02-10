import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/model/place_model.dart';
import 'package:wander_stay/utils/widgets/circle_button.dart';
import 'package:wander_stay/utils/widgets/image_network.dart';

import '../../view_model/favourite_provider.dart';
import '../colors/app_colors.dart';

class PlacesMarker extends StatelessWidget {
  const PlacesMarker({super.key, required this.place});

  final PlaceModel place; // The place to display in the marker

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size

    return Container( // Main container for the marker
      decoration: BoxDecoration( // Styling for the container
        color: AppColors.whiteColor,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column( // Column to arrange the content vertically
        children: [
          _buildImageCarousel(size), // Build the image carousel
          _buildPlaceDetails(), // Build the place details
        ],
      ),
    );
  }

  // Builds the image carousel.
  Widget _buildImageCarousel(Size size) {
    return Stack( // Stack to overlay icons on the image
      alignment: Alignment.topCenter, // Align children to the top center
      children: [
        SizedBox( // SizedBox to constrain the image size
          height: size.height * 0.18, // 18% of screen height
          child: ClipRRect( // Clip the image with rounded corners
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)), // Rounded top corners
            child: AnotherCarousel( // Image carousel
              images: place.imageUrls // Map image URLs to ImageNetwork widgets
                  .map((url) => ImageNetwork(null,
                  src: url,
                  errorIcon: const Icon(
                    Icons.image_not_supported_rounded,
                    size: 40,
                    weight: 40,
                  )))
                  .toList(),
              dotSize: 5, // Size of the indicator dots
              indicatorBgPadding: 5, // Padding around the indicator
              dotBgColor: Colors.transparent, // Transparent background for the indicator
            ),
          ),
        ),
        _buildFavoriteAndGuestFavoriteIcons(), // Favorite and Guest Favorite Icons
      ],
    );
  }

  // Builds the favorite and guest favorite icons.
  Widget _buildFavoriteAndGuestFavoriteIcons() {
    return Padding( // Padding around the icons
      padding: const EdgeInsets.symmetric(vertical: 6.0, horizontal: 12.0),
      child: Row( // Row to arrange the icons
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them evenly
        mainAxisSize: MainAxisSize.max, // Occupy maximum size
        crossAxisAlignment: CrossAxisAlignment.center, // Align to the center vertically
        children: [
          place.isActive == true // Show GuestFavorite label if place is active
              ? Container( // Container for the GuestFavorite label
            decoration: BoxDecoration( // Styling
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(40), // Rounded corners
            ),
            child: const Padding( // Padding around the text
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              child: Text(
                "GuestFavorite",
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
              : const SizedBox.shrink(), // Empty widget if not active
          Consumer<FavouriteProvider>( // Consumer for the favorite button
            builder: (BuildContext context, FavouriteProvider value, Widget? child) {
              return InkWell( // InkWell for tap functionality
                onTap: () => value.toggleFavorite(place), // Toggle favorite on tap
                child: CircleButton( // Custom CircleButton widget
                  radius: 15,
                  color: value.isExist(place) ? AppColors.whiteColor : AppColors.darkPinkColor, // Color based on favorite status
                  icon: Icons.favorite,
                  iconColor: value.isExist(place) ? AppColors.darkPinkColor : AppColors.whiteColor, // Icon color based on favorite status
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Builds the place details section.
  Widget _buildPlaceDetails() {
    return Padding( // Padding around the details
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column( // Column to arrange the details vertically
        crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left
        mainAxisSize: MainAxisSize.min, // Minimize the column size
        children: [
          Row( // Row for address and rating
            crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
            children: [
              Expanded( // Expanded for the address text
                child: Text(
                  place.address,
                  softWrap: true, // Allow text wrapping
                  maxLines: 2, // Limit to 2 lines
                  overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                  style: GoogleFonts.alkatra( // Address text styling
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.black54),
                ),
              ),
              Row( // Row for the rating
                mainAxisAlignment: MainAxisAlignment.center, // Center horizontally
                crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
                children: [
                  const Icon( // Star icon
                    Icons.star,
                    color: Colors.amber,
                    size: 21.0,
                    shadows: [ // Shadow for the star
                      BoxShadow(
                          color: Colors.amberAccent,
                          blurRadius: 8.0,
                          spreadRadius: 8.0)
                    ],
                  ),
                  Text( // Rating value
                    place.rating.toString(),
                    style: TextStyle( // Rating text styling
                        fontWeight: FontWeight.w600,
                        fontSize: 14.0,
                        color: (place.rating >= 4.2) // Color based on rating
                            ? Colors.green
                            : (place.rating >= 3.0)
                            ? Colors.amber
                            : Colors.red),
                  ),
                ],
              ),
            ],
          ),
          Flexible( // Flexible for the vendor info text
            child: Text(
                "Stay with ${place.vendor}. ${place.vendorProfession}",
                softWrap: true, // Allow text wrapping
                maxLines: 2, // Limit to 2 lines
                overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                style: GoogleFonts.alkatra( // Vendor info text styling
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    color: Colors.black45)),
          ),
        ],
      ),
    );
  }
}
