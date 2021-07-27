import 'package:dnd_charactersheet_app/utils/globalData.dart';
import 'package:flutter/material.dart';
import 'package:dnd_charactersheet_app/utils/get_api.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:animations/animations.dart';
import 'dart:convert';

class VerifiedScreen extends StatefulWidget {
  @override
  _VerifiedScreenState createState() => _VerifiedScreenState();
}

class _VerifiedScreenState extends State<VerifiedScreen> {
  ContainerTransitionType _transitionType = ContainerTransitionType.fade;
  int _selectedIndex = 0;

  /*void _showMarkedAsDoneSnackbar(bool isMarkedAsDone) {
    if (isMarkedAsDone == false)
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Successfully deleted!'),
      ));
  } */

  List<dynamic> acquiredSheets = [];

  @override
  initState() {
    grabAllSheets();
    super.initState();
  }

  void grabAllSheets() async {
    List<dynamic> results;
    String url = 'https://dndpagemaker.herokuapp.com/api/searchDnD';
    String payload;
    var jsonObject;

    payload = '{"userId":"' +
        GlobalData.userId +
        '","search":"' +
        '' +
        '","jwtToken":"' +
        GlobalData.token +
        '"}';
    String ret = await Payload.getJson(url, payload);
    jsonObject = json.decode(ret);
    GlobalData.token = jsonObject["jwtToken"];
    results = jsonObject["results"];
    acquiredSheets = results;
  }

  void filterSheets(String enteredKey) async {
    List<dynamic> results;
    String url = 'https://dndpagemaker.herokuapp.com/api/searchDnD';
    String payload;
    var jsonObject;

    if (enteredKey.isEmpty) {
      payload = '{"userId":"' +
          GlobalData.userId +
          '","search":"' +
          '' +
          '","jwtToken":"' +
          GlobalData.token +
          '"}';
      String ret = await Payload.getJson(url, payload);
      jsonObject = json.decode(ret);
      GlobalData.token = jsonObject["jwtToken"];
      results = jsonObject["results"];
    } else {
      print(enteredKey);
      payload = '{"userId":"' +
          GlobalData.userId +
          '","search":"' +
          enteredKey.toLowerCase() +
          '","jwtToken":"' +
          GlobalData.token +
          '"}';
      String ret = await Payload.getJson(url, payload);
      jsonObject = json.decode(ret);
      GlobalData.token = jsonObject["jwtToken"];
      results = jsonObject["results"];
    }

    setState(() {
      acquiredSheets = results;
    });
  }

  void _onItemTapped(int index) async {
    print('selected tab $index');
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                bottom: 50,
              ),
              child: Text(
                'Welcome back, ${GlobalData.firstName}!',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.white,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 50,
                right: 50,
                bottom: 50,
              ),
              child: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.brown,
                  border: Border.all(),
                  borderRadius: BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
                child: Text(
                  'ViewDatSheet is the companion app of the online web app known as MakeDatSheet.' +
                      ' To view your current collection of character sheets, tap the ‘View’ tab on the bottom navigation bar.' +
                      ' As of now, we’ve only implemented D&D sheets. Our plans are to add implementation for other TTRPGS in the future!',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            InkWell(
              child: Text(
                'LOGOUT',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/login');
                GlobalData.userId = '';
                GlobalData.firstName = '';
                GlobalData.lastName = '';
                GlobalData.loginName = '';
                GlobalData.password = '';
                GlobalData.token = '';
              },
            ),
          ],
        ),
      ),
      Padding(
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            TextField(
              style: TextStyle(
                color: Colors.white,
              ),
              onChanged: (value) => filterSheets(value),
              decoration: InputDecoration(
                  labelText: 'Search Character',
                  suffixIcon: Icon(Icons.search)),
            ),
            SizedBox(
              height: 20,
            ),
            Expanded(
                child: acquiredSheets.length > 0
                    ? ListView.separated(
                        itemCount: acquiredSheets.length,
                        itemBuilder: (context, index) => OpenContainer<bool>(
                          transitionType: _transitionType,
                          openBuilder:
                              (BuildContext _, VoidCallback openContainer) {
                            return _DetailsPage(
                                sheetInfo: acquiredSheets[index]);
                          },
                          //onClosed: //_showMarkedAsDoneSnackbar,
                          tappable: false,
                          closedShape: const RoundedRectangleBorder(),
                          closedElevation: 0.0,
                          closedBuilder:
                              (BuildContext _, VoidCallback openContainer) {
                            return ListTile(
                              tileColor: Colors.grey[850],
                              leading: Image.asset(
                                'assets/empty_char.png',
                                scale: 2.0,
                                width: 40,
                              ),
                              onTap: openContainer,
                              title: Text(
                                acquiredSheets[index]["characterName"],
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                              ),
                              subtitle: Text(
                                '   Class 1: ${acquiredSheets[index]["class1"]}, Level ${acquiredSheets[index]["class1lvl"]}\n' +
                                    '   Class 2: ${acquiredSheets[index]["class2"]}, Level ${acquiredSheets[index]["class2lvl"]}\n' +
                                    '   Class 3: ${acquiredSheets[index]["class3"]}, Level ${acquiredSheets[index]["class3lvl"]}',
                                style: TextStyle(
                                  color: Colors.grey,
                                ),
                              ),
                            );
                          },
                        ),
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            height: 5,
                          );
                        },
                      )
                    : Center(
                        child: Text(
                          'No sheets to display.',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )),
          ],
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[800],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.brown,
        selectedItemColor: Colors.white,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.auto_stories_rounded),
            label: 'View',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
    );
  }
}

