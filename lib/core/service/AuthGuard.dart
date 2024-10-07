import 'dart:html' as html;

import 'package:flutter/material.dart';

import 'AuthService.dart';

class AuthGuard extends StatefulWidget {
  final WidgetBuilder builder;

  const AuthGuard({Key? key, required this.builder}) : super(key: key);

  @override
  _AuthGuardState createState() => _AuthGuardState();
}

class _AuthGuardState extends State<AuthGuard> {
  bool _redirected = false;

  @override
  void initState() {
    super.initState();
    redirectToLoginIfNotAuthenticated();
  }

  Future<void> redirectToLoginIfNotAuthenticated() async {
    bool authenticated = await AuthService().isAuthenticated();
    if (!authenticated && !_redirected) {
      _redirected = true;
      // Store the requested route
      final currentRoute = ModalRoute.of(context)?.settings.name;
      html.window.localStorage['requestedRoute'] = currentRoute ?? '/Home';
      Navigator.pushReplacementNamed(context, '/Login');
    }
  }

  // Future<void> redirectToLoginIfNotAuthenticated() async {
  //   bool authenticated = await AuthService().isAuthenticated();
  //   if (!authenticated && !_redirected) {
  //     _redirected = true;
  //     Navigator.pushReplacementNamed(context, '/Login');
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: AuthService().isAuthenticated(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        return widget.builder(context);
      },
    );
  }
}

//
// class AuthCheck extends StatelessWidget {
//   final WidgetBuilder builder;
//
//   const AuthCheck({Key? key, required this.builder}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<bool>(
//       future: AuthService().isAuthenticated(),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         }
//         if (snapshot.hasData && snapshot.data == true) {
//           // If the user is authenticated, redirect to the home page
//           WidgetsBinding.instance.addPostFrameCallback((_) {
//             Navigator.pushReplacementNamed(context, path!);
//           });
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return builder(context);
//         }
//       },
//     );
//   }
// }

//
//
// class AuthCheck extends StatelessWidget {
//   final WidgetBuilder builder;
//
//   const AuthCheck({Key? key, required this.builder}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return FutureBuilder<void>(
//       future: localStorageEmpty(context),
//       builder: (context, snapshot) {
//         if (snapshot.connectionState == ConnectionState.waiting) {
//           return const Center(child: CircularProgressIndicator());
//         } else {
//           return builder(context);
//         }
//       },
//     );
//   }
//
//   Future<void> localStorageEmpty(BuildContext context) async {
//     bool authenticated = await AuthService().isAuthenticated();
//     if (authenticated) {
//       Navigator.pushReplacementNamed(context, path!);
//     }
//   }
// }

class AuthCheck extends StatelessWidget {
  final WidgetBuilder builder;

  const AuthCheck({Key? key, required this.builder}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
      future: localStorageEmpty(context),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return builder(context);
        }
      },
    );
  }

  Future<void> localStorageEmpty(BuildContext context) async {
    bool authenticated = await AuthService().isAuthenticated();
    if (authenticated) {
      // If the user is authenticated, redirect them to the home or dashboard route
      Navigator.pushReplacementNamed(context, '/Home'); // Redirect to the desired route
    } else {
      // Allow the user to continue to the login page
    }
  }
}
