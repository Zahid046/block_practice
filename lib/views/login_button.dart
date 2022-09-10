import 'package:block_practice/dialogs/generic_dialog.dart';
import 'package:block_practice/strings.dart';
import 'package:flutter/material.dart';

typedef OnLoginTapped = void Function(
  String email,
  String password,
);

class LoginButton extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final OnLoginTapped onLoginTapped;

  const LoginButton({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.onLoginTapped,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        final email = emailController.text;
        final password = passwordController.text;
        if (email.isEmpty || password.isEmpty) {
          showGenericDialog<bool>(
            context: context,
            title: emailOrPasswordEmptyDialogTitle,
            content: emailOrPasswordEmptyDescription,
            optionBuilder: () => {
              ok: true,
            },
          );
        } else {
          onLoginTapped(
            email,
            password,
          );
        }
      },
      child: const Text(
        login,
      ),
    );
  }
}
