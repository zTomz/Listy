// ignore_for_file: unnecessary_this

import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String title;
  final void Function() onPressed;
  const Button({super.key, required this.title, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);

    return Container(
      width: 225,
      height: 60,
      decoration: BoxDecoration(
        color: theme.primaryColor,
        borderRadius: BorderRadius.circular(15),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(15),
        child: MaterialButton(
          onPressed: this.onPressed,
          child: Center(
            child: Text(
              this.title,
              style: theme.textTheme.headline1!
                  .copyWith(fontSize: 20, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
