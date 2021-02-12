
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:contained_tab_bar_view/contained_tab_bar_view.dart';
import 'Comics_Overview.dart';

final FirebaseAuth auth = FirebaseAuth.instance;

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {

    return MaterialApp(

      title: 'XKCD Fan Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,

        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'XKCD Fan Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();

}


class _MyHomePageState extends State<MyHomePage> with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _passwordConfirm = TextEditingController();
  bool _success;
  String _userEmail;
  TabController _controller;
  @override
  void initState(){
    super.initState();
        _controller = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {

    void _register() async {
      final User user  = (await
      auth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _password.text,
      )
      ).user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
        });
      } else {
        setState(() {
          _success = true;
        });
      }
    }
    void _signIn() async {
      final User user = (await auth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _password.text,
      )).user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email;
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ComicsOverview()
            ),
          );
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    }
    ContainedTabBarView containedTabBarView = ContainedTabBarView(
      tabBarProperties: TabBarProperties(
        outerPadding: EdgeInsets.only(bottom: 20.0),
        background: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.all(Radius.circular(8.0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  spreadRadius: 0.5,
                  blurRadius: 2,
                  offset: Offset(1,-1)
                )
              ]
          ),
          child: Center(
            child: Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        )
      ),
      tabs: [
        Text('Login'),
        Text('Register')
      ],
      views: [
        Form(
          key: _formKey2,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding (
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Email Address',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.white),
                      )
                    ),
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Please Enter Email';
                      } if (value.contains(' ')){
                        String email2 = value.replaceAll(' ','');
                        _emailController.text = (email2);
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                child:Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _password,
                  decoration: InputDecoration(
                      hintText: 'Password',
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.black),
                      ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0)),
                      borderSide: BorderSide(color: Colors.white),
                    )
                  ),
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Please Enter Password';
                      }
                      return null;
                    },
                )
              )
              ),
              Container(
                child: Row(
                  children: <Widget>[
                    Container(

                    ),
                    Container(
                      child: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: RichText(
                                text: TextSpan(
                                  text:'Forgot Password',
                                ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
              Container(
                child: ButtonTheme(
                  minWidth: 500.0,
                  height: 300.0,
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: Colors.black, // background
                        onPrimary: Colors.white, // foreground
                      ),
                      onPressed: () async {
                        if (_formKey2.currentState.validate()){
                          _signIn();
                        }
                      },
                      child: Text(
                        'Login',
                        style: TextStyle(
                            fontSize: 20
                        ),
                      )
                  ),
                )
              ),
              Container(
                alignment: Alignment.topCenter,
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Text(
                  _success == null
                      ? ''
                      : (_success
                      ? 'Successfully signed in ' + _userEmail
                      : 'Sign in failed'),
                  style: TextStyle(color: Colors.red),
                ),
              )
            ],
          ),
        ),
        Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              Container(
                child: Padding (
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    controller: _emailController,
                    decoration: InputDecoration(
                        hintText: 'Email Address',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        )
                    ),
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Please Enter Email';
                      }
                      if(!RegExp("^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(value)){
                        return 'Please a valid Email';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                child: Padding (
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    cursorColor: Colors.white,
                    style: TextStyle(color: Colors.white),
                    controller: _password,
                    decoration: InputDecoration(
                        hintText: 'Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        )
                    ),
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Please Enter Password';
                      }else if (value.length < 6){
                        return "The Password Requires 6 Characters Or More";
                      }
                      return null;
                    },
                  ),
                ),
              ),
              Container(
                child: Padding (
                  padding: const EdgeInsets.all(15.0),
                  child: TextFormField(
                    style: TextStyle(color: Colors.white),
                    cursorColor: Colors.white,
                    controller: _passwordConfirm,
                    decoration: InputDecoration(
                        hintText: 'Confirm Password',
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.black),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0)),
                          borderSide: BorderSide(color: Colors.white),
                        ),
                      errorBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red),
                      )
                    ),
                    validator: (String value){
                      if (value.isEmpty){
                        return 'Please Re-enter Password';
                      }
                      if (_password.text != _passwordConfirm.text){
                        return "Passwords do not match";
                      }
                        return null;
                    },
                  ),
                ),
              ),
              Container(
                child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Colors.black, // background
                      onPrimary: Colors.white, // foreground
                    ),
                  onPressed: () async {
                    if (_formKey.currentState.validate()){
                      _register();
                    }
                  },
                  child: Text(
                      'Register',
                    style: TextStyle(
                      fontSize: 20
                    ),
                  )
                ),
              ),
              Container(
                alignment: Alignment.center,
                child: Text(_success == null
                    ? ''
                    : (_success
                    ? 'Successfully registered ' + _userEmail
                    : 'Registration failed')),
              )
            ],
          ),
        ),
      ],
    );

    @override
    void dispose() {
      _emailController.dispose();
      _password.dispose();
      _passwordConfirm.dispose();
      super.dispose();
    }

    return Scaffold(
      backgroundColor: Colors.blueGrey,
      appBar: AppBar( centerTitle: true,

        title: Text(widget.title),
      ),
      body: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
                child: ConstrainedBox(
                    constraints: BoxConstraints(
                      minWidth: 200,
                      minHeight: 300,
                      maxHeight: 700,
                      maxWidth: 600,
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        color: Colors.blue,
                      ),
                      alignment: Alignment.center,
                      padding: const EdgeInsets.all(30.0),
                      width: 350,
                      height: 500,
                      child: containedTabBarView,
                    )
                ),
              )
          ]
      ),
    );

  }
}
