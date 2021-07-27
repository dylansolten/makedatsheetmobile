import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:dnd_charactersheet_app/utils/get_api.dart';
import 'package:dnd_charactersheet_app/utils/globalData.dart';
import 'dart:convert';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:crypto/crypto.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

String generateMd5(String input) {
  return md5.convert(utf8.encode(input)).toString();
}

class _LoginScreenState extends State<LoginScreen> {
  String loginMessage = '', newLoginMessageText = '';
  String registerMessage = '', newRegisterMessageText = '';
  int _selectedIndex = 0;
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _regUsernameController = TextEditingController();
  TextEditingController _regPasswordController = TextEditingController();
  TextEditingController _regFirstNameController = TextEditingController();
  TextEditingController _regLastNameController = TextEditingController();
  TextEditingController _regEmailController = TextEditingController();
  TextEditingController _regVerifController = TextEditingController();

  void _onItemTapped(int index) async {
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
            Container(
              width: 281.25, // 187.5,
              height: 140.625, // 93.75,
              child: Image.asset(
                'assets/dnd_black.png',
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _usernameController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
              onPressed: () async {
                newLoginMessageText = "";
                changeLoginText();

                String payload = '{"login":"' +
                    _usernameController.text +
                    '","password":"' +
                    generateMd5(_passwordController.text) +
                    '"}';

                var jsonObject;

                String url = 'https://dndpagemaker.herokuapp.com/api/login';
                String ret = await Payload.getJson(url, payload);
                jsonObject = json.decode(ret);

                GlobalData.token = jsonObject["accessToken"];
                print(ret); // <----- send to console http response.

                if (GlobalData.token == null) {
                  newLoginMessageText = "Error: ${jsonObject["error"]}";
                  changeLoginText();
                } else {
                  Map<String, dynamic> ud = Jwt.parseJwt(GlobalData.token);

                  GlobalData.userId = ud['userId'];
                  GlobalData.firstName = ud['firstName'];
                  GlobalData.lastName = ud['lastName'];
                  Navigator.pushNamed(context, '/verified');
                }
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'SIGN IN',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '$loginMessage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
          ],
        ),
      ),
      Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regUsernameController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Username',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regPasswordController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Password',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regFirstNameController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'First Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regLastNameController,
                obscureText: true,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Last Name',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regEmailController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Email',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
              onPressed: () async {
                newRegisterMessageText = "";
                changeRegisterText();

                String payload = '{"username":"' +
                    _regUsernameController.text +
                    '","password":"' +
                    generateMd5(_regPasswordController.text) +
                    '","firstName":"' +
                    _regFirstNameController.text +
                    '","lastName":"' +
                    _regLastNameController.text +
                    '","email":"' +
                    _regEmailController.text +
                    '","SecurityCode":"' +
                    _regVerifController.text +
                    '"}';

                var jsonObject;

                String url = 'https://dndpagemaker.herokuapp.com/api/addUser';
                String ret = await Payload.getJson(url, payload);
                jsonObject = json.decode(ret);
                print(ret); // <----- send to console http response.
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'REGISTER',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                '$registerMessage',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Padding(
              padding: EdgeInsets.only(
                left: 90,
                right: 90,
                bottom: 10,
              ),
              child: TextFormField(
                controller: _regVerifController,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                ),
                cursorColor: Colors.white,
                decoration: InputDecoration(
                  hintText: 'Security Code',
                  hintStyle: TextStyle(color: Colors.grey),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                ),
              ),
            ),
            OutlinedButton(
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.brown),
              ),
              onPressed: () async {
                newRegisterMessageText = "";
                changeRegisterText();

                String payload = '{"login":"' +
                    _regUsernameController.text +
                    '","password":"' +
                    generateMd5(_regPasswordController.text) +
                    '","firstName":"' +
                    _regFirstNameController.text +
                    '","lastName":"' +
                    _regLastNameController.text +
                    '","email":"' +
                    _regEmailController.text +
                    '","SecurityCode":"' +
                    _regVerifController.text +
                    '"}';

                var jsonObject;

                String url = 'https://dndpagemaker.herokuapp.com/api/addUser';
                String ret = await Payload.getJson(url, payload);
                jsonObject = json.decode(ret);
                print(ret); // <----- send to console http response.
                Navigator.pushNamed(context, '/login');
              },
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(
                  'VERIFY',
                  style: TextStyle(
                    color: Colors.grey[100],
                    fontSize: 20,
                  ),
                ),
              ),
            ),
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
            icon: Icon(Icons.login),
            label: 'Login',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.app_registration),
            label: 'Register',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
      body: _widgetOptions.elementAt(_selectedIndex),
      resizeToAvoidBottomInset: false,
    );
  }

  changeLoginText() {
    setState(() {
      loginMessage = newLoginMessageText;
    });
  }

  changeRegisterText() {
    setState(() {
      registerMessage = newRegisterMessageText;
    });
  }
}
