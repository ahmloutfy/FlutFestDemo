import 'package:flutfest/core/bindings/event_binding.dart';
import 'package:flutfest/logic/models/event_model.dart';
import 'package:flutfest/views/events/screens/create_event_screen.dart';
import 'package:flutfest/views/home/screens/home_screen.dart';
import 'package:flutfest/views/login/login_screen.dart';
import 'package:flutfest/views/register/register_screen.dart';
import 'package:flutfest/views/welcome/welcome_screen.dart';
import 'package:get/get.dart';
import 'views/details/event_details_screen.dart';
import 'views/edit_profile/edit_profile_screen.dart';
import 'views/forgot_password/forgot_password_screen.dart';
import 'views/help_support/help_suppport_screen.dart';
import 'views/notifications/notifications_screen.dart';
import 'views/pick_location/pick_location_screen.dart';
import 'views/search/search_screen.dart';
import 'views/settings/settings_screen.dart';

class Routes {
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String createEvent = '/create-event';
  static const String eventDetails = '/event-details';
  static const String notifications = '/notifications';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String helpSupport = '/help-support';
  static const String search = '/search';
  static const String forgotPassword = '/forgot-password';
  static const String pickLocation = '/pick-location';
  static const String editEvent = '/edit-event';


  static List<GetPage> pages = [
    GetPage(
      name: Routes.editEvent,
      page: () => CreateEventScreen(event: Get.arguments),
      binding: CreateEventBinding(),
    ),
    GetPage(
      name: pickLocation,
      page: () => PickLocationScreen(),
    ),

    GetPage(name: welcome, page: () => const WelcomeScreen()),
    GetPage(name: login, page: () => const LoginScreen()),
    GetPage(name: register, page: () => const RegisterScreen()),
    GetPage(
      name: home,
      page: () => HomeScreen(),
      binding: EventBinding(),
    ),
    GetPage(
      name: createEvent,
      page: () => CreateEventScreen(),
      binding: CreateEventBinding(),
    ),
    GetPage(
      name: eventDetails,
      page: () {
        final event = Get.arguments as EventModel;
        return EventDetailsScreen(event: event);
      },
      binding: EventBinding(),
    ),
    GetPage(
      name: notifications,
      page: () => const NotificationsScreen(),
    ),
    GetPage(
      name: editProfile,
      page: () => EditProfileScreen(),
    ),
    GetPage(
      name: settings,
      page: () => SettingsScreen(),
    ),
    GetPage(
      name: helpSupport,
      page: () => const HelpSupportScreen(),
    ),
    GetPage(
      name: search,
      page: () => SearchScreen(),
    ),
    GetPage(
      name: forgotPassword,
      page: () => ForgotPasswordScreen(),
    ),
  ];
}
