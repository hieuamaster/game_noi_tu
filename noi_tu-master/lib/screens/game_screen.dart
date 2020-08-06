import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../screens/home_screen.dart';
import '../utilities/constants.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:math';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import '../utilities/word_db.dart' as word_database;
import '../utilities/words.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:esys_flutter_share/esys_flutter_share.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:screenshot/screenshot.dart';
import 'package:path_provider/path_provider.dart';

ScreenshotController screenshotController = ScreenshotController();

class GameScreen extends StatefulWidget {
  GameScreen();

  @override
  _GameScreenState createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  int lives = 5;
  String word = "loading text";
  String hiddenWord;
  List<String> wordList = [];
  List<int> hintLetters = [];
  List<bool> buttonStatus;
  bool hintStatus;
  int hangState = 0;
  int wordCount = 0;
  bool finishedGame = false;
  bool resetGame = false;
  Word currentWord;
  TextEditingController _controller = TextEditingController();

  void newGame() {
    setState(() {
      lives = 5;
      wordCount = 0;
      finishedGame = false;
      resetGame = false;
      initWords("");
    });
  }

  void returnHomePage() {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen()),
      ModalRoute.withName('homePage'),
    );
  }

  void _takeScreenshotandShare() async {
    var _imageFile = null;
    screenshotController
        .capture(delay: Duration(milliseconds: 10), pixelRatio: 2.0)
        .then((File image) async {
      setState(() {
        _imageFile = image;
      });
      final directory = (await getApplicationDocumentsDirectory()).path;
      Uint8List pngBytes = _imageFile.readAsBytesSync();
      File imgFile = new File('$directory/screenshot.png');
      imgFile.writeAsBytes(pngBytes);
      print("File Saved to Gallery");
      await Share.file('Anupam', 'screenshot.png', pngBytes, 'image/png');
    }).catchError((onError) {
      print(onError);
    });
  }

  void initWords(String tail) async {
    _controller.clear();
    finishedGame = false;
    resetGame = false;
    hintStatus = true;
    hangState = 0;
    wordList = [];
    hintLetters = [];
    final database = word_database.openDB();
    var queryResult = await word_database.findRandomWord(database, tail);
    if (queryResult.length == 0) {
      Alert(
        context: context,
        style: kSuccessAlertStyle,
        type: AlertType.success,
        title: "Chúc mừng bạn đã thắng",
//          desc: "You guessed it right!",
        buttons: [
          DialogButton(
            radius: BorderRadius.circular(10),
            child: Icon(
              MdiIcons.arrowRightThick,
              size: 30.0,
            ),
            onPressed: () {
              setState(() {
                wordCount += 5;
                Navigator.pop(context);
                initWords("");
              });
            },
            width: 127,
            color: kDialogButtonColor,
            height: 52,
          )
        ],
      ).show();
    } else {
      setState(() {
        word = queryResult[0].text;
        currentWord = queryResult[0];
        _controller.text = currentWord != null ? currentWord.tail + " " : "";
      });
    }
  }

  String chuanHoa(String text) {
    return text.trim().replaceAll("  ", " ").toLowerCase().split("-").join(' ');
  }

  String getHead(String text) {
    return chuanHoa(text).split(' ')[0].toLowerCase();
  }

  String getTail(String text) {
    return chuanHoa(text).split(' ').last.toLowerCase();
  }

  void checkText(String text) {
    if (lives == 0) {
      returnHomePage();
    }

    if (finishedGame) {
      setState(() {
        resetGame = true;
      });
      return;
    }

    setState(() async {
      if (text.split(' ').length > 1 &&
          text != currentWord.text &&
          getHead(text) == currentWord.tail) {
        final database = word_database.openDB();
        bool check = await word_database.checkWord(database, text);
        if (check) {
          finishedGame = true;
          Alert(
            context: context,
            style: kSuccessAlertStyle,
            type: AlertType.success,
            title: "Chúc mừng",
//          desc: "You guessed it right!",
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                child: Icon(
                  MdiIcons.arrowRightThick,
                  size: 30.0,
                ),
                onPressed: () {
                  setState(() {
                    wordCount += currentWord.chuan.split(' ').length-1;
                    Navigator.pop(context);
                    initWords(getTail(text));
                  });
                },
                width: 127,
                color: kDialogButtonColor,
                height: 52,
              )
            ],
          ).show();
        } else {
          lives -= 1;
          if (lives < 1) {
            finishedGame = true;
            final database2 = word_database.openDB();
            var queryResult2 =
                await word_database.findRandomWord(database2, currentWord.tail);
            Alert(
                style: kGameOverAlertStyle,
                context: context,
                title: "Trò chơi Cổ điển kết thúc!",
                desc: "Điểm số của bạn là $wordCount. Đáp án: " +
                    queryResult2[0].text,
                buttons: [
                  DialogButton(
                    width: 62,
                    onPressed: () => returnHomePage(),
                    child: Icon(
                      MdiIcons.home,
                      size: 30.0,
                    ),
//                  width: 90,
                    color: kDialogButtonColor,
//                  height: 50,
                  ),
                  DialogButton(
                    width: 62,
                    onPressed: () {
                      newGame();
                      Navigator.pop(context);
                    },
                    child: Icon(MdiIcons.refresh, size: 30.0),
//                  width: 90,
                    color: kDialogButtonColor,
//                  height: 20,
                  ),
                  DialogButton(
                    width: 62,
                    onPressed: () async {
                      _takeScreenshotandShare();
                    },
                    child: Icon(MdiIcons.shareAll, size: 30.0),
//                  width: 90,
                    color: kDialogButtonColor,
//                  height: 20,
                  ),
                ]).show();
          } else {
            finishedGame = false;
            Alert(
              context: context,
              style: kFailedAlertStyle,
              type: AlertType.error,
              title: "Làm gì có từ $text",
//            desc: "You Lost!",
              buttons: [
                DialogButton(
                  radius: BorderRadius.circular(10),
                  child: Icon(
                    MdiIcons.arrowRightThick,
                    size: 30.0,
                  ),
                  onPressed: () {
                    _controller.clear();
                    _controller.text =
                        currentWord != null ? currentWord.tail + " " : "";
                    setState(() {
                      Navigator.pop(context);
                      // initWords("");
                    });
                  },
                  width: 127,
                  color: kDialogButtonColor,
                  height: 52,
                ),
              ],
            ).show();
          }
        }
      } else {
        lives -= 1;
        if (lives < 1) {
          finishedGame = true;
          final database2 = word_database.openDB();
          var queryResult2 =
              await word_database.findRandomWord(database2, currentWord.tail);
          Alert(
              style: kGameOverAlertStyle,
              context: context,
              title: "Trò chơi Cổ điển kết thúc!",
              desc: "Điểm số của bạn là $wordCount. Đáp án: " +
                  queryResult2[0].text,
              buttons: [
                DialogButton(
                  width: 62,
                  onPressed: () => returnHomePage(),
                  child: Icon(
                    MdiIcons.home,
                    size: 30.0,
                  ),
//                  width: 90,
                  color: kDialogButtonColor,
//                  height: 50,
                ),
                DialogButton(
                  width: 62,
                  onPressed: () {
                    newGame();
                    Navigator.pop(context);
                  },
                  child: Icon(MdiIcons.refresh, size: 30.0),
//                  width: 90,
                  color: kDialogButtonColor,
//                  height: 20,
                ),
              ]).show();
        } else {
          finishedGame = false;
          Alert(
            context: context,
            style: kFailedAlertStyle,
            type: AlertType.error,
            title: "Sai rồi",
//            desc: "You Lost!",
            buttons: [
              DialogButton(
                radius: BorderRadius.circular(10),
                child: Icon(
                  MdiIcons.arrowRightThick,
                  size: 30.0,
                ),
                onPressed: () {
                  _controller.clear();
                  _controller.text =
                      currentWord != null ? currentWord.tail + " " : "";
                  setState(() {
                    Navigator.pop(context);
                    // initWords("");
                  });
                },
                width: 127,
                color: kDialogButtonColor,
                height: 52,
              ),
            ],
          ).show();
        }
      }
    });
  }

  @override
  void initState() {
    super.initState();
    initWords("");
  }

  @override
  Widget build(BuildContext context) {
    if (resetGame) {
      setState(() {
        initWords("");
      });
    }
    return Screenshot(
        controller: screenshotController,
        child: WillPopScope(
          onWillPop: () {
            return Future(() => false);
          },
          child: Scaffold(
            body: SafeArea(
              child: Column(
                children: <Widget>[
                  Expanded(
                      flex: 3,
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(6.0, 8.0, 6.0, 45.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 0.5),
                                          child: IconButton(
                                            tooltip: 'Home',
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            iconSize: 39,
                                            icon: Icon(MdiIcons.home),
                                            onPressed: () {
                                              returnHomePage();
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                Container(
                                  child: Text(
                                    wordCount == 1 ? "I" : '$wordCount',
                                    style: kWordCounterTextStyle,
                                  ),
                                ),
                                Row(
                                  children: <Widget>[
                                    Stack(
                                      children: <Widget>[
                                        Container(
                                          padding: EdgeInsets.only(top: 0.5),
                                          child: IconButton(
                                            tooltip: 'Lives',
                                            highlightColor: Colors.transparent,
                                            splashColor: Colors.transparent,
                                            iconSize: 39,
                                            icon: Icon(MdiIcons.heart),
                                            onPressed: () {},
                                          ),
                                        ),
                                        Container(
                                          padding: EdgeInsets.fromLTRB(
                                              8.7, 7.9, 0, 0.8),
                                          alignment: Alignment.center,
                                          child: SizedBox(
                                            height: 38,
                                            width: 38,
                                            child: Center(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(2.0),
                                                child: Text(
                                                  lives.toString() == "1"
                                                      ? "I"
                                                      : lives.toString(),
                                                  style: TextStyle(
                                                    color: Color(0xFF2C1E68),
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.bold,
                                                    fontFamily: 'PatrickHand',
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(
                              margin: EdgeInsets.symmetric(horizontal: 30.0),
                              alignment: Alignment.center,
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                child: Text(
                                  word == null ? "" : "$word",
                                  style: kWordTextStyle,
                                ),
                              ),
                            ),
                          ),
                          new TextField(
                            controller: _controller,
                            decoration: new InputDecoration(
                              labelText: currentWord != null &&
                                      currentWord.tail != null
                                  ? "Từ bắt đầu bằng " +
                                      currentWord.tail[0].toUpperCase() +
                                      currentWord.tail.substring(1)
                                  : "Nối từ",
                              fillColor: Colors.white,
                              border: new OutlineInputBorder(
                                borderRadius: new BorderRadius.circular(25.0),
                                borderSide: new BorderSide(),
                              ),
                              //fillColor: Colors.green
                            ),
                            style: new TextStyle(
                                fontFamily: 'PatrickHand',
                                color: Colors.white,
                                fontSize: 30),
                            onSubmitted: checkText,
                          ),
                        ],
                      )),
                ],
              ),
            ),
          ),
        ));
  }
}
