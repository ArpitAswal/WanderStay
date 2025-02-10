import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/utils/widgets/image_network.dart';
import 'package:wander_stay/utils/widgets/shimmer_loading.dart';
import 'package:wander_stay/view_model/message_provider.dart';

import '../model/message_model.dart';
import '../utils/colors/app_colors.dart';

class MessageScreen extends StatefulWidget {
  const MessageScreen({super.key});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}

class _MessageScreenState extends State<MessageScreen> {
  final Set<int> _animatedIndices = {}; // Keep track of animated indices

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<MessageProvider>( // Use Consumer to rebuild when MessageProvider changes.
          builder: (BuildContext context, MessageProvider provider, Widget? child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0).copyWith(top: 10.0),
                  child: Text("Messages",
                      style: GoogleFonts.alkatra(
                          fontSize: 28, fontWeight: FontWeight.bold)),
                ),

                _buildMessageTypeBar(provider), // Call the extracted method.

                Expanded( // Expand the message list to fill available space.
                  child: ListView.builder(
                    itemCount: provider.isLoading ? 8 : provider.allMessages.isEmpty ? 1 : provider.allMessages.length, // to display the no of items when then all messages is empty or not.
                    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                    itemBuilder: (context, index) {
                      if (provider.isLoading) {
                        return _buildShimmerLoadingItem(context);
                      } else if (provider.allMessages.isEmpty) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height,
                          width: MediaQuery.of(context).size.width,
                          child: const Center(
                              child: Text("No messages done yet!")),
                        );
                      } else {
                        // Check if the item has already been animated
                        bool isAlreadyAnimated = _animatedIndices.contains(index);

                        // Build the message item with animation only if it hasn't been animated yet
                        Widget messageItem = _buildMessageItem(provider.allMessages[index]);

                        if (!isAlreadyAnimated) {
                          _animatedIndices.add(index); // Mark the item as animated

                          if (index % 2 == 0) {
                            messageItem = SlideInLeft(
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 1000),
                              child: messageItem,
                            );
                          } else {
                            messageItem = SlideInRight(
                              delay: const Duration(milliseconds: 100),
                              duration: const Duration(milliseconds: 1000),
                              child: messageItem,
                            );
                          }
                        }
                        return messageItem;
                      }// Build the message item.
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

// Builds the message type selection bar.
  Widget _buildMessageTypeBar(MessageProvider provider) {
    return SizedBox( // Use SizedBox to control the height of the ListView.
      height: MediaQuery.of(context).size.height * 0.08, // Set a specific height.
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0), // Padding around the ListView.
        scrollDirection: Axis.horizontal, // Make the list scroll horizontally.
        shrinkWrap: true, // Important: Set shrinkWrap to true to prevent unbounded height errors.
        itemCount: provider.messagesScreenType.length, // Number of message types length.
        itemBuilder: (BuildContext context, int index) {
          final isSelected = provider.typeIndex == index; // Store selection state for easier access.
          return InkWell( // Make the items tappable.
            onTap: () => provider.changeIndex(index), // Call provider to change the selected index.
            splashColor: Colors.transparent, // Splash color on tap.
            child: Container( // Container for each message type item.
              alignment: Alignment.center, // Center the text within the container.
              margin: const EdgeInsets.only(right: 12.0), // Margin to separate items.
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2), // Padding around the text.
              decoration: BoxDecoration( // Styling for the container.
                color: isSelected // Use ternary operator for concise color selection.
                    ? Colors.black
                    : Colors.black12.withOpacity(0.05),
                borderRadius: BorderRadius.circular(8), // Rounded corners.
              ),
              child: Text( // Text widget to display the message type.
                provider.messagesScreenType[index], // Get the message type from the provider.
                style: TextStyle( // Text styling.
                  color: isSelected // Use ternary operator for concise color selection.
                      ? Colors.white
                      : Colors.black,
                  fontWeight: FontWeight.w600, // Semi-bold font weight.
                ),
              ),
            ),
          );
        },
      ),
    );
  }

