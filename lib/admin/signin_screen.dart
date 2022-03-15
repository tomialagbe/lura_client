import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:mobile_printer/login_state.dart';
import 'package:mobile_printer/ui/colors.dart';
import 'package:mobile_printer/ui/typography.dart';
import 'package:mobile_printer/ui/widgets/lura_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:provider/provider.dart';

class SigninScreen extends StatefulWidget {
  const SigninScreen({Key? key}) : super(key: key);

  @override
  State<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends State<SigninScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

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
                      passwordController: _passwordController),
                ),
              );
            }

            return _SigninMobile(
                emailController: _emailController,
                passwordController: _passwordController);
          },
        ),
      ),
    );
  }
}

class _SigninMobile extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const _SigninMobile({Key? key, this.emailController, this.passwordController})
      : super(key: key);

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
            ),
          ],
        ),
      ),
    );
  }
}

class SigninForm extends StatelessWidget {
  final TextEditingController? emailController;
  final TextEditingController? passwordController;

  const SigninForm({Key? key, this.emailController, this.passwordController})
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
            'Sign in',
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
                    context.read<LoginState>().loggedIn = true;
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
