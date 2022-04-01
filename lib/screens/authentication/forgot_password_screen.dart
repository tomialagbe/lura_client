import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';
import 'package:lura_client/screens/widgets/app_bars.dart';
import 'package:lura_client/ui/input_validator.dart';
import 'package:lura_client/ui/widgets/lura_alerts/alerts.dart';
import 'package:lura_client/ui/widgets/lura_text_field.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:rxdart/rxdart.dart';

import '../../ui/widgets/buttons/lura_flat_button.dart';
import 'bloc/auth_screen_bloc.dart';
import 'lura_logo.dart';

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
                          sizingInformation: sizingInformation))
                  : Center(
                      child: SizedBox(
                        width: 700,
                        child: _ForgotPasswordForm(
                            sizingInformation: sizingInformation),
                      ),
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
    final isSubmitting = screenBloc.state.isSubmitting;
    final isComplete = screenBloc.state.completed;
    final isDesktop = widget.sizingInformation.isDesktop;

    return Form(
      key: _formKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (widget.sizingInformation.isMobile)
            Gap(0.1 * MediaQuery.of(context).size.height),
          const LuraLogo(),
          const Gap(20),
          Text(
            'Reset your password',
            style: widget.sizingInformation.isDesktop
                ? Theme.of(context).textTheme.headline3
                : Theme.of(context).textTheme.headline4,
          ),
          const Gap(20),
          Text(
            'Enter the email address for your Lura account',
            style: Theme.of(context).textTheme.bodyText2,
          ),
          Gap(isDesktop ? 40 : 30),
          if (screenBloc.state.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: LuraErrorAlert(
                title: 'Password reset failed!',
                message: screenBloc.state.error!,
                onClose: () {
                  screenBloc.clearError();
                },
              ),
            )
          else if (screenBloc.state.completed)
            LuraInfoAlert(
              title: 'Email sent',
              message: 'A password reset link has been sent to your email',
              actionText: 'Back to login',
              onAction: () {
                context.go('/signin');
              },
            ),
          LuraTextField(
            large: isDesktop,
            controller: _emailController,
            textInputValidator: InputValidator.validateEmail,
            keyboardType: TextInputType.text,
            hintText: 'Your email address',
          ),
          Gap(isDesktop ? 30 : 20),
          LuraFlatButton(
            text: 'Send reset email',
            onTap: !isSubmitting && !isComplete ? _onSubmit : null,
          ),
          const Gap(20),
          const Divider(),
          TextButton(
            onPressed: () {
              context.go('/signin');
            },
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  void _onSubmit() async {
    if (_formKey.currentState?.validate() == true) {
      final email = _emailController.text.trim();
      context.read<ForgotPasswordScreenBloc>().sendPasswordResetEmail(email);
    }
  }
}