// Builds the shimmer loading item. Extracted for reusability.
  Widget _buildShimmerLoadingItem(BuildContext context) {
    return Container( // Container for the shimmer loading item.
      width: MediaQuery.of(context).size.width, // Occupy full width.
      margin: const EdgeInsets.only(bottom: 18.0), // Margin at the bottom.
      decoration: BoxDecoration( // Styling for the shimmer loading container.
        color: Theme.of(context).scaffoldBackgroundColor, // Background color.
        borderRadius: BorderRadius.circular(8.0), // Rounded corners.
        border: Border.all(color: AppColors.whiteColor, width: 2), // Border.
        boxShadow: const [ // Shadow.
          BoxShadow(
              color: Colors.black26,
              spreadRadius: 1.0,
              blurRadius: 4.0,
              offset: Offset(-5.0, 5.0))
        ],
      ),
      child: ShimmerLoading( // Shimmer loading effect.
          child: Row( // Row to arrange the shimmer elements.
            mainAxisAlignment: MainAxisAlignment.start, // Align to the start (left).
            children: [
              Container( // Container for the shimmer image placeholder.
                width: MediaQuery.of(context).size.width * 0.16, // 16% of screen width.
                height: MediaQuery.of(context).size.height * 0.08, // 8% of screen height.
                decoration: BoxDecoration( // Styling for the shimmer image placeholder.
                    color: AppColors.whiteColor,
                    borderRadius: BorderRadius.circular(8.0), // Rounded corners.
                    border: Border.all(color: Colors.black38, width: 2.0)), // Border.
              ),
              Expanded( // Expand the shimmer content to fill the remaining space.
                child: Padding( // Padding around the shimmer content.
                  padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
                  child: Column( // Column to arrange the shimmer text placeholders.
                    mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between elements.
                    crossAxisAlignment: CrossAxisAlignment.start, // Align to the start (left).
                    mainAxisSize: MainAxisSize.max, // Occupy maximum size.
                    children: [
                      Row( // Row for the top shimmer text placeholders.
                        mainAxisAlignment: MainAxisAlignment.spaceBetween, // Space them apart.
                        mainAxisSize: MainAxisSize.max, // Occupy maximum size.
                        crossAxisAlignment: CrossAxisAlignment.start, // Align to the start (left).
                        children: [
                          Container( // Shimmer text placeholder.
                            height: 16,
                            width: MediaQuery.of(context).size.width * 0.25, // 25% of screen width.
                            decoration: BoxDecoration( // Styling.
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12.0)), // Rounded corners.
                          ),
                          Container( // Shimmer text placeholder.
                            height: 16,
                            width: MediaQuery.of(context).size.width * 0.14, // 14% of screen width.
                            decoration: BoxDecoration( // Styling.
                                color: AppColors.whiteColor,
                                borderRadius: BorderRadius.circular(12.0)), // Rounded corners.
                          ),
                        ],
                      ),
                      SizedBox( // Spacing.
                        height: MediaQuery.of(context).size.height * 0.01,
                      ),
                      Container( // Shimmer text placeholder.
                        height: 16,
                        width: MediaQuery.of(context).size.width, // Full width.
                        decoration: BoxDecoration( // Styling.
                            color: AppColors.whiteColor,
                            borderRadius: BorderRadius.circular(12.0)), // Rounded corners.
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }

  // Builds an individual message item. Extracted for cleaner code.
  Widget _buildMessageItem(MessageModel message) {
    return Container( // Container for the individual message item.
      margin: const EdgeInsets.only(bottom: 18.0),
      decoration: BoxDecoration(
          color: AppColors.whiteColor,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(color: AppColors.darkPinkColor, width: 1.0),
          boxShadow: [ // Shadow.
            BoxShadow(
                color: AppColors.darkPinkColor.withOpacity(0.6), // Shadow color with opacity.
                spreadRadius: 1.0, // Shadow spread radius.
                blurRadius: 6.0, // Shadow blur radius.
                offset: const Offset(-5.0, 5.0) // Shadow offset.
            )
          ]
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start, // Align children to the start (left).
        children: [
          ClipRRect( // Clip the image to rounded corners.
            borderRadius: BorderRadius.circular(8.0), // Same radius as the container.
            child: SizedBox( // SizedBox to constrain the image size.
                width: MediaQuery.of(context).size.width * 0.16, // 16% of screen width.
                height: MediaQuery.of(context).size.height * 0.08, // 8% of screen height.
                child: ImageNetwork(null, // Placeholder for the image.
                    src: message.vendorImage, // Image URL from the message data.
                    errorIcon: const Icon(Icons.image_not_supported_rounded))), // Error icon if image fails to load.
          ),
          Expanded( // Expand the message content to fill the available space.
            child: Padding( // Padding around the message content.
              padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween, // Distribute space between name/date and description.
                crossAxisAlignment: CrossAxisAlignment.start, // Align text to the start (left).
                children: [
                  Row(
                    children: [
                      Text(message.name, // Vendor name.
                          maxLines: 1, // Limit to one line.
                          softWrap: true, // Allow text to wrap.
                          overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows.
                          style: GoogleFonts.alkatra(
                              fontSize: 21, fontWeight: FontWeight.w500)),
                      Flexible( // Flexible widget to push the date to the right.
                        child: Align( // Align the date to the right.
                          alignment: Alignment.centerRight,
                          child: Text(message.date, // Message date.
                              style: GoogleFonts.alkatra(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: Colors.black54)),
                        ),
                      ),
                    ],
                  ),
                  Text(message.description, // Message description.
                      maxLines: 1, // Limit to one line.
                      softWrap: true, // Allow text to wrap.
                      overflow: TextOverflow.ellipsis, // Add ellipsis if text overflows.
                      style: GoogleFonts.alkatra(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
