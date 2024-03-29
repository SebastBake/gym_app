import 'package:flutter/material.dart';
import 'package:gym_app/components/error.dart';
import 'package:gym_app/components/exercises.dart';
import 'package:gym_app/components/home.dart';
import 'package:gym_app/components/new_session.dart';
import 'package:gym_app/components/sessions.dart';
import 'package:gym_app/components/signin_or_register.dart';
import 'package:gym_app/routes.dart';
import 'package:gym_app/services/auth.dart';

main() {
  runApp(_App());
}

class _App extends StatelessWidget {
  @override
  build(context) => MaterialApp(
        title: 'Workout Log',
        theme: ThemeData.dark(),
        initialRoute: Routes.index,
        onUnknownRoute: (routeSettings) => MaterialPageRoute(
          builder: (context) =>
              ErrorScreen(debugMessage: 'The page could not be found.'),
        ),
        routes: {
          /////////////////////////////////////////////////
          /// Handler for the index route
          ///
          Routes.index: (context) => AuthenticationBloc(
                signedIn: (context, state) => HomeScreen(authState: state),
                signedOut: (context, state) =>
                    SignInOrRegisterScreen(authState: state),
              ),

          /////////////////////////////////////////////////
          /// Handler for the exercises route
          ///
          Routes.exercises: (context) => const ExercisesScreen(),

          /////////////////////////////////////////////////
          /// Handler for the index route
          ///
          Routes.sessionList: (context) {
            final authState = _getAuthState(context);
            return SessionsScreen(authState: authState);
          },

          /////////////////////////////////////////////////
          /// Handler for the session route
          ///
          Routes.session: (context) => const SessionScreen(),
        },
      );
}

AuthSignedIn _getAuthState(BuildContext context) {
  final route = ModalRoute.of(context);
  final args = route.settings.arguments;
  if (args is AuthSignedIn) {
    return args;
  }
  throw Exception("Cannot find auth state!");
}
