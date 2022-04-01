import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/authentication/lura_logo.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/input_validator.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../ui/widgets/buttons/lura_flat_button.dart';
import '../../ui/widgets/lura_alerts/alerts.dart';
import '../../ui/widgets/lura_text_field.dart';
import 'bloc/auth_screen_bloc.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();
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
                  child: SignupForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    passwordConfirmController: _passwordConfirmController,
                    formKey: _formKey,
                    isDesktop: true,
                  ),
                ),
              );
            }

            return _SignupMobile(
              emailController: _emailController,
              passwordController: _passwordController,
              passwordConfirmController: _passwordConfirmController,
              formKey: _formKey,
            );
          },
        ),
      ),
    );
  }
}

class _SignupMobile extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final GlobalKey<FormState> formKey;

  const _SignupMobile({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
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
            SignupForm(
              emailController: emailController,
              passwordController: passwordController,
              passwordConfirmController: passwordConfirmController,
              formKey: formKey,
              isDesktop: false,
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController passwordConfirmController;
  final GlobalKey<FormState> formKey;
  final bool isDesktop;

  const SignupForm({
    Key? key,
    required this.emailController,
    required this.passwordController,
    required this.passwordConfirmController,
    required this.formKey,
    this.isDesktop = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final signupScreenBloc = context.watch<SignupScreenBloc>();

    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const LuraLogo(),
          const Gap(20),
          SelectableText(
            'Sign up to Lura.',
            style: Theme.of(context).textTheme.headline3,
          ),
          const Gap(20),
          SelectableText.rich(
            TextSpan(
                text: 'Already have an account? ',
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: 'Log in',
                    style: const TextStyle(
                      color: LuraColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/signin');
                      },
                  ),
                  const TextSpan(text: '.'),
                ]),
            toolbarOptions: const ToolbarOptions(copy: true),
          ),
          Gap(isDesktop ? 40 : 30),
          LuraTextField(
            hintText: 'Your email',
            large: isDesktop,
            trailing: const Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.alternate_email_outlined),
            ),
            keyboardType: TextInputType.emailAddress,
            textInputValidator: InputValidator.validateEmail,
            controller: emailController,
          ),
          Gap(isDesktop ? 30 : 20),
          LuraTextField(
            hintText: 'Your password',
            large: isDesktop,
            trailing: const Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.password),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            textInputValidator: InputValidator.validatePassword,
            controller: passwordController,
          ),
          Gap(isDesktop ? 30 : 20),
          LuraTextField(
            hintText: 'Confirm your password',
            large: isDesktop,
            trailing: const Padding(
              padding: EdgeInsets.only(right: 30),
              child: Icon(Icons.password),
            ),
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            textInputValidator: InputValidator.validateConfirmPassword,
            controller: passwordConfirmController,
          ),
          Gap(isDesktop ? 30 : 20),
          LuraFlatButton(
            text: 'Sign up',
            onTap: signupScreenBloc.state.isSubmitting
                ? null
                : () => _onSubmit(context),
          ),
          if (signupScreenBloc.state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: LuraErrorAlert(
                title: 'Signup failed!',
                message: signupScreenBloc.state.error!,
                onClose: () {
                  signupScreenBloc.clearError();
                },
              ),
            ),
          Gap(isDesktop ? 30 : 20),
        ],
      ),
    );
  }

  void _onSubmit(BuildContext context) {
    if (formKey.currentState?.validate() ?? false) {
      final email = emailController.text.trim();
      final password = passwordController.text.trim();
      context.read<SignupScreenBloc>().signup(email, password);
    }
  }
}
