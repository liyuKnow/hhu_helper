import 'package:flutter/material.dart';
import 'package:hhu_helper/src/widgets/screens/screens.dart';

class Routes {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    final args = settings.arguments;
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeScreen());

      case '/reading':
        return MaterialPageRoute(
          builder: (_) => const ReadingScreen(),
        );

      // case '/camera':
      //   return MaterialPageRoute(
      //     builder: (_) => const CameraScreen(cameras : args),
      //   );

      case '/qr':
        return MaterialPageRoute(
          builder: (_) => const QRScreen(),
        );
      case '/edit_reading':
        return MaterialPageRoute(
          builder: (_) => const ReadingScreen(),
        );

      // case '/gallery':
      //   return MaterialPageRoute(
      //     builder: (_) => const ReadingScreen(),
      //   );

      default:
        return _errorRoute();
    }
  }

  static Route<dynamic> _errorRoute() {
    return MaterialPageRoute(builder: (_) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Error'),
        ),
        body: const Center(
          child: Text('ERROR'),
        ),
      );
    });
  }
}





// case '/edit_user':
      //   if (args is int) {
      //     return MaterialPageRoute(
      //         builder: (_) => EditUserScreen(
      //               userId: args,
      //             ));
      //   }
      //   return _errorRoute();