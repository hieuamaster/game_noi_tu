import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import '../components/action_button.dart';
import 'game_screen.dart';
import 'campaign_screen.dart';
import 'arcade_screen.dart';
import 'pvp_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SafeArea(
          child: Column(
        children: <Widget>[
          Center(
            child: Container(
              margin: EdgeInsets.fromLTRB(8.0, 10.0, 8.0, 8.0),
              child: Text(
                'NỐI TỪ KHÔNG?',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: height < 600 ? 30 : 50.0,
                    fontWeight: FontWeight.w300,
                    letterSpacing: 3.0),
              ),
            ),
          ),
          SizedBox(
            height: height * 0.012,
          ),
          Center(
            child: Container(
              padding: EdgeInsets.all(5.0),
              child: Image.asset(
                'images/noitu.png',
                height: height * 0.35,
              ),
            ),
          ),
          SizedBox(
            height: height * 0.04,
          ),
          Center(
            child: IntrinsicWidth(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Container(
//                    width: 155,
                    height: height * 0.08,
                    child: ActionButton(
                      buttonTitle: 'Cổ điển',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GameScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  Container(
//                    width: 155,
                    height: height * 0.08,
                    child: ActionButton(
                      buttonTitle: 'Nhập vai',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ArcadeScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  Container(
//                    width: 155,
                    height: height * 0.08,
                    child: ActionButton(
                      buttonTitle: 'Chiến dịch',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CampaignScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  SizedBox(
                    height: 9.0,
                  ),
                  Container(
//                    width: 155,
                    height: height * 0.08,
                    child: ActionButton(
                      buttonTitle: 'PvP Mode',
                      onPress: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => PvPScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      )),
    );
  }
}
