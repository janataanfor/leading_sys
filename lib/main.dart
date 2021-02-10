import 'package:flutter/material.dart';
import 'database_helper.dart';
import 'model/target.dart';
import 'pages/TargetScreen.dart';
import 'pages/OurLocationsScreen.dart';
import 'pages/HomeScreen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Leading System',
      theme: ThemeData(
        primaryColor: Color(0xFFFE903F),
        accentColor: Color(0xFFBCB0AC),
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageScreen createState() => _MyHomePageScreen();
}

class _MyHomePageScreen extends State<MyHomePage> {
  List<dynamic> tabs;

  int btnPressed = 0;
  Color activeColor = Color(0xFFFE903F);
  Color inActiveColor = Color(0xFFBCB0AC);

  @override
  void initState() {
    tabs = [
      TargetScreen(),
      OurLocationsScreen(),
      HomeScreen(),
    ];

//    setNotDispose();

    super.initState();
  }

  // homepage layout
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        //color: Color(0xFFFE903F),
        color: Color(0xFFF9F8F6),
        child: Center(
          child: Row(
            children: <Widget>[
              Container(
                width: 70,
                height: MediaQuery.of(context).size.height,
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    IconButton(
                      icon: Icon(Icons.assistant_navigation),
                      iconSize: 45,
                      color: activeColor,
                      tooltip: 'Leading System',
                      onPressed: () {},
                    ),
                    SizedBox(
                      height: 60,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 3,
                        ),
                        IconButton(
                          icon: Icon(Icons.location_searching),
                          iconSize: 30,
                          color: btnPressed == 0 ? activeColor : inActiveColor,
                          tooltip: 'Targets',
                          onPressed: () {
                            setState(() {
                              btnPressed = 0;
                            });
                          },
                        ),
                        Container(
                          height: 30,
                          width: 3,
                          color: btnPressed == 0 ? activeColor : Colors.white,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 3,
                        ),
                        IconButton(
                          icon: Icon(Icons.location_on_outlined),
                          iconSize: 30,
                          color: btnPressed == 1 ? activeColor : inActiveColor,
                          tooltip: 'Our Locations',
                          onPressed: () {
                            setState(() {
                              btnPressed = 1;
                            });
                          },
                        ),
                        Container(
                          height: 30,
                          width: 3,
                          color: btnPressed == 1 ? activeColor : Colors.white,
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          height: 30,
                          width: 3,
                        ),
                        IconButton(
                          icon: Icon(Icons.home_outlined),
                          iconSize: 30,
                          color: btnPressed == 2 ? activeColor : inActiveColor,
                          tooltip: 'home',
                          onPressed: () {
                            setState(() {
                              btnPressed = 2;
                            });
                          },
                        ),
                        Container(
                          height: 30,
                          width: 3,
                          color: btnPressed == 2 ? activeColor : Colors.white,
                        )
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(child: tabs[btnPressed])
            ],
          ),
        ),
      ),
    );
  }
}
