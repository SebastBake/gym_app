import 'package:flutter/material.dart';
import 'package:gym_app/components/blank.dart';
import 'package:gym_app/components/error.dart';
import 'package:gym_app/components/exercises.dart';
import 'package:gym_app/components/home.dart';
import 'package:gym_app/components/new_session.dart';
import 'package:gym_app/components/signin_or_register.dart';
import 'package:gym_app/routes.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/services/exercises.dart';

import 'components/loading.dart';

main() => runApp(_App());

class _App extends StatelessWidget {
  @override
  build(context) => MaterialApp(
        title: 'Workout Log',
        theme: ThemeData.light(),
        themeMode: ThemeMode.system,
        darkTheme: ThemeData.dark(),
        initialRoute: Routes.index,
        onUnknownRoute: (routeSettings) => MaterialPageRoute(
          builder: (context) =>
              ErrorScreen(debugMessage: 'The page could not be found.'),
        ),
        routes: {
          /// Handler for the index route
          Routes.index: (context) => AuthenticationBloc(
                signedIn: (context, state) => HomeScreen(authState: state),
                signedOut: (context, state) =>
                    SignInOrRegisterScreen(authState: state),
                error: (context) => BlankScreen(),
                loading: (context, state) {
                  if (state is AuthLoadingCurrentUser) {
                    return Loading(text: 'Authorising');
                  }

                  if (state is AuthSigningIn) {
                    return Loading(text: 'Signing In');
                  }

                  if (state is AuthSigningOut) {
                    return Loading(text: 'Signing Out');
                  }

                  return BlankScreen();
                },
              ),

          /// Handler for the exercises route
          Routes.exercises: (context) => AuthenticationBloc(
                error: (context) => BlankScreen(),
                signedIn: (context, authState) => ExerciseFactoryBloc(
                  userId: authState.userId,
                  child: ExerciseQueryBloc(
                    userId: authState.userId,
                    loading: (_) => Loading(text: 'Loading exercises...'),
                    ready: (_, exerciseData) =>
                        ExercisesScreen(exercises: exerciseData),
                  ),
                ),
                signedOut: (context, state) => BlankScreen(),
                loading: (context, state) => BlankScreen(),
              ),

          /// Handler for the session route
          Routes.session: (context) => const SessionScreen(),
        },
      );
}
