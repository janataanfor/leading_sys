import 'package:flutter/material.dart';
import 'dart:math' as math;

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreen createState() => _HomeScreen();
}

class _HomeScreen extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double pointX = 638229.565;
    double pointY = 3487476.170;

    double targetX = 638342.849;
    double targetY = 3487392.349;

    print(targetX - pointX);
    print(targetY - pointY);

    print(math
        .sqrt(math.pow(targetX - pointX, 2) + math.pow(targetY - pointY, 2))
        .round());

    double angle = math.atan2(targetX - pointX, targetY - pointY);
    print(angle);
    angle = angle * 180 / math.pi;

    print(angle);
    //print(360 - angle);

    return Scaffold(
      body: Container(
        child: Center(child: Text('home')),
      ),
    );
  }
}
