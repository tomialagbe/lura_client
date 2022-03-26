import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/widgets/app_bars.dart';
import 'package:lura_client/ui/colors.dart';
import 'package:lura_client/ui/typography.dart';
import 'package:lura_client/ui/widgets/alerts.dart';
import 'package:lura_client/ui/widgets/circular_icon_button.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

import 'bloc/forgot_password_screen_bloc.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ResponsiveBuilder(
      builder: (context, sizingInformation) {
        return Scaffold(
          appBar: luraAppBar(context),
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: sizingInformation.isMobile
                  ? SingleChildScrollView(
                      child: _ForgotPasswordForm(
                          sizingInformation: sizingInformation),
                    )
                  : Container(
                      constraints: const BoxConstraints(maxWidth: 700),
                      child: _ForgotPasswordForm(
                          sizingInformation: sizingInformation),
                    ),
            ),
          ),
        );
      },
    );
  }
}

class _ForgotPasswordForm extends StatefulWidget {
  final SizingInformation sizingInformation;

  const _ForgotPasswordForm({Key? key, required this.sizingInformation})
      : super(key: key);

  @override
  _ForgotPasswordFormState createState() => _ForgotPasswordFormState();
}

class _ForgotPasswordFormState extends State<_ForgotPasswordForm> {
  final _emailController = TextEditingController();
  final _formCompleteStream = BehaviorSubject.seeded(false);
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _emailController.addListener(() {
      _formCompleteStream
          .add(_emailController.text.trim().isEmpty ? false : true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenBloc = context.watch<ForgotPasswordScreenBloc>();
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Gap(widget.sizingInformation.isDesktop ? 100 : 20),
        Text(
          'Reset your password',
          style: LuraTextStyles.baseTextStyle.copyWith(
              color: LuraColors.blue,
              fontSize: 36,
              fontWeight: FontWeight.w400),
        ),
        const Gap(40),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Enter the email address for your Lura account',
                style: LuraTextStyles.baseTextStyle.copyWith(
                    color: LuraColors.blue,
                    fontSize: 20,
                    fontWeight: FontWeight.w400),
              ),
              const Gap(20),
              TextFormField(
                controller: _emailController,
                style: const TextStyle(fontSize: 18, color: LuraColors.blue),
                decoration: const InputDecoration(
                  filled: false,
                  hintText: 'Your email address',
                  hintStyle: TextStyle(
                    color: LuraColors.blue,
                    fontSize: 20,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                  border: UnderlineInputBorder(
                    borderSide: BorderSide(color: LuraColors.blue, width: 1),
                  ),
                ),
                validator: _validateEmail,
                keyboardType: TextInputType.text,
              ),
              if (screenBloc.state.error != null)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: ErrorAlert(
                    error: screenBloc.state.error!,
                    showRetry: false,
                  ),
                )
              else if (screenBloc.state.completed)
                Padding(
                  padding: const EdgeInsets.only(top: 20),
                  child: InfoAlert(
                    message:
                        'A password reset link has been sent to your email address',
                    actionText: 'back to login',
                    showAction: true,
                    onTap: () {
                      context.go('/signin');
                    },
                  ),
                ),
              const Gap(60),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  StreamBuilder<bool>(
                    stream: _formCompleteStream,
                    builder: (context, snapshot) {
                      final isFormComplete = (snapshot.data ?? false);
                      final isSubmitting = screenBloc.state.isSubmitting;
                      final isComplete = screenBloc.state.completed;
                      return LuraCircularIconButton(
                        icon: Icons.arrow_forward,
                        onTap: isFormComplete && !isSubmitting && !isComplete
                            ? _onSubmit
                            : null,
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _onSubmit() async {
    final email = _emailController.text.trim();
    context.read<ForgotPasswordScreenBloc>().sendPasswordResetEmail(email);
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
}
