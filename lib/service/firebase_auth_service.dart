import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:wander_stay/service/shared_preference_service.dart';
import 'package:wander_stay/utils/singleton/snackbar.dart';

class FirebaseAuthServices {
  late FacebookAuth _fbInstance; // Instance of FacebookAuth
  late GoogleSignIn _googleSignIn; // Instance of GoogleSignIn
  late List<String> _providers; // List to store linked providers
  User? auth; // Current authenticated user

  final SharedPreferenceService _pref = SharedPreferenceService(); // Instance of SharedPreferenceService

  // Singleton instance
  static final FirebaseAuthServices _instance = FirebaseAuthServices._internal();
  FirebaseAuthServices._internal(); // Private constructor
  factory FirebaseAuthServices() => _instance; // Factory constructor

  // Updates the auth state based on the current user.
  void authState() {
    auth = FirebaseAuth.instance.currentUser; // Get current user from Firebase Auth
  }

  // Signs in with Google.
  Future<void> signInWithGoogle() async {
    try {
      _googleSignIn = GoogleSignIn(); // Initialize GoogleSignIn
      await _googleSignIn.signOut(); // Sign out to force account selection
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn(); // Sign in with Google
      UserCredential result = await googleCredential(googleSignInAccount); // Get user credential
      if (result.user != null) {
        _pref.dataInitialize(email: result.user!.email); // Initialize shared preferences
        await emailLinkOrNot(user: result.user!, sourceProvider: "google"); // Link with email provider if possible
      }
    } catch (e) {
      rethrow; // Re-throw the exception
    }
  }

  // Signs in with Facebook.
  Future<void> signInWithFacebook() async {
    _fbInstance = FacebookAuth.instance; // Initialize FacebookAuth
    LoginResult result = await _fbInstance.login(); // Login with Facebook

    switch (result.status) {
      case LoginStatus.success: // Successful login
        try {
          final OAuthCredential facebookAuthCredential = // Create Facebook credential
          FacebookAuthProvider.credential(result.accessToken!.tokenString);
          final UserCredential userCredential = await FirebaseAuth.instance // Sign in with Facebook credential
              .signInWithCredential(facebookAuthCredential);

          _pref.dataInitialize(email: userCredential.user!.email); // Initialize shared preferences
          await _pref.setUserInfo(authUser: userCredential.user!, provider: "facebook"); // Save user info
        } on FirebaseAuthException catch (e) {
          // Handle Firebase Auth exceptions
          if (e.code == 'account-exists-with-different-credential') {
            throw ("account already exist");
          } else if (e.code == 'invalid-credential') {
            throw ("The supplied auth credential is incorrect, malformed or has expired.");
          }
        } catch (e) {
          rethrow; // Re-throw the exception
        }
        break;
      case LoginStatus.cancelled: // Login cancelled
        throw ('User cancelled login.');
      case LoginStatus.failed: // Login failed
        throw ('Facebook login failed: ${result.message}');
      case LoginStatus.operationInProgress: // Login in progress
        break;
    }
  }