class _DetailsPage extends StatelessWidget {
  final dynamic sheetInfo;

  _DetailsPage({@required this.sheetInfo});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Details',
          style: TextStyle(),
        ),
        backgroundColor: Colors.brown,
        actions: <Widget>[
          if (false)
            // ignore: dead_code
            IconButton(
              icon: const Icon(Icons.remove_circle_outline_outlined),
              onPressed: () => Navigator.pop(context, true),
              tooltip: 'Remove this character sheet',
            )
        ],
      ),
      body: ListView(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(0.0),
            child: Column(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 125,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CHARACTER NAME\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["characterName"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 18),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'PLAYER NAME\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["userName"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 16),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 125,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CLASS 1\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["class1"]}, Level ${sheetInfo["class1lvl"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CLASS 2\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["class2"]}, Level ${sheetInfo["class2lvl"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CLASS 3\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["class3"]}, Level ${sheetInfo["class3lvl"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 220,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'STRENGTH\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["str"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'DEXTERITY\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["dex"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CONSTITUTION\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["con"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'INTELLIGENCE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["int"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'WISDOM\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["wis"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 220,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: AutoSizeText.rich(
                                          TextSpan(
                                            text: 'CUR. HP\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${sheetInfo["currHP"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 12),
                                          minFontSize: 5,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: AutoSizeText.rich(
                                                  TextSpan(
                                                    text: 'MAX HP\n',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${sheetInfo["maxHP"]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  minFontSize: 5,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: AutoSizeText.rich(
                                          TextSpan(
                                            text: 'ARMOR\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${sheetInfo["armorClass"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 12),
                                          minFontSize: 5,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: AutoSizeText.rich(
                                                  TextSpan(
                                                    text: 'SPEED\n',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${sheetInfo["speed"]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  minFontSize: 5,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Container(
                                        child: AutoSizeText.rich(
                                          TextSpan(
                                            text: 'INIT.\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text:
                                                    '${sheetInfo["initiative"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 12),
                                          minFontSize: 5,
                                          maxLines: 2,
                                          textAlign: TextAlign.center,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                    Expanded(
                                      child: Container(
                                        child: Row(
                                          children: <Widget>[
                                            Expanded(
                                              child: Container(
                                                child: AutoSizeText.rich(
                                                  TextSpan(
                                                    text: 'HIT DICE\n',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            '${sheetInfo["hitDice"]}',
                                                        style: TextStyle(
                                                          fontWeight:
                                                              FontWeight.normal,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  style:
                                                      TextStyle(fontSize: 12),
                                                  minFontSize: 5,
                                                  maxLines: 2,
                                                  textAlign: TextAlign.center,
                                                ),
                                              ),
                                              flex: 1,
                                            ),
                                          ],
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: Row(
                                  children: <Widget>[
                                    Expanded(
                                      child: Center(
                                        child: AutoSizeText.rich(
                                          TextSpan(
                                            text: 'SAVING THROWS\n',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                            children: <TextSpan>[
                                              TextSpan(
                                                text: '${sheetInfo["strSave"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  STRENGTH\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${sheetInfo["dexSave"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  DEXTERITY\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${sheetInfo["conSave"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  CONSTITUTION\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${sheetInfo["intSave"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  INTELLIGENCE\n',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '${sheetInfo["wisSave"]}',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                  decoration:
                                                      TextDecoration.underline,
                                                ),
                                              ),
                                              TextSpan(
                                                text: '  WISDOM',
                                                style: TextStyle(
                                                  fontWeight: FontWeight.normal,
                                                ),
                                              ),
                                            ],
                                          ),
                                          style: TextStyle(fontSize: 14),
                                          minFontSize: 5,
                                          maxLines: 6,
                                          textAlign: TextAlign.justify,
                                        ),
                                      ),
                                      flex: 1,
                                    ),
                                  ],
                                ),
                              ),
                              flex: 2,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 220,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'RACE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["race"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'BACKGROUND\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' ${sheetInfo["backGround"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ALIGNMENT\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' ${sheetInfo["alignment"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'EXP. POINTS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: ' ${sheetInfo["exp"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SKILLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["acrobatics"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  ACROBATICS\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["animalHandling"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  HANDLING\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["arcana"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  ARCANA\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["athletics"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  ATHLETICS\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["deception"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  DECEPTION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["history"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  HISTORY\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["insight"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  INSIGHT\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["intimidation"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  INTIMIDATION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["investigation"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  INVESTIGATION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["medicine"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  MEDICINE\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["nature"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  NATURE\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["perception"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  PERCEPTION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["performance"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  PERFORMANCE\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["persuasion"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  PERSUASION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["religion"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  RELIGION\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["sleightOfhand"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  SLEIGHT OF HAND\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["stealth"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  STEALTH\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["survival"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  SURVIVAL\n\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text:
                                            '${sheetInfo["passivePerception"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  PASSIVE PERCEPTION',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 24,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        height: 300,
                        child: AutoSizeText.rich(
                          TextSpan(
                            text: 'PROFICIENCIES\n& LANGUAGES\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${sheetInfo["profLanguages"]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(fontSize: 12),
                          minFontSize: 5,
                          maxLines: 20,
                          textAlign: TextAlign.start,
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 3,
                    ),
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CURRENCY           \n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["cp"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  SP\n\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["sp"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '  SP\n\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["ep"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' EP\n\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["gp"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' GP\n\n',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                      TextSpan(
                                        text: '${sheetInfo["pp"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          decoration: TextDecoration.underline,
                                        ),
                                      ),
                                      TextSpan(
                                        text: ' PP',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 14),
                                  minFontSize: 5,
                                  maxLines: 12,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ATTACK 1\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack1Name"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ATTACK 2\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack2Name"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ATTACK 3\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack3Name"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 2,
                    ),
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'BONUS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack1Bonus"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'BONUS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack2Bonus"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'BONUS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack3Bonus"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 300,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'TYPE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack1Type"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'TYPE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack2Type"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'TYPE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["attack13ype"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        alignment: Alignment.topLeft,
                        height: 300,
                        child: AutoSizeText.rich(
                          TextSpan(
                            text: 'EQUIPMENT\n',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                            children: <TextSpan>[
                              TextSpan(
                                text: '${sheetInfo["equipment"]}',
                                style: TextStyle(
                                  fontWeight: FontWeight.normal,
                                ),
                              ),
                            ],
                          ),
                          style: TextStyle(fontSize: 12),
                          minFontSize: 5,
                          maxLines: 20,
                          textAlign: TextAlign.start,
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'AGE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["age"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'HEIGHT\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["height"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'WEIGHT\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["weight"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'EYES\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["eyes"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SKIN\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["skin"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'HAIR\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["hair"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 2,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'FEATS & TRAITS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["featTraits"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 2,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ORGANIZATION\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["alliedOrganizations"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 8,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ALLIES\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["allies"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 5,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'BACKSTORY\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["backStory"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 8,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 350,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'ADDITIONAL FEATS & TRAITS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["addfeatTraits"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 175,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'TREASURE\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["treasure"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 8,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 175,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'CANTRIPS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["cantrips"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 2,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SPELLCASTING CLASS/LEVEL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["spellClass"]}, ${sheetInfo["spellAbility"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SPELL SAVE DC\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["spellsaveDC"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SPELL ATTACK BONUS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["spellBonus"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl1Expended"]}/${sheetInfo["lvl1Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 1 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl1Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl2Expended"]}/${sheetInfo["lvl2Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 2 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl2Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl3Expended"]}/${sheetInfo["lvl3Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 3 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl3Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl4Expended"]}/${sheetInfo["lvl4Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 4 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl4Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl5Expended"]}/${sheetInfo["lvl5Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 5 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl5Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl6Expended"]}/${sheetInfo["lvl6Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 6 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl6Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[700],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl7Expended"]}/${sheetInfo["lvl7Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 7 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl7Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl8Expended"]}/${sheetInfo["lvl8Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 8 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl8Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                    Expanded(
                      child: Container(
                        height: 210,
                        child: Column(
                          children: <Widget>[
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'SLOTS USED/TOTAL\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text:
                                            '${sheetInfo["lvl9Expendedlvl9"]}/${sheetInfo["lvl9Spellslots"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 1,
                            ),
                            Expanded(
                              child: Container(
                                alignment: Alignment.topLeft,
                                child: AutoSizeText.rich(
                                  TextSpan(
                                    text: 'LEVEL 9 SPELLS\n',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: '${sheetInfo["lvl9Prepspells"]}',
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                        ),
                                      ),
                                    ],
                                  ),
                                  style: TextStyle(fontSize: 12),
                                  minFontSize: 5,
                                  maxLines: 15,
                                  textAlign: TextAlign.left,
                                ),
                              ),
                              flex: 3,
                            ),
                          ],
                        ),
                        color: Colors.grey[600],
                      ),
                      flex: 1,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
