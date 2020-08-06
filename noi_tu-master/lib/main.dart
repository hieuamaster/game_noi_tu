import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:noitu/screens/arcade_screen.dart';
import 'package:noitu/screens/campaign_screen.dart';
import 'package:noitu/screens/game_screen.dart';
import 'package:noitu/screens/pvp_screen.dart';
import './screens/home_screen.dart';
import './utilities/constants.dart';

void main() {
  return runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([]);
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        tooltipTheme: TooltipThemeData(
          decoration: BoxDecoration(
            color: kTooltipColor,
            borderRadius: BorderRadius.circular(5.0),
          ),
          textStyle: TextStyle(
            fontWeight: FontWeight.w900,
            fontSize: 20.0,



            letterSpacing: 1.0,
            color: Colors.white,
          ),
        ),
        scaffoldBackgroundColor: Color(0xFF607D8B),
        textTheme: Theme.of(context).textTheme.apply(fontFamily: 'PatrickHand'),
      ),
      initialRoute: 'homePage',
      routes: {
        'homePage': (context) => HomeScreen(),
        'arcade': (context) => ArcadeScreen(),
        'classic': (context) => GameScreen(),
        'campaign': (context) => CampaignScreen(),
        'pvpMode' : (context) =>  PvPScreen(),
      },
    );
  }
}
