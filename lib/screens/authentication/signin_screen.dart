import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';

import 'bloc/login_screen_bloc.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: ResponsiveBuilder(
          builder: (BuildContext context, SizingInformation sizingInfo) {
            if (sizingInfo.deviceScreenType == DeviceScreenType.desktop) {
              return Center(
                child: SizedBox(
                  width: sizingInfo.screenSize.width / 2,
                  child: SigninForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                  ),
                ),
              );
            }

            return _SigninMobile(
              emailController: _emailController,
              passwordController: _passwordController,
              formKey: _formKey,
            );
          },
        ),
      ),
    );
  }
}

class _SigninMobile extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const _SigninMobile({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Gap(MediaQuery.of(context).size.height * 0.1),
            SigninForm(
              emailController: emailController,
              passwordController: passwordController,
              formKey: formKey,
            ),
          ],
        ),
      ),
    );
  }
}

class SigninForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const SigninForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loginScreenBloc = context.watch<LoginScreenBloc>();
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            'assets/images/lura_logo_icon_alt.png',
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
          const Gap(20),
          Text(
            'Sign in',
            style: LuraTextStyles.baseTextStyle
                .copyWith(fontSize: 42, fontWeight: FontWeight.w400),
          ),
          const Gap(60),
          if (loginScreenBloc.state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 20),
              child: ErrorAlert(
                  error: loginScreenBloc.state.error!, showRetry: false),
            ),
          LuraTextField(
            hintText: 'Email',
            keyboardType: TextInputType.emailAddress,
            controller: emailController,
            textInputValidator: _validateEmail,
          ),
          const Gap(20),
          LuraTextField(
            hintText: 'Password',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordController,
            textInputValidator: _validatePassword,
          ),
          const Gap(20),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextButton(
                  onPressed: () {}, child: const Text('Forgot your password?')),
              const Gap(10),
              Container(
                width: 2.5,
                height: 2.5,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle, color: LuraColors.blue),
              ),
              const Gap(10),
              TextButton(
                child: const Text('Sign up for Lura'),
                onPressed: () {
                  context.go('/signup');
                },
              ),
            ],
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              CircularIconButton(
                icon: const Icon(Icons.arrow_forward),
                onTap: loginScreenBloc.state.isSubmitting
                    ? null
                    : () => _onSubmit(context),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      context.read<LoginScreenBloc>().login(email, password);
    }
  }

  String? _validateEmail(String? email) {
    if (email == null || email.trim().isEmpty) {
      return 'Your email is required';
    }

    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(email);
    if (!emailValid) {
      return 'Please enter a valid email';
    }

    return null;
  }

  String? _validatePassword(String? password) {
    if (password == null || password.trim().isEmpty) {
      return 'Your password is required';
    }

    if (password.length < 6) {
      return 'Your password must be at least 6 characters long';
    }

    return null;
  }
}
