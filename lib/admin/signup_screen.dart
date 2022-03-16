import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';

class SignupScreen extends StatefulWidget {
  const SignupScreen({Key? key}) : super(key: key);

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

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
                  child: SignupForm(
                    emailController: _emailController,
                    passwordController: _passwordController,
                    passwordConfirmController: _passwordConfirmController,
                  ),
                ),
              );
            }

            return _SignupMobile(
              emailController: _emailController,
              passwordController: _passwordController,
              passwordConfirmController: _passwordConfirmController,
            );
          },
        ),
      ),
    );
  }
}

class _SignupMobile extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? passwordConfirmController;

  const _SignupMobile({
    Key? key,
    this.emailController,
    this.passwordController,
    this.passwordConfirmController,
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
            ),
          ],
        ),
      ),
    );
  }
}

class SignupForm extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;
  final TextEditingController? passwordConfirmController;

  const SignupForm(
      {Key? key,
      this.emailController,
      this.passwordController,
      this.passwordConfirmController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
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
            'Sign up',
            style: LuraTextStyles.baseTextStyle
                .copyWith(fontSize: 42, fontWeight: FontWeight.w400),
          ),
          const Gap(60),
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
          LuraTextField(
            hintText: 'Confirm your password',
            keyboardType: TextInputType.visiblePassword,
            obscureText: true,
            controller: passwordConfirmController,
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
                child: const Text('Sign in'),
                onPressed: () {
                  context.go('/signin');
                },
              ),
            ],
          ),
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Theme(
                data: Theme.of(context).copyWith(
                  elevatedButtonTheme: ElevatedButtonThemeData(
                    style: ElevatedButton.styleFrom(
                      elevation: 0,
                      shape: const CircleBorder(),
                      padding: const EdgeInsets.all(20),
                      primary: LuraColors.blue,
                    ),
                  ),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    context.go('/');
                  },
                  child: Icon(Icons.arrow_forward),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

String? _validateEmail(String? input) {}

String? _validatePassword(String? input) {}
