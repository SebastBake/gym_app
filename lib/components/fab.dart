import 'package:flutter/material.dart';

class FAB extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String tag;

  const FAB({
    Key key,
    @required this.icon,
    this.onPressed,
    this.tag,
  }) : super(key: key);

  @override
  build(context) => FloatingActionButton(
        heroTag: this.tag,
        elevation: Theme.of(context).floatingActionButtonTheme.elevation,
        child: Icon(this.icon),
        onPressed: this.onPressed,
      );
}

class ExtendedFAB extends StatelessWidget {
  final Function onPressed;
  final IconData icon;
  final String label;
  final String tag;

  const ExtendedFAB({
    Key key,
    @required this.icon,
    @required this.label,
    this.onPressed,
    this.tag,
  }) : super(key: key);

  @override
  build(context) => FloatingActionButton.extended(
        heroTag: this.tag,
        elevation: Theme.of(context).floatingActionButtonTheme.elevation,
        icon: Icon(this.icon),
        label: Text(this.label),
        onPressed: this.onPressed,
      );
}
