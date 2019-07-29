import 'package:flutter/material.dart';
import 'package:grit/auth/auth.dart';
import 'package:grit/auth/auth_provider.dart';
import 'package:grit/bloc/user_bloc.dart';
import 'package:grit/database/user_db.dart';

class EmailFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Email can\'t be empty' : null;
  }
}

class PasswordFieldValidator {
  static String validate(String value) {
    return value.isEmpty ? 'Password can\'t be empty' : null;
  }
}

class LoginPage extends StatefulWidget {
  const LoginPage(this.onSignedIn, this.userBloc);

  final VoidCallback onSignedIn;
  final UserBloc userBloc;

  @override
  State<StatefulWidget> createState() => _LoginPageState();
}

enum FormType {
  login,
  register,
  resetPassword,
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  FormType _formType = FormType.login;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Login/Sign up'),
        backgroundColor: Color(0xFF18D191),
      ),
      body: Builder(
        builder: (context) => Container(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: buildInputs() + buildSubmitButtons(context),
                ),
              ),
            ),
      ),
    );
  }

  List<Widget> buildInputs() {
    if (_formType == FormType.resetPassword) {
      return <Widget>[
        TextFormField(
          key: Key('email'),
          decoration: InputDecoration(labelText: 'Email'),
          validator: EmailFieldValidator.validate,
          onSaved: (String value) => _email = value,
        ),
      ];
    }
    return <Widget>[
      TextFormField(
        key: Key('email'),
        decoration: InputDecoration(labelText: 'Email'),
        validator: EmailFieldValidator.validate,
        onSaved: (String value) => _email = value,
      ),
      TextFormField(
        key: Key('password'),
        decoration: InputDecoration(labelText: 'Password'),
        obscureText: true,
        validator: PasswordFieldValidator.validate,
        onSaved: (String value) => _password = value,
      ),
    ];
  }

  List<Widget> buildSubmitButtons(context) {

    if (_formType == FormType.login) {
      return <Widget>[
        new Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 20.0, right: 5.0, top: 10.0),
                child: GestureDetector(
                  onTap: () => validateAndSubmit(context),
                  child: new Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      decoration: new BoxDecoration(
                          color: Color(0xFF18D191),
                          borderRadius: new BorderRadius.circular(9.0)),
                      child: new Text("Login",
                          style: new TextStyle(
                              fontSize: 20.0, color: Colors.white))),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.only(left: 10.0, right: 20.0, top: 10.0),
                child: GestureDetector(
                  onTap: moveToResetPassword,
                  child: new Container(
                      alignment: Alignment.center,
                      height: 60.0,
                      child: new Text("Forgot Password?",
                          style: new TextStyle(
                              fontSize: 17.0, color: Color(0xFF18D191)))),
                ),
              ),
            )
          ],
        ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: FlatButton(
                  child: new Text("Create A New Account ",
                      style: new TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFF18D191),
                          fontWeight: FontWeight.bold)),
                  onPressed: moveToRegister,
                ),
              ),
            ],
          ),
        ),
      ];
    } else if (_formType == FormType.register) {
      return <Widget>[
//        RaisedButton(
//          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
//          onPressed: () => validateAndSubmit(context),
//        ),
        new SizedBox(
          height: 15.0,
        ),
        FlatButton(
          child: new Container(
              alignment: Alignment.center,
              height: 60.0,
              decoration: new BoxDecoration(
                  color: Color(0xFF18D191),
                  borderRadius: new BorderRadius.circular(9.0)),
              child: new Text("Create an account",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))),
          onPressed: () => validateAndSubmit(context),
        ),

//        FlatButton(
//          child:
//              Text('Have an account? Login', style: TextStyle(fontSize: 20.0)),
//          onPressed: moveToLogin,
//        ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: FlatButton(
                  child: new Text("Have an account? Login ",
                      style: new TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFF18D191),
                          fontWeight: FontWeight.bold)),
                  onPressed: moveToLogin,
                ),
              ),
            ],
          ),
        ),

      ];
    }
    else if (_formType == FormType.resetPassword) {
      return <Widget>[
//        RaisedButton(
//          child: Text('Create an account', style: TextStyle(fontSize: 20.0)),
//          onPressed: () => validateAndSubmit(context),
//        ),
        new SizedBox(
          height: 15.0,
        ),
        FlatButton(
          child: new Container(
              alignment: Alignment.center,
              height: 60.0,
              decoration: new BoxDecoration(
                  color: Color(0xFF18D191),
                  borderRadius: new BorderRadius.circular(9.0)),
              child: new Text("Send email",
                  style: new TextStyle(fontSize: 20.0, color: Colors.white))),
          onPressed: () => validateAndSubmit(context),
        ),

        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 18.0),
                child: FlatButton(
                  child: new Text("Go Back to Login",
                      style: new TextStyle(
                          fontSize: 17.0,
                          color: Color(0xFF18D191),
                          fontWeight: FontWeight.bold)),
                  onPressed: moveToLogin,
                ),
              ),
            ],
          ),
        ),
      ];
    }
  }

  bool validateAndSave() {
    final FormState form = formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> validateAndSubmit(BuildContext context) async {
    if (validateAndSave()) {
      try {
        final BaseAuth auth = AuthProvider.of(context).auth;
        if (_formType == FormType.resetPassword) {
          await auth.sendPasswordResetEmail(_email);
          Scaffold.of(context).showSnackBar(
            SnackBar(content: Text('Password reset email is sent'), backgroundColor: Colors.green),
          );
          return;
        }
        if (_formType == FormType.login) {
          final String userId =
              await auth.signInWithEmailAndPassword(_email, _password);
          print('login_page Signed in: $userId');
        } else {
          final String userId =
              await auth.createUserWithEmailAndPassword(_email, _password);
          // (TODO): Store new user
//         userDocId = await _userDb.storeUser(userId, _email); // Store new user to user database.
          widget.userBloc.storeUser(userId, _email);
          print('Registered user: $userId');
        }
        widget.onSignedIn();
      } catch (e) {
        print('Error: $e');
        Scaffold.of(context).showSnackBar(
          SnackBar(content: Text('${e.message}'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void moveToRegister() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.register;
    });
  }

  void moveToLogin() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.login;
    });
  }

  void moveToResetPassword() {
    formKey.currentState.reset();
    setState(() {
      _formType = FormType.resetPassword;
    });
  }
}
