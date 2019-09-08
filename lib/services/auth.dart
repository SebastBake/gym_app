import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:gym_app/components/blank.dart';
import 'package:gym_app/components/loading.dart';

/////////////////////////////////////////////////////////////////////////// Public State classes

@immutable
class AuthState {}

@immutable
abstract class AuthLoading extends AuthState {}

@immutable
class AuthLoadingCurrentUser extends AuthLoading {}

@immutable
class AuthSigningIn extends AuthLoading {}

@immutable
class AuthSigningOut extends AuthLoading {}

@immutable
abstract class AuthSignedIn extends AuthState {
  String get displayName;
  String get userId;
  Future<void> signOut();
}

@immutable
abstract class AuthSignedOut extends AuthState {
  Future<void> signInWithGoogle();
}

////////////////////////////////////////////////////////////////////////// Authentication Bloc

class AuthenticationBloc extends StatefulWidget {
  final Widget Function(BuildContext, AuthSignedIn) signedIn;
  final Widget Function(BuildContext, AuthSignedOut) signedOut;

  AuthenticationBloc({
    Key key,
    @required this.signedIn,
    @required this.signedOut,
  }) : super(key: key);

  _AuthenticationBlocState createState() => _AuthenticationBlocState(
        signedIn: this.signedIn,
        signedOut: this.signedOut,
      );
}

class _AuthenticationBlocState extends State<AuthenticationBloc> {
  final Widget Function(BuildContext, AuthSignedIn) signedIn;
  final Widget Function(BuildContext, AuthSignedOut) signedOut;

  Stream<AuthState> stream;

  _AuthenticationBlocState({
    @required this.signedIn,
    @required this.signedOut,
  });

  @override
  initState() {
    this.stream = _makeAuthStream();
    super.initState();
  }

  @override
  build(context) => StreamBuilder(
        stream: this.stream,
        builder: (context, snapshot) => snapshot.hasData
            ? _renderState(context, snapshot.data)
            : BlankScreen(),
      );

  Widget _renderState(BuildContext context, AuthState state) {
    if (state is AuthSignedIn) {
      return signedIn(context, state);
    }

    if (state is AuthSignedOut) {
      return signedOut(context, state);
    }

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
  }
}

///////////////////////////////////////////////////////////////////// Implementation of auth Stream

final _auth = FirebaseAuth.instance;
final _googleSignIn = GoogleSignIn();

Stream<AuthState> _makeAuthStream() {
  StreamController<AuthState> controller;

  final onListen = () => _startStream(controller);

  controller = StreamController(onListen: onListen);

  return controller.stream;
}

void _startStream(StreamController<AuthState> controller) async {
  controller.add(AuthLoadingCurrentUser());

  final currentUser = await _auth.currentUser();

  final nextState = currentUser == null
      ? _SignedOut(controller: controller)
      : _SignedIn(
          userId: currentUser.uid,
          displayName: currentUser.displayName,
          controller: controller,
        );

  controller.add(nextState);
}

@immutable
class _SignedOut extends AuthSignedOut {
  final StreamController<AuthState> controller;

  _SignedOut({@required this.controller});

  @override
  signInWithGoogle() async {
    controller.add(AuthSigningIn());

    final googleAccount = await _googleSignIn.signIn();

    final googleAuth = await googleAccount.authentication;

    final credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final firebaseSignIn = await _auth.signInWithCredential(credential);

    final nextState = _SignedIn(
      controller: controller,
      userId: firebaseSignIn.user.uid,
      displayName: firebaseSignIn.user.displayName,
    );

    controller.add(nextState);
  }
}

@immutable
class _SignedIn extends AuthSignedIn {
  final String displayName;
  final String userId;
  final StreamController<AuthState> controller;

  _SignedIn({
    @required this.displayName,
    @required this.userId,
    @required this.controller,
  });

  @override
  signOut() async {
    controller.add(AuthSigningOut());

    await _googleSignIn.signOut();
    await _auth.signOut();

    final nextState = _SignedOut(controller: controller);
    controller.add(nextState);
  }
}
