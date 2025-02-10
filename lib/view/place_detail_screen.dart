import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

import '../model/place_model.dart';
import '../utils/colors/app_colors.dart';
import '../utils/widgets/circle_button.dart';
import '../utils/widgets/image_network.dart';
import '../view_model/favourite_provider.dart';

class PlaceDetailScreen extends StatefulWidget {
  final PlaceModel place; // PlaceModel instance passed to this screen.
  const PlaceDetailScreen({super.key, required this.place});

  @override
  State<PlaceDetailScreen> createState() => _PlaceDetailScreenState();
}

class _PlaceDetailScreenState extends State<PlaceDetailScreen> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get the screen size.

    return Scaffold(
      body: SafeArea( // Ensure content is not obscured by notches etc.
        top: false, // Allow content to extend behind the top bar (if any).
        bottom: false, // Allow content to extend behind the bottom bar (if any).
        child: SingleChildScrollView( // Enables scrolling if content overflows.
          child: Column( // Main layout column.
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the top.
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left.
            children: [
              _buildImageAndIcons(size, context), // Call the extracted method for image carousel and icons.

              Padding( // Padding around the place details.
                padding: const EdgeInsets.symmetric(
                    horizontal: 18.0, vertical: 12.0),
                child: Column( // Column for place details.
                  crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left.
                  children: [
                    Text(widget.place.title, // Place title.
                        maxLines: 2, // Limit to 2 lines.
                        softWrap: true, // Allow text wrapping.
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows.
                        style: GoogleFonts.alkatra( // Title text styling.
                            height: 1.25,
                            fontSize: 23,
                            fontWeight: FontWeight.w600,
                            color: AppColors.blackColor)),
                    Text("Room in ${widget.place.address}", // Place address.
                        maxLines: 2, // Limit to 2 lines.
                        softWrap: true, // Allow text wrapping.
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows.
                        style: GoogleFonts.alkatra( // Address text styling.
                            height: 1.25,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                            color: AppColors.blackColor)),
                    Text(widget.place.bedAndBathroom, // Bed and bathroom info.
                        maxLines: 1, // Limit to 1 line.
                        softWrap: true, // Allow text wrapping.
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows.
                        style: GoogleFonts.alkatra( // Bed and bathroom text styling.
                            height: 1.25,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45)),

                    _buildRatingAndReview(), // Call the extracted method for rating and reviews.

                    const Divider(), // Divider line.
                    _buildPlacePropertyItem( // Call the extracted method for place properties.
                      size,
                      "https://static.vecteezy.com/system/resources/previews/018/923/486/original/diamond-symbol-icon-png.png",
                      "This is a rare find",
                      "${widget.place.vendor}'s place is usually fully booked.",
                    ),
                    const Divider(), // Divider line.
                    _buildPlacePropertyItem( // Call the extracted method for place properties.
                      size,
                      widget.place.vendorProfile,
                      "Stay with ${widget.place.vendor}",
                      "Super host ${widget.place.yearOfHosting} years hosting.",
                    ),
                    const Divider(),
                    _buildPlacePropertyItem( // Call the extracted method for place properties.
                        size,
                        "https://cdn-icons-png.flaticon.com/512/6192/6192020.png",
                        "Room in a rental unit",
                        "Your own room in a home, plus access\nto shared spaces."),
                    const Divider(),
                    _buildPlacePropertyItem( // Call the extracted method for place properties.
                        size,
                        "https://cdn0.iconfinder.com/data/icons/co-working/512/coworking-sharing-17-512.png",
                        "Shared common spaces",
                        "You'll share parts of the home with the host."),
                    const Divider(),
                    _buildPlacePropertyItem( // Call the extracted method for place properties.
                        size,
                        "https://img.pikbest.com/element_our/20230223/bg/102f90fb4dec6.png!w700wp",
                        "Shared bathroom",
                        "You'll share the bathroom with others."),
                    const Divider(),
                    const Text( // About place
                      "About Place",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 22,
                      ),
                    ),
                    Text(
                        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.",
                        style: GoogleFonts.alkatra(
                            height: 1.25,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor)),
                    const Divider(),
                    const Text( // WanderStay address
                      "WanderStay Address",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(widget.place.address, // WanderStay address.
                        style: GoogleFonts.alkatra( // Address text styling.
                            height: 1.25,
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.blackColor)),

                    Container( // Container for the Google Map.
                      height: 400, // Set a fixed height for the map.
                      width: size.width, // Occupy full width.
                      margin: const EdgeInsets.symmetric(vertical: 15), // Margin around the map.
                      decoration: BoxDecoration( // Map container styling.
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black38,
                              spreadRadius: 0.5,
                              blurRadius: 6.0,
                              offset: Offset(-5, 5))
                        ],
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: GoogleMap( // Google Map widget.
                        myLocationButtonEnabled: false, // Disable my location button.
                        tiltGesturesEnabled: true, // Enable tilt gestures.
                        scrollGesturesEnabled: true, // Enable scroll gestures.
                        zoomControlsEnabled: true, // Enable zoom controls.
                        zoomGesturesEnabled: true, // Enable zoom gestures.
                        markers: { // Markers on the map.
                          Marker(
                            markerId: MarkerId(widget.place.address), // Unique marker ID.
                            position: LatLng(widget.place.latitude, widget.place.longitude), // Marker position.
                          ),
                        },
                        initialCameraPosition: CameraPosition( // Initial camera position.
                            target: LatLng(widget.place.latitude, widget.place.longitude), // Map center.
                            zoom: 12), // Zoom level.
                      ),
                    ),
                    SizedBox(height: size.height * 0.1) // Spacing at the bottom.
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomSheet: _buildPriceAndReserve(size), // Call the extracted method for price and reserve bottom sheet.
    );
  }

  // Builds the price and reserve bottom sheet.
  Widget _buildPriceAndReserve(Size size) {
    return Container( // Container for the bottom sheet.
      height: size.height * 0.08, // Set a fixed height.
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24.0)),
          border: Border.all(color: AppColors.darkPinkColor),
          boxShadow: const [
            BoxShadow(
                color: AppColors.darkPinkColor,
                blurRadius: 8.0,
                spreadRadius: 1.0)
          ]),
      child: Row( // Row to arrange price and reserve button.
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them apart.
        children: [
          Column( // Column for the price and date.
            mainAxisAlignment: MainAxisAlignment.center, // Vertically center.
            children: [
              RichText( // RichText for styling price and currency.
                text: TextSpan(
                  text: "\$${widget.place.price}", // Price.
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.green),
                  children: const [
                    TextSpan( // Currency and unit.
                        text: " / ",
                        style: TextStyle(color: AppColors.blackColor)),
                    TextSpan(
                      text: "Night",
                      style: TextStyle(
                        color: AppColors.darkPinkColor,
                      ),
                    ),
                  ],
                ),
              ),
              Text(widget.place.date, // Date.
                  style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.black45))
            ],
          ),
          Container( // Reserve button.
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            decoration: BoxDecoration(
              color: AppColors.darkPinkColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text( // Button text.
              "Reserve 😊",
              style: TextStyle(
                fontSize: 18,
                color: AppColors.whiteColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Builds the place property list item.
  Widget _buildPlacePropertyItem(Size size, image, title, subtitle) {
    return Padding( // Padding around the item.
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row( // Row to arrange image and text.
        mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left).
        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center.
        mainAxisSize: MainAxisSize.max, // Occupy maximum size.
        children: [
          CircleAvatar( // Circle avatar for the image.
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            backgroundImage: NetworkImage(image), // Image from URL.
            radius: 30, // Radius of the circle.
          ),
          SizedBox( // Spacing.
            width: size.width * 0.05,
          ),
          Expanded( // Expand the text to fill the remaining space.
            child: Column( // Column for the title and subtitle.
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center.
              crossAxisAlignment: CrossAxisAlignment.start, // Align to the start (left).
              children: [
                Text(title, // Title text.
                    softWrap: true, // Allow text wrapping.
                    maxLines: 2, // Limit to 2 lines.
                    overflow: TextOverflow.visible, // Show overflow if text exceeds the limit.
                    textAlign: TextAlign.start, // Align text to the start (left).
                    style: GoogleFonts.alkatra( // Title text styling.
                        height: 1.25,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black)),
                Text(subtitle, // Subtitle text.
                    softWrap: true, // Allow text wrapping.
                    maxLines: 3, // Limit to 3 lines.
                    overflow: TextOverflow.visible, // Show overflow if text exceeds the limit.
                    textAlign: TextAlign.start, // Align text to the start (left).
                    style: GoogleFonts.alkatra( // Subtitle text styling.
                        height: 1.25,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.blackColor))
              ],
            ),
          )
        ],
      ),
    );
  }

  // Builds the rating and review section.
  Widget _buildRatingAndReview() {
    return Container( // Container for the rating and review section.
      width: MediaQuery.of(context).size.width, // Occupy full width.
      margin: const EdgeInsets.symmetric(vertical: 12.0), // Margin around the container.
      decoration: BoxDecoration(
        gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Colors.red.shade400, Colors.orange.shade400]),
        border: Border.all(color: AppColors.darkPinkColor, width: 2),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row( // Row to arrange rating, guest favorite, and reviews.
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them evenly.
        mainAxisSize: MainAxisSize.max, // Occupy maximum size.
        crossAxisAlignment: CrossAxisAlignment.center, // Vertically center.
        children: [
          Expanded( // Expand the rating column.
            child: Column( // Column for the rating value and stars.
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center.
              crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center.
              children: [
                Text(widget.place.rating.toString(), // Rating value.
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontFamily: "Roboto",
                      fontSize: 16,
                    )),
                RatingBar( // Rating bar widget.
                  glow: true, // Enable glow effect.
                  glowColor: AppColors.darkPinkColor, // Glow color.
                  glowRadius: 4.0, // Glow radius.
                  itemSize: 20.0, // Size of the stars.
                  ratingWidget: RatingWidget( // Rating widget configuration.
                      full: const Icon( // Full star icon.
                        Icons.star,
                        color: AppColors.darkPinkColor,
                        size: 18.0,
                      ),
                      half: const Icon( // Half star icon.
                        Icons.star_half,
                        color: AppColors.darkPinkColor,
                        size: 18.0,
                      ),
                      empty: const Icon( // Empty star icon.
                        Icons.star,
                        color: AppColors.whiteColor,
                        size: 18.0,
                      )),
                  onRatingUpdate: (value) {}, // Callback for rating update (not used here).
                  ignoreGestures: true, // Disable user interaction with the rating bar.
                  initialRating: widget.place.rating, // Initial rating value.
                  minRating: 1, // Minimum rating value.
                  maxRating: 5, // Maximum rating value.
                  allowHalfRating: true, // Allow half star ratings.
                  itemCount: 5, // Number of stars.
                  tapOnlyMode: true, // Only allow tap to set rating.
                  updateOnDrag: true, // Update rating on drag.
                )
              ],
            ),
          ),
          (widget.place.isActive == true) // Conditionally show guest favorite badge.
              ? Expanded( // Expand the guest favorite badge column.
            child: Stack( // Stack to overlay the image and text.
              alignment: Alignment.center, // Center the children.
              children: [
                Image.network( // Guest favorite image.
                  "https://wallpapers.com/images/hd/golden-laurel-wreathon-teal-background-k5791qxis5rtcx7w-k5791qxis5rtcx7w.png",
                  height: 80,
                  width: 120,
                  color: AppColors.amberColor, // Tint color.
                ),
                const Text( // Guest favorite text.
                  "Guest\nFavorite",
                  textAlign: TextAlign.center, // Center the text.
                  style: TextStyle( // Text styling.
                    fontSize: 16,
                    height: 1.2,
                    fontWeight: FontWeight.bold,
                    color: AppColors.amberColor, // Text color.
                  ),
                ),
              ],
            ),
          )
              : const SizedBox(height: 80), // Empty SizedBox if not a guest favorite.
          Expanded( // Expand the reviews column.
            child: Column( // Column for the review count and text.
              mainAxisAlignment: MainAxisAlignment.center, // Vertically center.
              crossAxisAlignment: CrossAxisAlignment.center, // Horizontally center.
              children: [
                Text( // Review count.
                  widget.place.review.toString(),
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: "Roboto",
                    fontSize: 16,
                  ),
                ),
                const Text( //Review title
                  "Reviews",
                  style: TextStyle(
                      fontSize: 14.0,
                      fontWeight: FontWeight.w600,
                      color: AppColors.darkPinkColor,
                      decoration: TextDecoration.underline,
                      decorationStyle: TextDecorationStyle.solid,
                      decorationColor: AppColors.darkPinkColor),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  // Builds the image carousel with back, share, and favorite buttons.
  Widget _buildImageAndIcons(Size size, BuildContext context) {
    return Stack( // Use a Stack to overlay widgets.
      alignment: Alignment.topCenter, // Align children to the top center.
      children: [
        SizedBox( // SizedBox to constrain the carousel height.
          height: size.height * 0.4, // 40% of screen height.
          child: AnotherCarousel( // Image carousel.
            images: widget.place.imageUrls // Map image URLs to Image widgets.
                .map((url) => ImageNetwork(null, // Use your custom ImageNetwork widget.
                src: url,
                errorIcon: const Icon( // Error icon.
                  Icons.image_not_supported_rounded,
                  size: 60,
                  weight: 60,
                )))
                .toList(),
            showIndicator: true, // Show the indicator dots.
            dotBgColor: Colors.transparent, // Transparent background for the dots.
            dotColor: AppColors.darkPinkColor, // Color of the inactive dots.
            dotIncreasedColor: AppColors.amberColor, // Color of the active dot.
            onImageChange: (p0, p1) {}, // Callback for image change (not used here).
            autoplay: true, // Autoplay the carousel.
            boxFit: BoxFit.cover, // Cover the entire SizedBox.
          ),
        ),
        Padding( // Padding for the icon buttons.
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 32.0),
          child: SizedBox( // SizedBox to manage width.
            width: size.width,
            child: Row( // Row to arrange the icon buttons.
              mainAxisSize: MainAxisSize.max, // Occupy maximum width.
              crossAxisAlignment: CrossAxisAlignment.center, // Vertically center the icons.
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space the icons evenly.
              children: [
                InkWell( // Back button.
                  onTap: () => Navigator.of(context).pop(), // Navigate back.
                  child: const CircleButton( // Your custom circle button widget.
                    icon: Icons.arrow_back_ios_new,
                    radius: 18,
                  ),
                ),
                const Spacer(), // Use Spacer to push share and favorite buttons to the right.
                const CircleButton( // Share button.
                  icon: Icons.share_rounded,
                  radius: 18,
                ),
                SizedBox(width: size.width * 0.02), // Small spacing.
                Consumer<FavouriteProvider>( // Favorite button.
                  builder: (BuildContext context, FavouriteProvider provider, Widget? child) {
                    return InkWell( // Make the button tappable.
                      onTap: () => provider.toggleFavorite(widget.place), // Toggle favorite status.
                      child: CircleButton( // Your custom circle button widget.
                        icon: Icons.favorite,
                        iconColor: provider.isExist(widget.place) // Icon color based on favorite status.
                            ? AppColors.darkPinkColor
                            : AppColors.whiteColor,
                        radius: 18.0,
                        color: provider.isExist(widget.place) // Background color based on favorite status.
                            ? AppColors.whiteColor
                            : AppColors.darkPinkColor,
                      ),
                    );
                  },
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}
