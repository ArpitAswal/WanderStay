import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/utils/widgets/image_network.dart';
import 'package:wander_stay/utils/widgets/shimmer_loading.dart';

import '../model/category_model.dart';
import '../model/place_model.dart';
import '../utils/colors/app_colors.dart';
import '../utils/widgets/places_view.dart';
import '../view_model/models_provider.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final SearchController searchCtrl = SearchController(); // Controller for the search bar.
  late ModelsProvider provider; // Instance of ModelsProvider for state management.

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size; // Get screen size.

    return Scaffold(
      body: SafeArea( // Ensures content is not obscured by notches, etc.
        bottom: false, // Allow content to extend below the bottom navigation bar.
        child: Column( // Main layout column.
          mainAxisAlignment: MainAxisAlignment.start, // Align children to the top.
          crossAxisAlignment: CrossAxisAlignment.start, // Align children to the left.
          mainAxisSize: MainAxisSize.max, // Occupy maximum size.
          children: [
            // Search bar widget.
            Selector<ModelsProvider, List<PlaceModel>>( // Rebuilds when the list of places changes.
              selector: (_, provider) => provider.places, // Selects the list of places from the provider.
              builder: (BuildContext context, List<PlaceModel> places, Widget? child) {
                return searchBarWidget(context, places, searchCtrl); // Build the search bar.
              },
            ),

            Expanded( // Expands to fill the remaining space.
                child: SingleChildScrollView( // Allows scrolling if content overflows.
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12.0), // Padding around content.
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Align to top.
                        crossAxisAlignment: CrossAxisAlignment.start, // Align to left.
                        children: [
                          // Category items widget.

                          Selector<ModelsProvider, bool>( // it will determine whether the display shimmer loading or not
                           selector: (_ , provider) => provider.isCategoriesLoading,
                            builder: (BuildContext context, bool value, Widget? child) {
                              return value
                                  ?  _buildCategoryShimmer(size)
                                  : Selector<ModelsProvider,
                                  List<
                                      CategoryModel>>( // Rebuilds when the list of categories changes.
                                selector: (_, provider) => provider.categories,
                                // Selects the list of categories.
                                builder: (BuildContext context,
                                    List<CategoryModel> categories,
                                    Widget? child) {
                                  return categoryItemsWidget(size,
                                      categories); // Build the category items.
                                },
                              );
                            }),

                          // Price card widget.
                          SlideInLeft( // Fade-in animation for the price card.
                            delay: const Duration(milliseconds: 100),
                            duration: const Duration(milliseconds: 1000),
                            child: Selector<ModelsProvider, bool>( // Rebuilds when the switch value changes.
                              selector: (_, provider) => provider.isSwitch, // Selects the switch value.
                              builder: (BuildContext context, bool switchValue, Widget? child) {
                                return priceCard(size, switchValue); // Build the price card.
                              },
                            ),
                          ),

                          Selector<ModelsProvider, bool>(
                              selector: (_, provider) => provider.isPlacesLoading, // value whether the places data is loading or not.
                              builder: (BuildContext context, bool value, Widget? child) {
                              return value
                                  ? _buildShimmerLoading(size)
                                  : const PlacesView();
                           })// Places view widget.
                        ],
                      ),
                    )))
          ],
        ),
      ),
    );
  }

  Widget searchBarWidget(BuildContext context, List<PlaceModel> places,
      SearchController searchCtrl) {
    return SearchAnchor( // Widget for the search bar with suggestions.
      isFullScreen: true, // Makes the search view full-screen.
      viewBackgroundColor: Theme.of(context).scaffoldBackgroundColor, // Background color of the search view.
      searchController: searchCtrl, // Controller for the search text.
      viewHintText: "room description...", // Hint text in the search view.
      viewSide: const BorderSide(color: AppColors.peachColor, width: 2.0), // Border of the search view.
      textInputAction: TextInputAction.done, // Input action for the keyboard.
      textCapitalization: TextCapitalization.sentences, // Capitalization of input text.
      headerHeight: 48.0, // Height of the header in the search view.
      viewTrailing: [ // Trailing icons in the search view.
        IconButton(
            onPressed: () {
              searchCtrl.text = ""; // Clear the search text.
            },
            icon: const Icon(Icons.clear))
      ],
      viewOnSubmitted: (String text) { // Called when the search is submitted.
        searchCtrl.closeView(text); // Close the search view.
      },
      builder: (BuildContext context, SearchController controller) { // Builder for the search bar.
        return Container( // Container for the search bar.
            width: MediaQuery.of(context).size.width, // Occupy full width.
            margin: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0), // Margin around the search bar.
            decoration: BoxDecoration( // Styling for the search bar.
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              boxShadow: const [ // Shadow.
                BoxShadow(
                    blurRadius: 8.0, color: Colors.black38, spreadRadius: 2.0)
              ],
            ),
            child: Row( // Row for the search icon and text.
              mainAxisSize: MainAxisSize.max, // Occupy maximum size.
              children: [
                IconButton( // Search icon button.
                    onPressed: () {
                      searchCtrl.openView(); // Open the search view.
                    },
                    icon: const Icon(Icons.search_outlined)),
                Expanded( // Expand to fill available space.
                  child: Text( // Search text.
                    (searchCtrl.value.text.isNotEmpty) // Display entered text or hint.
                        ? searchCtrl.value.text
                        : "Search WanderStay here...",
                    style: TextStyle( // Text styling.
                        color: (searchCtrl.value.text.isNotEmpty)
                            ? AppColors.redAccentColor
                            : AppColors.blackColor,
                        fontWeight: FontWeight.w400),
                  ),
                )
              ],
            ));
      },
      suggestionsBuilder: (BuildContext context, SearchController controller) { // Builder for search suggestions.
        final String input = controller.value.text; // Get the entered text.
        return places // Filter the places based on the input.
            .where((PlaceModel item) =>
        item.title.toLowerCase().contains(input.toLowerCase()) &&
            input.isNotEmpty)
            .map((PlaceModel filterItem) => ListTile( // Build a list tile for each suggestion.
            title: Text(filterItem.title),
            onTap: () { // Called when a suggestion is tapped.
              searchCtrl.closeView(filterItem.title); // Close the search view and set the text.
            }));
      },
    );
  }

  Widget categoryItemsWidget(Size size, List<CategoryModel> categories) {
    return SizedBox( // SizedBox for the category items.
      height: size.height * 0.11, // Set the height.
      width: size.width, // Occupy full width.
      child: ListView.builder( // ListView for the categories.
        padding: const EdgeInsets.symmetric(vertical: 8.0), // Padding around the list.
        scrollDirection: Axis.horizontal, // Scroll horizontally.
        itemCount: categories.isEmpty ? 1 : categories.length, // Number of items.
        physics: const BouncingScrollPhysics(), // Bouncing physics for scrolling.
        itemBuilder: (context, index) { // Builder for each item.
          return Padding( // Padding around each item.
            padding: EdgeInsets.only(
                right: (index == categories.length - 1) ? 0.0 : 24.0),
            child: categories.isEmpty // Show shimmer loading if categories are empty.
                ? SizedBox(
                width: size.width,
                child: const Center(child: Text("No room categories")))
                : Selector<ModelsProvider, int>( // Rebuilds when the selected category changes.
                selector: (_, provider) {
                  this.provider = provider; // Store the provider instance.
                  return provider.selectedCategory; // Return the selected category index.
                },
                builder: (BuildContext context, int category, Widget? child) { // Builder for each category item.
                  return GestureDetector( // Makes the item tappable.
                      onTap: () {
                        provider.changeCategory(index); // Change the selected category.
                      },
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start, // Align to top.
                        mainAxisSize: MainAxisSize.max, // Max size.
                        crossAxisAlignment: CrossAxisAlignment.center, // Center horizontally.
                        children: [
                          SizedBox( // Container for the category image.
                            height: 36,
                            width: 36,
                            child: Center(
                              child: ImageNetwork(
                                  provider.selectedCategory == index // Highlight if selected.
                                      ? AppColors.redAccentColor
                                      : Colors.black38,
                                  src: categories[index].image,
                                  errorIcon: const Icon(Icons.category))
                            ),
                          ),
                          Text( // Category title.
                            categories[index].title.isNotEmpty
                                ? categories[index].title
                                : "NA",
                            style: TextStyle( // Text styling.
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: provider.selectedCategory == index // Highlight if selected.
                                  ? AppColors.redAccentColor
                                  : Colors.black38,
                            ),
                          ),
                          if (provider.selectedCategory == index) // Show divider if selected.
                            const SizedBox(
                              width: 50,
                              child: Divider(
                                color: AppColors.redColor,
                                thickness: 2.0,
                              ),
                            )
                        ],
                      ));
                }),
          );
        },
      ),
    );
  }

  Widget priceCard(Size size, bool switchValue) {
    return Container(
      padding: const EdgeInsets.all(16.0), // Padding inside the card.
      margin: const EdgeInsets.only(bottom: 16.0, top: 2.0), // Margin around the card.
      decoration: BoxDecoration(
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Colors.black26,
              blurRadius: 7,
              spreadRadius: 1.0,
              offset: Offset(-7, 7),
            ),
          ],
          borderRadius: BorderRadius.circular(12.0),
          border: Border.all(color: AppColors.whiteColor, width: 2.0),
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.blue.shade300,
              Colors.lightGreenAccent.shade100
            ],
          )),
      child: Row( // Row for the text and the switch.
        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them apart.
        children: [
          const Column( // Column for the price text.
            crossAxisAlignment: CrossAxisAlignment.start, // Align text to the left.
            children: [
              Text(
                "Display total price",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                ),
              ),
              Text(
                "Included all fees, before taxes",
                style: TextStyle(
                  color: AppColors.whiteColor,
                  fontSize: 14,
                ),
              )
            ],
          ),
          Switch( // Switch to toggle price display.
            activeColor: Colors.lightGreenAccent.shade100, // Color when active.
            activeTrackColor: Colors.blue.shade300, // Track color when active.
            inactiveThumbColor: Colors.lightGreenAccent.shade100, // Color when inactive.
            inactiveTrackColor: Colors.blue.shade300, // Track color when inactive.
            trackOutlineColor: const WidgetStatePropertyAll(AppColors.whiteColor), // Outline color.
            value: switchValue, // Current value of the switch.
            onChanged: (value) { // Called when the switch is changed.
              provider.switchChange(); // Call the switchChange method to update the state.
            },
          )
        ],
      ),
    );
  }

  // Builds the shimmer loading card.
  Widget _buildShimmerLoading(Size size) {
    return Column(
      children: List.generate(8, (index){
      return Card( // Card for shimmer loading.
        elevation: 12.0,
        shape: RoundedRectangleBorder( // Rounded corners.
            borderRadius: BorderRadius.circular(21.0),
            side: const BorderSide(color: AppColors.whiteColor)),
        // White border.
        color: Theme
            .of(context)
            .scaffoldBackgroundColor,
        // Background color.
        shadowColor: AppColors.blackColor,
        // Shadow color.
        margin: const EdgeInsets.only(bottom: 12.0),
        // Margin at the bottom.
        child: ShimmerLoading( // Shimmer loading effect.
            child: Column( // Column to arrange shimmer elements.
              mainAxisSize: MainAxisSize.min,
              // Minimize the column size.
              crossAxisAlignment: CrossAxisAlignment.start,
              // Align children to the left.
              mainAxisAlignment: MainAxisAlignment.start,
              // Align children to the top.
              children: [
                Container( // Shimmer loading container for the image.
                  height: size.height * 0.3, // 30% of screen height.
                  width: size.width, // Full screen width.
                  decoration: const BoxDecoration( // Styling.
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.vertical(
                          top: Radius.circular(21))), // Rounded top corners.
                ),
                Container( // Shimmer loading container for the text and icons.
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 12.0), // Padding.
                  margin: const EdgeInsets.all(8.0), // Margin.
                  child: Row( // Row to arrange shimmer elements.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    // Space them evenly.
                    mainAxisSize: MainAxisSize.max,
                    // Occupy maximum size.
                    crossAxisAlignment: CrossAxisAlignment.start,
                    // Align to the top.
                    children: [
                      Expanded( // Expand the text placeholders.
                          child: Column( // Column for text placeholders.
                            mainAxisAlignment: MainAxisAlignment.start,
                            // Align to the top.
                            crossAxisAlignment: CrossAxisAlignment.start,
                            // Align to the left.
                            mainAxisSize: MainAxisSize.min,
                            // Minimize size.
                            children: [
                              _buildShimmerText(size, 0.3),
                              SizedBox(height: size.height * 0.01), // Spacing.
                              _buildShimmerText(size, 0.4),
                              SizedBox(height: size.height * 0.01), // Spacing.
                              _buildShimmerText(size, 0.2),
                            ],
                          )),
                      Column( // Column for icon placeholders.
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        // Space them evenly.
                        mainAxisSize: MainAxisSize.min,
                        // Minimize size.
                        crossAxisAlignment: CrossAxisAlignment.center,
                        // Center horizontally.
                        children: [
                          _buildShimmerText(size, 0.2),
                          SizedBox(height: size.height * 0.01), // Spacing.
                          Container( // Shimmer loading container for icon.
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration( // Styling.
                              color: Colors.black,
                              borderRadius: BorderRadius.circular(90),
                              // Circular.
                              border: Border.all(
                                  color: AppColors.peachColor,
                                  width: 2.0), // Border.
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                )
              ],
            )),
      );
      })
    );
  }

  Widget _buildCategoryShimmer(Size size){
    return SizedBox( // SizedBox for the category items.
        height: size.height * 0.11, // Set the height.
        width: size.width, // Occupy full width.
        child: ListView.builder( // ListView for the categories.
            padding: const EdgeInsets.symmetric(vertical: 8.0), // Padding around the list.
            scrollDirection: Axis.horizontal, // Scroll horizontally.
            itemCount: 8, // Number of items.
            physics: const BouncingScrollPhysics(), // Bouncing physics for scrolling.
            itemBuilder: (context, index) {
              return Padding(
                padding: EdgeInsets.only(
                    right: (index ==  7) ? 0.0 : 24.0),
                child: ShimmerLoading( // Shimmer loading effect.
                    child: Container(
                      height: size.height * 0.08,
                      width: 52,
                      margin: const EdgeInsets.symmetric(
                          vertical: 6.0),
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(
                              5.0)),
                    )),
              );
            }));
  }

// Helper function to build shimmer text placeholders
  Widget _buildShimmerText(Size size, double widthFactor) {
    return Container(
      height: 16,
      width: size.width * widthFactor,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
      ),
    );
  }
}
