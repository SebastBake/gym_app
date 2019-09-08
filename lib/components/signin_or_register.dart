import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';

class SignInOrRegisterScreen extends StatelessWidget {
  final AuthSignedOut authState;

  const SignInOrRegisterScreen({this.authState});

  @override
  build(context) => Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: EdgeInsets.only(top: 100, bottom: 100),
              child: Text(
                'Workout Log',
                style: Theme.of(context).textTheme.display3,
                textAlign: TextAlign.center,
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: RaisedButton(
                child: Text('Sign In With Google'),
                onPressed: () {
                  this.authState.signInWithGoogle();
                },
              ),
            ),
          ],
        ),
      );
}
