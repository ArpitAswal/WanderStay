## App Logo
Click on a logo to download the latest version of the app apk file:

<a href="https://github.com/ArpitAswal/WanderStay/releases/download/v1.0.0/WanderStay.apk"> ![app_logo](https://github.com/user-attachments/assets/ca738837-3753-4ffb-ab1b-4e7413f39179)
</a>

# Project Title: WanderStay

WanderStay is a prototype application designed to provide users with an immersive experience of discovering and reserving stay places, similar to Airbnb. The current version is a beta release intended for user experience testing and feedback collection. All data is managed statically using Firebase services, including authentication and Firestore for data storage.

The app allows users to search and explore rental stay places listed by vendors for various occasions such as holiday getaways, festive seasons, or weekend retreats. Additionally, it features an interactive Google Map that displays available stay locations with markers, making it easier for users to find and evaluate places based on their preferred locations.

## Features

#### Explore Screen

- Displays a list of stay places with essential details, including images, vendor profile, availability date, address, and price per night.

- Provides a search functionality with search suggestions, allowing users to find specific locations effortlessly.

- Categorized listings such as Surfing activity stays, Wooden houses, Amazing view places, Houseboats, etc.

#### Map Screen

- Integrated Google Map displaying location markers for available places, allowing users to visually identify service coverage areas.

- Tapping on a marker reveals essential details like images, addresses, and ratings in a pop-up window.

#### Profile (Account) Screen

- Users must sign in via phone number, email, Google, or Facebook authentication (managed by Firebase) to access full features.

- Displays personal information, security settings, payment and payout options, and a feedback section.

#### Wishlist Screen

- Allows users to see their favourite stay places for future reference.

- Helps users plan and compare multiple locations before making a reservation decision.

#### Message Screen

Contains chat sections where users can communicate with:

- Support Team (for help and queries)

- Friends (to share stay details or plan trips together)

- Vendors (to inquire about availability or additional details)

- WanderStay Service Team

(These five screens are are main screens and managed via a bottom navigation bar)

#### Place Detail Screen

- Displays comprehensive information when a user selects a stay place from Explore, Wishlist, or Google Maps.

- Includes place images, addresses, ratings, reviews, service lists, vendor descriptions, and map location.

## Challenges

- Ensuring seamless UI/UX to enhance user engagement and app approval for further development.

#### Future Challenges

- Managing real-time data from APIs while maintaining performance and responsiveness.

- Handling user location tracking for navigation from source to destination.

- Securely integrating a payment gateway for hassle-free reservations.

## Future Enhancements

#### API Integration

- Replacing static Firebase data with dynamically fetched data from APIs for real-time listings and updates.

- Optimizing UI to adapt based on user interactions.

#### Real-Time User Location Tracking

- Implementing features to track users from source to destination with optimized travel paths.

- Enhancing map functionalities for a better navigational experience.

#### Payment Gateway Implementation

- Ensuring secure and smooth transactions between users and WanderStay service accounts.

- Allowing users to reserve places by selecting available dates and making payments.

## Installation

To run this project locally:

- Clone the repository:
  git clone https://github.com/ArpitAswal/WanderStay.git

- Navigate to the project directory:
  cd WanderStay

- Install dependencies:
  flutter pub get

- Set up the Google API Key at Manifest file and the required permissions

- Run the app:
  flutter run

## Note

- This is a prototype application that currently displays static data from Firebase.

- The primary goal is to test user experience, interface design, and core functionality before moving towards a fully functional production app.

- User has to provide the access of getting location to get the Google Map service on app, so they can easily see the stay locations and their current location.

- we have to link the google and email provider to sign in with same email and by sign in with facebook I don't have a access of getting a email so I built a temporary logic with the help of shared preferences.

## Usage Flow

#### Launch App:

- Displays the SplashScreen with the app logo, name, and motto.

https://github.com/user-attachments/assets/9a289c0d-5b23-4b84-b49e-70d76397a4a3

#### Guest Access (Without Sign-In):

- Users can only access the Explore Screen (limited functionality) and the Account Screen (for sign-in/sign-up options).
  
- Limited access prevents users from viewing full location details, using search functionality, or checking reservation status.
  
  ![photo_2_2025-02-10_16-40-53](https://github.com/user-attachments/assets/2d6cbb46-104a-4cf4-a06e-e09e19170cb8)

  https://github.com/user-attachments/assets/7ae1328b-45b4-4b25-b175-91e4b437506c
  
  ![photo_2025-02-10_16-47-22](https://github.com/user-attachments/assets/655c1e67-fd44-4b39-8af7-3080e17112e8)

#### After Sign-In:

- Users gain access to the five main screens (Explore, Wishlist, Google Map, Messages, Profile).

- Viewing Stay Locations on Google Maps by tapping on a markers

https://github.com/user-attachments/assets/f6f6e7a2-520b-44a3-a335-9e7c3be4447b

![photo_3_2025-02-10_16-40-53](https://github.com/user-attachments/assets/539b7087-c5b6-4d72-a311-17d99817f6a3)

![photo_4_2025-02-10_16-40-53](https://github.com/user-attachments/assets/0a4475a7-e43d-424a-82bc-dd679d7be528)

![photo_2025-02-10_16-55-16](https://github.com/user-attachments/assets/c45bd87e-3bdc-4ddb-a9ff-a674a340cece)

https://github.com/user-attachments/assets/2b64408e-0641-4cf4-97eb-1a6abac07f99

https://github.com/user-attachments/assets/b7761718-6586-45e5-80ea-a65cd9fc26eb

#### Viewing Place Details:

- Users can access the Place Detail Screen by selecting a stay place from Explore and Wishlist.

https://github.com/user-attachments/assets/1b443f9e-7fe2-40a7-82f1-7cb289854351

## Tech Stack

- Flutter: The primary framework for building the mobile application.

- Dart: The programming language used with Flutter.

- Google Map Key: To run the map on devices.

- Firebase: To provide the Authentication and Firestore database service

## Packages Used

-  cupertino_icons: ^1.0.8 # Provides Cupertino (iOS-style) icons for Flutter apps.
-  google_maps_flutter: ^2.9.0 # A Flutter plugin for integrating Google Maps into your application.
-  another_carousel_pro: ^1.0.2 # A carousel widget for displaying a scrollable list of images or other widgets.
-  custom_info_window: ^1.0.1 # A package for creating custom info windows for markers on Google Maps.
-  firebase_core: ^3.6.0 # The core Firebase SDK for Flutter, required for other Firebase services.
-  cloud_firestore: ^5.4.4 # A Flutter plugin for using Cloud Firestore, a NoSQL database from Firebase.
-  firebase_auth: ^5.3.1 # A Flutter plugin for Firebase Authentication, allowing user sign-up and sign-in.
-  google_sign_in: ^6.2.1 # A Flutter plugin for integrating Google Sign-In into your app.
-  provider: ^6.1.2 # A package for state management in Flutter, making it easy to share data and rebuild widgets.
-  flutter_plugin_android_lifecycle: ^2.0.24 # A plugin to access Android lifecycle events from Flutter.
-  persistent_bottom_nav_bar: ^6.2.1 # A customizable persistent bottom navigation bar for Flutter apps.
-  animated_text_kit: ^4.2.3 # A package for creating various text animations in Flutter.
-  google_fonts: ^6.2.1 # A package for easily using Google Fonts in your Flutter applications.
-  flutter_rating_bar: ^4.0.1 # A widget for displaying and interacting with a rating bar.
-  location: ^6.0.1 # A package for accessing device location services in Flutter.
-  flutter_circular_text: ^0.3.1 # A widget for displaying text along a circular path.
-  marquee: ^2.3.0 # A widget for creating scrolling text (marquee effect) in Flutter.
-  encrypt_shared_preferences: ^0.8.7 # A package for encrypting data stored in shared preferences.
- flutter_facebook_auth: ^7.1.1 # A Flutter plugin for integrating Facebook Authentication.
-  cached_network_image: ^3.4.1 # A package for displaying and caching network images in Flutter.
-  shimmer: ^3.0.0 # A package for adding shimmer (loading) effects to widgets in Flutter.
-  animate_do: ^3.3.7 # A package for easily adding various animations to widgets in Flutter.
-  geolocator: ^13.0.2 # A package for retrieving the user's geolocation in Flutter.

## Feedback

- If you have any feedback, please reach out to me at arpitaswal995@gmail.com

- If you face an issue, then open an issue in a GitHub repository.

## Contributing

Contributions are always welcome!

#### Fork the Repository:

- Go to the original repository on GitHub or GitLab.
- Click the "Fork" button. This creates a copy of the repository under your own account.

#### Create a New Branch:
- Clone your forked repository to your local machine: git clone <your_fork_url>
- Create a new branch for your feature: git checkout -b feature-branch
- Replace feature-branch with a descriptive name for your changes (e.g., fix-bug, add-feature).

#### Make Changes and Commit:
- Make the necessary changes to the code in your local feature-branch.
- Stage the changes: git add <files> (or git add . to stage all changes)
- Commit the changes with a clear message: git commit -m "Add new feature"
- Use a descriptive and concise message that explains the changes.

#### Push Changes to Your Fork:
- Push your feature-branch to your remote repository: git push origin feature-branch

#### Create a Pull Request:
- Go back to the original repository on GitHub or GitLab.
- Click the "New Pull Request" button.
- Select your feature-branch as the source and the original repository's main or develop branch as the target.
- Provide a clear description of your changes and why they are needed.
- Submit the pull request.


## Conclusion

WanderStay is an innovative concept designed to bridge the gap between travellers and hosts, offering an efficient and visually engaging experience. While the current version is a prototype, future enhancements will make it a robust, real-time booking platform that meets industry standards. Stay tuned for upcoming updates!
