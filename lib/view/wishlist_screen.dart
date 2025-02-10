import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:marquee/marquee.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/utils/widgets/shimmer_loading.dart';
import 'package:wander_stay/view/place_detail_screen.dart';
import 'package:wander_stay/view_model/favourite_provider.dart';

import '../utils/colors/app_colors.dart';
import '../utils/widgets/image_network.dart';
import '../view_model/models_provider.dart';

class WishlistScreen extends StatefulWidget {
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size.
    return Scaffold(
      body: SafeArea( // Ensure content is not obscured.
        child: Padding( // Padding around the content.
          padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
          child: Column( // Main column for the layout.
            crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left.
            mainAxisAlignment: MainAxisAlignment.start, // Align children to the top.
            children: [
              Text("Wishlists",
                  style: GoogleFonts.alkatra(
                      fontSize: 28, fontWeight: FontWeight.bold)),
              SizedBox(height: size.height * 0.01), // Spacing.
              Expanded( // Expand the grid to fill the remaining space.
                child: Consumer<FavouriteProvider>( // Rebuild when FavouriteProvider changes.
                  builder: (BuildContext context, FavouriteProvider provider, Widget? child) {
                    return GridView.builder( // Grid view for the favorite places.
                      itemCount: provider.isLoading
                      ? 8 : provider.favoritePlaces.isEmpty // Number of items.
                          ? 1 : provider.favoritePlaces.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount( // Grid layout.
                        crossAxisCount: 2, // 2 columns.
                        crossAxisSpacing: 8, // Spacing between columns.
                        mainAxisSpacing: 8, // Spacing between rows.
                      ),
                      itemBuilder: (context, index) {
                        return provider.isLoading
                         ? _buildShimmerLoadingGridItem(size) // Call shimmer loading item builder.
                         : provider.favoritePlaces.isEmpty // Show shimmer loading if empty.
                         ? const Center(child: Text("No Favorite Places"))
                         : _buildFavoritePlaceGridItem(provider, index); // Call favorite place item builder.
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Builds the shimmer loading grid item. Extracted for reusability.
  Widget _buildShimmerLoadingGridItem(Size size) {
    return ShimmerLoading( // Shimmer loading effect.
      child: Container( // Container for the shimmer loading item.
        height: size.height * 0.18, // Height of the shimmer loading item.
        width: size.width, // Full width.
        decoration: BoxDecoration( // Styling for the shimmer loading item.
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(21.0), // Rounded corners.
        ),
      ),
    );
  }

  // Builds the grid item for a favorite place.  Extracted for better organization.
  Widget _buildFavoritePlaceGridItem(FavouriteProvider provider, int index) {
    return InkWell( // Make the item tappable.
      onTap: () {
        final place = Provider.of<ModelsProvider>(context, listen: false) // Access ModelsProvider.
            .places // Get the list of places.
            .where((place) => place.id == provider.favoritePlaces[index].favID); // Find the place by ID.

        if (place.isNotEmpty) { // Check if a matching place was found.
          Navigator.push( // Navigate to the PlaceDetailScreen.
              context,
              MaterialPageRoute(
                  builder: (context) => PlaceDetailScreen( // Pass the selected place.
                      place: place.elementAt(0))));
        } else {
          // Handle the case where the place is not found (e.g., show an error message).
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Place not found!')),
          );
        }
      },
      child: Container( // Container for the grid item.
        decoration: BoxDecoration( // Styling.
          color: AppColors.peachColor,
          borderRadius: BorderRadius.circular(21.0), // Rounded corners.
          border: Border.all(color: AppColors.darkPinkColor, width: 2.0), // Border.
        ),
        child: ClipRRect( // Clip the content to the rounded corners.
          borderRadius: const BorderRadius.all(Radius.circular(21.0)),
          child: Column( // Column to arrange the image and title.
            children: [
              SizedBox( // SizedBox for the carousel.
                height: MediaQuery.of(context).size.height * 0.18, // Set a specific height.
                width: MediaQuery.of(context).size.width, // Occupy full width.
                child: Stack( // Stack for the carousel and favorite icon.
                  alignment: Alignment.topCenter, // Align children to the top center.
                  children: [
                    AnotherCarousel( // Image carousel.
                      images: provider.favoritePlaces[index].favImageUrls // Get image URLs from the provider.
                          .map((url) => ImageNetwork(null, // Image widget.
                          src: url,
                          errorIcon: const Icon( // Error icon.
                            Icons.image_not_supported_rounded,
                            size: 24,
                            weight: 24,
                          )))
                          .toList(),
                      dotSize: 3, // Size of the dots.
                      indicatorBgPadding: 5, // Padding around the indicator.
                      dotBgColor: Colors.transparent, // Background color of the indicator.
                    ),
                    const Positioned( // Favorite icon.
                      top: 8,
                      right: 8,
                      child: Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded( // Expand the title to fill the remaining space.
                child: Marquee( // Marquee for scrolling text.
                  text: provider.favoritePlaces[index].favTitle, // Title text from provider.
                  style: GoogleFonts.labrada( // Text styling.
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.whiteColor),
                  scrollAxis: Axis.horizontal, // Scroll horizontally.
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to the start (top).
                  blankSpace: 20.0, // Space between repetitions.
                  velocity: 100.0, // Scrolling speed.
                  pauseAfterRound: const Duration(seconds: 1), // Pause after each round.
                  showFadingOnlyWhenScrolling: true, // Show fading edges only when scrolling.
                  fadingEdgeStartFraction: 0.1, // Start fraction of fading edge.
                  fadingEdgeEndFraction: 0.1, // End fraction of fading edge.
                  numberOfRounds: null, // Number of repetitions (null for infinite).
                  startPadding: 10.0, // Padding at the start.
                  accelerationDuration: const Duration(seconds: 1), // Acceleration duration.
                  accelerationCurve: Curves.linear, // Acceleration curve.
                  decelerationDuration: const Duration(milliseconds: 500), // Deceleration duration.
                  decelerationCurve: Curves.easeOut, // Deceleration curve.
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
