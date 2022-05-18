import 'package:flutter/material.dart';
import 'package:tappecg_ai/constants.dart';

class CustomAppbar extends AppBar {
  CustomAppbar({Key? key})
      : super(
          key: key,
          iconTheme: const IconThemeData(
            color: colorIcon, //change your color here
          ),
          backgroundColor: primaryColor,
          title: const Text(
            "Smart Heart Monitoring",
            style: TextStyle(color: colorIcon),
          ),
          elevation: 0.0,
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.circle),
              onPressed: () => null,
            ),
          ],
        );
}
