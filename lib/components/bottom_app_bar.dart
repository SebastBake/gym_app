import 'package:flutter/material.dart';

final _appBarHeight = 56.0;

class MenuBottomAppBar extends StatelessWidget {
  final Function onPressMenu;

  MenuBottomAppBar({this.onPressMenu});

  @override
  build(context) => BottomAppBar(
        elevation: Theme.of(context).bottomAppBarTheme.elevation,
        child: Container(
          height: _appBarHeight,
          child: _getMenuButton(),
        ),
      );

  Widget _getMenuButton() => this.onPressMenu != null
      ? SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: Icon(Icons.menu),
                onPressed: this.onPressMenu,
              ),
            ],
          ),
        )
      : null;
}