  // Handles email account authentication.
  Future<void> emailAccountAuth({required String email, required String password}) async {
    try {
      _pref.dataInitialize(email: email); // Initialize shared preferences
      if (_pref.data[email] != null) {
        _providers = (_pref.data[email]['linkProviders'] as List<dynamic>).cast<String>(); // Get linked providers
      }

      if (!_pref.sharedPref.getKeys().contains(email) || (_providers.length == 1 && _providers.contains("facebook"))) {
        // Create account if not exists or only linked with Facebook
        final authResponse = await FirebaseAuth.instance.createUserWithEmailAndPassword( // Create user with email and password
          email: email,
          password: password,
        );
        if (authResponse.user != null) {
          await _pref.setUserInfo(authUser: authResponse.user!, pass: password, provider: "email"); // Save user info
        }
      } else if (_providers.contains("google") && !_providers.contains("email")) {
        // Link with email if linked with Google but not email
        final credential = EmailAuthProvider.credential(email: email, password: password);
        await silentSignIn(credential, password); // Silent sign in to link providers
      } else {
        // Sign in with email and password
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      if (e.code == 'weak-password') {
        throw ('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        throw ('The account already exists for that email.');
      } else if (e.code == 'INVALID_LOGIN_CREDENTIALS') {
        throw 'Invalid login credentials.';
      } else if (e.code == 'invalid-credential') {
        throw 'The supplied auth credential is incorrect, malformed or has expired.';
      } else if (e.code == 'provider-already-linked') {
        return; // Already linked, no need to do anything
      } else {
        throw (e.message.toString());
      }
    } catch (e) {
      rethrow; // Re-throw the exception
    }
  }

  // Links email provider with other providers if possible.
  Future<void> emailLinkOrNot({required User user, required String sourceProvider}) async {
    try {
      final info = _pref.data;
      if (info[user.email] != null) {  // check that user information is saved already in the shared preference by authentication email
        _providers = (info[user.email]['linkProviders'] as List<dynamic>).cast<String>(); // extract all the link providers with same authentication email
        if (info[user.email]["password"] != null && !_providers.contains(sourceProvider)) { // if the password is not null and google provider is not exist from linkProvider that means the email and google provider not linked up yet by same authentication email
          final AuthCredential emailCredential = EmailAuthProvider.credential(
            email: user.email!,
            password: info[user.email]['password'],
          );
          FirebaseAuth.instance.currentUser?.linkWithCredential(emailCredential); // link the google and email provider
        }
        await _pref.setUserInfo(authUser: user, provider: sourceProvider);
      } else {
        await _pref.setUserInfo(authUser: user, provider: sourceProvider);
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      switch (e.code) {
        case "provider-already-linked":
          throw ("The provider has already been linked to the user.");
        case "invalid-credential":
          throw ("The provider's credential is not valid.");
        case "credential-already-in-use":
          throw ("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
      }
    } catch (e) {
      rethrow; // Re-throw the exception
    }
  }

  // Performs silent sign-in to link providers.
  Future<void> silentSignIn(AuthCredential credential, String password) async {
    try {
      _googleSignIn = GoogleSignIn();
      GoogleSignInAccount? googleUser = await _googleSignIn.signInSilently(); // Attempt silent sign-in
      googleUser ??= await _googleSignIn.signIn(); // If silent fails, prompt for sign-in
      UserCredential result = await googleCredential(googleUser); // Get user credential
      if (result.user != null) {
        await auth?.linkWithCredential(credential); // Link the credentials
        await _pref.setUserInfo(authUser: result.user!, pass: password, provider: "email"); // Save user info
      }
    } on FirebaseAuthException catch (e) {
      // Handle Firebase Auth exceptions
      switch (e.code) {
        case "provider-already-linked":
          throw ("The provider has already been linked to the user.");
        case "invalid-credential":
          throw ("The provider's credential is not valid.");
        case "credential-already-in-use":
          throw ("The account corresponding to the credential already exists, "
              "or is already linked to a Firebase User.");
      }
    } catch (e) {
      rethrow; // Re-throw the exception
    }
  }

  // Gets Google user credential.
  Future<UserCredential> googleCredential(GoogleSignInAccount? googleSignInAccount) async {
    if (googleSignInAccount == null) {
      throw ("Google sign-in aborted."); // Throw exception if no account is selected
    }
    final GoogleSignInAuthentication googleSignInAuthentication = // Get Google auth details
    await googleSignInAccount.authentication;
    final AuthCredential authCredential = GoogleAuthProvider.credential( // Create Google credential
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken);
    return await FirebaseAuth.instance.signInWithCredential(authCredential); // Sign in with credential
  }

  // Signs out the current user.
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // Sign out from Firebase Auth
      _pref.data.clear();                   // Clear shared preferences
    } catch (e) {
      SingletonSnackbar().showSnackbar("Sign out failed: $e"); // Throw exception if sign out fails
    }
  }
}
