import 'package:flutter/material.dart';

import '../../shared/configs/colors_config.dart';
import '../../shared/configs/themes_config.dart';
import 'widgets/signin.dart';
import 'widgets/signup.dart';
import 'widgets/tab_indicator_painter.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  Size _size;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  final FocusNode myFocusNodeEmailLogin = FocusNode();
  final FocusNode myFocusNodePasswordLogin = FocusNode();

  final FocusNode myFocusNodePassword = FocusNode();
  final FocusNode myFocusNodeEmail = FocusNode();
  final FocusNode myFocusNodeName = FocusNode();

  TextEditingController loginEmailController = TextEditingController();
  TextEditingController loginPasswordController = TextEditingController();

  bool _obscureTextLogin = true;
  bool _obscureTextSignup = true;
  bool _obscureTextSignupConfirm = true;

  TextEditingController signupEmailController = TextEditingController();
  TextEditingController signupNameController = TextEditingController();
  TextEditingController signupPasswordController = TextEditingController();
  TextEditingController signupConfirmPasswordController = TextEditingController();

  PageController _pageController;

  Color left = Colors.black;
  Color right = Colors.white;
  double _logoWidth = 150;

  @override
  void dispose() {
    myFocusNodePassword.dispose();
    myFocusNodeEmail.dispose();
    myFocusNodeName.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
  }

  @override
  Widget build(BuildContext context) {
    _size = MediaQuery.of(context).size;

    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
        key: _scaffoldKey,
        body: NotificationListener<OverscrollIndicatorNotification>(
          // onNotification: (overscroll) {
          //   overscroll.disallowGlow();
          // },
          child: Stack(
            children: <Widget>[
              SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Stack(
                      children: <Widget>[
                        Container(
                          width: _size.width,
                          height: _size.height,
                          decoration: buildBackground(),
                          child: Column(
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              _buildLogo(),
                              _buildMenuBar(),
                              Expanded(
                                flex: 2,
                                child: _buildMenu(),
                              ),
                            ],
                          ),
                        ),
                        // PolicyWidget(),
                      ],
                    ),
                  ],
                ),
              ),
              // LoadingWidget(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenu() {
    return PageView(
      controller: _pageController,
      onPageChanged: (i) {
        if (i == 0) {
          setState(() {
            right = Colors.white;
            left = Colors.black;
            _logoWidth = 150;
          });
        } else if (i == 1) {
          setState(() {
            right = Colors.black;
            left = Colors.white;
            _logoWidth = 100;
          });
        }
      },
      children: <Widget>[
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: SignIn(),
        ),
        ConstrainedBox(
          constraints: const BoxConstraints.expand(),
          child: SignUp(),
        ),
      ],
    );
  }

  Widget _buildMenuBar() {
    return Container(
      width: 300,
      height: 50,
      decoration: BoxDecoration(
        color: ColorsConfig.menuBar,
        borderRadius: BorderRadius.all(Radius.circular(25)),
      ),
      child: CustomPaint(
        painter: TabIndicationPainter(pageController: _pageController),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignInButtonPress,
                child: Text(
                  'Entrar',
                  style: TextStyle(color: left, fontSize: 16),
                ),
              ),
            ),
            Expanded(
              child: FlatButton(
                splashColor: Colors.transparent,
                highlightColor: Colors.transparent,
                onPressed: _onSignUpButtonPress,
                child: Text(
                  'Criar Conta',
                  maxLines: 1,
                  style: TextStyle(color: right, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onSignInButtonPress() {
    _pageController.animateToPage(0, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _onSignUpButtonPress() {
    _pageController?.animateToPage(1, duration: Duration(milliseconds: 500), curve: Curves.decelerate);
  }

  void _toggleLogin() {
    setState(() {
      _obscureTextLogin = !_obscureTextLogin;
    });
  }

  void _toggleSignup() {
    setState(() {
      _obscureTextSignup = !_obscureTextSignup;
    });
  }

  void _toggleSignupConfirm() {
    setState(() {
      _obscureTextSignupConfirm = !_obscureTextSignupConfirm;
    });
  }

  Widget _buildLogo() {
    return SafeArea(
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 40),
        child: Column(
          children: [
            Image.asset(
              "assets/images/storeroom_logo.png",
              width: _logoWidth,
            ),
            Text('Organizador de Despensa', style: themeData.textTheme.headline5),
          ],
        ),
      ),
    );
  }

  BoxDecoration buildBackground() {
    var background = BoxDecoration(
      gradient: LinearGradient(
        colors: [ColorsConfig.loginGradientStart, ColorsConfig.loginGradientEnd],
        begin: const FractionalOffset(0, 0),
        end: const FractionalOffset(1, 1),
        stops: [0, 1],
        tileMode: TileMode.clamp,
      ),
    );

    return background;
  }
}
