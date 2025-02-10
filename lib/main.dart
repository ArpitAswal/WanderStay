import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_circular_text/circular_text/model.dart';
import 'package:flutter_circular_text/circular_text/widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:wander_stay/utils/colors/app_colors.dart';
import 'package:wander_stay/view/home_screen.dart';
import 'package:wander_stay/view_model/condition_provider.dart';
import 'package:wander_stay/view_model/favourite_provider.dart';
import 'package:wander_stay/view_model/message_provider.dart';
import 'package:wander_stay/view_model/models_provider.dart';

import 'firebase_options.dart';

void main() async {
  // Ensure Flutter bindings are initialized. This is crucial for Firebase initialization.
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize Firebase. This sets up the connection to your Firebase project.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  // This starts the Flutter application. MyApp is the root widget of the application.
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider allows you to provide multiple providers (for state management) to the widget tree.
    return MultiProvider(
      providers: [
        // ChangeNotifierProvider creates and provides an instance of Provider Class.
        ChangeNotifierProvider(create: (_) => ConditionProvider()),
        ChangeNotifierProvider(create: (_) => ModelsProvider()),
        ChangeNotifierProvider(create: (_) => FavouriteProvider()),
        ChangeNotifierProvider(create: (_) => MessageProvider()),
      ],
      child: MaterialApp(
        // MaterialApp is the base widget for a Material Design app.
        title: 'WanderStay',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          // Defines the overall theme of the app.
          useMaterial3: true,
          scaffoldBackgroundColor: Colors.white,
          primaryColor: AppColors.peachColor,
          fontFamily: 'RobotoSerif',
          focusColor: AppColors.peachColor,
          textSelectionTheme:
              const TextSelectionThemeData(cursorColor: AppColors.peachColor),
          appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.peachColor,
              centerTitle: true,
              titleTextStyle:
                  TextStyle(fontSize: 21.0, fontWeight: FontWeight.bold)),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.redAccentColor,
                foregroundColor: AppColors.whiteColor,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                  side:
                      const BorderSide(color: AppColors.whiteColor, width: 2.0),
                ),
                shadowColor: AppColors.peachColor,
                minimumSize: const Size(double.infinity, 48),
                maximumSize: const Size(double.infinity, 48),
                elevation: 12.0,
                textStyle: const TextStyle(
                    fontFamily: 'RobotoSerif',
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold),
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(horizontal: 8.0, vertical: 10.0),
                iconColor: AppColors.blackColor),
          ),
        ),
        home: const SplashScreen(),
      ),
    );
  }
}

// SplashScreen is the initial screen of the app. It's a StatefulWidget because it manages animation state.
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  // Mixin for animation controller.
  late AnimationController
      _controller; // Animation controller for the splash screen animations.
  late Animation<double> _fadeAnimation; // Fade-in animation for the logo.
  late Animation<Offset> _logoAnimation; // Slide-up animation for the logo.
  late Animation<double>
      _textScaleAnimation; // Scale animation for the circular text.

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller with a duration of 2 seconds.
    _controller = AnimationController(
      vsync: this, // vsync is required for the animation controller.
      duration: const Duration(seconds: 1),
    );

    // Create a fade-in animation for the logo.
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
          parent: _controller,
          curve: const Interval(0.0, 1.0, curve: Curves.easeInOut)),
    );

    // Create a slide-up animation for the logo.
    _logoAnimation =
        Tween<Offset>(begin: const Offset(0, 1.0), end: Offset.zero).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Create a scale animation for the circular text.
    _textScaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Delay Animation Start Until Layout is Ready
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controller.forward();
    });

    // Navigate to the HomeScreen after 4 seconds.
    Timer(const Duration(seconds: 3), () {
      _controller.reverse().whenComplete(() {
        if (mounted) {
          // Check if the widget is still mounted to avoid errors.
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        }
      });
    });
  }

  @override
  void dispose() {
    _controller
        .dispose(); // Dispose of the animation controller to prevent memory leaks.
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Stack(alignment: Alignment.center, children: [
        ScaleTransition(
          scale: _textScaleAnimation,
          child: CircularText(
            children: [
              TextItem(
                text: Text(
                  "WanderStay".toUpperCase(),
                  style: GoogleFonts.bungeeShade(
                    letterSpacing: 5.0,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                    color: AppColors.peachColor,
                  ),
                ),
                space: 16,
                startAngle: -90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.clockwise,
              ),
              TextItem(
                text: Text(
                  "Stay Curious, Wander Often",
                  style: GoogleFonts.bebasNeue(
                    letterSpacing: 3.0,
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: AppColors.peachColor,
                  ),
                ),
                space: 4,
                startAngle: 90,
                startAngleAlignment: StartAngleAlignment.center,
                direction: CircularTextDirection.anticlockwise,
              ),
            ],
            radius: 105,
            position: CircularTextPosition.outside,
            backgroundPaint: Paint()
              ..color = Theme.of(context).scaffoldBackgroundColor,
          ),
        ),
        SlideTransition(
          position: _logoAnimation,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: Image.asset(
              filterQuality: FilterQuality.high,
              fit: BoxFit.contain,
              'asset/images/app_logo.png', // Replace with your actual image path
              height: MediaQuery.of(context).size.height * 0.2,
              width: MediaQuery.of(context).size.width -
                  (MediaQuery.of(context).size.width * 0.3),
            ),
          ),
        )
      ]),
    ));
  }
}
