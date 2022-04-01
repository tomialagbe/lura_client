import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/authentication/lura_logo.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/input_validator.dart';
import 'package:lura_client/ui/widgets/buttons/lura_flat_button.dart';
import 'package:lura_client/ui/widgets/lura_alerts/alerts.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';

import 'bloc/auth_screen_bloc.dart';

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
            Gap(0.1 * MediaQuery.of(context).size.height),
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
          const LuraLogo(),
          const Gap(20),
          SelectableText(
            'Log in to Lura.',
            style: Theme.of(context).textTheme.headline3,
          ),
          const Gap(20),
          SelectableText.rich(
            TextSpan(
                text: 'Don\'t have an account yet? ',
                style: Theme.of(context).textTheme.bodyText2,
                children: [
                  TextSpan(
                    text: 'Sign up',
                    style: const TextStyle(
                      color: LuraColors.blue,
                      fontWeight: FontWeight.w500,
                    ),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        context.go('/signup');
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
          LuraFlatButton(
            text: 'Login',
            onTap: loginScreenBloc.state.isSubmitting
                ? null
                : () => _onSubmit(context),
          ),
          if (loginScreenBloc.state.error != null)
            Padding(
              padding: const EdgeInsets.only(top: 30),
              child: LuraErrorAlert(
                title: 'Login failed',
                message: loginScreenBloc.state.error!,
                onClose: () {
                  loginScreenBloc.clearError();
                },
              ),
            ),
          Gap(isDesktop ? 30 : 20),
          const Divider(),
          const _LoginLinks(),
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
      ],
    );
  }
}
