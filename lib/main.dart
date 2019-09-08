import 'package:flutter/material.dart';
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
          /// Handler for the index route
          ///
          Routes.sessionList: (context) => AuthenticationBloc(
                signedIn: (context, state) => SessionsScreen(authState: state),
                signedOut: (context, state) =>
                    SignInOrRegisterScreen(authState: state),
              ),

          /////////////////////////////////////////////////
          /// Handler for the session route
          ///
          Routes.session: (context) => const SessionScreen(),
        },
      );
}
