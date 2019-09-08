import 'package:flutter/material.dart';
import 'package:gym_app/services/auth.dart';
import 'package:gym_app/utils/navigation.dart';

class MenuModal extends StatelessWidget {
  final AuthSignedIn authState;

  const MenuModal({@required this.authState});

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(10),
              child: Text(
                'Signed In as ' + this.authState.displayName,
                style: Theme.of(context).textTheme.body2,
              ),
            ),
            OutlineButton(
              child: Text('Sign Out'),
              onPressed: () {
                this.authState.signOut();
                NavUtil.back(context);
              },
            ),
          ],
        ),
      );

  static void show(BuildContext context, AuthSignedIn authState) {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      builder: (_) => MenuModal(authState: authState),
    );
  }
}
