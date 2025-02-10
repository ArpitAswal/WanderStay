import 'package:flutter/material.dart';
import 'package:another_carousel_pro/another_carousel_pro.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/view_model/favourite_provider.dart';
import 'package:wander_stay/utils/widgets/image_network.dart';

import '../../model/place_model.dart';
import '../../view/place_detail_screen.dart';
import '../../view_model/models_provider.dart';
import '../colors/app_colors.dart';

class PlacesView extends StatefulWidget {
  const PlacesView({super.key});

  @override
  State<PlacesView> createState() => _PlacesViewState();
}

class _PlacesViewState extends State<PlacesView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Selector<ModelsProvider, List<PlaceModel>>( // Use Selector for efficient rebuilds.
      selector: (_, provider) => provider.places, // Select only the places list.
      builder: (BuildContext context, List<PlaceModel> places, Widget? child) {
        return ListView.builder( // Use ListView.builder for efficient list rendering.
          physics: const NeverScrollableScrollPhysics(), // Disable scrolling of this ListView.
          itemCount: places.isEmpty ? 1 : places.length, // Show shimmer loading items if places is empty, otherwise show actual data.
          shrinkWrap: true, // Important: Set shrinkWrap to true to prevent unbounded height errors.
          itemBuilder: (context, index) {
            if (places.isEmpty) { // Show ShimmerLoading while data is loading.
              return SizedBox(
                height: size.height / 2,
                width: size.width,
                child: const Center(child:
                  Text("No places exist")),
              ); // Build shimmer loading card.
            } else { // Display the place data.
              return _buildPlaceCard(places[index], size); // Build place card.
            }
          },
        );
      },
    );
  }

  // Builds the actual place card.
  Widget _buildPlaceCard(PlaceModel place, Size size) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => PlaceDetailScreen(place: place),
          ),
        );
      },
      child: Card(
        elevation: 12.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(21.0),
          side: const BorderSide(color: AppColors.whiteColor),
        ),
        color: AppColors.peachColor,
        shadowColor: AppColors.blackColor,
        margin: const EdgeInsets.only(bottom: 12.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            _buildPlaceImageCarousel(place, size), // Image carousel
            _buildPlaceInfo(place, size),         // Place information
          ],
        ),
      ),
    );
  }

  // Builds the place image carousel.
  Widget _buildPlaceImageCarousel(PlaceModel place, Size size) {
    return Stack(
      alignment: Alignment.topCenter,
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(21)),
          child: SizedBox(
            height: size.height * 0.3,
            width: size.width,
            child: AnotherCarousel(
              images: place.imageUrls
                  .map((url) => ImageNetwork(null,
                  src: url,
                  errorIcon: const Icon(
                    Icons.image_not_supported_rounded,
                    size: 60,
                    weight: 60,
                  )))
                  .toList(),
              dotSize: 6,
              indicatorBgPadding: 5,
              dotBgColor: Colors.transparent,
            ),
          ),
        ),
        _buildFavoriteAndGuestFavoriteIcons(place), // Favorite and Guest Favorite Icons
      ],
    );
  }

  // Builds the favorite and guest favorite icons.
  Widget _buildFavoriteAndGuestFavoriteIcons(PlaceModel place) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          place.isActive == true
              ? Container(
            decoration: BoxDecoration(
              color: AppColors.whiteColor,
              borderRadius: BorderRadius.circular(40),
            ),
            child: const Padding(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: Text(
                "GuestFavorite",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
          )
              : const SizedBox.shrink(),
          Consumer<FavouriteProvider>(
            builder: (BuildContext context, FavouriteProvider value, Widget? child) {
              return IconButton(
                onPressed: () => value.toggleFavorite(place),
                highlightColor: value.isExist(place) ? AppColors.whiteColor : AppColors.darkPinkColor,
                tooltip: "FavoriteStay",
                icon: Icon(
                  Icons.favorite,
                  color: value.isExist(place) ? AppColors.darkPinkColor : AppColors.whiteColor,
                  size: 24.0,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  // Builds the place information section.
  Widget _buildPlaceInfo(PlaceModel place, Size size) {
    return Flexible( // Flexible to allow the card to expand vertically
      child: Card( // Card for the place information
        elevation: 12.0,
        shape: RoundedRectangleBorder( // Rounded corners
          borderRadius: BorderRadius.circular(8.0),
          side: const BorderSide(color: AppColors.darkPinkColor, width: 2.0), // Pink border
        ),
        color: AppColors.whiteColor, // Background color
        shadowColor: AppColors.darkPinkColor, // Shadow color
        margin: const EdgeInsets.all(8.0), // Margin around the card
        child: Padding( // Padding inside the card
          padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
          child: Row( // Row to arrange place details and rating/vendor info
            mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them evenly
            crossAxisAlignment: CrossAxisAlignment.start, // Align to the top
            children: [
              Expanded( // Place details (address, vendor, etc.)
                child: Column( // Column for the place details
                  crossAxisAlignment: CrossAxisAlignment.start, // Align to the left
                  children: [
                    Text(place.address, // Address
                        softWrap: true, // Allow text wrapping
                        maxLines: 2, // Limit to 2 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                        style: GoogleFonts.alkatra( // Address text styling
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.black54)),
                    Text( // Vendor info
                        "Stay with ${place.vendor}. ${place.vendorProfession}",
                        softWrap: true, // Allow text wrapping
                        maxLines: 2, // Limit to 2 lines
                        overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows
                        style: GoogleFonts.alkatra( // Vendor info text styling
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black45)),
                    Text(place.date, // Date
                        style: GoogleFonts.alkatra( // Date text styling
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.black45)),
                    RichText( // Price
                      text: TextSpan( // TextSpan for styling the price
                        text: "\$${place.price}", // Price value
                        style: GoogleFonts.alkatra( // Price text styling
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.green),
                        children: const [ // Children for the currency and unit
                          TextSpan( // Currency symbol and space
                              text: " / ",
                              style: TextStyle(color: AppColors.blackColor)),
                          TextSpan( // Unit (Night)
                            text: "Night",
                            style: TextStyle(color: AppColors.darkPinkColor),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              Column( // Rating and Vendor Profile
                crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally
                children: [
                  Row( // Rating
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
                  SizedBox(height: size.height * 0.015), // Spacing
                  // Vendor Profile Image
                  Container( // Container for the vendor profile image
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration( // Styling
                      borderRadius: BorderRadius.circular(90), // Circular
                      border: Border.all( // Border
                          color: AppColors.peachColor, width: 2.0),
                    ),
                    child: ClipRRect( // Clip the image with rounded corners
                      borderRadius: BorderRadius.circular(90), // Circular
                      child: ImageNetwork(null, // ImageNetwork widget for image loading
                          src: place.vendorProfile,
                          errorIcon: const Icon( // Error icon if image fails to load
                              Icons.image_not_supported_rounded)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}