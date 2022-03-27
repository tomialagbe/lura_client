import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:lura_client/ui/widgets/lura_alerts/alerts.dart';
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
                  width: 600,
                  child: SigninForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    formKey: _formKey,
                    isDesktop: true,
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
              isDesktop: false,
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
  final bool isDesktop;

  const SigninForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
    this.isDesktop = false,
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
            'images/lura_logo_icon_alt.png',
            fit: BoxFit.cover,
            width: 100,
            height: 100,
          ),
          const Gap(20),
          if (loginScreenBloc.state.error != null)
            LuraErrorAlert(
              title: 'Login failed',
              message: loginScreenBloc.state.error!,
              onClose: () {},
            ),
          Container(
            margin: const EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(isDesktop ? 40 : 20),
            decoration: BoxDecoration(
                color: LuraColors.formBackground,
                borderRadius: BorderRadius.circular(20)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sign in',
                  style: Theme.of(context).textTheme.headline3,
                ),
                const Gap(60),
                LuraTextField(
                  hintText: 'Email',
                  keyboardType: TextInputType.emailAddress,
                  controller: emailController,
                  textInputValidator: _validateEmail,
                ),
                Gap(isDesktop ? 30 : 20),
                LuraTextField(
                  hintText: 'Password',
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: true,
                  controller: passwordController,
                  textInputValidator: _validatePassword,
                ),
                const Gap(20),
                const _LoginLinks(),
                const Gap(40),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    LuraCircularIconButton(
                      icon: Icons.arrow_forward,
                      size: 30,
                      onTap: loginScreenBloc.state.isSubmitting
                          ? null
                          : () => _onSubmit(context),
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

class _LoginLinks extends StatelessWidget {
  const _LoginLinks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            context.go('/forgot-password');
          },
          child: const Text('Forgot your password?'),
        ),
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
    );
  }
}
