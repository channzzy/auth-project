import 'package:auth_project/providers/auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';
import 'package:provider/provider.dart';

const users = const {
  'dribbble@gmail.com': '12345',
  'hunter@gmail.com': 'hunter',
};

class LoginScreen extends StatefulWidget {
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  Duration get loginTime => const Duration(milliseconds: 2250);

  Future<String?> _authUserSignUp(SignupData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then((_) async {
      try {
        await Provider.of<Authen>(context, listen: false)
            .signUp(data.name!, data.password!);
      } catch (error) {
        return error.toString();
      }
      return null;
    });
  }

  Future<String?> _authUserLogin(LoginData data) {
    debugPrint('Signup Name: ${data.name}, Password: ${data.password}');
    return Future.delayed(loginTime).then(
      (_) async {
        try {
          await Provider.of<Authen>(context, listen: false)
              .login(data.name, data.password);
        } catch (err) {
          return err.toString();
        }
        return null;
      },
    );
  }

  Future<String> _recoverPassword(String name) {
    debugPrint('Name: $name');
    return Future.delayed(loginTime).then((_) {
      if (!users.containsKey(name)) {
        return 'User not exists';
      }
      // ignore: null_check_always_fails
      return null!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return FlutterLogin(
      title: 'ECORP',
      onLogin: _authUserLogin,
      onSignup: _authUserSignUp,
      onSubmitAnimationCompleted: () {
        Provider.of<Authen>(context, listen: false).tempData();
      },
      onRecoverPassword: _recoverPassword,
    );
  }
}
